-- Step 1 - Open a new query window to the tempdb database

USE tempdb;
GO

-- Step 2 - Create a stored procedure that queries sys.login_token and sys.user_token

CREATE PROC dbo.spDisplayExecutionContext
AS
SET NOCOUNT ON;
BEGIN
  SELECT * FROM sys.login_token;
  SELECT * FROM sys.user_token;
END
GO

-- Step 3 - Execute the stored procedure and review the rowsets returned

EXEC dbo.spDisplayExecutionContext;
GO

-- Step 4 - Use the EXECUTE AS statement to change context

EXECUTE AS User = 'SecureUser';
GO

-- Step 5 - Try to execute the procedure. Why does it not it work?

EXEC dbo.spDisplayExecutionContext;
GO

-- Step 6 - Revert to the previous security context

REVERT;
GO

-- Step 7 - Grant permission to SecureUser to execute the procedure

GRANT EXECUTE ON dbo.spDisplayExecutionContext TO SecureUser;
GO

-- Step 8 - Now try again and note the output

EXECUTE AS User = 'SecureUser';
GO

EXEC dbo.spDisplayExecutionContext;
GO

REVERT;
GO

-- Step 9 - Alter the procedure to execute as owner

ALTER PROC dbo.spDisplayExecutionContext
WITH EXECUTE AS OWNER
AS
SET NOCOUNT ON;
BEGIN
  SELECT * FROM sys.login_token;
  SELECT * FROM sys.user_token;
END
GO

-- Step 10 - Execute as SecureUser again and note the difference

EXECUTE AS User = 'SecureUser';
GO

EXEC dbo.spDisplayExecutionContext;
GO

REVERT;
GO

-- Step 11 - Drop the procedure

DROP PROC dbo.spDisplayExecutionContext;
GO
