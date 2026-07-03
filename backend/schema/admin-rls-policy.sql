-- Admin RLS Policy + First Admin Setup
-- Run this in Supabase SQL Editor

-- 1. Allow admins to UPDATE any user's profile
CREATE POLICY "admins_update_all_profiles"
  ON public.users_profile
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.users_profile
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- 2. Set yourself as admin (replace with your email)
UPDATE public.users_profile
SET role = 'admin'
WHERE email = 'your-email@example.com';
