-- Migration: Initial Schema Setup
-- Description: Creates the initial database schema for 10xCards application
-- Tables: flashcards, generations, generation_error_logs
-- Note: users table is managed by Supabase Auth

-- Create flashcards table
create table if not exists public.flashcards (
    id bigserial primary key,
    front varchar(200) not null,
    back varchar(500) not null,
    source varchar not null check (source in ('ai-full', 'ai-edited', 'manual')),
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    generation_id bigint,
    user_id uuid not null
);

-- Add comment to flashcards table
comment on table public.flashcards is 'Stores user flashcards with front and back content';

-- Create generations table
create table if not exists public.generations (
    id bigserial primary key,
    user_id uuid not null,
    model varchar not null,
    generated_count integer not null,
    accepted_unedited_count integer,
    accepted_edited_count integer,
    source_text_hash varchar not null,
    source_text_length integer not null check (source_text_length between 1000 and 10000),
    generation_duration integer not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Add comment to generations table
comment on table public.generations is 'Tracks AI generation metadata for flashcards';

-- Create generation_error_logs table
create table if not exists public.generation_error_logs (
    id bigserial primary key,
    user_id uuid not null,
    model varchar not null,
    source_text_hash varchar not null,
    source_text_length integer not null check (source_text_length between 1000 and 10000),
    error_code varchar(100) not null,
    error_message text not null,
    created_at timestamptz not null default now()
);

-- Add comment to generation_error_logs table
comment on table public.generation_error_logs is 'Logs errors during flashcard generation process';

-- Create foreign key constraints
alter table public.flashcards
    add constraint flashcards_user_id_fkey
    foreign key (user_id)
    references auth.users(id);

alter table public.flashcards
    add constraint flashcards_generation_id_fkey
    foreign key (generation_id)
    references public.generations(id)
    on delete set null;

alter table public.generations
    add constraint generations_user_id_fkey
    foreign key (user_id)
    references auth.users(id);

alter table public.generation_error_logs
    add constraint generation_error_logs_user_id_fkey
    foreign key (user_id)
    references auth.users(id);

-- Create indexes
create index if not exists flashcards_user_id_idx on public.flashcards(user_id);
create index if not exists flashcards_generation_id_idx on public.flashcards(generation_id);
create index if not exists generations_user_id_idx on public.generations(user_id);
create index if not exists generation_error_logs_user_id_idx on public.generation_error_logs(user_id);

-- Create trigger to update updated_at timestamp for flashcards
create or replace function public.handle_updated_at()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

create trigger set_updated_at
before update on public.flashcards
for each row execute function public.handle_updated_at();

-- Create trigger to update updated_at timestamp for generations
create trigger set_generations_updated_at
before update on public.generations
for each row execute function public.handle_updated_at();

-- Enable Row Level Security
alter table public.flashcards enable row level security;
alter table public.generations enable row level security;
alter table public.generation_error_logs enable row level security;

-- RLS policies for flashcards table
-- Policy for authenticated users to select their own records
create policy "Users can view their own flashcards"
on public.flashcards for select
to authenticated
using (auth.uid() = user_id);

-- Policy for authenticated users to insert their own records
create policy "Users can insert their own flashcards"
on public.flashcards for insert
to authenticated
with check (auth.uid() = user_id);

-- Policy for authenticated users to update their own records
create policy "Users can update their own flashcards"
on public.flashcards for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Policy for authenticated users to delete their own records
create policy "Users can delete their own flashcards"
on public.flashcards for delete
to authenticated
using (auth.uid() = user_id);

-- RLS policies for generations table
-- Policy for authenticated users to select their own records
create policy "Users can view their own generations"
on public.generations for select
to authenticated
using (auth.uid() = user_id);

-- Policy for authenticated users to insert their own records
create policy "Users can insert their own generations"
on public.generations for insert
to authenticated
with check (auth.uid() = user_id);

-- Policy for authenticated users to update their own records
create policy "Users can update their own generations"
on public.generations for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Policy for authenticated users to delete their own records
create policy "Users can delete their own generations"
on public.generations for delete
to authenticated
using (auth.uid() = user_id);

-- RLS policies for generation_error_logs table
-- Policy for authenticated users to select their own records
create policy "Users can view their own generation error logs"
on public.generation_error_logs for select
to authenticated
using (auth.uid() = user_id);

-- Policy for authenticated users to insert their own records
create policy "Users can insert their own generation error logs"
on public.generation_error_logs for insert
to authenticated
with check (auth.uid() = user_id);

-- No update policy for error logs as they should be immutable

-- No policies for anon role as all operations require authentication 