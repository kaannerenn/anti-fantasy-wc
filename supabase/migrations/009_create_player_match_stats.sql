-- =========================================
-- Migration 009: player_match_stats
-- =========================================
-- Stores raw player performance data from API-Football for each match.
-- The 'events' JSONB field contains all metric counts.
-- rating is extracted as a column for fast queries (rating bonus thresholds).

CREATE TABLE public.player_match_stats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id int NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  match_id int NOT NULL REFERENCES public.matches(id) ON DELETE CASCADE,
  events jsonb NOT NULL DEFAULT '{}'::jsonb,
  rating numeric(3,1),
  minutes_played int NOT NULL DEFAULT 0 CHECK (minutes_played BETWEEN 0 AND 120),
  started boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),

  -- A player has only one stat row per match
  CONSTRAINT unique_player_match UNIQUE (player_id, match_id)
);

CREATE INDEX idx_pms_player ON public.player_match_stats(player_id);
CREATE INDEX idx_pms_match ON public.player_match_stats(match_id);
CREATE INDEX idx_pms_rating ON public.player_match_stats(rating)
WHERE rating IS NOT NULL;
