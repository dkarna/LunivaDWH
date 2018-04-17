CREATE TABLE DataWareHouse.[dbo].[BillLoginMaster_Mah](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_PatientID] [int] NULL,
	[BillLogin] [varchar](50) NULL,
	[BillPassword] [varchar](50) NULL,
	[ClientID] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[IsMemberMapped] [bit] NULL,
	[IsDocSharable] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
 CONSTRAINT [pk_BillLoginMaster_Mah_Id] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


-- INsert data

INSERT INTO DataWareHouse.dbo.BillLoginMaster_Mah

SELECT 
 Id AS _PatientID
,CAST(id as varchar(10) )+ 'LOG' AS BillLogin
,CAST(id as varchar(10) )+ 'PWD' AS BillPassword
,1 AS ClientID
,1 AS IsActive
,0 AS IsMemberMapped
,1 AS IsDocSharable
,GETDATE() AS CreateTs
,GETDATE() AS UpdateTs
FROM [pat].[tbl_PatientInfo] pat
WHERE MemberCode <> '' AND MemberCode <> 'N'-- AND ContactNo <> ''
order by Id