#!/usr/bin/env python3
"""LOINC → cleaned CSV files.
  - Loinc.csv: keep 7 columns (loinc_num, component, property, system, scale_type, class_type, long_common_name), ACTIVE/TRIAL only.
  - Part.csv: rename headers to match SQL column names.
"""
import csv
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from config import RAW_DIR, CLEANED_DIR
from scripts.utils import setup_logger

logger = setup_logger("filter_loinc")

LOINC_SRC = os.path.join(RAW_DIR, "LOINC")

# Column mappings: { loinc_column: sql_column }
LOINC_COL_MAP = {
    "LOINC_NUM": "loinc_num",
    "COMPONENT": "component",
    "PROPERTY": "property",
    "SYSTEM": "system",
    "SCALE_TYP": "scale_type",
    "CLASS": "class_type",
    "LONG_COMMON_NAME": "long_common_name",
}

PART_COL_MAP = {
    "PartNumber": "part_number",
    "PartName": "part_name",
    "PartTypeName": "part_type_name",
    "PartDisplayName": "part_display_name",
    "Status": "status",
}

LOINC_KEEP_STATUSES = {"ACTIVE", "TRIAL"}


def filter_loinc_main():
    os.makedirs(CLEANED_DIR, exist_ok=True)

    # --- Loinc.csv → loinc_codes.csv ---
    src = os.path.join(LOINC_SRC, "LoincTable", "Loinc.csv")
    dst = os.path.join(CLEANED_DIR, "loinc_codes.csv")
    count = 0
    with open(src, "r", encoding="utf-8") as fin, \
         open(dst, "w", encoding="utf-8", newline="") as fout:
        reader = csv.DictReader(fin)
        out_cols = list(LOINC_COL_MAP.values())
        writer = csv.writer(fout)
        writer.writerow(out_cols)
        for row in reader:
            status = row.get("STATUS", "").strip().upper()
            if status not in LOINC_KEEP_STATUSES:
                continue
            writer.writerow([row.get(k, "").strip() for k in LOINC_COL_MAP])
            count += 1
    logger.info(f"[LOINC] Loinc.csv → loinc_codes.csv  ({count} rows)")

    # --- Part.csv → loinc_parts.csv ---
    _remap_csv(
        os.path.join(LOINC_SRC, "AccessoryFiles", "PartFile", "Part.csv"),
        os.path.join(CLEANED_DIR, "loinc_parts.csv"),
        PART_COL_MAP,
    )



def _remap_csv(src: str, dst: str, col_map: dict):
    """Read source CSV, rename columns per col_map, write cleaned CSV."""
    if not os.path.exists(src):
        logger.warning(f"Source not found: {src}")
        return
    out_cols = list(col_map.values())
    count = 0
    with open(src, "r", encoding="utf-8") as fin, \
         open(dst, "w", encoding="utf-8", newline="") as fout:
        reader = csv.DictReader(fin)
        writer = csv.writer(fout)
        writer.writerow(out_cols)
        for row in reader:
            writer.writerow([row.get(k, "").strip() for k in col_map])
            count += 1
    logger.info(f"[LOINC] {os.path.basename(src)} → {os.path.basename(dst)}  ({count} rows)")


if __name__ == "__main__":
    filter_loinc_main()
