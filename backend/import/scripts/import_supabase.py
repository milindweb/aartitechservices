#!/usr/bin/env python3
"""Import cleaned CSVs into Supabase PostgreSQL.
  - Runs SQL DDL (CREATE TABLE IF NOT EXISTS)
  - Batch-inserts CSVs (1k rows/batch, ON CONFLICT DO NOTHING)

Usage:
  python scripts/import_supabase.py              # run SQL + import all
  python scripts/import_supabase.py --sql-only    # schema only
  python scripts/import_supabase.py --data-only   # data only
"""
import csv
import os
import sys
import argparse
from pathlib import Path

import psycopg2

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from config import SUPABASE_DB_URL, CLEANED_DIR, SQL_DIR, BATCH_SIZE
from scripts.utils import setup_logger

logger = setup_logger("import_supabase")

# Import config: { cleaned_csv: (table_name, conflict_column) }
IMPORT_MAP = {
    "substance_master.csv": ("substance_master", "identifier"),
    "generic_master.csv": ("generic_master", "identifier"),
    "brand_master.csv": ("brand_master", "identifier"),
    "product_master.csv": ("product_master", "identifier"),
    "drug_form_master.csv": ("drug_form_master", "identifier"),
    "route_master.csv": ("route_master", "identifier"),
    "supplier_master.csv": ("supplier_master", "identifier"),
    "loinc_codes.csv": ("loinc_codes", "loinc_num"),
    "loinc_parts.csv": ("loinc_parts", "part_number"),
    "icd10_codes.csv": ("icd10_codes", "icd_code"),
}

def run_sql_files(conn):
    """Execute all .sql files in SQL_DIR."""
    sql_files = sorted(Path(SQL_DIR).glob("*.sql"))
    for sf in sql_files:
        sql = sf.read_text(encoding="utf-8")
        try:
            with conn.cursor() as cur:
                cur.execute(sql)
            conn.commit()
            logger.info(f"[SQL] Executed: {sf.name}")
        except Exception as e:
            conn.rollback()
            logger.error(f"[SQL] Failed: {sf.name} — {e}")
            raise

def import_csv(conn, csv_file: str, table: str, conflict_col: str | None):
    """Batch import a cleaned CSV into the given table."""
    src = os.path.join(CLEANED_DIR, csv_file)
    if not os.path.exists(src):
        logger.warning(f"  Skipped (not found): {csv_file}")
        return 0

    with open(src, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        logger.info(f"  {csv_file}: 0 rows")
        return 0

    columns = list(rows[0].keys())
    col_list = ", ".join(columns)
    placeholders = ", ".join(["%s"] * len(columns))
    conflict_sql = f" ON CONFLICT ({conflict_col}) DO NOTHING" if conflict_col else ""

    sql = f"INSERT INTO public.{table} ({col_list}) VALUES ({placeholders}){conflict_sql}"

    total = 0
    with conn.cursor() as cur:
        for i in range(0, len(rows), BATCH_SIZE):
            batch = rows[i:i + BATCH_SIZE]
            values = [[row.get(c, "") for c in columns] for row in batch]
            try:
                cur.executemany(sql, values)
                conn.commit()
                total += len(batch)
            except Exception as e:
                conn.rollback()
                logger.error(f"  Batch failed at offset {i}: {e}")
                raise
    logger.info(f"  {csv_file} → {table}: {total} rows")
    return total

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--sql-only", action="store_true", help="Run SQL DDL only")
    parser.add_argument("--data-only", action="store_true", help="Import data only")
    args = parser.parse_args()

    if not SUPABASE_DB_URL:
        logger.error("SUPABASE_DB_URL not set in .env")
        sys.exit(1)

    conn = psycopg2.connect(SUPABASE_DB_URL)
    logger.info("Connected to Supabase PostgreSQL")

    if not args.data_only:
        run_sql_files(conn)
        if args.sql_only:
            conn.close()
            return

    if not args.sql_only:
        logger.info("Starting CSV import...")
        grand = 0
        for csv_file, (table, conflict_col) in IMPORT_MAP.items():
            grand += import_csv(conn, csv_file, table, conflict_col)
        logger.info(f"Import complete. Total rows: {grand}")

    conn.close()

if __name__ == "__main__":
    main()
