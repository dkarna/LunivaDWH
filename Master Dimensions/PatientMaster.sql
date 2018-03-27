-- PatientMaster

CREATE TABLE [dbo].[PatientMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MainPatID] [int] NULL,
	[IsMember] [bit] NULL,
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
	[CreditParty] [varchar](100) NULL,
	[NepaliDate] [nvarchar](15) NULL,
	[Requestor] [nvarchar](255) NULL,
	[Age] [nvarchar](20) NULL,
	[PDate] [datetime] NULL,
	,ReferredDoctorId int
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT INTO DataWareHouse.dbo.PatientMaster 
--(MainPatID,IsMember,MemberCode,FirstName,MidName,LastName,FullName,Dob,Gender,Address1,Address2,Address3,ContactNo,EmailId,IdentityID,IdentityType,Salutation,ContactNo2,ContactNo3,CrdtPrtyId,IsActive,CreateTs,UpdateTs)

SELECT 
Id AS MainPatID
,CASE WHEN MemberCode IS NULL OR MemberCode = '' OR MemberCode = 'N' THEN 0 ELSE 1 END AS IsMember
,CASE WHEN MemberCode IS NULL OR MemberCode = '' OR MemberCode = 'N' THEN NULL ELSE MemberCode END AS MemberCode
,FirstName AS FirstName
,MiddleName AS MidName
,LastName AS LastName
,FirstName + ' ' + MiddleName  + ' ' + LastName AS FullName
,CAST(getdate() AS DATE) AS Dob
,CASE Sex WHEN 'Male' THEN 'M'
	WHEN 'Female' THEN 'F'
	ELSE 'O' END AS Gender
,'' AS Address1
,'' AS Address2
,'' AS Address3
,ContactNo AS ContactNo
,isnull(EmailId,'') AS EmailId
,'' AS IdentityID
,'' AS IdentityType
,Designation AS Salutation
,'' AS ContactNo2
,'' AS ContactNo3
,CrdtPrtyId AS CrdtPrtyId
,1 AS IsActive
,CAST(getdate() AS DATE) AS CreateTs
,CAST(getdate() AS DATE) AS UpdateTs
,cpt.PartyType as CreditParty
,NepaliDate
,Requestor
,Age
,Date as PDate
,tpi.ReferredDoctorId
FROM pat.tbl_PatientInfo tpi
left join tbl_CreditPartyType cpt on cpt.TypeId=tpi.CrdtPrtyId
