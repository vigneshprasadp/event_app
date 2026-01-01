-- FIX: "events_created_by_fkey" constraint violation
-- The current schema requires 'created_by' to be a TEACHER. 
-- But Students can also create (request) events.
-- We change the Foreign Key to reference 'auth.users' so it accepts BOTH Students and Teachers.

BEGIN;

-- 1. Drop the old strict constraint
ALTER TABLE events DROP CONSTRAINT IF EXISTS events_created_by_fkey;

-- 2. Add the new flexible constraint (referencing auth.users)
ALTER TABLE events 
    ADD CONSTRAINT events_created_by_fkey 
    FOREIGN KEY (created_by) 
    REFERENCES auth.users(id);

COMMIT;
