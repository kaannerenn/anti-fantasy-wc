-- =========================================
-- Migration 006: league_members
-- =========================================
-- Bridge table between profiles and leagues.
-- A user can be in multiple leagues, a league has multiple users.
-- draft_position is assigned when draft starts.

CREATE TABLE public.league_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id uuid NOT NULL REFERENCES public.leagues(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  draft_position int,
  joined_at timestamptz NOT NULL DEFAULT now(),

  -- A user cannot join the same league twice
  CONSTRAINT unique_member_per_league UNIQUE (league_id, user_id),

  -- Each draft position is unique within a league
  CONSTRAINT unique_draft_position UNIQUE (league_id, draft_position)
);

-- Indexes for common queries
CREATE INDEX idx_league_members_league ON public.league_members(league_id);
CREATE INDEX idx_league_members_user ON public.league_members(user_id);
