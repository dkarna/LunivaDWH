-- Int_PatientReportDetails

--drop table DataWareHouse.[dbo].[Int_PatientReportDetails]
		CREATE TABLE DataWareHouse.[dbo].[Int_PatientReportDetails](
	[PatId] [int] NULL,
	[_OrigPatId] [int] NULL,
	[ReportDate] [varchar](10) NULL,
	[DiagId] [int] NULL,
	[_OrigDiagId] [int] NULL,
	[TestID] [int] NULL,
	[_OrigTestId] [int] NULL,
	[PanelId] [int] NULL,
	[Panel][nvarchar](max) NULL,
	[_OrigPanelId] [int] NULL,
	[TestRange] [nvarchar](max) NULL,
	[IsExecutive] [char](1) NULL,
	[TestPrice] [money] NULL,
	[TestMethod] [varchar](max) NULL,
	[TestResult] [nvarchar](50) NULL,
	[SubTestId] [int] NULL,
	[_OrigSubTestId] [int] NULL,
	[SubTest] [nvarchar](150) NULL,
	[SubTestRange] [nvarchar](max) NULL,
	[SubTestUnits] [nvarchar](max) NULL,
	[SubTestActive] [int] NULL,
	[SubTestResult] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[PanelName] [nvarchar](max) NULL,
	[SubMethod] [nvarchar](max) NULL,
	[D_Group] [int] NULL,
	[GroupId][int] NULL,
	[GroupName][nvarchar](max) NULL,
	[DigId][int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Data insertion

insert into DataWareHouse.dbo.Int_PatientReportDetails
select * from
(
select distinct  
pm.ID as PatId
,pm.MainPatID as _OrigPatId
,convert(varchar(10),patrecord.ResultDate,105) as ReportDate
,dgroup.ID as DiagId
,dgroup._DiagnosisIDOrig as _OrigDiagId
,nTest.ID as TestID
,nTest._TestIDOrig as _OrigTestId
,0 as PanelId
,0 as _OrigPanelId
--,dgroup.DiagnosisName as Panel
,ran.[Max] as TestRange
,case when patrecord.IsExecutive = 1 then 'Y' else 'N' end as IsExecutive
,nTest.TotalPrice as TestPrice
,nTest.Method as TestMethod
,patrecord.TestResult
,subtest.ID as SubTestId
,subtest._SubTestIdOrig as _OrigSubTestId
,subtest.SubTestName as SubTest
,subtest.SubTestRange
,subtest.SubTestUnits
,subtest.IsActive as SubTestActive
,ttrfr.Result as SubTestResult
,patrecord.Note
,dgroup.DiagnosisName as PanelName
,ttrfr.Method as SubMethod
,dgroup._DiagnosisIDOrig as D_Group
,dgroup._DiagnosisIDOrig as GroupId
,dgroup.DiagnosisName as GroupName
,InTest.Id as DigId
 from pat.tbl_PatientTestRecord patrecord
LEFT JOIN DataWareHouse.dbo.PatientMaster pm on pm.MainPatID = patrecord.PatId
left join tbl_TestResultForReport ttrfr on ttrfr.TestId=patrecord.Id
left join DataWareHouse.dbo.SubTestMaster subtest on subtest._SubTestIdOrig=ttrfr.SubTestId
JOIN tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id 
left join DataWareHouse.dbo.TestMaster nTest on Intest.TestId = nTest._TestIDOrig
left join DataWareHouse.dbo.DiagnosisMaster dgroup on Intest.DGId=dgroup._DiagnosisIDOrig
LEFT JOIN tbl_RangeOfTests ran on ran.DGId=Intest.Id
where 
--patrecord.PatId=@PatId 
--and 
nTest.Testname not like 'Stone Analysis' and patrecord.IsHideOnPrint=0

union

--Declare @PatId int = 19
select distinct pm.ID as PatId
,pm.MainPatID as _OrigPatId
,convert(varchar(10),patrecord.ResultDate,105) as ReportDate
,dGroup.ID as DiagId
,dGroup._DiagnosisIDOrig as _OrigDiagId
,ntest.ID as TestID
,ntest._TestIDOrig as _OrigTestId
,testGroup.Id as PanelId
,pGroup._OrigPanelId as _OrigPanelId
,trange.[Max] as TestRange
,case when patrecord.IsExecutive = 1 then 'Y' else 'N' end as IsExecutive
,ntest.TotalPrice as TestPrice
,ntest.Method as TestMethod
,patrecord.TestResult
,subtest.ID as SubTestId
,subtest._SubTestIdOrig as _OrigSubTestId
,subtest.SubTestName as SubTest
,subtest.SubTestRange
,Isnull(subtest.SubTestUnits,'') as SubTestUnits
,subtest.IsActive as SubTestActive
,rep.Result as SubTestResult
,patrecord.Note
,pGroup.DiagnosisGroup as PanelName
,rep.Method as SubMethod
,pGroup.DiagnosisId as D_Group
,pGroup._OrigPanelId as GroupId
,pGroup.PanelName as GroupName
,testDiagnosis.Id as DigId
 FROM [pat].[tbl_PatientTestRecord] patrecord
				JOIN DataWareHouse.dbo.PatientMaster pm on pm.MainPatID = patrecord.PatId
					   LEFT JOIN tbl_TestResultForReport rep on rep.TestId=patrecord.Id
					   --LEFT JOIN tbl_SubTests subtest on subtest.Id=rep.SubTestId
					   left join DataWareHouse.dbo.SubTestMaster subtest on subtest._SubTestIdOrig=rep.SubTestId
					   left JOIN tbl_TestPanel_ProfileGroup testGroup ON patrecord.TestPanId=testGroup.Id
					   --JOIN tbl_Panel_ProfileGroup pGroup ON testGroup.PanId=pGroup.Id
					   left join DataWareHouse.dbo.PanelMaster pGroup on testGroup.PanId=pGroup._OrigPanelId
					   left JOIN tbl_Test_DiagnosisGroup testDiagnosis ON testGroup.DGId=testDiagnosis.Id
					   --JOIN tbl_NrlTests ntest ON ntest.Id=testDiagnosis.TestId
					   left join DataWareHouse.dbo.TestMaster ntest on ntest._TestIDOrig = testDiagnosis.TestId
					   --JOIN tbl_DiagnosisGroup dGroup ON dGroup.Id=testDiagnosis.DGId 					  		   
					   join DataWareHouse.dbo.DiagnosisMaster dGroup on dGroup._DiagnosisIDOrig=testDiagnosis.DGId
					   LEft JOIN tbl_RangeOfTests trange on trange.DGId=testDiagnosis.id 
					 WHERE 
					 --patrecord.PatId=@PatId and 
					 patrecord.IsHideOnPrint=0
) as t