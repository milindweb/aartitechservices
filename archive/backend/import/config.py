import os
from dotenv import load_dotenv

load_dotenv()

# Database
SUPABASE_DB_URL = os.getenv("SUPABASE_DB_URL", "")
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")

# Paths
RAW_DIR = os.path.join(os.path.dirname(__file__), "raw")
CLEANED_DIR = os.path.join(os.path.dirname(__file__), "cleaned")
SQL_DIR = os.path.join(os.path.dirname(__file__), "sql")

# CDCI file mapping: { table_name: (input_file, delimiter) }
CDCI_FILES = {
    "substance_master": ("SubstanceMaster.txt", "\t"),
    "generic_master": ("GenericMaster.txt", "\t"),
    "brand_master": ("BrandMaster.txt", "\t"),
    "product_master": ("ProductMaster.txt", "\t"),
    "supplier_master": ("SupplierMaster.txt", "\t"),
    "drug_form_master": ("DrugFormMaster.txt", "\t"),
    "route_master": ("RouteOfAdministrationMaster.txt", "\t"),
}

# LOINC files (active: Loinc.csv + Part.csv only; AnswerList + LoincAnswerListLink + LoincPartLink kept in raw/ for future)
LOINC_FILES = {
    "loinc_codes": ("LOINC/LoincTable/Loinc.csv", ","),
    "loinc_parts": ("LOINC/AccessoryFiles/PartFile/Part.csv", ","),
}

ICD10_DIR = os.path.join(RAW_DIR, "ICD10")

# Batch size for DB inserts
BATCH_SIZE = 1000
