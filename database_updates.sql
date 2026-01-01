-- ==========================================
-- DATABASE UPDATE SCRIPT
-- Run these queries in your Supabase SQL Editor
-- ==========================================

-- 1. Update Students Table
-- Adds the 'year' field to track First, Second, or Third Year
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS year text;

-- 2. Update Teachers Table
-- Adds fields for the new teacher profile features
ALTER TABLE teachers 
ADD COLUMN IF NOT EXISTS sections_taught text[], -- Stores array like ['A', 'B']
ADD COLUMN IF NOT EXISTS is_homeroom_teacher boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS homeroom_class text;

-- 3. (Optional) Storage Bucket for Certificates
-- NOTE: The current mobile app code generates certificates dynamically on the screen, 
-- so you DO NOT STRICTLY NEED a bucket right now. 
-- However, if you want to store permanent PDF copies in the future to populate 
-- the 'certificate_url' field in your schema, run the following:

-- Create the bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('certificates', 'certificates', true)
ON CONFLICT (id) DO NOTHING;

-- Allow public access to view certificates
CREATE POLICY "Public Certificate Access"
ON storage.objects FOR SELECT
USING ( bucket_id = 'certificates' );

-- Allow authenticated users (teachers/backend) to upload certificates
CREATE POLICY "Authenticated Certificate Upload"
ON storage.objects FOR INSERT
WITH CHECK ( bucket_id = 'certificates' AND auth.role() = 'authenticated' );
