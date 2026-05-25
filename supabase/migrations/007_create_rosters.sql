-- =========================================
-- Migration 007: rosters
-- =========================================
-- Tracks which player belongs to which user's squad in a specific league.
-- Each row = one player on one user's roster in one league.
-- 18 players per user (11 starting + 7 bench).

CREATE TABLE public.rosters (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id uuid NOT NULL REFERENCES public.leagues(id) ON DELETE CASCADE,
  member_id uuid NOT NULL REFERENCES public.league_members(id) ON DELETE CASCADE,
  player_id int NOT NULL REFERENCES public.players(id) ON DELETE RESTRICT,
  slot text NOT NULL DEFAULT 'bench' CHECK (slot IN ('starter', 'bench')),
  position_slot text CHECK (position_slot IN ('GK', 'DEF', 'MID', 'FWD')),
  acquired_at timestamptz NOT NULL DEFAULT now(),

  -- A player can only be on one user's roster in a league (classic fantasy rule)
  CONSTRAINT unique_player_per_league UNIQUE (league_id, player_id),

  -- If slot is 'starter', position_slot must be set
  CONSTRAINT starter_must_have_position
    CHECK (slot = 'bench' OR position_slot IS NOT NULL)
);

-- Indexes for common queries
CREATE INDEX idx_rosters_league ON public.rosters(league_id);
CREATE INDEX idx_rosters_member ON public.rosters(member_id);
CREATE INDEX idx_rosters_player ON public.rosters(player_id);

-- Index for finding active starters in a league (for daily score calculation)
CREATE INDEX idx_rosters_starters ON public.rosters(league_id, slot)
WHERE slot = 'starter';
