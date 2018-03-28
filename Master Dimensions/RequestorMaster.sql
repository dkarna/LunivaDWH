-- Requestor Dimension

create table DataWareHouse.dbo.RequestorMaster
(
	ID int identity(1,1) primary key
	,_OrigRequestorId int not null
	,RequestorName varchar(200)
	,ReqIsActive int
	,ReqReqId int
	,CreateTs datetime
	,UpdateTs datetime
)


-- insert data into RequestorMaster
--truncate table DataWareHouse.dbo.RequestorMaster
insert into DataWareHouse.dbo.RequestorMaster
select * from
(
select distinct
ri.Id as _OrigRequestorId
,isnull(ri.Requestor,'') as RequestorName
,ri.IsActive as ReqIsActive
,isnull(ri.reqId,0) as ReqReqId
,getdate() as CreateTs
,getdate() as UpdateTs
from tbl_RequestorInfo ri
where ri.Requestor not in('','.','**')
union
select top 1
ri.Id as _OrigRequestorId
,isnull(ri.Requestor,'') as RequestorName
,ri.IsActive as ReqIsActive
,isnull(ri.reqId,0) as ReqReqId
,getdate() as CreateTs
,getdate() as UpdateTs
from tbl_RequestorInfo ri
where ri.Requestor='.'
union
select top 1
ri.Id as _OrigRequestorId
,isnull(ri.Requestor,'') as RequestorName
,ri.IsActive as ReqIsActive
,isnull(ri.reqId,0) as ReqReqId
,getdate() as CreateTs
,getdate() as UpdateTs
from tbl_RequestorInfo ri
where ri.Requestor='**'
) as t
order by t._OrigRequestorId

--select * from pat.tbl_PatientInfo where Requestor='.'


