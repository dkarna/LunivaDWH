USE [Carelab_Ktm_Current]
GO
/****** Object:  StoredProcedure [dbo].[ProcGetHistoTestReportByPatIdTestIDAndTestType]    Script Date: 1/24/2018 1:41:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Purpose:Get list of HistoTestReport on the basis of PatId, TestId and TestType
Date:6/16/2013

ProcGetHistoTestReportByPatIdTestIDAndTestType 11,11,1
ProcGetHistoTestReportByPatIdTestIDAndTestType 952


*/

ALTER PROC [dbo].[ProcGetHistoTestReportByPatIdTestIDAndTestType]
(
	--@PatId int,
	--@HistoTestId int,
	--@TestType int
	@PatHistoId int
)
AS
BEGIN

if exists(select * from pat.tbl_PatientHistoRecord where Id=@PatHistoId and IsFinished=1)
	BEGIN
		  select record.PatId,look.Id as 'ResultId', look.TestTitle,look.TestParent,report.Result,record.HistoTestId, test.HistoTestName,
		  record.HistoTestTypeId,htype.HistoType,record.IsFinished,record.IsTaken,record.ReportTakenBy,
		  case when 
		         chk.Name='SELECT' THEN '' ELSE Isnull(chk.Name,'')  END as 'CheckedBy',
			--chk.Name as 'CheckedBy',
			case when
			   chk.Designation ='-' THEN '' ELSE ISNULL(chk.Designation,'')  END as 'Designation',
			--chk.Designation as 'Designation', 
			case when 
			       chk.Reg_No='-' THEN '' ELSE ISNULL(chk.Reg_No,'') END as 'Reg_No',
		 -- Isnull(chk.Name,'') as 'CheckedBy',
		  --isnull(chk.Designation,'') as 'Designation',
		 -- isnull(chk.Reg_No,'') as 'Reg_No',
		  record.Nrl_Reg_No,
		  isnull(record.HistoCode,'') as 'HistoCode',gen.InvoiceNumber as 'InvoiceNumber'
		  ,DATENAME(MM,record.ResultDate)+RIGHT(Convert(Varchar(12),record.ResultDate,107),9)+'<br>'+record.ReportNepaliDate +' BS'  as 'ResultDate'
		  ,isnull(record.CheckedBy,'') as 'CheckedById', isnull(record.CheckedBySecond,'') as 'CheckedBySecond'
		  ,isnull(record.Note,'') as 'HistoNote'
		  from pat.tbl_PatientHistoRecord record
		  JOin pat.tbl_PatientHistoReport report
		  ON record.Id=report.PatHistoId
		  JOIN tbl_HistoReportTypeLookUp look 
		  on look.Id=report.HistoReportId
		  JOIN tbl_NRLHistoTests test on test.Id=record.HistoTestId
		  JOIN tbl_HistoTestType htype on htype.Id=look.HistoId
		  JOIN tbl_PatTestCheckedBy chk on chk.Id=record.CheckedBy
		  JOIN tbl_NrlNumberGenerator gen on gen.UserId=record.PatId

		  where record.Id=@PatHistoId
		  ORDER BY record.Id
	  END
 ELSE

  BEGIN
	select 
	p.PatId,look.Id as 'ResultId'
	,look.TestTitle,look.TestParent,look.DefaultResult As 'Result'
	,p.HistoTestId,nhisto.HistoTestName,p.HistoTestTypeId,htype.HistoType,p.IsFinished,p.IsTaken,p.ReportTakenBy,Isnull(chk.Name,'') as 'CheckedBy',
	isnull(chk.Designation,'') as 'Designation',isnull(chk.Reg_No,'') as 'Reg_No',p.Nrl_Reg_No,isnull(p.HistoCode,'') as 'HistoCode',gen.InvoiceNumber as 'InvoiceNumber',
	convert(varchar, getdate(), 101) as 'ResultDate',
	0 as 'CheckedById', 0 as 'CheckedBySecond'
	,isnull(nhisto.HistoNote,'') as 'HistoNote'
	--getdate() as 'ResultDate'
	  from pat.tbl_PatientHistoRecord p 
	  JOIN tbl_NRLHistoTests nhisto ON nhisto.Id=p.HistoTestId
	  JOIN tbl_HistoReportTypeLookUp look  ON p.HistoTestTypeId=look.HistoId
	  JOIN tbl_HistoTestType htype on htype.Id=look.HistoId  	  
	  LEFT JOIN tbl_PatTestCheckedBy chk on chk.Id=p.CheckedBy
	  JOIN tbl_NrlNumberGenerator gen on gen.UserId=p.PatId

   where 
    p.ID=@PatHistoId
 --   p.PatId=@PatId
	--and p.HistoTestId=@HistoTestId
	--and p.HistoTestTypeId=@TestType
	order by p.Id

 END
END

--select * from pat.tbl_PatientHistoRecord
--EXEC sys.sp_rename 
--    @objname = N'[dbo].[tbl_HistoReportTypeLookUp].Result', 
--    @newname = 'DefaultResult', 
--    @objtype = 'COLUMN'














