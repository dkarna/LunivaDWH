

--drop table DataWareHouse.dbo.Roles
create table DataWareHouse.dbo.Roles
(
	RID int identity(1,1) primary key
	,_OrigRoleId int not null
	,RoleName nvarchar(50)
	,CreateTs datetime
	,UpdateTs datetime
)

insert into DataWareHouse.dbo.Roles
select tr.roleID as _OrigRoleId
,tr.roleName as RoleName
,getdate() as CreateTs
,getdate() as UpdateTs
from tbl_Role tr

--drop table DataWareHouse.dbo.Rights
create table DataWareHouse.dbo.Rights
(
	RID int identity(1,1) primary key
	,_OrigRightsId int not null
	,RightsName varchar(50)
	,RightDesc varchar(max)
	,CreateTs datetime
	,UpdateTs datetime
)

insert into DataWareHouse.dbo.Rights
select tr.rightsID as _OrigRightsId
,tr.rightsName as RightsName
,tr.rightsDescp as RightsDesc
,getdate() as CreateTs
,getdate() as UpdateTs
from tbl_Rights tr

--drop table DataWareHouse.dbo.Role_Rights
create table DataWareHouse.dbo.Role_Rights
(
	RRID int identity(1,1) primary key
	,RoleId int not null
	,RightsId int not null
)

insert into DataWareHouse.dbo.Role_Rights
select trr.rrRoleID as RoleId
,trr.rrRightID
from tbl_RoleRights trr


select top 1 * from tbl_Role
select top 1 * from tbl_Rights
select top 1 * from tbl_RoleRights

select * from tbl_Role


select top 1 * from tbl_Membership

alter table DataWareHouse.dbo.LoginMaster add UserRole int
update DataWareHouse.dbo.LoginMaster set UserRole=0
alter table DataWareHouse.dbo.LoginMaster add _OrigId int
update lm set _OrigId=tmem.Id
--select top 2 *
from DataWareHouse.dbo.LoginMaster lm
join tbl_Membership tmem on tmem.MemberCode = lm.LoginTypeId

select * from DataWareHouse.dbo.LoginMaster
select count(*) from DataWareHouse.dbo.LoginMaster
select top 2 * from tbl_appUsers
select count(*) from tbl_appUsers
select top 1 * from DataWareHouse.dbo.LoginInfo

insert into DataWareHouse.dbo.LoginMaster
select 'STAFF' as LoginType
,tau.usrusername as LoginTypeId
,tau.usrusername as LoginID
,tau.usrpassword as LoginPw
,getdate() as CreateTs
,getdate() as UpdateTS
,1 as IsActive
,tau.usrrole as UserRole
,tau.usruserid
from tbl_appUsers tau