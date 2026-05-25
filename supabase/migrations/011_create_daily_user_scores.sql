-- =========================================
-- Migration 011: daily_user_scores
-- =========================================
-- Aggregated daily total for each user in each league.
-- Only counts starters (not bench).
-- Powers the leaderboard view.

CREATE TABLE public.daily_user_scores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id uuid NOT NULL REFERENCES public.leagues(id) ON DELETE CASCADE,
  member_id uuid NOT NULL REFERENCES public.league_members(id) ON DELETE CASCADE,
  match_date date NOT NULL,
  total_points numeric(7,1) NOT NULL DEFAULT 0,
  calculated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT unique_member_date UNIQUE (league_id, member_id, match_date)
);

CREATE INDEX idx_dus_league_date ON public.daily_user_scores(league_id, match_date DESC);
CREATE INDEX idx_dus_member ON public.daily_user_scores(member_id);
