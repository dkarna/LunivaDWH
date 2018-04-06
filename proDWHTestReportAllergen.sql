--select top 1 * from tbl_NRLTests where SubGroupType <> ''

--select top 1 * from DataWareHouse.dbo.TestMaster where SubGroupType <> ''

USE [DataWareHouse]
GO
/****** Object:  StoredProcedure [dbo].[proDWHTestReport]    Script Date: 4/3/2018 6:15:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[proDWHTestReport] 18
Create PROC [dbo].[proDWHTestReportAllergen]
(
   @PatientId int
)
AS
BEGIN
-- *** FOR PATIENT PERSONAL RECORD ****

	select distinct
			--top 1 *
			pm.MainPatID as Nrl_Reg_No, DATENAME(MM,pm.PDate)+RIGHT(Convert(Varchar(12),pm.PDate,107),9)+'<br>'+pm.NepaliDate+' BS' as [Date],pm.Salutation+' '+ pm.FirstName+' '+pm.MidName+' '+ pm.LastName as 'FirstName',
			 pm.Age,iprd.ReportDate +'<br>'+ '-'+' BS' as 'ResultDate',firstms.Name
			 ,case when pm.Gender='M' then 'Male'
			  when pm.Gender='F' then 'Female'
			  else 'Other'
			  end as Sex
			 ,nng.InvoiceNumber as 'InvoiceNumber',isnull(rm._OrigRequestorId,'') as Requestor 
			from DataWareHouse.dbo.FactPatientDiagnosis fpd
			join DataWareHouse.dbo.Int_PatientReportDetails iprd on iprd.PatId=fpd.PatientID
			join DataWareHouse.dbo.PatientMaster pm on pm.MainPatID=iprd._OrigPatId
			left join DataWareHouse.dbo.MasterSpecialist firstms on firstms._SpecialistIdOrig=pm.ReferredDoctorId
			left join DataWareHouse.dbo.RequestorMaster rm on rm._OrigRequestorId=pm.RequestorId
			--left join DataWareHouse.dbo.MasterSpecialist secondms on secondms.ID=fpd.CheckedBySecondID
			left join DataWareHouse.dbo.NrlNumberGenerator nng on nng.UserId=pm.MainPatId
			where pm.MainPatId=@PatientId

			--- for second doctor

			select top 1 
			isnull(secondms.Name,'') as 'SecDoctor',
			isnull(secondms.Designation,'') as 'SecDeg',
			case when (secondms.NHPCRegID is null or secondms.NHPCRegID = '') and (secondms.OtherReg is null or secondms.OtherReg = '') then isnull(secondms.NMCRegID,'')
			 when (secondms.NMCRegID is null or secondms.NMCRegID = '') and (secondms.OtherReg = '' or secondms.OtherReg is null) then isnull(secondms.NHPCRegID,'')
			 else isnull(secondms.OtherReg,'')
		end as 'SReg'
			from DataWareHouse.dbo.FactPatientDiagnosis fpd 
			left join DataWareHouse.dbo.PatientMaster pm on pm.ID=fpd.PatientID
			left join DataWareHouse.dbo.MasterSpecialist secondms on secondms.ID=fpd.CheckedBySecondID and secondms.IsReferrer=0
			where pm.MainPatID=@PatientId

	-- script to get test and subtest records on the basis of patientid

	Select subtestId,GroupId,
			--GroupName, 
			case  when GroupName like '%RENAL%' AND Testname like '%Urine Routine'
			 Then ''
			 ELSE
			  GroupName
            END AS GroupName,
			Testname,Method,[Max],TestResult,TestSubType,subresult,[Range],submethod,CheckedBy,
			Designation,RegNo,PanId,			
			--Panel,
			case  when GroupName like '%RENAL%' AND Testname like '%Urine Routine'
			 Then 'Urine Analysis'
			 ELSE
			  Panel
            END AS Panel,			
			--D_group,
			case  when GroupName like '%RENAL%' AND Testname like '%Urine Routine'
			 Then 7
			 ELSE
			  D_group
            END AS D_group,
			
			Units,DigId,SubUnit,Note
			 from
			 (
	select 
		--fpd._PatientID,fpd.MemberCode,pm.FullName,pm.MainPatID,dm.DiagnosisName,tm.Testname,ms.Name 
		iprd.SubTestId as 'subtestid', iprd.GroupId as 'GroupId',
		--case when iprd.PanelName='' or iprd.PanelName is null then upper(dm.DiagnosisName)
		--iprd._OrigPanelId,
		--case when iprd._OrigPanelId <> 0 then upper(iprd.PanelName) else upper(dm.DiagnosisName)
		--end as 'GroupName',
		iprd.GroupName,
		tm.Testname as 'TestName',
		tm.Method as Method,
		tm.SubGroupType as [Max],
		--isnull(fpd.Range,'') as [Max],
		fpd.Result as TestResult,
		fpd.SubTest as 'TestSubType',
		fpd.SubTestResult as subresult,
		fpd.SubTestRange as 'Range',
		fpd.SubMethod,
		ms.Name as 'CheckedBy',
		ms.Designation,
		case when (ms.NHPCRegID is null or ms.NHPCRegID = '') and (ms.OtherReg is null or ms.OtherReg = '') then ms.NMCRegID
			 when (ms.NMCRegID is null or ms.NMCRegID = '') and (ms.OtherReg = '' or ms.OtherReg is null) then ms.NHPCRegID
			 else ms.OtherReg
		end as 'RegNo',
		iprd.PanelId as 'PanId',
		dm.DiagnosisName as 'Panel',
		iprd.D_Group as 'D_Group',
		tm.Units,
		iprd.DigId as 'DigId',
		ISNULL(fpd.SubTestUnits,'') as 'SubUnit',
		fpd.Note
		from DataWareHouse.dbo.FactPatientDiagnosis fpd 
		--left join DataWareHouse.dbo.Int_PatientReportDetails iprd on fpd.PatientID=iprd.PatId and fpd.DiagnosisID=iprd._OrigDiagId
		--and fpd.TestID=iprd._OrigTestId and isnull(fpd.SubTest,'')=isnull(iprd.SubTest,'')
		left join DataWareHouse.dbo.Int_PatientReportDetails iprd on fpd.PatientID=iprd.PatId and fpd.DiagnosisID=iprd.DiagId
		and fpd.TestID=iprd.TestID and isnull(fpd.SubTest,'')=isnull(iprd.SubTest,'')
		left join DataWareHouse.dbo.PatientMaster pm on fpd.PatientID=pm.ID
		left join DataWareHouse.dbo.DiagnosisMaster dm on fpd.DiagnosisID=dm.ID
		left join DataWareHouse.dbo.TestMaster tm on fpd.TestID=tm.ID
		left join DataWareHouse.dbo.MasterSpecialist ms on fpd.CheckedByFirstID=ms.ID
		where pm.MainPatID=@PatientId --order by D_Group,PanId,DigId--GroupName,TestName
		) tbl
					order by D_group,GroupId
					, PanId
					, DigId
		
		--order by D_group,GroupId, PanId, DigId

END