-- Execute no Supabase: SQL Editor > New query > Run.
-- Esta tabela armazena o progresso completo separado para cada conta autenticada.
create table if not exists public.player_saves (
  user_id uuid primary key references auth.users(id) on delete cascade,
  save_data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.player_saves enable row level security;

drop policy if exists "Jogador lê o próprio salvamento" on public.player_saves;
create policy "Jogador lê o próprio salvamento"
  on public.player_saves for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Jogador cria o próprio salvamento" on public.player_saves;
create policy "Jogador cria o próprio salvamento"
  on public.player_saves for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Jogador atualiza o próprio salvamento" on public.player_saves;
create policy "Jogador atualiza o próprio salvamento"
  on public.player_saves for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
