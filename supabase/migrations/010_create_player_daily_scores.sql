-- =========================================
-- Migration 010: player_daily_scores
-- =========================================
-- Calculated anti-fantasy points for each player per match.
-- 'breakdown' JSONB shows which event contributed how many points.
-- This table is derived from player_match_stats but cached for fast UI reads.

CREATE TABLE public.player_daily_scores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id int NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  match_id int NOT NULL REFERENCES public.matches(id) ON DELETE CASCADE,
  total_points numeric(6,1) NOT NULL DEFAULT 0,
  breakdown jsonb NOT NULL DEFAULT '{}'::jsonb,
  calculated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT unique_player_match_score UNIQUE (player_id, match_id)
);

CREATE INDEX idx_pds_player ON public.player_daily_scores(player_id);
CREATE INDEX idx_pds_match ON public.player_daily_scores(match_id);
CREATE INDEX idx_pds_total ON public.player_daily_scores(total_points DESC);
