-- FactPatientHistoRecords
--drop table DataWareHouse.dbo.FactPatientHistoRecords
create table DataWareHouse.dbo.FactPatientHistoRecords
(
	ID int identity(1,1) primary key
	,IntPatientId int not null
	,PatHistRecId int not null
	,PatientID int not null
	,_OrigPatientID int not null
	,ResultId int
	,TestTitle varchar(max)
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

--select top 1 * from DataWareHouse.dbo.PatientHistoMaster

-- Insert data into Fact table

insert into DataWareHouse.dbo.FactPatientHistoRecords
select iphd.ID as IntPatientId
,pm.ID as PatientID
,iphd.PatHistoRecId as PatHistRecId
,pm.MainPatID as _OrigPatientID
,iphd.ResultId
,iphd.TestTitle
,iphd.Result
,iphd.HistoTestId
,iphd.HistoTestName
,iphd.HistoTestTypeId
,iphd.HistoType
,iphd.IsFinished
,iphd.IsTaken
,iphd.ReportTakenBy
,iphd.CheckedBy
,iphd.Designation
,iphd.Reg_No
,iphd.Nrl_Reg_No
,iphd.HistoCode
,iphd.InvoiceNumber
,iphd.ResultDate
,iphd.CheckedById
,iphd.CheckedBySecond
,iphd.HistoNote
,iphd.IsHistoRecord
,getdate() as CreateTs
,getdate() as UpdateTs
from DataWareHouse.dbo.Int_PatientHistoDetails iphd
left join DataWareHouse.dbo.PatientMaster pm on pm.MainPatID=iphd.PatId
--where --PatHistoRecId=7849 and 
--IsHistoRecord=0

--select top 1 * from DataWareHouse.dbo.Int_PatientHistoDetails