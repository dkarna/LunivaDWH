create table DataWarehouse.dbo.FFPanelDiagnosisTest
(
	Id int primary key identity(1,1),
	_OrigPanId int,
	_OrigDiagId int,
	_OrigTestId int,
	PanelName varchar(100), 
	DiagnosisName varchar(100),
	TestName varchar(100),
	CreateTs datetime,
	UpdateTs datetime
)

insert into DataWarehouse.dbo.FFPanelDiagnosisTest(_OrigPanId,_OrigDiagId,_OrigTestId,PanelName,DiagnosisName,TestName,CreateTs,UpdateTs)
  select ttppg.PanId as _OrigPanId
  ,ttdg.DgId as _OrigDiagId
  ,ttdg.TestId as _OrigTestId
  ,tppg.Description as PanelName
  ,tdg.Diagnosis as DiagnosisName
  ,tnt.Testname as TestName
  ,getdate() as CreateTs
  ,getdate() as UpdateTs
   from tbl_TestPanel_ProfileGroup ttppg
  join tbl_Test_DiagnosisGroup ttdg on ttppg.DGId = ttdg.Id
  join tbl_Panel_ProfileGroup tppg on ttppg.PanId = tppg.Id
  join tbl_DiagnosisGroup tdg on ttdg.DgId = tdg.Id
  join tbl_NRLTests tnt on ttdg.TestId=tnt.Id