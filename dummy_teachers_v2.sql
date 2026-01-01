-- ============================================
-- DUMMY TEACHERS DATA GENERATOR (V2 - 20 Users)
-- ============================================
-- This script manually inserts users into auth.users to satisfy the Foreign Key constraint.
-- NOTE: The password hash allows login with "password123" (bcrypt hash).
-- Use this strictly for DEVELOPMENT/TESTING.

BEGIN;

-- 1. Insert into auth.users
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, confirmation_token)
VALUES 
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'alan.turing@cs.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'ada.lovelace@cs.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'grace.hopper@cs.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'john.neumann@math.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'richard.feynman@phy.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'marie.curie@chem.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'isaac.newton@phy.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'charles.darwin@bio.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'sigmund.freud@psych.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'adam.smith@econ.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'karl.marx@history.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'albert.einstein@phy.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'rosalind.franklin@bio.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'stephen.hawking@phy.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'nikola.tesla@eng.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a26', 'thomas.edison@eng.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a27', 'william.shakespeare@lit.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a28', 'jane.austen@lit.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a29', 'plato@phil.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', ''),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a30', 'aristotle@phil.edu', '$2a$10$2SjP/s.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5.g5.55O.e5', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), 'authenticated', 'authenticated', '')
ON CONFLICT (id) DO NOTHING;

-- 2. Insert into teachers
INSERT INTO teachers (id, teacher_id, name, email, department, password, courses_taught, years_taught, subjects_taught, is_homeroom_teacher, homeroom_course, homeroom_year) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'T001', 'Dr. Alan Turing', 'alan.turing@cs.edu', 'Computer Science', 'password123', '{BCA, BSc}', '{First Year, Third Year}', '{Algorithms, Artificial Intelligence}', true, 'BCA', 'Third Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'T002', 'Prof. Ada Lovelace', 'ada.lovelace@cs.edu', 'Computer Science', 'password123', '{BCA, B.Tech}', '{Second Year}', '{Programming, C++}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'T003', 'Dr. Grace Hopper', 'grace.hopper@cs.edu', 'Computer Science', 'password123', '{BCA}', '{First Year}', '{COBOL, Software Engineering}', true, 'BCA', 'First Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'T004', 'Prof. John von Neumann', 'john.neumann@math.edu', 'Mathematics', 'password123', '{BSc, B.Tech}', '{First Year, Second Year}', '{Calculus, Discrete Math}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'T005', 'Dr. Richard Feynman', 'richard.feynman@phy.edu', 'Physics', 'password123', '{BSc}', '{Third Year}', '{Quantum Mechanics, Thermodynamics}', true, 'BSc', 'Third Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'T006', 'Prof. Marie Curie', 'marie.curie@chem.edu', 'Chemistry', 'password123', '{BSc}', '{First Year, Second Year}', '{Physical Chemistry, Radioactivity}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'T007', 'Dr. Isaac Newton', 'isaac.newton@phy.edu', 'Physics', 'password123', '{BSc, B.Tech}', '{First Year}', '{Mechanics, Optics}', true, 'BSc', 'First Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'T008', 'Prof. Charles Darwin', 'charles.darwin@bio.edu', 'Biology', 'password123', '{BSc}', '{Second Year}', '{Evolutionary Biology, Genetics}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'T009', 'Dr. Sigmund Freud', 'sigmund.freud@psych.edu', 'Psychology', 'password123', '{BA, BSc}', '{Third Year}', '{Psychoanalysis, Human Behavior}', true, 'BA', 'Third Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'T010', 'Prof. Adam Smith', 'adam.smith@econ.edu', 'Economics', 'password123', '{BCom, BBA}', '{First Year, Third Year}', '{Microeconomics, Wealth of Nations}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'T011', 'Dr. Karl Marx', 'karl.marx@history.edu', 'History', 'password123', '{BA}', '{Second Year}', '{Political Economy, European History}', true, 'BA', 'Second Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'T012', 'Prof. Albert Einstein', 'albert.einstein@phy.edu', 'Physics', 'password123', '{BSc, PhD}', '{Third Year}', '{Relativity, Cosmology}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'T013', 'Dr. Rosalind Franklin', 'rosalind.franklin@bio.edu', 'Biology', 'password123', '{BSc}', '{Second Year}', '{DNA Structure, Molecular Biology}', true, 'BSc', 'Second Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'T014', 'Prof. Stephen Hawking', 'stephen.hawking@phy.edu', 'Physics', 'password123', '{BSc}', '{Third Year}', '{Black Holes, General Relativity}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'T015', 'Dr. Nikola Tesla', 'nikola.tesla@eng.edu', 'Engineering', 'password123', '{B.Tech}', '{Final Year}', '{Electrical Engineering, AC Systems}', true, 'B.Tech', 'Final Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a26', 'T016', 'Prof. Thomas Edison', 'thomas.edison@eng.edu', 'Engineering', 'password123', '{B.Tech}', '{First Year}', '{Innovation, Circuit Design}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a27', 'T017', 'Dr. William Shakespeare', 'william.shakespeare@lit.edu', 'Literature', 'password123', '{BA}', '{First Year, Second Year}', '{Drama, Poetry}', true, 'BA', 'First Year'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a28', 'T018', 'Prof. Jane Austen', 'jane.austen@lit.edu', 'Literature', 'password123', '{BA}', '{Third Year}', '{Victorian Novels, Social Commentary}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a29', 'T019', 'Prof. Plato', 'plato@phil.edu', 'Philosophy', 'password123', '{BA}', '{First Year}', '{Ethics, Metaphysics}', false, NULL, NULL),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a30', 'T020', 'Dr. Aristotle', 'aristotle@phil.edu', 'Philosophy', 'password123', '{BA}', '{Second Year}', '{Logic, Rhetoric}', true, 'BA', 'Second Year')
ON CONFLICT (id) DO NOTHING;

COMMIT;
