-- 日日澆水：在 Supabase 的 SQL Editor 貼上並執行一次即可。
-- 每個使用者只有一列資料，內容是整份遊戲進度（jsonb）。

create table if not exists public.saves (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  payload    jsonb not null,
  updated_at timestamptz not null default now(),
  constraint saves_payload_size check (octet_length(payload::text) < 500000)
);

-- 開啟列級安全：沒有下面的規則，任何人都讀寫不到。
alter table public.saves enable row level security;

drop policy if exists "saves_select_own" on public.saves;
drop policy if exists "saves_insert_own" on public.saves;
drop policy if exists "saves_update_own" on public.saves;
drop policy if exists "saves_delete_own" on public.saves;

create policy "saves_select_own" on public.saves
  for select using ((select auth.uid()) = user_id);
create policy "saves_insert_own" on public.saves
  for insert with check ((select auth.uid()) = user_id);
create policy "saves_update_own" on public.saves
  for update using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "saves_delete_own" on public.saves
  for delete using ((select auth.uid()) = user_id);
