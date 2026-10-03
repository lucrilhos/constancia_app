-- ============================================================
-- Constancia — schema inicial do Supabase (Checkpoint 5)
-- Rode isto inteiro no SQL Editor do seu projeto Supabase.
-- ============================================================

-- Extensão pra gerar UUIDs automaticamente
create extension if not exists "pgcrypto";

-- ------------------------------------------------------------
-- profiles: cada pessoa do grupo (você + amigos)
-- ------------------------------------------------------------
create table profiles (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  initials text not null,
  current_streak int not null default 0,
  multiplier numeric(3, 1) not null default 1.0,
  shields int not null default 0,
  points int not null default 0,
  created_at timestamptz not null default now()
);

-- ------------------------------------------------------------
-- tasks: tarefas de cada pessoa
-- ------------------------------------------------------------
create table tasks (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references profiles (id) on delete cascade,
  title text not null,
  status text not null check (status in ('nao_iniciada', 'em_desenvolvimento', 'parada')),
  blocked_reason text,
  created_at timestamptz not null default now()
);

-- ------------------------------------------------------------
-- task_comments: comentários de amigos numa tarefa
-- ------------------------------------------------------------
create table task_comments (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references tasks (id) on delete cascade,
  author_id uuid not null references profiles (id) on delete cascade,
  text text not null,
  created_at timestamptz not null default now()
);

-- ------------------------------------------------------------
-- RLS: habilitado, mas com política aberta de leitura/escrita.
-- Pra um protótipo de checkpoint (sem autenticação real) isso é
-- suficiente — dá pra restringir depois, quando houver login de verdade.
-- ------------------------------------------------------------
alter table profiles enable row level security;
alter table tasks enable row level security;
alter table task_comments enable row level security;

create policy "Leitura e escrita abertas (protótipo)" on profiles
  for all using (true) with check (true);
create policy "Leitura e escrita abertas (protótipo)" on tasks
  for all using (true) with check (true);
create policy "Leitura e escrita abertas (protótipo)" on task_comments
  for all using (true) with check (true);

-- ============================================================
-- Dados mockados — nomes reais do grupo
-- ============================================================

insert into profiles (name, initials, current_streak, multiplier, shields, points) values
  ('Gustavo Braga',      'GB', 14, 1.5, 1, 189),
  ('Lucas Mendes',       'LM', 12, 1.2, 0, 153),
  ('Kaio Correa',        'KC',  9, 1.2, 1, 120),
  ('Guilherme Califoni', 'GC',  7, 1.2, 0,  98),
  ('Antônio Lucas',      'AL',  4, 1.0, 0,  61),
  ('Enzo Ribeiro',       'ER',  2, 1.0, 0,  30),
  ('Bento',              'BE',  1, 1.0, 0,  12);

-- tarefas do Gustavo (dono "principal" do app nesta demo)
insert into tasks (owner_id, title, status, blocked_reason)
select id, 'Estudar Python', 'em_desenvolvimento', null
from profiles where name = 'Gustavo Braga';

insert into tasks (owner_id, title, status, blocked_reason)
select id, 'Integração com API — Estudo', 'parada', 'Esperando a aula 2 sobre APIs ficar disponível'
from profiles where name = 'Gustavo Braga';

insert into tasks (owner_id, title, status, blocked_reason)
select id, 'Ler 20 páginas do livro', 'nao_iniciada', null
from profiles where name = 'Gustavo Braga';

insert into tasks (owner_id, title, status, blocked_reason)
select id, '30 min de exercício', 'nao_iniciada', null
from profiles where name = 'Gustavo Braga';

insert into tasks (owner_id, title, status, blocked_reason)
select id, 'Preparar apresentação do TCC', 'em_desenvolvimento', null
from profiles where name = 'Gustavo Braga';

-- comentários dos amigos
insert into task_comments (task_id, author_id, text)
select t.id, p.id, 'Bora nessa, te chamo pra revisar depois'
from tasks t, profiles p
where t.title = 'Estudar Python' and p.name = 'Enzo Ribeiro';

insert into task_comments (task_id, author_id, text)
select t.id, p.id, 'Vi um vídeo bom sobre isso, te mando o link'
from tasks t, profiles p
where t.title = 'Integração com API — Estudo' and p.name = 'Lucas Mendes';

insert into task_comments (task_id, author_id, text)
select t.id, p.id, 'Travei nessa parte também, bora estudar junto amanhã?'
from tasks t, profiles p
where t.title = 'Integração com API — Estudo' and p.name = 'Kaio Correa';

insert into task_comments (task_id, author_id, text)
select t.id, p.id, 'Manda um print de como tá ficando'
from tasks t, profiles p
where t.title = 'Preparar apresentação do TCC' and p.name = 'Guilherme Califoni';
