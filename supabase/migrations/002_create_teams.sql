-- =========================================
-- Migration 002: teams
-- =========================================
-- Stores the 48 national teams in the 2026 World Cup.
-- The id is the API-Football team id (INT, not UUID).

CREATE TABLE public.teams (
  id int PRIMARY KEY,
  name text NOT NULL,
  code text NOT NULL,
  group_letter text,
  flag_url text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_teams_group ON public.teams(group_letter);
