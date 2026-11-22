
-- CIS 047: Database development permissions
-- Allow students to create and manage practice databases.
-- Do not grant MySQL server administration privileges.

GRANT CREATE, ALTER, DROP, INDEX,
      SELECT, INSERT, UPDATE, DELETE,
      REFERENCES, CREATE VIEW, SHOW VIEW,
      CREATE ROUTINE, ALTER ROUTINE, EXECUTE,
      TRIGGER, EVENT
ON *.* TO 'cis047_user'@'%';
