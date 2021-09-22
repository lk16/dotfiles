### Get total table size on disk in mysql

```sql
-- returns size of data and index in Gibibytes
SELECT SUM(DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024 / 1024
FROM tables
WHERE TABLE_SCHEMA = 'spocosy' -- adjust this one
LIMIT 1;
```
