#!/usr/bin/env python3
"""CDCI TSV → cleaned CSV (tab → comma, columns renamed to snake_case SQL names)."""
import csv
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from config import RAW_DIR, CLEANED_DIR, CDCI_FILES
from scripts.utils import setup_logger

logger = setup_logger("filter_cdci")
TARGET = os.path.join(RAW_DIR, "CDCI")

CDCI_CONFIG = {
    "substance_master": {
        "file": "SubstanceMaster.txt", "delim": "\t",
        "cols": {"Identifier": "identifier", "Substance Name": "substance_name",
                 "CAS Number": "cas_number", "UNII": "unii",
                 "Substance Description": "substance_description",
                 "Molecular Weight": "molecular_weight", "Toxicity": "toxicity",
                 "SMILE": "smile", "InChI": "inchi", "IUPAC Name": "iupac_name",
                 "Molecular Formula": "molecular_formula", "last_updated_on": "last_updated"},
    },
    "generic_master": {
        "file": "GenericMaster.txt", "delim": "\t",
        "cols": {"Identifier": "identifier", "Generic Name": "generic_name",
                 "Substance Identifier": "substance_identifier",
                 "Route of Administration": "route_identifier",
                 "Dose Form": "dose_form_identifier",
                 "Therapeutic Role": "therapeutic_role",
                 "Indication": "indication", "Contra Indication": "contra_indication",
                 "Interaction with Drugs": "drug_interaction",
                 "Classification of Drugs": "classification",
                 "Source/ Regulatory": "source", "last_updated_on": "last_updated"},
    },
    "brand_master": {
        "file": "BrandMaster.txt", "delim": "\t",
        "cols": {"Identifier": "identifier", "Brand Name": "brand_name",
                 "Product Identifier": "product_identifier",
                 "Supplier Identifier": "supplier_identifier",
                 "Generic Identifier": "generic_identifier",
                 "License Number": "license_number",
                 "License Status": "license_status",
                 "Excipient": "excipient", "last_updated_on": "last_updated"},
    },
    "product_master": {
        "file": "ProductMaster.txt", "delim": "\t",
        "cols": {"Identifier": "identifier", "Product Name": "product_name"},
    },
    "drug_form_master": {
        "file": "DrugFormMaster.txt", "delim": "\t",
        "cols": {"Identifier": "identifier", "Dose Form": "drug_form_name"},
    },
    "route_master": {
        "file": "RouteOfAdministrationMaster.txt", "delim": "\t",
        "cols": {"Identifier": "identifier", "RouteOfAdministration": "route_name"},
    },
    "supplier_master": {
        "file": "SupplierMaster.txt", "delim": "\t",
        "cols": {"Identifier": "identifier", "Supplier Name": "supplier_name"},
    },
}


def convert(table_name: str, cfg: dict):
    src = os.path.join(TARGET, cfg["file"])
    dst = os.path.join(CLEANED_DIR, f"{table_name}.csv")

    if not os.path.exists(src):
        logger.warning(f"Source not found: {src}")
        return 0

    col_map = cfg["cols"]
    out_cols = list(col_map.values())
    count = 0

    with open(src, "r", encoding="utf-8") as fin, \
         open(dst, "w", encoding="utf-8", newline="") as fout:
        reader = csv.DictReader(fin, delimiter=cfg["delim"])
        writer = csv.writer(fout)
        writer.writerow(out_cols)

        for row in reader:
            writer.writerow([(row.get(k) or "").strip() for k in col_map])
            count += 1

    logger.info(f"[CDCI] {cfg['file']} → {table_name}.csv  ({count} rows)")
    return count


def main():
    os.makedirs(CLEANED_DIR, exist_ok=True)
    total = 0
    for table, cfg in CDCI_CONFIG.items():
        total += convert(table, cfg)
    logger.info(f"CDCI total: {total} rows")


if __name__ == "__main__":
    main()
