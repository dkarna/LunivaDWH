--exec [dbo].[proNormalNrlLabReport_test_august] 90

----exec DataWareHouse.[dbo].[proDWHTestReport] 90
exec [dbo].[ProcGetHistoTestReportByPatIdTestIDAndTestType] 11817
exec DataWareHouse.dbo.HistoReportByPatIdTestIdTestType 11817

declare @PatHistoId int = 7885
select * from DataWareHouse.dbo.Int_PatientHistoDetails where Id=@PatHistoId and IsFinished=1
select * from pat.tbl_PatientHistoRecord where IsFinished=0
--Id=@PatHistoId and 
select PatientId
			,ResultId
			,TestTitle
			,TestParent
			,Result
			,HistoTestId
			,HistoTestName
			,HistoTestTypeId
			,HistoType
			,IsFinished
			,IsTaken
			,ReportTakenBy
			,CheckedBy
			,Designation
			,Reg_No
			,Nrl_Reg_No
			,HistoCode,InvoiceNumber
			,ResultDate
			,CheckedById
			,CheckedBySecond
			,HistoNote 
			from DataWareHouse.dbo.FactPatientHistoRecords where PatHistRecId=@PatHistoId and IsHistoRecord=0
			order by ResultId
--select * from DataWareHouse.dbo.FactPatientHistoRecords where PatHistRecId=7849 and IsHistoRecord=1 order by ResultId
--exec [dbo].[proNormalNrlLabReport_test_Allergen] 18
--select top 10 * from DataWareHouse.[dbo].[Int_PatientHistoDetails]

--select top 1 * from pat.tbl_PatientHistoRecord record where IsFinished = 0
--select top 1 * from DataWareHouse.dbo.PatientHistoMaster
--select top 1 * from DataWareHouse.dbo.FactPatientHistoRecords

exec DataWareHouse.dbo.HistoReportByPatIdTestIdTestType 7885
exec [dbo].[ProcGetHistoTestReportByPatIdTestIDAndTestType] 7885



alter proc dbo.HistoReportByPatIdTestIdTestType
(
	@PatHistoId int
)
AS
BEGIN
	--if exists(select * from DataWareHouse.dbo.Int_PatientHistoDetails where Id=@PatHistoId and IsFinished=1)
		Begin
			select PatientId
			,ResultId
			,TestTitle
			,TestParent
			,Result
			,HistoTestId
			,HistoTestName
			,HistoTestTypeId
			,HistoType
			,IsFinished
			,IsTaken
			,ReportTakenBy
			,CheckedBy
			,Designation
			,Reg_No
			,Nrl_Reg_No
			,HistoCode,InvoiceNumber
			,ResultDate
			,CheckedById
			,CheckedBySecond
			,HistoNote 
			from DataWareHouse.dbo.FactPatientHistoRecords where PatHistRecId=@PatHistoId --and IsHistoRecord=1
			order by ResultId
		End
	--Else
	--	Begin
	--		select PatientId
	--		,ResultId
	--		,TestTitle
	--		,TestParent
	--		,Result
	--		,HistoTestId
	--		,HistoTestName
	--		,HistoTestTypeId
	--		,HistoType
	--		,IsFinished
	--		,IsTaken
	--		,ReportTakenBy
	--		,CheckedBy
	--		,Designation
	--		,Reg_No
	--		,Nrl_Reg_No
	--		,HistoCode,InvoiceNumber
	--		,ResultDate
	--		,CheckedById
	--		,CheckedBySecond
	--		,HistoNote 
	--		from DataWareHouse.dbo.FactPatientHistoRecords where PatHistRecId=@PatHistoId and IsHistoRecord=0
	--		order by ResultId
	--	End
END

 