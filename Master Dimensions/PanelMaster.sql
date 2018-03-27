create table DataWarehouse.dbo.PanelMaster 
(
	Id int primary key Identity(1,1)
	,_OrigPanelId int,
	PanelName varchar(100), 
	PanelType varchar(100),
	CreateTs datetime,
	UpdateTs datetime
)
  
  insert into DataWarehouse.dbo.PanelMaster
  select tppg.Id as _OrigPanelId,
  tppg.Description as PanelName,
  ttgt.TestType as PanelType,
  getdate() as CreateTs,
  getdate() as UpdateTs 
  from tbl_Panel_ProfileGroup tppg
  join tbl_Test_GroupType ttgt on tppg.TypeId = ttgt.Id

 --select * from DataWarehouse.dbo.PanelMaster