select getdate() - 365

select * from  DataWareHouse.[dbo].[LoginInfo]

insert into  DataWareHouse.[dbo].[LoginInfo] (LoginType,LoginID,LoginPw,CreateTs,UpdateTS,IsActive)

SELECT
 CASE WHEN IsMember = 0 then 'Patient' ELSE 'Member' end AS LoginType
,CASE WHEN IsMember = 0 then cast(id as varchar) ELSE MemberCode END AS LoginID
,SUBSTRING(CONVERT(varchar(40), NEWID()),0,9) AS LoginPw
,GETDATE() AS CreateTs
,GETDATE() AS UpdateTS
,IsActive AS IsActive
FROM DataWareHouse..PatientMaster

select * from DataWareHouse..PatientMaster


--SELECT MAX(LEN()) FROM pat.tbl_PatientInfo
--SELECT MAX(LEN(MiddleName)) FROM pat.tbl_PatientInfo
--SELECT MAX(LEN(Designation)) FROM pat.tbl_PatientInfo



