-- Migration: Disable Initial Policies
-- Description: Disables all RLS policies created in the initial schema setup
-- Tables affected: flashcards, generations, generation_error_logs

-- Drop policies for flashcards table
drop policy if exists "Users can view their own flashcards" on public.flashcards;
drop policy if exists "Users can insert their own flashcards" on public.flashcards;
drop policy if exists "Users can update their own flashcards" on public.flashcards;
drop policy if exists "Users can delete their own flashcards" on public.flashcards;

-- Drop policies for generations table
drop policy if exists "Users can view their own generations" on public.generations;
drop policy if exists "Users can insert their own generations" on public.generations;
drop policy if exists "Users can update their own generations" on public.generations;
drop policy if exists "Users can delete their own generations" on public.generations;

-- Drop policies for generation_error_logs table
drop policy if exists "Users can view their own generation error logs" on public.generation_error_logs;
drop policy if exists "Users can insert their own generation error logs" on public.generation_error_logs;

-- Note: RLS remains enabled on the tables, but all policies are removed
-- This effectively blocks all access to these tables until new policies are created 