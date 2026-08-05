#!/usr/bin/env python3
"""Verify import: compare CSV row count vs DB row count for each table.

Usage:
  python scripts/verify_data.py
"""
import csv
import os
import sys
from pathlib import Path

import psycopg2

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from config import SUPABASE_DB_URL, CLEANED_DIR
from scripts.utils import setup_logger
from scripts.import_supabase import IMPORT_MAP

logger = setup_logger("verify_data")

def get_csv_count(csv_file: str) -> int:
    src = os.path.join(CLEANED_DIR, csv_file)
    if not os.path.exists(src):
        return 0
    with open(src, "r", encoding="utf-8") as f:
        return sum(1 for _ in f) - 1  # minus header

def get_db_count(conn, table: str) -> int:
    with conn.cursor() as cur:
        cur.execute(f"SELECT COUNT(*) FROM public.{table}")
        return cur.fetchone()[0]

def main():
    if not SUPABASE_DB_URL:
        logger.error("SUPABASE_DB_URL not set in .env")
        sys.exit(1)

    conn = psycopg2.connect(SUPABASE_DB_URL)
    logger.info(f"{'Table':<30} {'CSV rows':>10} {'DB rows':>10} {'Match':>8}")
    logger.info("-" * 60)

    all_ok = True
    for csv_file, (table, _) in IMPORT_MAP.items():
        csv_count = get_csv_count(csv_file)
        db_count = get_db_count(conn, table)
        match = "✓" if csv_count == db_count else "✗"
        if csv_count != db_count:
            all_ok = False
        logger.info(f"{table:<30} {csv_count:>10} {db_count:>10} {match:>8}")

    conn.close()
    if all_ok:
        logger.info("All tables verified successfully.")
    else:
        logger.warning("Some tables have mismatched counts. Check logs.")

if __name__ == "__main__":
    main()
