-- =========================================
-- Migration 012: transactions
-- =========================================
-- Audit log of all roster changes after draft.
-- type: add_drop (regular daily swap), injury_swap (free), elimination_swap (free).

CREATE TABLE public.transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id uuid NOT NULL REFERENCES public.leagues(id) ON DELETE CASCADE,
  member_id uuid NOT NULL REFERENCES public.league_members(id) ON DELETE CASCADE,
  player_in_id int REFERENCES public.players(id) ON DELETE RESTRICT,
  player_out_id int REFERENCES public.players(id) ON DELETE RESTRICT,
  type text NOT NULL CHECK (type IN ('add_drop', 'injury_swap', 'elimination_swap')),
  created_at timestamptz NOT NULL DEFAULT now(),

  -- At least one of player_in_id or player_out_id must be set
  CONSTRAINT at_least_one_player CHECK (
    player_in_id IS NOT NULL OR player_out_id IS NOT NULL
  )
);

CREATE INDEX idx_transactions_league ON public.transactions(league_id);
CREATE INDEX idx_transactions_member ON public.transactions(member_id);
CREATE INDEX idx_transactions_date ON public.transactions(created_at DESC);
