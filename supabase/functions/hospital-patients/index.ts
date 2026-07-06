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

    const { method } = req;
    const url = new URL(req.url);
    const path = url.pathname;
    const id = path.split("/").pop();

    if (method === "GET") {
      if (id && id !== "hospital-patients") {
        const { data } = await supabase.from("hospital_patients").select("*, hospital_visits(*)").eq("id", id).single();
        return new Response(JSON.stringify(data), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
      }
      const q = url.searchParams.get("q") || "";
      const page = parseInt(url.searchParams.get("page") || "1");
      const limit = parseInt(url.searchParams.get("limit") || "20");
      let query = supabase.from("hospital_patients").select("*", { count: "exact" });
      if (q) query = query.or(`full_name.ilike.%${q}%,uhid.ilike.%${q}%,mobile.ilike.%${q}%`);
      query = query.order("created_at", { ascending: false }).range((page - 1) * limit, page * limit - 1);
      const { data, count } = await query;
      return new Response(JSON.stringify({ data, count, page, limit }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    if (method === "POST") {
      const body = await req.json();
      const { data, error } = await supabase.from("hospital_patients").insert(body).select().single();
      if (error) throw error;
      return new Response(JSON.stringify(data), { status: 201, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
