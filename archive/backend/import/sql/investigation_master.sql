-- Investigation Master Tables (LOINC)
-- Run BEFORE import_supabase.py
-- Active: loinc_codes + loinc_parts only.
-- Future (DDL removed, recreate if needed): loinc_answer_list, loinc_answer_list_links, loinc_part_links

CREATE TABLE IF NOT EXISTS public.loinc_codes (
  id SERIAL PRIMARY KEY,
  loinc_num VARCHAR(10) UNIQUE NOT NULL,
  component TEXT,
  property TEXT,
  system TEXT,
  scale_type VARCHAR(20),
  class_type VARCHAR(100),
  long_common_name TEXT,
  status VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_loinc_codes_search
  ON public.loinc_codes USING gin (long_common_name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_loinc_codes_class
  ON public.loinc_codes (class_type);
CREATE INDEX IF NOT EXISTS idx_loinc_codes_status
  ON public.loinc_codes (status);

CREATE TABLE IF NOT EXISTS public.loinc_parts (
  id SERIAL PRIMARY KEY,
  part_number VARCHAR(20) UNIQUE NOT NULL,
  part_name TEXT NOT NULL,
  part_type_name VARCHAR(100),
  part_display_name TEXT,
  status VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW()
);
