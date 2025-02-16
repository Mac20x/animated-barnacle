/*
  # Add password column to user_logins table

  1. Changes
    - Add `password_hash` column to `user_logins` table safely:
      1. First add as nullable
      2. Update any existing records
      3. Make it NOT NULL
    
  2. Security
    - Maintains existing RLS policies
    - No changes to security policies needed
*/

DO $$ 
BEGIN
  -- First add the column as nullable
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_logins' 
    AND column_name = 'password_hash'
  ) THEN
    -- Add column as nullable first
    ALTER TABLE user_logins 
    ADD COLUMN password_hash text;
    
    -- Update any existing records with a placeholder value
    UPDATE user_logins 
    SET password_hash = 'PLACEHOLDER_HASH_' || gen_random_uuid()
    WHERE password_hash IS NULL;
    
    -- Now make it NOT NULL
    ALTER TABLE user_logins 
    ALTER COLUMN password_hash SET NOT NULL;
  END IF;
END $$;