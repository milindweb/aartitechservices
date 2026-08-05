-- Medicine Master Tables (CDCI)
-- Run BEFORE import_supabase.py

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS public.substance_master (
  id SERIAL PRIMARY KEY,
  identifier VARCHAR(50) UNIQUE NOT NULL,
  substance_name TEXT NOT NULL,
  cas_number VARCHAR(50),
  unii VARCHAR(50),
  substance_description TEXT,
  molecular_weight VARCHAR(50),
  toxicity TEXT,
  smile TEXT,
  inchi TEXT,
  iupac_name TEXT,
  molecular_formula VARCHAR(100),
  last_updated DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.generic_master (
  id SERIAL PRIMARY KEY,
  identifier VARCHAR(50) UNIQUE NOT NULL,
  generic_name TEXT NOT NULL,
  substance_identifier VARCHAR(200),
  route_identifier VARCHAR(200),
  dose_form_identifier VARCHAR(50),
  therapeutic_role TEXT,
  indication TEXT,
  contra_indication TEXT,
  drug_interaction TEXT,
  classification TEXT,
  source VARCHAR(50),
  last_updated DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.brand_master (
  id SERIAL PRIMARY KEY,
  identifier VARCHAR(50) UNIQUE NOT NULL,
  brand_name TEXT NOT NULL,
  product_identifier VARCHAR(50),
  supplier_identifier VARCHAR(50),
  generic_identifier VARCHAR(50),
  license_number VARCHAR(100),
  license_status VARCHAR(50),
  excipient TEXT,
  last_updated DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.product_master (
  id SERIAL PRIMARY KEY,
  identifier VARCHAR(50) UNIQUE NOT NULL,
  product_name TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.drug_form_master (
  id SERIAL PRIMARY KEY,
  identifier VARCHAR(50) UNIQUE NOT NULL,
  drug_form_name TEXT NOT NULL,
  last_updated DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.route_master (
  id SERIAL PRIMARY KEY,
  identifier VARCHAR(50) UNIQUE NOT NULL,
  route_name TEXT NOT NULL,
  last_updated DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.supplier_master (
  id SERIAL PRIMARY KEY,
  identifier VARCHAR(50) UNIQUE NOT NULL,
  supplier_name TEXT NOT NULL,
  last_updated DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Materialized view for fast prescription autocomplete
-- Strength data not available from CDCI source; joins with available tables.
CREATE MATERIALIZED VIEW IF NOT EXISTS public.medicine_search AS
SELECT DISTINCT ON (g.generic_name, b.brand_name)
  g.id AS generic_id,
  g.generic_name,
  b.id AS brand_id,
  b.brand_name,
  NULL AS strength,
  df.drug_form_name AS dosage_form,
  r.route_name AS route,
  s.supplier_name AS manufacturer
FROM public.generic_master g
LEFT JOIN public.brand_master b ON b.generic_identifier = g.identifier
LEFT JOIN public.drug_form_master df ON df.identifier = g.dose_form_identifier
LEFT JOIN public.route_master r ON r.identifier = split_part(g.route_identifier, '+', 1)
LEFT JOIN public.supplier_master s ON s.identifier = b.supplier_identifier
WHERE g.generic_name IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_medicine_search_unique
  ON public.medicine_search (generic_id, brand_id);

CREATE INDEX IF NOT EXISTS idx_medicine_search_generic
  ON public.medicine_search USING gin (generic_name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_medicine_search_brand
  ON public.medicine_search USING gin (brand_name gin_trgm_ops);
