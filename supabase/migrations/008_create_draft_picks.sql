-- =========================================
-- Migration 008: draft_picks
-- =========================================
-- Stores the history of all draft selections in a league.
-- Once draft is complete, this table is read-only (audit trail).
-- 18 rounds × max 12 users = up to 216 picks per league.

CREATE TABLE public.draft_picks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id uuid NOT NULL REFERENCES public.leagues(id) ON DELETE CASCADE,
  member_id uuid NOT NULL REFERENCES public.league_members(id) ON DELETE CASCADE,
  player_id int NOT NULL REFERENCES public.players(id) ON DELETE RESTRICT,
  round int NOT NULL CHECK (round BETWEEN 1 AND 18),
  pick_number int NOT NULL CHECK (pick_number > 0),
  picked_at timestamptz NOT NULL DEFAULT now(),

  -- Each pick_number is unique per league
  CONSTRAINT unique_pick_per_league UNIQUE (league_id, pick_number),

  -- A player can only be drafted once per league
  CONSTRAINT unique_player_draft_per_league UNIQUE (league_id, player_id)
);

CREATE INDEX idx_draft_picks_league ON public.draft_picks(league_id);
CREATE INDEX idx_draft_picks_member ON public.draft_picks(member_id);
