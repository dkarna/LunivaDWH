CREATE TABLE DataWareHouse.[dbo].[TestMaster_Mah](
	[ID] [int] IDENTITY(1,1) NOT NULL,
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


--drop table [DataWareHouse].dbo.[TestMaster_Mah]
insert into  [DataWareHouse].dbo.[TestMaster_Mah]

SELECT 
 ID AS _TestIDOrig
,TESTCODE AS TestCode
,Testname AS Testname
,Price AS Price
,TotalPrice AS TotalPrice
,Specimen AS Specimen
,Method AS Method
,Schedule AS Schedule
,Reporting AS Reporting
,Units AS Units
,IsOutGoingTest AS IsOutGoingTest
,SubGroupId AS SubGroupId
,SubGroupType AS SubGroupType
,IsCulture AS IsCulture
,u.usrFullName AS UserId
,EntryDate AS EntryDate
,IsActive AS TestIsActive
,isnull(TestType,'') AS TestType
,'0' AS IsHisto
,'0' AS IsDifferentialTest
,getdate() as CreateTs
,getdate() as UpdateTs
FROM tbl_NRLTests T
LEFT JOIN tbl_appUsers U on T.UserId =  U.usruserid