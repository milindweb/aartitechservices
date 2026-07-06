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

    const today = new Date().toISOString().split("T")[0];

    const [{ count: totalPatients }, { count: todayVisits }, { count: pendingVisits }, { data: recentVisits }] = await Promise.all([
      supabase.from("hospital_patients").select("*", { count: "exact", head: true }),
      supabase.from("hospital_visits").select("*", { count: "exact", head: true }).gte("visit_date", today).lt("visit_date", today + "T23:59:59"),
      supabase.from("hospital_visits").select("*", { count: "exact", head: true }).eq("visit_status", "active"),
      supabase.from("hospital_visits").select("id, opd_number, visit_date, visit_type, visit_status, hospital_patients(full_name, uhid)").order("created_at", { ascending: false }).limit(10),
    ]);

    const data = {
      totalPatients: totalPatients || 0,
      todayVisits: todayVisits || 0,
      pendingVisits: pendingVisits || 0,
      recentVisits: recentVisits || [],
    };

    return new Response(JSON.stringify(data), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
