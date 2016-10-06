

/* создание ролей для проекта печать бирок 

	001_LBLPRNT_DML - Data Manipulation Language
	001_LBLPRNT_DDL - Data Definition Language
	001_LBLPRNT_SDL - Select Data Language

	001				- порядковый номер проекта
	LBLPRNT			- сокращенное имя проекта
	DML | DDL | SDL - тип доступа

*/

IF IS_ROLEMEMBER('001_LBLPRNT_DML') IS NULL
   CREATE ROLE [001_LBLPRNT_DML] AUTHORIZATION dbo; 
GO

IF IS_ROLEMEMBER('001_LBLPRNT_DDL') IS NULL
   CREATE ROLE [001_LBLPRNT_DDL] AUTHORIZATION dbo; 
GO

IF IS_ROLEMEMBER('001_LBLPRNT_SDL') IS NULL
   CREATE ROLE [001_LBLPRNT_SDL] AUTHORIZATION [db_datareader]; 
GO
