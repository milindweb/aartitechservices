-- Hospital Module - OPD Transaction Schema
-- Additive to main schema.sql (hospital_departments, hospital_doctors, hospital_appointments)
-- Master data tables (medicine, investigation, diagnosis) are in backend/import/sql/ — run those first

-- ============================================================
-- MASTER / REFERENCE TABLES
-- ============================================================

-- Doctor Master (local clinics/hospitals — NOT linked to auth users)
CREATE TABLE public.hospital_doctor_master (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  department_id UUID REFERENCES public.hospital_departments(id),
  is_hospital BOOLEAN DEFAULT false,
  contact VARCHAR(100),
  address TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_doctor_master ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- OPD / PATIENT MANAGEMENT TABLES
-- ============================================================

-- OPD Appointments (for hospital module — separate from main hospital_appointments)
CREATE TABLE public.hospital_opd_appointments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES public.hospital_patients(id) ON DELETE CASCADE,
  doctor_id UUID REFERENCES public.hospital_doctor_master(id),
  doctor_name VARCHAR(255),
  department_id UUID REFERENCES public.hospital_departments(id),
  appointment_date TIMESTAMP NOT NULL DEFAULT NOW(),
  duration_minutes INT DEFAULT 15,
  status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'confirmed', 'completed', 'cancelled')),
  notes TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_opd_appointments ENABLE ROW LEVEL SECURITY;

-- Patients
CREATE TABLE public.hospital_patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  uhid VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  gender VARCHAR(10),
  date_of_birth DATE,
  age INT GENERATED ALWAYS AS (
    CASE
      WHEN date_of_birth IS NOT NULL THEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth))::INT
      ELSE NULL
    END
  ) STORED,
  mobile VARCHAR(20),
  email VARCHAR(255),
  address TEXT,
  blood_group VARCHAR(5),
  drug_allergies TEXT[],
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_patients ENABLE ROW LEVEL SECURITY;

-- UHID auto-generation: daily counter (resets each day)
CREATE TABLE IF NOT EXISTS public.uhid_daily_counter (
  date_key DATE PRIMARY KEY DEFAULT CURRENT_DATE,
  last_seq INT NOT NULL DEFAULT 0
);

CREATE OR REPLACE FUNCTION public.generate_uhid()
RETURNS TRIGGER AS $$
DECLARE
  seq_num INT;
BEGIN
  -- If UHID is explicitly provided, use it as-is
  IF NEW.uhid IS NOT NULL AND NEW.uhid != '' THEN
    RETURN NEW;
  END IF;

  INSERT INTO public.uhid_daily_counter (date_key, last_seq)
  VALUES (CURRENT_DATE, 1)
  ON CONFLICT (date_key) DO UPDATE SET last_seq = uhid_daily_counter.last_seq + 1
  RETURNING last_seq INTO seq_num;

  NEW.uhid := TO_CHAR(CURRENT_DATE, 'YYMMDD') || '-' || LPAD(seq_num::TEXT, 2, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_hospital_patients_uhid
  BEFORE INSERT ON public.hospital_patients
  FOR EACH ROW
  EXECUTE FUNCTION public.generate_uhid();

-- OPD Visits
CREATE TABLE public.hospital_visits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES public.hospital_patients(id) ON DELETE CASCADE,
  opd_number VARCHAR(50) NOT NULL,
  token_number INT,
  visit_date TIMESTAMP NOT NULL DEFAULT NOW(),
  visit_type VARCHAR(20) CHECK (visit_type IN ('New', 'Follow-up')),
  department_id UUID REFERENCES public.hospital_departments(id),
  doctor_id UUID REFERENCES public.hospital_doctor_master(id),
  referred_by TEXT,
  visit_status VARCHAR(20) DEFAULT 'active' CHECK (visit_status IN ('active', 'completed', 'cancelled')),
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_visits ENABLE ROW LEVEL SECURITY;

-- Chief Complaints
CREATE TABLE public.hospital_chief_complaints (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  symptom TEXT NOT NULL,
  duration TEXT,
  severity VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_chief_complaints ENABLE ROW LEVEL SECURITY;

-- Patient History
CREATE TABLE public.hospital_histories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  history_type VARCHAR(50) NOT NULL CHECK (history_type IN (
    'present_illness', 'past_medical', 'current_medicines', 'drug_allergy', 'family', 'personal'
  )),
  description TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_histories ENABLE ROW LEVEL SECURITY;

-- Vitals
CREATE TABLE public.hospital_vitals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  height_cm DECIMAL(5,1),
  weight_kg DECIMAL(5,1),
  bmi DECIMAL(4,1) GENERATED ALWAYS AS (
    CASE
      WHEN height_cm IS NOT NULL AND weight_kg IS NOT NULL
      THEN ROUND((weight_kg / ((height_cm / 100) ^ 2))::DECIMAL, 1)
      ELSE NULL
    END
  ) STORED,
  bp_systolic INT,
  bp_diastolic INT,
  pulse_rate INT,
  respiratory_rate INT,
  spo2 INT,
  temperature DECIMAL(4,1),
  blood_sugar DECIMAL(6,1),
  blood_sugar_type VARCHAR(20) CHECK (blood_sugar_type IN ('fasting', 'post_prandial', 'random', 'hba1c')),
  recorded_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_vitals ENABLE ROW LEVEL SECURITY;

-- Examinations
CREATE TABLE public.hospital_examinations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  exam_type VARCHAR(50) NOT NULL CHECK (exam_type IN (
    'general', 'systemic', 'clinical_findings', 'lab_findings'
  )),
  description TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_examinations ENABLE ROW LEVEL SECURITY;

-- Investigation Results (references loinc_codes from import pipeline)
CREATE TABLE public.hospital_investigation_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  loinc_code VARCHAR(10) REFERENCES public.loinc_codes(loinc_num),
  test_name TEXT NOT NULL,
  category VARCHAR(100),
  result TEXT,
  normal_range TEXT,
  status VARCHAR(20) GENERATED ALWAYS AS (
    CASE
      WHEN result IS NULL THEN 'pending'
      WHEN normal_range IS NULL THEN 'not_applicable'
      ELSE 'reviewed'
    END
  ) STORED,
  doctor_remark TEXT,
  is_abnormal BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_investigation_results ENABLE ROW LEVEL SECURITY;

-- Diagnoses (references icd10_codes from import pipeline)
CREATE TABLE public.hospital_diagnoses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  diagnosis_type VARCHAR(20) NOT NULL CHECK (diagnosis_type IN ('provisional', 'final')),
  icd_code VARCHAR(20) REFERENCES public.icd10_codes(icd_code),
  diagnosis_text TEXT NOT NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_diagnoses ENABLE ROW LEVEL SECURITY;

-- Prescriptions (medicine_name used directly; generic_id references import pipeline)
CREATE TABLE public.hospital_prescriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  generic_id INT REFERENCES public.generic_master(id),
  brand_id INT REFERENCES public.brand_master(id),
  medicine_name TEXT NOT NULL,
  route VARCHAR(50) CHECK (route IN (
    'Tablet', 'Capsule', 'Syrup', 'Injection', 'IV', 'Ointment', 'Drops', 'Other'
  )),
  frequency VARCHAR(50) CHECK (frequency IN (
    'OD', 'BD', 'TDS', 'QID', 'HS', 'SOS', 'STAT', 'Weekly', 'Monthly'
  )),
  food_timing VARCHAR(50) CHECK (food_timing IN (
    'Before Food', 'After Food', 'With Food', 'Empty Stomach', 'At Bedtime', 'SOS', 'Not Applicable'
  )),
  duration VARCHAR(100),
  instructions TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_prescriptions ENABLE ROW LEVEL SECURITY;

-- Procedures / Treatments
CREATE TABLE public.hospital_procedures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  procedure_name VARCHAR(100) NOT NULL CHECK (procedure_name IN (
    'Injection', 'Dressing', 'Nebulization', 'IV Fluids', 'Minor Procedure', 'Other Treatment'
  )),
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_procedures ENABLE ROW LEVEL SECURITY;

-- Advice
CREATE TABLE public.hospital_advice (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  advice_type VARCHAR(50) CHECK (advice_type IN (
    'Diet', 'Lifestyle', 'Rest', 'Exercise', 'General Instructions'
  )),
  description TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_advice ENABLE ROW LEVEL SECURITY;

-- Special Instructions
CREATE TABLE public.hospital_special_instructions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  instructions TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_special_instructions ENABLE ROW LEVEL SECURITY;

-- Follow-ups
CREATE TABLE public.hospital_followups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  treatment_response VARCHAR(30) CHECK (treatment_response IN (
    'N/A', 'Improved', 'Recovered', 'No Change', 'Worsened', 'Follow-up Required'
  )),
  followup_date DATE,
  next_visit_advice TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_followups ENABLE ROW LEVEL SECURITY;

-- Doctor Notes
CREATE TABLE public.hospital_doctor_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  remarks TEXT,
  signature TEXT,
  doctor_id UUID REFERENCES public.hospital_doctor_master(id),
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_doctor_notes ENABLE ROW LEVEL SECURITY;

-- Billing Items
CREATE TABLE public.hospital_billing_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE,
  description TEXT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  rate DECIMAL(10,2) NOT NULL,
  amount DECIMAL(10,2) GENERATED ALWAYS AS (quantity * rate) STORED,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_billing_items ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.hospital_billing_summary (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES public.hospital_visits(id) ON DELETE CASCADE UNIQUE,
  total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
  discount DECIMAL(10,2) DEFAULT 0,
  grand_total DECIMAL(10,2) GENERATED ALWAYS AS (total_amount - discount) STORED,
  payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'partially_paid', 'cancelled')),
  payment_method VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE public.hospital_billing_summary ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_hospital_patients_uhid ON public.hospital_patients(uhid);
CREATE INDEX idx_hospital_patients_mobile ON public.hospital_patients(mobile);
CREATE INDEX idx_hospital_patients_name ON public.hospital_patients(full_name);
CREATE INDEX idx_hospital_visits_patient ON public.hospital_visits(patient_id);
CREATE INDEX idx_hospital_visits_date ON public.hospital_visits(visit_date DESC);
CREATE INDEX idx_hospital_visits_opd ON public.hospital_visits(opd_number);
CREATE INDEX idx_hospital_visits_status ON public.hospital_visits(visit_status);
CREATE INDEX idx_hospital_prescriptions_visit ON public.hospital_prescriptions(visit_id);
CREATE INDEX idx_hospital_investigations_visit ON public.hospital_investigation_results(visit_id);
CREATE INDEX idx_hospital_billing_visit ON public.hospital_billing_items(visit_id);
CREATE INDEX idx_hospital_followups_visit ON public.hospital_followups(visit_id);
CREATE INDEX idx_hospital_opd_appts_patient ON public.hospital_opd_appointments(patient_id);
CREATE INDEX idx_hospital_opd_appts_date ON public.hospital_opd_appointments(appointment_date DESC);
CREATE INDEX idx_hospital_opd_appts_status ON public.hospital_opd_appointments(status);
