
--drop table DataWareTest.[dbo].[TestMaster]
CREATE TABLE DataWareTest.[dbo].[TestMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID][int] NOT NULL,
	[_OrigClientId][int] NOT NULL,
	[ClientTestID] [int] NOT NULL,
	[_TestIDOrig] [varchar](max) NULL,
	[TestCode] [varchar](max) NULL,
	[Testname] [varchar](max) NULL,
	[Price] [varchar](max) NULL,
	[TotalPrice] [varchar](max) NULL,
	[Specimen] [varchar](max) NULL,
	[Method] [varchar](max) NULL,
	[Schedule] [varchar](max) NULL,
	[Reporting] [varchar](max) NULL,
	[Units] [varchar](max) NULL,
	[IsOutGoingTest] [varchar](max) NULL,
	[SubGroupId] [varchar](max) NULL,
	[SubGroupType] [varchar](max) NULL,
	[IsCulture] [varchar](max) NULL,
	[EnteredBy] [varchar](max) NULL,
	[EntryDate] [varchar](max) NULL,
	[TestIsActive] [varchar](max) NULL,
	[TestType] [varchar](max) NULL,
	[IsHisto] [varchar](max) NULL,
	[IsDifferentialTest] [varchar](max) NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- insert data

insert into DataWareTest.[dbo].[TestMaster]
select c.CID as ClientID
,c._OrigClientId
,tm.ID as ClientTestID
,tm._TestIDOrig
,tm.TestCode
,tm.Testname
,tm.Price
,isnull(tm.TotalPrice,0) as TotalPrice
,tm.Specimen
,tm.Method
,tm.Schedule
,tm.Reporting
,tm.Units
,tm.IsOutGoingTest
,tm.SubGroupId
,tm.SubGroupType
,tm.IsCulture
,tm.EnteredBy
,tm.EntryDate
,tm.TestIsActive
,tm.TestType
,tm.IsHisto
,tm.IsDifferentialTest
,tm.CreateTs
,tm.UpdateTs
from DataWareHouse.dbo.TestMaster tm, DataWareTest.dbo.ClientMaster c
where c._OrigClientId=1

UNION

select c.CID as ClientID
,c._OrigClientId
,tm.ID as ClientTestID
,tm._TestIDOrig
,tm.TestCode
,tm.Testname
,tm.Price
,isnull(tm.TotalPrice,0) as TotalPrice
,tm.Specimen
,tm.Method
,tm.Schedule
,tm.Reporting
,tm.Units
,tm.IsOutGoingTest
,tm.SubGroupId
,tm.SubGroupType
,tm.IsCulture
,tm.EnteredBy
,tm.EntryDate
,tm.TestIsActive
,tm.TestType
,tm.IsHisto
,tm.IsDifferentialTest
,tm.CreateTs
,tm.UpdateTs
from DataWareHouse.dbo.TestMaster_Mah tm, DataWareTest.dbo.ClientMaster c
where c._OrigClientId=2

--select top 1 * from DataWareHouse.dbo.TestMaster
--select top 1 * from DataWareHouse.dbo.TestMaster_Mah
--select top 1 * from DataWareTest.dbo.TestMaster
--select top 1 * from DataWareTest.dbo.ClientMaster