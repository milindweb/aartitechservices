-- Diagnosis Master Tables (ICD-10) — placeholder for future import
-- Run BEFORE import_supabase.py

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS public.icd10_codes (
  id SERIAL PRIMARY KEY,
  icd_code VARCHAR(20) UNIQUE NOT NULL,
  disease_name TEXT NOT NULL,
  category VARCHAR(100),
  chapter VARCHAR(200),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_icd10_search
  ON public.icd10_codes USING gin (disease_name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_icd10_category
  ON public.icd10_codes (category);
