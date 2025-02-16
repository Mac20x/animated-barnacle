/*
  # Update failed_logins table policies

  1. Changes
    - Drop existing insert policy
    - Create new policy to allow all users to insert records
    - Ensure service role can read records

  2. Security
    - Allow public access for inserts
    - Restrict read access to service role only
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Service role can insert failed logins" ON failed_logins;
DROP POLICY IF EXISTS "Service role can read failed logins" ON failed_logins;

-- Create new policy to allow all users to insert
CREATE POLICY "Allow all users to insert failed logins"
  ON failed_logins
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Create policy for service role to read
CREATE POLICY "Service role can read failed logins"
  ON failed_logins
  FOR SELECT
  TO service_role
  USING (true);