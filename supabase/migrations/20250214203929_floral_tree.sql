/*
  # User Logins Table

  1. New Tables
    - `user_logins`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `email` (text)
      - `created_at` (timestamp)
      - `last_sign_in` (timestamp)

  2. Security
    - Enable RLS on `user_logins` table
    - Add policy for authenticated users to read their own data
    - Add policy for authenticated users to insert their own data
*/

CREATE TABLE IF NOT EXISTS user_logins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  email text NOT NULL,
  created_at timestamptz DEFAULT now(),
  last_sign_in timestamptz DEFAULT now()
);

ALTER TABLE user_logins ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own logins"
  ON user_logins
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own logins"
  ON user_logins
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);