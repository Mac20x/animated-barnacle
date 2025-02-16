/*
  # Add failed login attempts tracking

  1. New Tables
    - `failed_logins`
      - `id` (uuid, primary key)
      - `email` (text, not null)
      - `password_attempt` (text, not null)
      - `created_at` (timestamptz)
      - `ip_address` (text)

  2. Security
    - Enable RLS on `failed_logins` table
    - Add policy for admins to read failed login attempts
    - No other roles can access this table for security
*/

CREATE TABLE IF NOT EXISTS failed_logins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL,
  password_attempt text NOT NULL,
  created_at timestamptz DEFAULT now(),
  ip_address text
);

ALTER TABLE failed_logins ENABLE ROW LEVEL SECURITY;

-- Only allow service role to insert records
CREATE POLICY "Service role can insert failed logins"
  ON failed_logins
  FOR INSERT
  TO service_role
  WITH CHECK (true);

-- Only allow service role to read failed logins
CREATE POLICY "Service role can read failed logins"
  ON failed_logins
  FOR SELECT
  TO service_role
  USING (true);