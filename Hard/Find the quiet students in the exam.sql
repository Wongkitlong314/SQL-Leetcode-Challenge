-- Question 106
-- Table: Student

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | student_id          | int     |
-- | student_name        | varchar |
-- +---------------------+---------+
-- student_id is the primary key for this table.
-- student_name is the name of the student.
 

-- Table: Exam

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | exam_id       | int     |
-- | student_id    | int     |
-- | score         | int     |
-- +---------------+---------+
-- (exam_id, student_id) is the primary key for this table.
-- Student with student_id got score points in exam with id exam_id.
 

-- A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score.

-- Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.

-- Don't return the student who has never taken any exam. Return the result table ordered by student_id.

-- The query result format is in the following example.

 

-- Student table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Jade          |
-- | 3           | Stella        |
-- | 4           | Jonathan      |
-- | 5           | Will          |
-- +-------------+---------------+

-- Exam table:
-- +------------+--------------+-----------+
-- | exam_id    | student_id   | score     |
-- +------------+--------------+-----------+
-- | 10         |     1        |    70     |
-- | 10         |     2        |    80     |
-- | 10         |     3        |    90     |
-- | 20         |     1        |    80     |
-- | 30         |     1        |    70     |
-- | 30         |     3        |    80     |
-- | 30         |     4        |    90     |
-- | 40         |     1        |    60     |
-- | 40         |     2        |    70     |
-- | 40         |     4        |    80     |
-- +------------+--------------+-----------+

-- Result table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 2           | Jade          |
-- +-------------+---------------+

-- For exam 1: Student 1 and 3 hold the lowest and high score respectively.
-- For exam 2: Student 1 hold both highest and lowest score.
-- For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
-- Student 2 and 5 have never got the highest or lowest in any of the exam.
-- Since student 5 is not taking any exam, he is excluded from the result.
-- So, we only return the information of Student 2.

-- Solution
with t1 as(
select student_id
from
(select *,
min(score) over(partition by exam_id) as least,
max(score) over(partition by exam_id) as most
from exam) a
where least = score or most = score)


select distinct student_id, student_name
from exam join student
using (student_id)
where student_id != all(select student_id from t1)
order by 1

-- Create Student table
CREATE TABLE Student (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(255)
);

-- Insert data into Student table
INSERT INTO Student (student_id, student_name) VALUES
(1, 'Daniel'),
(2, 'Jade'),
(3, 'Stella'),
(4, 'Jonathan'),
(5, 'Will');

-- Create Exam table
CREATE TABLE Exam (
  exam_id INT,
  student_id INT,
  score INT,
  PRIMARY KEY (exam_id, student_id),
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- Insert data into Exam table
INSERT INTO Exam (exam_id, student_id, score) VALUES
(10, 1, 70),
(10, 2, 80),
(10, 3, 90),
(20, 1, 80),
(30, 1, 70),
(30, 3, 80),
(30, 4, 90),
(40, 1, 60),
(40, 2, 70),
(40, 4, 80);


with cte as 
  (select student_id, min(score_h2l) score_h2l, min(score_l2h) score_l2h
  from 
    (select 
      student_id, exam_id, 
      dense_rank() over(partition by exam_id order by score desc) score_h2l,
      dense_rank() over(partition by exam_id order by score asc) score_l2h
    from exam) t 
  group by student_id
  )

select t1.student_id, t2.student_name
from 
  cte t1 
join 
  student t2 
  on t1.student_id = t2.student_id
where score_h2l <> 1 and score_l2h <> 1 
;

