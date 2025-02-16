/*
  # Add IP address tracking to user_logins

  1. Changes
    - Add `ip_address` column to `user_logins` table
    
  2. Notes
    - IP address is stored as text to support both IPv4 and IPv6 addresses
    - Column is nullable to handle cases where IP cannot be determined
*/

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_logins' 
    AND column_name = 'ip_address'
  ) THEN
    ALTER TABLE user_logins 
    ADD COLUMN ip_address text;
  END IF;
END $$;