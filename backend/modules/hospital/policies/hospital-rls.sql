-- Hospital Module - RLS Policies
-- Roles: hospital_admin, doctor, developer

-- ============================================================
-- MASTER DATA (from import pipeline) — read-only for all authenticated users
-- ============================================================

DO $$
DECLARE
  tables TEXT[] := ARRAY[
    'substance_master', 'generic_master', 'brand_master', 'product_master',
    'drug_form_master', 'route_master', 'supplier_master',
    'loinc_codes', 'loinc_parts',
    'icd10_codes', 'medicine_search',
    'symptom_master', 'hospital_doctor_master', 'hospital_departments'
  ];
  t TEXT;
BEGIN
  FOREACH t IN ARRAY tables
  LOOP
    EXECUTE format('
      CREATE POLICY "Master data readable by all authenticated users"
      ON public.%I FOR SELECT
      USING (auth.role() = ''authenticated'');', t);
  END LOOP;
END $$;

-- ============================================================
-- PATIENTS
-- ============================================================

CREATE POLICY "Patients viewable by hospital staff"
  ON public.hospital_patients FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('hospital_admin', 'doctor', 'developer'))
    OR created_by = auth.uid()
  );

CREATE POLICY "Patients insertable by hospital staff"
  ON public.hospital_patients FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('hospital_admin', 'doctor', 'developer'))
  );

CREATE POLICY "Patients updatable by hospital staff"
  ON public.hospital_patients FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('hospital_admin', 'doctor', 'developer')))
  WITH CHECK (EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('hospital_admin', 'doctor', 'developer')));

-- ============================================================
-- OPD CHILD TABLES — all follow same pattern
-- ============================================================

DO $$
DECLARE
  tables TEXT[] := ARRAY[
    'hospital_visits', 'hospital_chief_complaints', 'hospital_histories', 'hospital_vitals',
    'hospital_examinations', 'hospital_investigation_results', 'hospital_diagnoses',
    'hospital_prescriptions', 'hospital_procedures', 'hospital_advice',
    'hospital_special_instructions', 'hospital_followups', 'hospital_doctor_notes',
    'hospital_billing_items', 'hospital_billing_summary', 'hospital_opd_appointments'
  ];
  t TEXT;
BEGIN
  FOREACH t IN ARRAY tables
  LOOP
    EXECUTE format('
      CREATE POLICY "OPD viewable by hospital staff" ON public.%I FOR SELECT
      USING (EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN (''hospital_admin'', ''doctor'', ''developer'')));', t);
    EXECUTE format('
      CREATE POLICY "OPD insertable by hospital staff" ON public.%I FOR INSERT
      WITH CHECK (EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN (''hospital_admin'', ''doctor'', ''developer'')));', t);
    EXECUTE format('
      CREATE POLICY "OPD updatable by hospital staff" ON public.%I FOR UPDATE
      USING (EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN (''hospital_admin'', ''doctor'', ''developer'')))
      WITH CHECK (EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN (''hospital_admin'', ''doctor'', ''developer'')));', t);
  END LOOP;
END $$;
