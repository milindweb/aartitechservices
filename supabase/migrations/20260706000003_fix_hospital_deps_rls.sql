-- Fix hospital module issues:
-- 1. Add missing `code` column to hospital_departments
-- 2. Add RLS SELECT policy for hospital_departments
-- 3. Create missing symptom_master table

ALTER TABLE public.hospital_departments ADD COLUMN IF NOT EXISTS code VARCHAR(50) UNIQUE;

DROP POLICY IF EXISTS "Master data readable by all authenticated users" ON public.hospital_departments;
CREATE POLICY "Master data readable by all authenticated users"
  ON public.hospital_departments FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE TABLE IF NOT EXISTS public.symptom_master (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  department_code VARCHAR(50) NOT NULL,
  symptom_name VARCHAR(255) NOT NULL
);

ALTER TABLE public.symptom_master ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Master data readable by all authenticated users"
  ON public.symptom_master FOR SELECT
  USING (auth.role() = 'authenticated');
