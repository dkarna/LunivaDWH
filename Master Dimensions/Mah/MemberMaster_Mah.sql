CREATE TABLE DataWareHouse.[dbo].[MemberMaster_Mah](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MemberCode] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[MidName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[FullName] [varchar](100) NULL,
	[Dob] [date] NULL,
	[Gender] [char](1) NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[Address3] [varchar](100) NULL,
	[ContactNo] [varchar](20) NULL,
	[EmailId] [varchar](50) NULL,
	[IdentityID] [varchar](50) NULL,
	[IdentityType] [varchar](20) NULL,
	[Salutation] [varchar](10) NULL,
	[ContactNo2] [varchar](20) NULL,
	[ContactNo3] [varchar](20) NULL,
	[CrdtPrtyId] [int] NULL,
	[IsActive] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


-- Insert data

INSERT INTO DataWareHouse.[dbo].[MemberMaster_Mah]

SELECT DISTINCT
 case when MemberCode like '%M%' then MemberCode else NULL end AS MemberCode
,FirstName AS FirstName
,MiddleName AS MidName
,LastName AS LastName
,FirstName + ' ' + MiddleName + ' ' + LastName AS FullName
,GETDATE()  AS Dob
,CASE SEX	WHEN 'Male'		THEN 1
			WHEN 'Female'	THEN 2 
			ELSE 0 
 END AS Gender
,'' AS Address1
,'' AS Address2
,'' AS Address3
,case when convert(varchar,ContactNo) is null then '0' else convert(varchar,ContactNo) end AS ContactNo
,EmailId AS EmailId
,'' AS IdentityID
,'' AS IdentityType
,Designation AS Salutation
,'' AS ContactNo2
,'' AS ContactNo3
,0 AS CrdtPrtyId
,1 AS IsActive
,GETDATE() AS CreateTs
,GETDATE() AS UpdateTs
FROM [pat].[tbl_PatientInfo] pat
WHERE MemberCode <> '' AND MemberCode <> 'N' AND MemberCode is not null --and ContactNo <> ''