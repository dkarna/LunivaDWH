create table DataWareHouse.dbo.NRLNumberGenerator
(
	Id int identity(1,1) primary key
	,NrlNumber int not null
	,InvoiceNumber nvarchar(50) not null
	,NumDate datetime not null
	,UserId int 
	,NepaliDate varchar(15)
)

INSERT INTO DataWareHouse.dbo.NRLNumberGenerator
(NrlNumber,InvoiceNumber, NumDate, UserId, NepaliDate)
select NrlNumber,InvoiceNumber,[Date],UserId,NepaliDate from dbo.tbl_NrlNumberGenerator