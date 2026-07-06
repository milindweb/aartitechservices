-- Seed: Hospital Module Reference Data
-- Departments, doctors, symptoms only.
-- Medicine & investigation master data is imported via backend/import/ pipeline.

-- ============================================================
-- DEPARTMENTS
-- ============================================================
INSERT INTO public.hospital_departments (name, code, description) VALUES
  ('General Medicine', 'MED', 'General Medicine'),
  ('Cardiology', 'CARD', 'Cardiology'),
  ('Emergency / Casualty', 'CASUALTY', 'Emergency / Casualty'),
  ('Pulmonology', 'CHEST/TB', 'Pulmonology / Chest & TB'),
  ('Dental', 'DENT', 'Dental'),
  ('Dermatology', 'DERM', 'Dermatology'),
  ('Endocrinology', 'ENDO', 'Endocrinology'),
  ('Ear Nose & Throat', 'ENT', 'Ear, Nose & Throat'),
  ('Ophthalmology', 'EYE', 'Ophthalmology'),
  ('Gastroenterology', 'GASTRO', 'Gastroenterology'),
  ('Nephrology', 'NEPH', 'Nephrology'),
  ('Neurology', 'NEURO', 'Neurology'),
  ('Neurosurgery', 'NSURG', 'Neurosurgery'),
  ('Obstetrics & Gynecology', 'OBG/GYN', 'Obstetrics & Gynecology'),
  ('Oncology', 'ONCO', 'Oncology'),
  ('Orthopedics', 'ORTHO', 'Orthopedics'),
  ('Pediatrics', 'PAEDS', 'Pediatrics'),
  ('Physical Medicine & Rehab', 'PMR', 'Physical Medicine & Rehabilitation'),
  ('Psychiatry', 'PSY', 'Psychiatry'),
  ('General Surgery', 'SURG', 'General Surgery'),
  ('Urology', 'URO', 'Urology'),
  ('Physiotherapy', 'PHYSIO', 'Physiotherapy')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- DOCTOR MASTER (local clinics/hospitals from ClinicSRS)
-- ============================================================
INSERT INTO public.hospital_doctor_master (name, department_id, is_hospital) VALUES
  ('Dr. Girkar', (SELECT id FROM public.hospital_departments WHERE code = 'MED'), false),
  ('Dr. Nerekar', (SELECT id FROM public.hospital_departments WHERE code = 'MED'), false),
  ('Dr. Sathe', (SELECT id FROM public.hospital_departments WHERE code = 'MED'), false),
  ('Dr. Hajari', (SELECT id FROM public.hospital_departments WHERE code = 'MED'), false),
  ('Gargi Hospital', NULL, true),
  ('Gitai Hospital', NULL, true),
  ('Shyamnagar Hospital', NULL, true),
  ('INHS Sandhani', NULL, true),
  ('Terna Hospital', NULL, true),
  ('JJ Hospital', NULL, true),
  ('KEM Hospital', NULL, true),
  ('Other', NULL, false);

-- ============================================================
-- SYMPTOM MASTER (department-wise)
-- ============================================================
INSERT INTO public.symptom_master (department_code, symptom_name) VALUES
  ('MED', 'Fever'), ('MED', 'Cough'), ('MED', 'Cold'), ('MED', 'Body ache'),
  ('MED', 'Headache'), ('MED', 'Fatigue'), ('MED', 'Weakness'), ('MED', 'Weight loss'),
  ('MED', 'Loss of appetite'), ('MED', 'Nausea'), ('MED', 'Vomiting'),
  ('CARD', 'Chest pain'), ('CARD', 'Palpitations'), ('CARD', 'Shortness of breath'),
  ('CARD', 'Swelling in feet'), ('CARD', 'High BP'), ('CARD', 'Dizziness'),
  ('DERM', 'Skin rash'), ('DERM', 'Itching'), ('DERM', 'Hair fall'),
  ('DERM', 'Skin infection'), ('DERM', 'Eczema'), ('DERM', 'Psoriasis'),
  ('ENT', 'Ear pain'), ('ENT', 'Hearing loss'), ('ENT', 'Nasal congestion'),
  ('ENT', 'Sore throat'), ('ENT', 'Tonsillitis'), ('ENT', 'Sinusitis'),
  ('EYE', 'Eye pain'), ('EYE', 'Blurred vision'), ('EYE', 'Watering eyes'),
  ('EYE', 'Redness'), ('EYE', 'Difficulty seeing'), ('EYE', 'Glaucoma'),
  ('ORTHO', 'Joint pain'), ('ORTHO', 'Back pain'), ('ORTHO', 'Neck pain'),
  ('ORTHO', 'Knee pain'), ('ORTHO', 'Fracture'), ('ORTHO', 'Swelling'),
  ('PAEDS', 'Fever in child'), ('PAEDS', 'Vaccination'), ('PAEDS', 'Growth issues'),
  ('PAEDS', 'Diarrhea'), ('PAEDS', 'Cold & cough'), ('PAEDS', 'Feeding issues'),
  ('OBG/GYN', 'Pregnancy care'), ('OBG/GYN', 'Menstrual issues'), ('OBG/GYN', 'Lower abdominal pain'),
  ('OBG/GYN', 'White discharge'), ('OBG/GYN', 'Fertility concerns'),
  ('PSY', 'Anxiety'), ('PSY', 'Depression'), ('PSY', 'Insomnia'),
  ('PSY', 'Stress'), ('PSY', 'Mood swings'), ('PSY', 'Panic attacks'),
  ('NEURO', 'Migraine'), ('NEURO', 'Seizures'), ('NEURO', 'Numbness'),
  ('NEURO', 'Tremors'), ('NEURO', 'Memory loss'), ('NEURO', 'Stroke symptoms'),
  ('GASTRO', 'Abdominal pain'), ('GASTRO', 'Acidity'), ('GASTRO', 'Constipation'),
  ('GASTRO', 'Indigestion'), ('GASTRO', 'Ulcer'), ('GASTRO', 'Liver issues'),
  ('URO', 'Urinary infection'), ('URO', 'Kidney stones'), ('URO', 'Difficulty urinating'),
  ('URO', 'Blood in urine'), ('URO', 'Prostate issues'),
  ('CASUALTY', 'Accident'), ('CASUALTY', 'Injury'), ('CASUALTY', 'Burns'),
  ('CASUALTY', 'Poisoning'), ('CASUALTY', 'Snake bite'), ('CASUALTY', 'Emergency');

-- ============================================================
-- BILLING ITEMS MASTER
-- ============================================================
INSERT INTO public.hospital_billing_items (visit_id, description, quantity, rate, amount)
SELECT gen_random_uuid(), descr, 1, rate, 1 * rate FROM (
  VALUES
    ('Consultation Fee', 300.00),
    ('Online Consultation', 200.00),
    ('Follow-up Visit', 150.00),
    ('Injection', 50.00),
    ('Dressing', 100.00),
    ('Nebulization', 80.00),
    ('IV Fluids', 150.00),
    ('ECG', 200.00),
    ('Blood Test (CBC)', 250.00),
    ('Urine Routine', 100.00),
    ('X-Ray', 300.00),
    ('Ultrasound', 500.00),
    ('Minor Procedure', 500.00),
    ('Vaccination', 200.00),
    ('Prescription Refill', 100.00)
) AS items(description, rate)
WHERE false; -- no-op for billing master; items are created per-visit dynamically
