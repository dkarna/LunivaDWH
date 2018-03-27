-- Int_PatientHistoDetails

--select top 2 * from DataWareHouse.dbo.PatientHistoMaster
--select top 1 * from pat.tbl_PatientHistoReport


--drop table DataWareHouse.dbo.Int_PatientHistoDetails
--truncate table DataWareHouse.dbo.Int_PatientHistoDetails

select * from DataWareHouse.dbo.Int_PatientHistoDetails

create table DataWareHouse.dbo.Int_PatientHistoDetails
(
	ID int identity(1,1) primary key
	,PatId int
	,PatHistoRecId int
	,ResultId int
	,TestTitle varchar(max)
	,TestParent varchar(max)
	,Result varchar(max)
	,HistoTestId int
	,HistoTestName varchar(max)
	,HistoTestTypeId int
	,HistoType varchar(max)
	,IsFinished int
	,IsTaken int
	,ReportTakenBy varchar(max)
	,CheckedBy varchar(max)
	,Designation varchar(max)
	,Reg_No varchar(max)
	,Nrl_Reg_No int
	,HistoCode varchar(max)
	,InvoiceNumber varchar(max)
	,ResultDate varchar(100)
	,CheckedById int
	,CheckedBySecond int
	,HistoNote varchar(max)
	,IsHistoRecord int
	,CreateTs datetime
	,UpdateTs datetime
)

-- Records of patients having Histo records in HistoReport table (i.e. histo report finished)

insert into DataWareHouse.dbo.Int_PatientHistoDetails   -- case when patients have Historecord
select record._OrigPatId as PatId
,record.HistoRecordId as PatHistoRecId
,look.Id as ResultId
,look.TestTitle
,look.TestParent
,report.Result
,record.HistoTestId
,test.HistoTestName
,record.HistoTestTypeId
,htype.HistoType
,record.IsFinished
,record.IsTaken
,record.ReportTakenBy
,record.CheckedByFirstName as CheckedBy
,record.CheckedByFirstDesignation as Designation
,record.CheckedByFirstRegNo as Reg_No
,record._OrigPatId as Nrl_Reg_No
,isnull(record.HistoCode,'') as HistoCode
,gen.InvoiceNumber
--,DATENAME(MM,record.ResultDate)+RIGHT(Convert(Varchar(12),record.ResultDate,107),9)+'<br>'+convert(varchar,record.ReportNepaliDate) +' BS' as ReportNepaliDate
,convert(varchar,record.ReportNepaliDate) + 'BS' as ResultDate
,isnull(record.CheckedByFirstId,'') as CheckedById
,isnull(record.CheckedBySecondId,'') as CheckedBySecond
,isnull(record.Note,'') as HistoNote
,1 as IsHistoRecord
,getdate() as CreateTs
,getdate() as UpdateTs
from DataWareHouse.dbo.PatientHistoMaster record
join pat.tbl_PatientHistoReport report on report.PatHistoId = record.HistoRecordId
JOIN tbl_HistoReportTypeLookUp look on look.Id=report.HistoReportId 
JOIN tbl_NRLHistoTests test on test.Id=record.HistoTestId
JOIN tbl_HistoTestType htype on htype.Id=look.HistoId
JOIN DataWareHouse.dbo.MasterSpecialist chk on chk._SpecialistIdOrig=record.CheckedByFirstId and chk.IsReferrer=0
JOIN tbl_NrlNumberGenerator gen on gen.UserId=record._OrigPatId
order by record.Id
--where record.HistoRecordId=7849
--record._OrigPatId=212

-- Patients not having records in historeport table (i.e. histo report not finished)
insert into DataWareHouse.dbo.Int_PatientHistoDetails
select 
	p.PatId
	,p.Id as PatHistoRecId
	,look.Id as 'ResultId'
	,look.TestTitle,
	look.TestParent,
	look.DefaultResult As 'Result'
	,p.HistoTestId,
	nhisto.HistoTestName,
	p.HistoTestTypeId,
	htype.HistoType,
	p.IsFinished,
	p.IsTaken,
	p.ReportTakenBy,
	Isnull(chk.Name,'') as 'CheckedBy',
	isnull(chk.Designation,'') as 'Designation',
	isnull(chk.Reg_No,'') as 'Reg_No',
	p.Nrl_Reg_No,
	isnull(p.HistoCode,'') as 'HistoCode',
	gen.InvoiceNumber as 'InvoiceNumber',
	convert(varchar, getdate(), 101) as 'ResultDate',
	0 as 'CheckedById', 0 as 'CheckedBySecond'
	,isnull(nhisto.HistoNote,'') as 'HistoNote'
	,0 as IsHistoRecord
	,getdate() as CreateTs
	,getdate() as UpdateTs
from pat.tbl_PatientHistoRecord p 
	  JOIN tbl_NRLHistoTests nhisto ON nhisto.Id=p.HistoTestId
	  JOIN tbl_HistoReportTypeLookUp look  ON p.HistoTestTypeId=look.HistoId
	  JOIN tbl_HistoTestType htype on htype.Id=look.HistoId  	  
	  LEFT JOIN tbl_PatTestCheckedBy chk on chk.Id=p.CheckedBy
	  JOIN tbl_NrlNumberGenerator gen on gen.UserId=p.PatId
order by p.Id

	  --select top 1 * from DataWareHouse.dbo.TestMaster
--select top 1 * from DataWareHouse.dbo.PatientHistoMaster
--select top 1 * from DataWareHouse.dbo.MasterSpecialist
--exec [dbo].[ProcGetHistoTestReportByPatIdTestIDAndTestType] 7849