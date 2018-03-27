
  
  -- new

  
  


-- Add bill number to PatientBillMaster



-- Second intermediate table for test details

drop table DataWareHouse.dbo.Int_PatientReportDetails

create table DataWareHouse.dbo.Int_PatientReportDetails
(
  PatId int
        ,
  _OrigPatId int
        ,
  ReportDate varchar(10)
  ,DiagId INT
  ,_OrigDiagId INT
        ,
  TestID int
        ,
  _OrigTestId int
        ,
  PanelId int
        ,
  _OrigPanelId int
        ,
  TestRange nvarchar(max)
        ,
  IsExecutive char(1)  -- y or n
        ,
  TestPrice money
        ,
  TestResult nvarchar(50)
);

alter table DataWareHouse.dbo.Int_PatientReportDetails add SubTest nvarchar(150),SubTestRange nvarchar(max),SubTestUnits nvarchar(max),SubTestActive int

select pm.MainPatId,tdg.Diagnosis,tdg.Id as diagnosisid,tnt.Id as testid,tnt.TestCode,tnt.Testname
FROM pat.tbl_PatientTestRecord tptr
  LEFT JOIN DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=tptr.PatId
  LEFT JOIN tbl_TestPanel_ProfileGroup tppg on tptr.TestPanId=tppg.Id
  LEFT JOIN tbl_Test_DiagnosisGroup ttdg on tppg.DGId=ttdg.Id
  LEFT JOIN tbl_DiagnosisGroup tdg on ttdg.DGId=tdg.Id
  LEFT JOIN tbl_NRLTests tnt on ttdg.TestId=tnt.Id
  --LEFT JOIN DataWareHouse.dbo.PanelMaster panm on tptr.TestPan

  

-- Queries for intermediate table for fact table

-- Test with panel
IF OBJECT_ID('tempdb..#TestWithPanel') IS NOT NULL
    DROP TABLE #TestWithPanel
--drop table #TestWithPanel
select --top 100
pm.ID as PatientId
, tptr.PatId as _OrigPatientId
, pm.MemberCode as MemberCode
, pm.ContactNo as MobileNo
, bm.BillMasterID as BillID
, ttppg.PanId as PanelId
, tppg.Description as PanelName
, ttdg.Id as IndividualTestId
, tdg.Id as DiagnosisId
, tdg.Diagnosis as DiagnosisName
, ttdg.TestId as TestId
, tptr.ResultDate
, tnt.TestName
, tbd.TestId as billtestid
, tbd.billPrice as TestPrice
, tptr.TestResult
, tptr.TestRange
, case when tptr.IsExecutive=1 then 'Y' else 'N' end as IsExecutive
, tst.TestSubType as SubTest
,tst.SubTestRange
,tst.SubTestUnits
,ttrfr.Result
,ttrfr.Method as SubMethod
,tst.IsActive as SubTestActive
,tptr.Note
into #TestWithPanel
from pat.tbl_patientTestRecord tptr
  left join tbl_TestResultForReport ttrfr on ttrfr.TestId=tptr.Id
  left join tbl_SubTests tst on tst.Id = ttrfr.SubTestId
  join DataWareHouse.dbo.PatientMaster pm on pm.MainPatId=tptr.PatId
  join tbl_TestPanel_ProfileGroup ttppg on ttppg.Id = tptr.TestPanId
  join tbl_Panel_ProfileGroup tppg on tppg.Id=ttppg.PanId
  join tbl_Test_DiagnosisGroup ttdg on ttdg.Id=ttppg.DGId
  join tbl_DiagnosisGroup tdg on tdg.Id=ttdg.DgId
  join tbl_NRLTests tnt on tnt.Id=ttdg.TestId
  left join pat.tbl_PatientBill tpb on tpb.PatId=tptr.PatId
  join DataWareHouse.dbo.BillMaster bm on bm.BillNo=tpb.BillNo
  left join pat.tbl_Bill_Details tbd on tbd.BillNo=tpb.BillNo and tbd.TestID=ttdg.Id
where tptr.TestPanId <> 0-- and pm.MainPatID=3
order by tptr.PatId

-- Query for #TestWithoutPanel

IF OBJECT_ID('tempdb..#TestWithoutPanel') IS NOT NULL
    DROP TABLE #TestWithoutPanel
--drop table #TestWithoutPanel
select --top 100 
pm.ID as PatientId
, tptr.PatId as _OrigPatientId
, pm.MemberCode as MemberCode
, pm.ContactNo as MobileNo
, bm.BillMasterID as BillID
, 0 as PanelId
, '' as PanelName
, tptr.IndividualTestId IndividualTestId
, tdg.Id as DiagnosisId
, tdg.Diagnosis as DiagnosisName
, ttdg.TestId as TestId
, tptr.ResultDate
, tnt.TestName
, tbd.TestId as billtestid
, tbd.billPrice as TestPrice
, tptr.TestResult
, tptr.TestRange
, case when tptr.IsExecutive=1 then 'Y' else 'N' end as IsExecutive
, tst.TestSubType as SubTest
,tst.SubTestRange
,tst.SubTestUnits
,ttrfr.Result
,ttrfr.Method as SubMethod
,tst.IsActive as SubTestActive
,tptr.Note
into #TestWithoutPanel
from pat.tbl_PatientTestRecord tptr 
			--left join tbl_TestResultForReport trfr on trfr.TestId=tptr.Id
			left join tbl_TestResultForReport ttrfr on ttrfr.TestId=tptr.Id
			--left join tbl_SubTests tst on tst.Id=ttrfr.SubTestId
			left join tbl_SubTests tst on tst.Id = ttrfr.SubTestId
			left join DataWareHouse.dbo.PatientMaster pm on pm.MainPatID=tptr.PatId
			join tbl_Test_DiagnosisGroup ttdg on ttdg.Id=tptr.IndividualTestId
			left join tbl_DiagnosisGroup tdg on tdg.Id=ttdg.DGId
			left join tbl_NRLTests tnt on ttdg.TestId=tnt.Id
			left join pat.tbl_PatientBill tpb on tpb.PatId=tptr.PatId
			join DataWareHouse.dbo.BillMaster bm on bm.BillNo=tpb.BillNo
			left join pat.tbl_Bill_Details tbd on tbd.BillNo=tpb.BillNo and tbd.TestID=ttdg.Id
--where --tptr.IndividualTestId <> 0
--where pm.MainPatID=3
order by tptr.PatId

IF OBJECT_ID('tempdb..#AllDiagnosisTest') IS NOT NULL
    DROP TABLE #AllDiagnosisTest
--drop table #AllDiagnosisTest
--select top 1 * from #AllDiagnosisTest
select *
into #AllDiagnosisTest
from
  (
    select *
    from #TestWithoutPanel
  union
    select *
    from #TestWithPanel
) as t
order by t.PatientId

-- Query for inserting


-- Query for inserting data from #AllDiagnosisTest into Int_PatientReportDetails
--TRUNCATE table DataWareHouse.dbo.Int_PatientReportDetails  -- truncate table query

alter table DataWareHouse.dbo.Int_PatientReportDetails add SubTestResult nvarchar(max), Note nvarchar(max)


truncate table DataWareHouse.dbo.Int_PatientReportDetails
--select top 1 * from  DataWareHouse.dbo.Int_PatientReportDetails where PanelName <> ''

Insert into DataWareHouse.dbo.Int_PatientReportDetails
select PatientId as PatId
, _OrigPatientId as _OrigPatId
, convert(varchar(10),ResultDate,105) as ReportDate
, DiagnosisId as DiagId
, DiagnosisId as _OrigDiagId
, TestId as TestID
, TestId as _OrigTestId
, PanelId as PanelId
, PanelId as _OrigPanelId
, TestRange as TestRange
, IsExecutive as IsExecutive
, IsNull(TestPrice,0) as TestPrice
, TestResult as TestResult
,#AllDiagnosisTest.SubTest
,#AllDiagnosisTest.SubTestRange
,#AllDiagnosisTest.SubTestUnits
,#AllDiagnosisTest.SubTestActive
,#AllDiagnosisTest.Result as SubTestResult
,#AllDiagnosisTest.Note
,#AllDiagnosisTest.PanelName
,#AllDiagnosisTest.SubMethod
from #AllDiagnosisTest

-- Query for inserting data from Int_PatientBillReport and Int_PatientReportDetails into FactPatientDiagnosis

alter table DataWareHouse.dbo.FactPatientDiagnosis add SubTest nvarchar(150),SubTestRange nvarchar(max),SubTestUnits nvarchar(max),SubTestActive int
alter table DataWareHouse.dbo.FactPatientDiagnosis add SubTestResult nvarchar(max),SubMethod nvarchar(max)

truncate table DataWareHouse.dbo.FactPatientDiagnosis
Insert into DataWareHouse.dbo.FactPatientDiagnosis
--select max(len(t.Price)) as maxlen from
--(
select ipbr.MemberCode
, ipbr.PatId as _PatientID
, pm.ContactNo as MobileNo
, ipbr.BillId as BillID
, SpecialistId as DoctorId
, SecondSpecialistId as CheckedByID
, DiagId as DiagnosisID
, TestID as TestID
, '' as Method
, TestRange as Range
, TestResult as Result
, TestPrice as Price
, '' as Remarks
, '' as AttachmentLink
, getdate() as CreateTs
, getdate() as UpdateTs
,iprd.SubTest
,iprd.SubTestRange
,iprd.SubTestUnits
,iprd.SubTestActive
,iprd.SubTestResult
,iprd.Note
,iprd.SubMethod
from DataWareHouse.dbo.Int_PatientBillReport ipbr
  join DataWareHouse.dbo.Int_PatientReportDetails iprd on iprd.PatId=ipbr.PatId and iprd.ReportDate=ipbr.ReportDate
  join DataWareHouse.dbo.PatientMaster pm on pm.ID=ipbr.PatId
