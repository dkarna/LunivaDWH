
CREATE PROC [dbo].[proDWHTestReport]
(
   @PatientId int
)
AS
BEGIN
-- *** FOR PATIENT PERSONAL RECORD ****

	select distinct
			pm.MainPatID as Nrl_Reg_No, DATENAME(MM,pm.PDate)+RIGHT(Convert(Varchar(12),pm.PDate,107),9)+'<br>'+pm.NepaliDate+' BS' as [Date],pm.Salutation+' '+ pm.FirstName+' '+pm.MidName+' '+ pm.LastName as 'FirstName',
			 pm.Age,iprd.ReportDate +'<br>'+ '-'+' BS' as 'ResultDate',firstms.Name,pm.Gender as Sex
			 ,nng.InvoiceNumber as 'InvoiceNumber',pm.Requestor
			 from DataWareHouse.dbo.FactPatientDiagnosis fpd
			 join DataWareHouse.dbo.Int_PatientReportDetails iprd on iprd.PatId=fpd._PatientID
			join DataWareHouse.dbo.PatientMaster pm on pm.ID=fpd._PatientID
			join DataWareHouse.dbo.MasterSpecialist firstms on firstms.ID=fpd.DoctorID
			join DataWareHouse.dbo.MasterSpecialist secondms on secondms.ID=fpd.CheckedByID
			join DataWareHouse.dbo.NRLNumberGenerator nng on nng.UserId=pm.MainPatID
			where pm.MainPatID=@PatientId

			--- for second doctor

			select top 1 secondms.Name as 'SecDoctor',
			secondms.Designation as 'SecDeg',
			case when (secondms.NHPCRegID is null or secondms.NHPCRegID = '') and (secondms.OtherReg is null or secondms.OtherReg = '') then secondms.NMCRegID
			 when (secondms.NMCRegID is null or secondms.NMCRegID = '') and (secondms.OtherReg = '' or secondms.OtherReg is null) then secondms.NHPCRegID
			 else secondms.OtherReg
		end as 'SReg'
			from DataWareHouse.dbo.FactPatientDiagnosis fpd 
			join DataWareHouse.dbo.PatientMaster pm on pm.ID=fpd._PatientID
			join DataWareHouse.dbo.MasterSpecialist secondms on secondms.ID=fpd.CheckedByID
			where pm.MainPatID=@PatientId

	-- script to get test and subtest records on the basis of patientid

	select 
		--fpd._PatientID,fpd.MemberCode,pm.FullName,pm.MainPatID,dm.DiagnosisName,tm.Testname,ms.Name 
		0 as 'subtestid', 0 as 'GroupId',
		case when iprd.PanelId=0 then dm.DiagnosisName else iprd.PanelName end as 'GroupName',
		tm.Testname as 'TestName',
		tm.Method as Method,
		fpd.Range as [Max],
		fpd.Result,
		fpd.SubTest as 'TestSubType',
		fpd.SubTestResult,
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
		fpd.DiagnosisID as 'D_Group',
		tm.Units,
		0 as 'DigId',
		ISNULL(fpd.SubTestUnits,'') as 'SubUnit',
		fpd.Note
		from DataWareHouse.dbo.FactPatientDiagnosis fpd 
		join DataWareHouse.dbo.Int_PatientReportDetails iprd on fpd._PatientID=iprd.PatId and fpd.DiagnosisID=iprd._OrigDiagId
		and fpd.TestID=iprd._OrigTestId and isnull(fpd.SubTest,'')=isnull(iprd.SubTest,'')
		left join DataWareHouse.dbo.PatientMaster pm on fpd._PatientID=pm.ID
		left join DataWareHouse.dbo.DiagnosisMaster dm on fpd.DiagnosisID=dm._DiagnosisIDOrig
		left join DataWareHouse.dbo.TestMaster tm on fpd.TestID=tm._TestIDOrig
		left join DataWareHouse.dbo.MasterSpecialist ms on fpd.DoctorID=ms.ID
		where pm.MainPatID=@PatientId

END

--exec [dbo].[proDWHTestReport] 1