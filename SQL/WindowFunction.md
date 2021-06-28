SELECT [MIN, MAX, FIRST_VALUE, LAST_VALUE, SUM] OVER (PARTITION BY ... [ORDER BY ... [RANGE BETWEEN]]) as ROW_NAME

Ex: Get maximum value of each row in its group
ORDER BY works on framing (accumulate the value of all previous value to current one)

Default frame of ORDER BY is everything before and the current row (In its PARTITION)

FRAME:

PRECEDING // rows before the current one

FOLLOWING // rows after the current one

UNBOUNDED PRECEDING // All before

UNBOUNDED FOLLOWING // All after

CURRENT ROW // current row
