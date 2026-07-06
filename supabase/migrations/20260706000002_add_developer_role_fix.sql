-- Add developer role to existing RLS policies
-- Uses safe IF EXISTS checks for each table

-- Users profile policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'users_profile') THEN
    DROP POLICY IF EXISTS "users_view_own_profile" ON public.users_profile;
    CREATE POLICY "users_view_own_profile"
      ON public.users_profile FOR SELECT
      USING (
        auth.uid() = id 
        OR EXISTS (
          SELECT 1 FROM public.users_profile 
          WHERE id = auth.uid() AND role IN ('admin', 'developer')
        )
      );
    DROP POLICY IF EXISTS "admins_update_all_profiles" ON public.users_profile;
    CREATE POLICY "admins_update_all_profiles"
      ON public.users_profile FOR UPDATE
      USING (
        EXISTS (
          SELECT 1 FROM public.users_profile
          WHERE id = auth.uid() AND role IN ('admin', 'developer')
        )
      );
  END IF;
END $$;

-- Blog posts policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'blog_posts') THEN
    DROP POLICY IF EXISTS "blog_posts_public_read" ON public.blog_posts;
    CREATE POLICY "blog_posts_public_read"
      ON public.blog_posts FOR SELECT
      USING (
        status = 'published' OR author_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer', 'blogger')
        )
      );
    DROP POLICY IF EXISTS "blog_posts_insert" ON public.blog_posts;
    CREATE POLICY "blog_posts_insert"
      ON public.blog_posts FOR INSERT
      WITH CHECK (
        author_id = auth.uid() AND EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer', 'blogger')
        )
      );
    DROP POLICY IF EXISTS "blog_posts_update" ON public.blog_posts;
    CREATE POLICY "blog_posts_update"
      ON public.blog_posts FOR UPDATE
      USING (
        author_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer')
        )
      );
    DROP POLICY IF EXISTS "blog_posts_delete" ON public.blog_posts;
    CREATE POLICY "blog_posts_delete"
      ON public.blog_posts FOR DELETE
      USING (
        author_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer')
        )
      );
  END IF;
END $$;

-- Blog comments policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'blog_comments') THEN
    DROP POLICY IF EXISTS "blog_comments_read" ON public.blog_comments;
    CREATE POLICY "blog_comments_read"
      ON public.blog_comments FOR SELECT
      USING (
        EXISTS (SELECT 1 FROM public.blog_posts WHERE id = post_id AND status = 'published')
        OR user_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer'))
      );
    DROP POLICY IF EXISTS "blog_comments_update" ON public.blog_comments;
    CREATE POLICY "blog_comments_update"
      ON public.blog_comments FOR UPDATE
      USING (
        user_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer')
        )
      );
  END IF;
END $$;

-- Hospital appointments policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'hospital_appointments') THEN
    DROP POLICY IF EXISTS "hospital_appointments_read" ON public.hospital_appointments;
    CREATE POLICY "hospital_appointments_read"
      ON public.hospital_appointments FOR SELECT
      USING (
        patient_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.hospital_doctors WHERE id = doctor_id AND user_id = auth.uid())
        OR EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer', 'hospital_admin'))
      );
    DROP POLICY IF EXISTS "hospital_appointments_update" ON public.hospital_appointments;
    CREATE POLICY "hospital_appointments_update"
      ON public.hospital_appointments FOR UPDATE
      USING (
        patient_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.hospital_doctors WHERE id = doctor_id AND user_id = auth.uid())
        OR EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer'))
      );
  END IF;
END $$;

-- Hospital doctors policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'hospital_doctors') THEN
    DROP POLICY IF EXISTS "hospital_doctors_read" ON public.hospital_doctors;
    CREATE POLICY "hospital_doctors_read"
      ON public.hospital_doctors FOR SELECT
      USING (
        status = 'active' OR user_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer', 'hospital_admin')
        )
      );
  END IF;
END $$;

-- Society posts policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'society_posts') THEN
    DROP POLICY IF EXISTS "society_posts_members_read" ON public.society_posts;
    CREATE POLICY "society_posts_members_read"
      ON public.society_posts FOR SELECT
      USING (
        EXISTS (SELECT 1 FROM public.society_members WHERE group_id = society_posts.group_id AND user_id = auth.uid())
        OR EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer'))
      );
    DROP POLICY IF EXISTS "society_posts_update" ON public.society_posts;
    CREATE POLICY "society_posts_update"
      ON public.society_posts FOR UPDATE
      USING (
        author_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer')
        )
      );
  END IF;
END $$;

-- Society groups policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'society_groups') THEN
    DROP POLICY IF EXISTS "society_groups_read" ON public.society_groups;
    CREATE POLICY "society_groups_read"
      ON public.society_groups FOR SELECT
      USING (
        status = 'active' OR admin_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer')
        )
      );
  END IF;
END $$;

-- Seniority records policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'seniority_records') THEN
    DROP POLICY IF EXISTS "seniority_records_read_own" ON public.seniority_records;
    CREATE POLICY "seniority_records_read_own"
      ON public.seniority_records FOR SELECT
      USING (
        user_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer', 'senior_admin')
        )
      );
    DROP POLICY IF EXISTS "seniority_records_update_admin" ON public.seniority_records;
    CREATE POLICY "seniority_records_update_admin"
      ON public.seniority_records FOR UPDATE
      USING (
        EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer', 'senior_admin'))
      );
  END IF;
END $$;

-- Seniority promotions policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'seniority_promotions') THEN
    DROP POLICY IF EXISTS "seniority_promotions_read" ON public.seniority_promotions;
    CREATE POLICY "seniority_promotions_read"
      ON public.seniority_promotions FOR SELECT
      USING (
        EXISTS (SELECT 1 FROM public.seniority_records sr WHERE sr.id = record_id AND (sr.user_id = auth.uid() OR auth.uid() IN (
          SELECT id FROM public.users_profile WHERE role IN ('admin', 'developer', 'senior_admin')
        )))
      );
  END IF;
END $$;

-- Audit logs policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'audit_logs') THEN
    DROP POLICY IF EXISTS "audit_logs_admin_read" ON public.audit_logs;
    CREATE POLICY "audit_logs_admin_read"
      ON public.audit_logs FOR SELECT
      USING (
        EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer'))
      );
  END IF;
END $$;

-- Admin settings policies
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'admin_settings') THEN
    DROP POLICY IF EXISTS "admin_settings_write" ON public.admin_settings;
    CREATE POLICY "admin_settings_write"
      ON public.admin_settings FOR UPDATE
      USING (
        EXISTS (SELECT 1 FROM public.users_profile WHERE id = auth.uid() AND role IN ('admin', 'developer'))
      );
  END IF;
END $$;
