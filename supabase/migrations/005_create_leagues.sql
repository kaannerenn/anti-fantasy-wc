-- =========================================
-- Migration 005: leagues
-- =========================================
-- A league is a group of users playing anti-fantasy together.
-- The owner is the user who created it. invite_code is shared with friends.

CREATE TABLE public.leagues (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
  name text NOT NULL,
  invite_code text NOT NULL UNIQUE,
  status text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'drafting', 'active', 'completed', 'cancelled')),
  max_members int NOT NULL DEFAULT 10 CHECK (max_members BETWEEN 6 AND 12),
  draft_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Index for finding leagues by invite code (most common query when joining)
CREATE INDEX idx_leagues_invite_code ON public.leagues(invite_code);

-- Index for finding leagues by owner
CREATE INDEX idx_leagues_owner ON public.leagues(owner_id);
