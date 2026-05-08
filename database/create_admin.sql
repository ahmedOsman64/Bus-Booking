-- SQL Script to create a new Admin user in Supabase
-- Run this in the Supabase SQL Editor

-- 0. Ensure pgcrypto extension is available for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
  -- CONFIGURATION: Change these values as needed
  new_user_id UUID := gen_random_uuid();
  admin_email TEXT := 'admin@busbooking.com';
  admin_password TEXT := 'admin123'; -- Change this after first login
  first_name TEXT := 'System';
  last_name TEXT := 'Admin';
BEGIN
  -- 1. Check if user already exists
  IF EXISTS (SELECT 1 FROM auth.users WHERE email = admin_email) THEN
    RAISE NOTICE 'User with email % already exists. Skipping auth.users insertion.', admin_email;
    SELECT id INTO new_user_id FROM auth.users WHERE email = admin_email;
  ELSE
    -- 2. Insert into auth.users (Authentication)
    INSERT INTO auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    )
    VALUES (
        '00000000-0000-0000-0000-000000000000',
        new_user_id,
        'authenticated',
        'authenticated',
        admin_email,
        crypt(admin_password, gen_salt('bf')),
        now(),
        now(),
        now(),
        '{"provider":"email","providers":["email"]}',
        jsonb_build_object('first_name', first_name, 'last_name', last_name),
        now(),
        now(),
        '',
        '',
        '',
        ''
    );
    RAISE NOTICE 'Created new auth user with ID: %', new_user_id;
  END IF;

  -- 3. Insert or Update public.profiles (Application Data)
  INSERT INTO public.profiles (
      id,
      first_name,
      last_name,
      email,
      role,
      status,
      created_at
  )
  VALUES (
      new_user_id,
      first_name,
      last_name,
      admin_email,
      'admin',
      'active',
      now()
  )
  ON CONFLICT (id) DO UPDATE SET
      role = 'admin',
      status = 'active',
      first_name = EXCLUDED.first_name,
      last_name = EXCLUDED.last_name;

  RAISE NOTICE 'Profile for % has been set as ADMIN.', admin_email;

END $$;
