-- ==========================================
-- DATABASE RESET & ENHANCEMENT SCRIPT
-- WARNING: This will DELETE ALL EXISTING DATA in the specified tables.
-- Run this in your Supabase SQL Editor.
-- ==========================================

-- 1. DROP EXISTING TABLES (Reverse dependencies order)
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS attendance_requests CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;

-- 2. CREATE TABLES

-- TEACHERS TABLE
CREATE TABLE teachers (
    id uuid PRIMARY KEY REFERENCES auth.users(id),
    teacher_id text UNIQUE NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text, -- Stored locally just for reference if needed, but Auth handles real password
    department text,
    
    -- Enhanced Fields
    courses_taught text[],    -- e.g. {'BCA', 'BBA'}
    years_taught text[],      -- e.g. {'First Year', 'Second Year'}
    subjects_taught text[],   -- e.g. {'Maths', 'Java'}
    
    is_homeroom_teacher boolean DEFAULT false,
    homeroom_course text,     -- e.g. 'BCA'
    homeroom_year text,       -- e.g. 'Third Year'
    
    created_at timestamptz DEFAULT now()
);

-- STUDENTS TABLE
CREATE TABLE students (
    id uuid PRIMARY KEY REFERENCES auth.users(id),
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    register_number text UNIQUE NOT NULL,
    
    -- Enhanced Fields
    course text NOT NULL,     -- e.g. 'BCA', 'BBA', 'BCom', 'BSc'
    year text NOT NULL,       -- e.g. 'First Year', 'Second Year', 'Third Year'
    
    created_at timestamptz DEFAULT now()
);

-- EVENTS TABLE
CREATE TABLE events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    description text,
    category text, -- e.g. 'Academic', 'Sports'
    
    scheduled_for timestamptz NOT NULL,
    
    created_by uuid REFERENCES teachers(id), -- specific teacher who created it
    supervising_teacher_id uuid REFERENCES teachers(id),
    
    status text DEFAULT 'upcoming', -- 'upcoming', 'completed', 'cancelled'
    
    created_at timestamptz DEFAULT now()
);

-- ATTENDANCE REQUESTS
-- Links students to events and tracks their status
CREATE TABLE attendance_requests (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id uuid REFERENCES events(id) ON DELETE CASCADE,
    student_id uuid REFERENCES students(id) ON DELETE CASCADE,
    
    status text DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'present'
    
    -- Snapshot fields for reporting (in case student changes class later)
    student_course text, 
    student_year text,
    
    certificate_url text,
    created_at timestamptz DEFAULT now()
);

-- NOTIFICATIONS
CREATE TABLE notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    
    teacher_id uuid REFERENCES teachers(id), -- If notification is for a teacher
    student_id uuid REFERENCES students(id), -- If notification is for a student
    
    event_id uuid REFERENCES events(id),
    
    type text NOT NULL, -- 'attendance', 'event_request', 'report'
    title text NOT NULL,
    body text NOT NULL,
    
    is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now()
);

-- 3. ENABLE ROW LEVEL SECURITY (Optional/Recommended defaults)
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Basic Policies (Open access for development - TIGHTEN BEFORE PRODUCTION)
CREATE POLICY "Public profiles" ON teachers FOR ALL USING (true);
CREATE POLICY "Public students" ON students FOR ALL USING (true);
CREATE POLICY "Public events" ON events FOR ALL USING (true);
CREATE POLICY "Public attendance" ON attendance_requests FOR ALL USING (true);
CREATE POLICY "Public notifications" ON notifications FOR ALL USING (true);
