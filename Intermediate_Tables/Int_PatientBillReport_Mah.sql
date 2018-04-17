--drop table DataWareHouse.[dbo].[Int_PatientBillReport_Mah]
CREATE TABLE DataWareHouse.[dbo].[Int_PatientBillReport_Mah](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[PatId] [int] NULL,
	[_OrigPatId] [int] NULL,
	[MemberCode] [varchar](20) NULL,
	[BillId] [int] NULL,
	[_OrigBillId] [int] NULL,
	[BillNo] [nvarchar](12) NULL,
	[BillDate] [varchar](10) NULL,
	[ReportDate] [varchar](10) NULL,
	[EnteredBy] [varchar](50) NULL,
	[SpecialistId] [int] NULL,
	[SecondSpecialistId] [int] NULL,
	[IsReportTaken] [char](1) NULL,
	[IsDone] [char](1) NULL,
	[IsPartiallyDone] [char](1) NULL,
	[BillPriceFinal] [varchar](50) NULL,
	[RequestorId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


select distinct PatId,CheckedBy,CheckedBySecond,IstakenByPatient,IsReportDone,IspartiallyDone 
into #temppatientrec   -- temporary table for temp patient records
from pat.tbl_PatientTestRecord 
order by PatId

insert into DataWareHouse.dbo.Int_PatientBillReport_Mah
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
, CASE WHEN tptr.IstakenByPatient = 1 THEN 'Y' ELSE 'N' END AS IsReportTaken
, CASE WHEN tptr.IsReportDone=1 THEN 'Y' ELSE 'N' END AS IsDone
, CASE WHEN tptr.IspartiallyDone=1 THEN 'Y' ELSE 'N' END AS IsPartiallyDone
, ISNULL(bm.BillTotal,0) AS BillPriceFinal
,rm.ID as RequestorId
from pat.tbl_PatientBill tpb
join DataWareHouse.dbo.PatientMaster_Mah pm on pm.MainPatId=tpb.PatId
left join DataWareHouse.dbo.RequestorMaster_Mah rm on rm.Id=pm.RequestorId
join DataWareHouse.dbo.BillMaster_Mah bm on bm._PatientId=tpb.PatId 
left join tbl_appUsers tau on tau.usruserid=tpb.UserId
left join #temppatientrec as tptr on tptr.PatId=tpb.PatId
left join DataWareHouse.dbo.MasterSpecialist_Mah ms on ms._SpecialistIdOrig=tptr.CheckedBy and ms.IsReferrer=0
left join DataWareHouse.dbo.MasterSpecialist_Mah ms2 on ms2._SpecialistIdOrig=tptr.CheckedBySecond and ms2.IsReferrer=0
WHERE bm.BIllNo IS NOT NULL OR bm.BILLNO <> ''
ORDER BY bm.BillNo;

