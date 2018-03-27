--drop table DataWareHouse.dbo.SubTestMaster
create table DataWareHouse.dbo.SubTestMaster
(
	ID int identity(1,1) primary key
	,_SubTestIdOrig int not null
	,SubTestName nvarchar(max)
	,SubTestGroup nvarchar(max)
	,SubTestRange nvarchar(max)
	,SubTestUnits nvarchar(max)
	,ParentSubTestId int
	,ParentSubTest nvarchar(max)
	,IsActive int not null
	,CreateTs datetime not null
	,UpdateTs datetime not null
)

insert into DataWareHouse.dbo.SubTestMaster
select t1.Id as _SubTestIdOrig
,t1.TestSubType as SubTestName
,t1.[Group] as SubTestGroup
,t1.SubTestRange as SubTestRange
,t1.SubTestUnits as SubTestUnits
,t1.SubTestId as ParentSubTestId
,t2.TestSubType as  ParentSubTest
,isnull(t1.IsActive,0) as IsActive
,getdate() as CreateTs
,getdate() as UpdateTs
from tbl_SubTests t1
left join tbl_SubTests t2 on t2.SubTestId=t1.Id