exec [dbo].[proNormalNrlLabReport_test_august] 90

--exec DataWareHouse.[dbo].[proDWHTestReport] 90
exec [dbo].[ProcGetHistoTestReportByPatIdTestIDAndTestType] 212

exec [dbo].[proNormalNrlLabReport_test_Allergen] 18
select top 10 * from DataWareHouse.[dbo].[Int_PatientHistoDetails]

select top 1 * from pat.tbl_PatientHistoRecord record
select top 1 * from DataWareHouse.dbo.PatientHistoMaster

create proc DataWareHouse.dbo.HistoReportByPatIdTestIdTestType
(
	@PatHistoId int
)
AS
BEGIN
	if exists(select * from DataWareHouse.dbo.Int_Patient where Id=@PatHistoId and IsFinished=1)
END

 