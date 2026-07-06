import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") || "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || ""
    );

    const url = new URL(req.url);
    const type = url.searchParams.get("type") || "medicines";
    const q = url.searchParams.get("q") || "";
    const deptCode = url.searchParams.get("dept") || "";

    let data;

    switch (type) {
      case "medicines": {
        let query = supabase.from("medicine_search")
          .select("generic_id, generic_name, brand_id, brand_name, strength, dosage_form, route, manufacturer")
          .limit(50);
        if (q) query = query.or(`generic_name.ilike.%${q}%,brand_name.ilike.%${q}%`);
        const res = await query;
        data = res.data;
        break;
      }
      case "investigations": {
        let query = supabase.from("loinc_codes")
          .select("loinc_num, long_common_name, component, system, class, status")
          .in("status", ["ACTIVE", "TRIAL"])
          .limit(50);
        if (q) query = query.or(`long_common_name.ilike.%${q}%,loinc_num.ilike.%${q}%,component.ilike.%${q}%`);
        if (url.searchParams.get("class")) query = query.eq("class", url.searchParams.get("class"));
        const res = await query;
        data = res.data;
        break;
      }
      case "symptoms": {
        let query = supabase.from("symptom_master").select("id, symptom_name, department_code");
        if (deptCode) query = query.eq("department_code", deptCode);
        if (q) query = query.ilike("symptom_name", `%${q}%`);
        const res = await query;
        data = res.data;
        break;
      }
      case "diagnoses": {
        let query = supabase.from("icd10_codes").select("id, icd_code, disease_name").limit(50);
        if (q) query = query.or(`disease_name.ilike.%${q}%,icd_code.ilike.%${q}%`);
        const res = await query;
        data = res.data;
        break;
      }
      case "doctors": {
        let query = supabase.from("hospital_doctor_master").select("id, name, hospital_departments(name)");
        if (url.searchParams.get("dept_id")) query = query.eq("department_id", url.searchParams.get("dept_id"));
        const res = await query;
        data = res.data;
        break;
      }
      case "departments": {
        const res = await supabase.from("hospital_departments").select("id, name, code").order("name");
        data = res.data;
        break;
      }
      default:
        return new Response(JSON.stringify({ error: "Invalid type" }), { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    return new Response(JSON.stringify(data), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
