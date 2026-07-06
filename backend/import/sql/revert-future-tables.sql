-- Revert: Drop future LOINC tables that were exported but are not yet needed.
-- Run only if these tables exist in Supabase and have no data worth keeping.
-- Safe to re-run (DROP IF EXISTS).

DROP TABLE IF EXISTS public.loinc_answer_list_links;
DROP TABLE IF EXISTS public.loinc_answer_list;
DROP TABLE IF EXISTS public.loinc_part_links;
