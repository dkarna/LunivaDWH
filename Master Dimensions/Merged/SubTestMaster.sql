
--drop table DataWareTest.[dbo].[SubTestMaster]
CREATE TABLE DataWareTest.[dbo].[SubTestMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID][int] NOT NULL,
	[_OrigClientId][int] NOT NULL,
	[ClientSubTestID] [int] NOT NULL,
	[_SubTestIdOrig] [int] NOT NULL,
	[SubTestName] [nvarchar](max) NULL,
	[SubTestGroup] [nvarchar](max) NULL,
	[SubTestRange] [nvarchar](max) NULL,
	[SubTestUnits] [nvarchar](max) NULL,
	[ParentSubTestId] [int] NULL,
	[ParentSubTest] [nvarchar](max) NULL,
	[IsActive] [int] NOT NULL,
	[CreateTs] [datetime] NOT NULL,
	[UpdateTs] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- insert data

--insert into DataWareTest.dbo.SubTestMaster
select c.CID as ClientID
,c._OrigClientId
,stm.ID as ClientSubTestID
,stm._SubTestIdOrig
,stm.SubTestName
,stm.SubTestGroup
,isnull(stm.SubTestRange,'') as SubTestRange
,isnull(stm.SubTestUnits,'') as SubTestUnits
,stm.ParentSubTestId
,isnull(stm.ParentSubTest,'') as ParentSubTest
,stm.IsActive
,stm.CreateTs
,stm.UpdateTs
from DataWareHouse.dbo.SubTestMaster stm,DataWareTest.dbo.ClientMaster c
where c._OrigClientId=1

UNION

select c.CID as ClientID
,c._OrigClientId
,stm.ID as ClientSubTestID
,stm._SubTestIdOrig
,stm.SubTestName
,stm.SubTestGroup
,isnull(stm.SubTestRange,'') as SubTestRange
,isnull(stm.SubTestUnits,'') as SubTestUnits
,stm.ParentSubTestId
,isnull(stm.ParentSubTest,'') as ParentSubTest
,stm.IsActive
,stm.CreateTs
,stm.UpdateTs
from DataWareHouse.dbo.SubTestMaster_Mah stm,DataWareTest.dbo.ClientMaster c
where c._OrigClientId=2

--select top 1 * from DataWareHouse.dbo.SubTestMaster
--select * from DataWareHouse.dbo.SubTestMaster_Mah
--select top 1 * from DataWareTest.dbo.ClientMaster
--select top 1 * from DataWareTest.dbo.SubTestMaster
