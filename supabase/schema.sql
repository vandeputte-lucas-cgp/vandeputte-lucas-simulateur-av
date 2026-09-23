-- Simulateur Assurance Vie — schéma Supabase
-- À coller une seule fois dans Supabase : SQL Editor → New query → Run.

create table if not exists public.clients (
  id          text primary key,
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nom         text not null default '',
  data        jsonb not null,
  updated_at  timestamptz not null default now(),
  created_at  timestamptz not null default now()
);

create index if not exists clients_user_idx on public.clients (user_id);

-- Chaque conseiller ne voit et ne modifie que ses propres clients.
alter table public.clients enable row level security;

drop policy if exists "clients_select_own" on public.clients;
drop policy if exists "clients_insert_own" on public.clients;
drop policy if exists "clients_update_own" on public.clients;
drop policy if exists "clients_delete_own" on public.clients;

create policy "clients_select_own" on public.clients
  for select to authenticated using (user_id = auth.uid());
create policy "clients_insert_own" on public.clients
  for insert to authenticated with check (user_id = auth.uid());
create policy "clients_update_own" on public.clients
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "clients_delete_own" on public.clients
  for delete to authenticated using (user_id = auth.uid());

-- Synchronisation en direct entre appareils (ordinateur, iPad, téléphone).
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'clients'
  ) then
    alter publication supabase_realtime add table public.clients;
  end if;
end $$;
alter table public.clients replica identity full;
