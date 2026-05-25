import { createBrowserClient } from '@supabase/ssr'

/**
 * Browser-side Supabase client.
 * Used in Client Components (anything with "use client" directive).
 * Reads session from cookies that the middleware refreshes.
 */
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
