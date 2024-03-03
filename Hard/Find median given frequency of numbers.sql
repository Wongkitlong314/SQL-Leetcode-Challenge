-- Question 107
-- The Numbers table keeps the value of number and its frequency.

-- +----------+-------------+
-- |  Number  |  Frequency  |
-- +----------+-------------|
-- |  0       |  7          |
-- |  1       |  1          |
-- |  2       |  3          |
-- |  3       |  1          |
-- +----------+-------------+
-- In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

-- +--------+
-- | median |
-- +--------|
-- | 0.0000 |
-- +--------+
-- Write a query to find the median of all numbers and name the result as median.

-- Solution
with t1 as(
select *,
sum(frequency) over(order by number) as cum_sum, (sum(frequency) over())/2 as middle
from numbers)

select avg(number) as median
from t1
where middle between (cum_sum - frequency) and cum_sum


-- my solution
CREATE TABLE freq (
  Number INT,
  Frequency INT
);

INSERT INTO freq (Number, Frequency) VALUES
(0, 7),
(1, 1),
(2, 3),
(3, 1);

select * from freq;

with cte as 
(select sum(Frequency) / 2 as mid 
from freq), 

cte2 as (
select number, frequency, sum(frequency) over(order by number) cum_sum
from freq 
)

select avg(number) as median
from cte t1 
join cte2 t2 on t2.cum_sum between mid and mid + 1  
