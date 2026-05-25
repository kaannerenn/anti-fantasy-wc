-- =========================================
-- Migration 004: matches
-- =========================================
-- Stores all matches in the 2026 World Cup (104 matches).
-- The id is the API-Football fixture id (INT).
-- Both team references use RESTRICT.

CREATE TABLE public.matches (
  id int PRIMARY KEY,
  home_team_id int NOT NULL REFERENCES public.teams(id) ON DELETE RESTRICT,
  away_team_id int NOT NULL REFERENCES public.teams(id) ON DELETE RESTRICT,
  kickoff_at timestamptz NOT NULL,
  status text NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'live', 'finished', 'postponed', 'cancelled')),
  home_score int,
  away_score int,
  stage text NOT NULL,
  processed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),

  -- A team cannot play against itself
  CONSTRAINT different_teams CHECK (home_team_id <> away_team_id)
);

-- Index for finding matches by date (for daily score calculations)
CREATE INDEX idx_matches_kickoff ON public.matches(kickoff_at);

-- Index for finding unprocessed finished matches (for cron job)
CREATE INDEX idx_matches_status_processed ON public.matches(status, processed_at)
WHERE status = 'finished' AND processed_at IS NULL;

-- Index for finding matches by team
CREATE INDEX idx_matches_home_team ON public.matches(home_team_id);
CREATE INDEX idx_matches_away_team ON public.matches(away_team_id);
