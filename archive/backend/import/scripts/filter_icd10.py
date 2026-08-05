#!/usr/bin/env python3
"""Filter ICD-10 CSV files from WHO/CDC source format into cleaned CSVs.

Expects backend/import/raw/ICD10/ with:
  - icd10_codes.csv (columns: icd_code, disease_name, category, chapter)

Output: backend/import/cleaned/icd10_codes.csv
"""
import csv
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from config import RAW_DIR, CLEANED_DIR
from scripts.utils import setup_logger

logger = setup_logger("filter_icd10")

SOURCE_FILE = os.path.join(RAW_DIR, "ICD10", "icd10_codes.csv")
TARGET_FILE = os.path.join(CLEANED_DIR, "icd10_codes.csv")
REQUIRED_COLS = ["icd_code", "disease_name", "category", "chapter"]

def main():
    if not os.path.exists(SOURCE_FILE):
        logger.warning(f"Source not found: {SOURCE_FILE}")
        logger.info("Place ICD-10 source CSV at: " + SOURCE_FILE)
        logger.info("Expected columns: icd_code, disease_name, category, chapter")
        return

    os.makedirs(CLEANED_DIR, exist_ok=True)

    rows = []
    with open(SOURCE_FILE, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            icd_code = row.get("icd_code", "").strip()
            disease_name = row.get("disease_name", "").strip()
            category = row.get("category", "").strip()
            chapter = row.get("chapter", "").strip()
            if icd_code and disease_name:
                rows.append({
                    "icd_code": icd_code,
                    "disease_name": disease_name,
                    "category": category or "",
                    "chapter": chapter or "",
                })

    if not rows:
        logger.warning("No valid rows found in source file")
        return

    with open(TARGET_FILE, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=REQUIRED_COLS)
        writer.writeheader()
        writer.writerows(rows)

    logger.info(f"Filtered {len(rows)} ICD-10 codes → {TARGET_FILE}")

if __name__ == "__main__":
    main()
