-- Sumber percakapan baru (WhatsApp/Website Sapta & Mandala) pada catatan follow-up.
-- Sudah diterapkan ke Supabase hnwgpwkkpqdblrofjrvh pada 2026-11-02.
alter table public.follow_ups drop constraint if exists follow_ups_channel_check;
alter table public.follow_ups add constraint follow_ups_channel_check
  check (channel = any (array['wa','website','call','lainnya','wa_sapta','wa_mandala','web_sapta','web_mandala']::text[]));
