select distinct PatId,CheckedBy,CheckedBySecond,IstakenByPatient,IsReportDone,IspartiallyDone 
into #temppatientrec   -- temporary table for temp patient records
from pat.tbl_PatientTestRecord 
order by PatId

create table DataWareHouse.dbo.Int_PatientBillReport -- First intermediate table
(
  ID int identity(1,1) primary key
  ,
  ClientId int
        ,
  PatId int
        ,
  _OrigPatId int
  ,MemberCode VARCHAR(20)      
        ,
  BillId int
        ,
  _OrigBillId int
        ,
  BillNo nvarchar(12)
        ,
  BillDate VARCHAR(10)
        ,
  ReportDate VARCHAR(10)
        ,
  EnteredBy varchar(50)
        ,
  SpecialistId int
        ,
  SecondSpecialistId INT
  ,
  RequestorId
  ,
  IsReportTaken char(1) -- y or n
        ,
  IsDone char(1)   -- y or n
        ,
  IsPartiallyDone char(1)  -- y or n
        ,
  BillPriceFinal money
)

insert into DataWareHouse.dbo.Int_PatientBillReport
select --top 2
1 as  ClientId
,pm.ID as PatId
,pm.MainPatId as _OrigPatId
,isnull(pm.MemberCode,'') as MemberCode
,bm.BillMasterID as BillId
,bm.BillMasterID as _OrigBillId
,bm.BillNo
,convert(varchar(10),tpb.BillDate,105) as BillDate
,convert(varchar(10),tpb.BillDate,105) as ReportDate
,tau.usrFullName as EnteredBy
,ms.ID as SpecialistId
,ms2.ID as SecondSpecialistId
,rm.ID as RequestorId
, CASE WHEN tptr.IstakenByPatient = 1 THEN 'Y' ELSE 'N' END AS IsReportTaken
, CASE WHEN tptr.IsReportDone=1 THEN 'Y' ELSE 'N' END AS IsDone
, CASE WHEN tptr.IspartiallyDone=1 THEN 'Y' ELSE 'N' END AS IsPartiallyDone
, ISNULL(bm.BillTotal,0) AS BillPriceFinal
from pat.tbl_PatientBill tpb
join DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=tpb.PatId
left join DataWareHouse.dbo.RequestorMaster rm on rm.Id=pm.RequestorId
join DataWareHouse.dbo.BillMaster bm on bm._PatientId=tpb.PatId 
left join tbl_appUsers tau on tau.usruserid=tpb.UserId
left join #temppatientrec as tptr on tptr.PatId=tpb.PatId
left join DataWareHouse.dbo.MasterSpecialist ms on ms._SpecialistIdOrig=tptr.CheckedBy and ms.IsReferrer=0
left join DataWareHouse.dbo.MasterSpecialist ms2 on ms2._SpecialistIdOrig=tptr.CheckedBySecond and ms2.IsReferrer=0
WHERE bm.BIllNo IS NOT NULL OR bm.BILLNO <> ''
ORDER BY bm.BillNo;