-- =========================================
-- Migration 003: players
-- =========================================
-- Stores all players in the 2026 World Cup (~1248 players).
-- The id is the API-Football player id (INT, not UUID).
-- team_id references teams(id) with RESTRICT - we don't delete teams.

CREATE TABLE public.players (
  id int PRIMARY KEY,
  team_id int NOT NULL REFERENCES public.teams(id) ON DELETE RESTRICT,
  name text NOT NULL,
  position text NOT NULL CHECK (position IN ('GK', 'DEF', 'MID', 'FWD')),
  shirt_number int,
  photo_url text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Index for filtering players by team (common query in roster building)
CREATE INDEX idx_players_team ON public.players(team_id);

-- Index for filtering by position (common query in free agent search)
CREATE INDEX idx_players_position ON public.players(position);
