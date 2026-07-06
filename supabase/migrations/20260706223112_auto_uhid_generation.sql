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
