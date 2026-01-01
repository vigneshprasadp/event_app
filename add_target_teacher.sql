ALTER TABLE attendance_requests 
ADD COLUMN target_teacher_id uuid REFERENCES teachers(id);
