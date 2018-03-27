CREATE TABLE DataWareHouse.[dbo].[FactPatientDiagnosis](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MemberCode] [varchar](50) NULL,
	[PatientID] [int] NULL,
	[MobileNo] [varchar](20) NULL,
	[BillID] [int] NULL,
	[CheckedByFirstID] [int] NULL,
	[CheckedBySecondID] [int] NULL,
	[DiagnosisID] [int] NULL,
	[TestID] [int] NULL,
	[Method] [varchar](50) NULL,
	[Range] [nvarchar](max) NULL,
	[Result] [varchar](100) NULL,
	[Price] [varchar](20) NULL,
	[Remarks] [nvarchar](2000) NULL,
	[AttachmentLink] [varchar](200) NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[SubTest] [nvarchar](150) NULL,
	[SubTestRange] [nvarchar](max) NULL,
	[SubTestUnits] [nvarchar](max) NULL,
	[SubTestActive] [int] NULL,
	[SubTestResult] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[SubMethod] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--truncate table DataWareHouse.dbo.FactPatientDiagnosis
insert into DataWareHouse.dbo.FactPatientDiagnosis
select --*
isnull(pm.MemberCode,'') as MemberCode
,pm.ID as PatientID
,pm.ContactNo as MobileNo
,ipbr.BillId as BillID
,ipbr.SpecialistId as CheckByFirstID
,isnull(ipbr.SecondSpecialistId,'') as CheckedBySecondID
,iprd.DiagId as DiagnosisID
,iprd.TestID
,iprd.TestMethod as [Method]
,iprd.TestRange as [Range]
,iprd.TestResult as [Result]
,iprd.TestPrice as [Price]
,'' as Remarks
,'' as AttachmentLink
,getdate() as CreateTs
,getdate() as UpdateTs
,iprd.SubTest
,iprd.SubTestRange
,iprd.SubTestUnits
,iprd.SubTestActive
,iprd.SubTestResult
,iprd.Note
,iprd.SubMethod
 from DataWareHouse.dbo.Int_PatientBillReport ipbr
left join DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=ipbr._OrigPatId
join DataWareHouse.dbo.Int_PatientReportDetails iprd on iprd.PatId=ipbr.PatId