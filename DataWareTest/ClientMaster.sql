create table DataWareTest.dbo.ClientMaster
(
	CID int identity(1,1) primary key
	,_OrigClientId int not null
	,Code varchar(10)
	,CName varchar(50)
	,CLocation varchar(100)
	,CreateTs datetime
	,UpdateTs datetime
)


INSERT INTO DataWareTest.dbo.ClientMaster
select 
ID as _OrigClientId
,Code
,CName
,CLocation
,getdate() as CreateTs
,getdate() as UpdateTs
from DataWareHouse.dbo.Clients