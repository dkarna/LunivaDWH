USE [Carelab_Ktm_Current]
GO
/****** Object:  StoredProcedure [branch].[proNormalNrlLabReport_test_augustForBranch]    Script Date: 1/24/2018 1:40:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
PUrpose: for reporting of normal test along with subtest
Date 7th june
[branch].[proNormalNrlLabReport_test_augustForBranch]31


*/

ALTER PROC [branch].[proNormalNrlLabReport_test_augustForBranch]
(
   @PatId int
)
AS
BEGIN
       
	   -- *** FOR PATIENT PERSONAL RECORD ****
		Select distinct pRecord.Nrl_Reg_No, DATENAME(MM,Pinfo.Date)+RIGHT(Convert(Varchar(12),Pinfo.Date,107),9)+'<br>'+pinfo.NepaliDate+' BS' as [Date],Pinfo.Designation+' '+ Pinfo.FirstName+' '+Pinfo.MiddleName+' '+ Pinfo.LastName as 'FirstName',
		 Pinfo.Age,DATENAME(MM,precord.ResultDate)+RIGHT(Convert(Varchar(12),precord.ResultDate,107),9)+'<br>'+ pRecord.ReportedNepaliDate+' BS' as 'ResultDate',doc.Name,pinfo.Sex
		 ,Pinfo.BranchInvoiceNo +' ('+ branchName +')' as 'InvoiceNumber',Pinfo.Requestor
		 from branch.tbl_BranchPatientInfo Pinfo
		JOIn branch.tbl_BranchPatientTestRecord pRecord on Pinfo.Id=pRecord.PatId 
		JOIN pat.tbl_PatReferDoctor doc on doc.ID=pinfo.ReferredDoctorId
		JOIN tbl_NrlNumberGenerator num on num.UserId=Pinfo.Id	 
		join branch.tbl_BranchInfo BInfo on Pinfo.BranchId=BInfo.branchID		
		where Pinfo.Id=@PatId

		
		--- ** FOR DIAGNOSIS GROUP **** BUT NOT USED
		--SELECT  distinct pat.Id,InTest.Id as 'DignosisId',dgroup.Diagnosis as 'Description',
		--   dgroup.Id as 'ProrityId'	  
		--  from pat.tbl_PatientTestRecord pat
		--  JOIN tbl_Test_DiagnosisGroup InTest on pat.IndividualTestId=InTest.Id		  
		--  JOIN tbl_DiagnosisGroup dgroup ON Intest.DGId=dgroup.id	
		  
		--  where pat.PatId=@PatId
		--  order by dgroup.Id


		--- for second doctor
		select top 1 
		  case when 
		         d.Name='SELECT' THEN '' ELSE d.Name  END as 'SecDoctor',
	      CASE WHEN d.Designation='-' THEN '' ELSE d.Designation  END as 'SecDeg', 
		  Case when  d.Reg_No='-' THEN '' ELSE d.Reg_No END as 'SReg' 
		from branch.tbl_BranchPatientTestRecord r JOIN tbl_PatTestCheckedBy d on d.Id=r.CheckedBySecond where r.PatId=@PatId

		 -- select p.CheckedBySecond,chk.Name as 'CheckedBy2',chk.Designation as 'Chk2Desg',chk.Reg_No as 'Chk2Reg' from pat.tbl_PatientTestRecord p
			--join tbl_PatTestCheckedBy chk on p.CheckedBySecond=chk.Id
			--where p.PatId=@PatId


-- ***** SELECT INDIVIDUAL AND PROFILE TESTS WITH SUB GROUP
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
			 from (			
			--- Individual
			select  subresult.Id as 'subtestId', dgroup.Id as 'GroupId', patrecord.Id,UPPER(dgroup.Diagnosis) as 'GroupName', 
			nTest.Testname,
			ntest.Method,
			--ran.SubGroup+' '+ran.Min+case when ran.Min=null OR Ran.Min='' then ' ' else ' - ' End+ ran.Max+'( '+ran.[Group]+')' as 'Max',
			ran.[Min] as 'Max',
			patrecord.TestResult,subtest.TestSubType,subresult.Result as 'subresult',subtest.SubTestRange as'Range',
			subresult.Method as 'submethod',
			case when 
		         chk.Name='SELECT' THEN '' ELSE chk.Name  END as 'CheckedBy',
			--chk.Name as 'CheckedBy',
			case when
			   chk.Designation ='-' THEN '' ELSE chk.Designation  END as 'Designation',
			--chk.Designation as 'Designation', 
			case when 
			       chk.Reg_No='-' THEN '' ELSE chk.Reg_No END as 'RegNo',
			--chk.Reg_No as 'RegNo', 
			'0' as 'PanId'
			,dgroup.Diagnosis as 'Panel', dgroup.Id as 'D_group',nTest.Units,InTest.Id as 'DigId',Isnull(subtest.SubTestUnits,'') as 'SubUnit',patrecord.Note as 'Note'
			 from branch.tbl_BranchPatientTestRecord patrecord
			LEFT JOIN  branch.tbl_BranchTestResultForReport subresult  on patrecord.Id=subresult.TestId
			LEFT JOIN tbl_SubTests subtest on subtest.Id=subresult.SubTestId
			 JOIN tbl_Test_DiagnosisGroup InTest on patrecord.IndividualTestId=InTest.Id
			LEFT JOIN tbl_NrlTests nTest ON InTest.TestId=nTest.id
			LEFT JOIN tbl_DiagnosisGroup dgroup ON Intest.DGId=dgroup.id
			--LEFT JOIN tbl_RangeOfTests ran on ran.Id=subTest.RangeID
			LEFT JOIN tbl_RangeOfTests ran on ran.DGId=Intest.Id
			LEFT JOIN tbl_PatTestCheckedBy chk on chk.Id=patrecord.CheckedBy
			where patrecord.PatId=@PatId and nTest.Testname not like 'Stone Analysis' and patrecord.IsHideOnPrint=0

			UNION
			-- Panel PRofile
			SELECT rep.id as 'subtestId',pgroup.Id as 'GroupId', pat.Id,UPPER(pGroup.Description) as 'GroupName',
					 ntest.Testname as'TestName', 
					 ntest.Method,
					 --isnull((trange.Min+'-'+trange.Max ),'-')as 'Max',
					 isnull(trange.[Min],'') as 'Max',
					 pat.TestResult,
					 subtest.TestSubType,rep.Result as 'subresult',subtest.SubTestRange as 'Range',rep.Method as 'submethod',
					 --chk.Name as 'CheckedBy',
					 --chk.Designation as 'Designation',
					 -- chk.Reg_No as 'RegNo',
					  case when 
						chk.Name='SELECT' THEN '' ELSE chk.Name  END as 'CheckedBy',			
			     case when
			         chk.Designation ='-' THEN '' ELSE chk.Designation  END as 'Designation',			
			   case when 
			       chk.Reg_No='-' THEN '' ELSE chk.Reg_No END as 'RegNo',
			
					  testGroup.Id as 'panId'
					 ,pGroup.DiagnosisGroup as 'Panel', 
					  pGroup.DiagnosisId as 'D_Group',
					-- dGroup.Id as 'D_group',
					 
					 ntest.Units,testDiagnosis.Id as  'DigId',Isnull(subtest.SubTestUnits,'') as 'SubUnit',pat.Note as 'Note'
					  FROM branch.[tbl_BranchPatientTestRecord] pat
					   LEFT JOIN branch.tbl_BranchTestResultForReport rep on rep.TestId=pat.Id
					   LEFT JOIN tbl_SubTests subtest on subtest.Id=rep.SubTestId
					   JOIN tbl_TestPanel_ProfileGroup testGroup ON pat.TestPanId=testGroup.Id
					   JOIN tbl_Panel_ProfileGroup pGroup ON testGroup.PanId=pGroup.Id
					   JOIN tbl_Test_DiagnosisGroup testDiagnosis ON testGroup.DGId=testDiagnosis.Id
					   JOIN tbl_NrlTests ntest ON ntest.Id=testDiagnosis.TestId
					   JOIN tbl_DiagnosisGroup dGroup ON dGroup.Id=testDiagnosis.DGId 					  		   
					   LEft JOIN tbl_RangeOfTests trange on trange.DGId=testDiagnosis.id 
					   LEFT JOIN tbl_PatTestCheckedBy chk on chk.Id=pat.CheckedBy
					  WHERE pat.PatId=@PatId and pat.IsHideOnPrint=0 ) tbl
					order by D_group,GroupId, PanId, DigId--,Id
		  
END
