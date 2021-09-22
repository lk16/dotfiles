### Create user in postgresql with read-only permissions

```sql
CREATE USER username WITH PASSWORD 'your_password';
GRANT CONNECT ON DATABASE database_name TO username;
GRANT USAGE ON SCHEMA schema_name TO username;
GRANT SELECT ON ALL TABLES IN SCHEMA schema_name TO username;
```
