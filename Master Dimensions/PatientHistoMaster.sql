--drop table DataWareHouse.dbo.PatientHistoMaster
create table DataWareHouse.dbo.PatientHistoMaster
(
	ID int identity(1,1) primary key
	,HistoRecordId int
	,_OrigPatId int
	,HistoTestId int
	,CheckedByFirstId int
	,CheckedByFirstName varchar(max)
	,CheckedBySecondId int
	,CheckedBySecondName varchar(max)
	,ReportDate varchar(10)
	,IsFinished int
	,HistoTestTypeId int
	,HistoTestType varchar(max)
	,IsTaken int
	,UserId int
	,UserName varchar(max)
	,ReportTakenBy varchar(max)
	,HistoCode varchar(max)
	,ResultDate varchar(10)
	,ReportNepaliDate varchar(10)
	,Note varchar(max)
	,CreateTs datetime
	,UpdateTs datetime
)

-- insert data into PatientHistoMaster
insert into DataWareHouse.dbo.PatientHistoMaster
select 
tphr.Id as HistoRecordId
,tphr.PatId as _OrigPatId
,tphr.HistoTestId
,tphr.CheckedBy as CheckedByFirstId
,ms.Name as CheckedByFirstName
,tphr.CheckedBySecond as CheckBySecondId
,ms2.Name as CheckedBySecondName
,convert(varchar(10),tphr.ReportDate,105) as ReportDate
,tphr.IsFinished
,tphr.HistoTestTypeId
,thtt.HistoType as HistoTestType
,tphr.IsTaken
,tphr.UserId
,tau.usrFullName as UserName
,tphr.ReportTakenBy
,tphr.HistoCode
,convert(varchar(10),tphr.ResultDate,105) as ResultDate
,tphr.ReportNepaliDate
,tphr.Note
,getdate() as CreateTs
,getdate() as UpdateTs
from pat.tbl_PatientHistoRecord tphr
left join DataWareHouse.dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tphr.CheckedBy and ms.IsReferrer=0
left join  DataWareHouse.dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tphr.CheckedBySecond and ms2.IsReferrer=0
left join tbl_HistoTestType thtt on thtt.Id=tphr.HistoTestTypeId
left join tbl_appUsers tau on tau.usruserid=tphr.UserId