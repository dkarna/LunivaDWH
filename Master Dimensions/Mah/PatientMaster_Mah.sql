--select top 1 * from pat.tbl_PatientInfo
--select * FROM pat.tbl_PatientInfo tpi
--select * from tbl_RequestorInfo where Requestor like '%Ans%'
--select distinct MemberCode from pat.tbl_PatientInfo
--select * from tbl_MemberShip

CREATE TABLE DataWareHouse.[dbo].[PatientMaster_Mah](
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
	[RequestorId] int NULL,
	[Requestor] [nvarchar](255) NULL,
	[Age] [nvarchar](20) NULL,
	[PDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

-- temporary requestor table to filter out unwanted data

select * into #tempRequestor from
(
	select distinct Id,
	Requestor,IsActive,
	isnull(reqId,0) as reqId from tbl_RequestorInfo 
	where Requestor not in ('','-','self')

union

	select top 1 * from tbl_RequestorInfo where Requestor='self'
) as t
order by t.Id

INSERT INTO DataWareHouse.dbo.PatientMaster_Mah 
--(MainPatID,IsMember,MemberCode,FirstName,MidName,LastName,FullName,Dob,Gender,Address1,Address2,Address3,ContactNo,EmailId,IdentityID,IdentityType,Salutation,ContactNo2,ContactNo3,CrdtPrtyId,IsActive,CreateTs,UpdateTs)

SELECT DISTINCT
tpi.Id AS MainPatID
,CASE WHEN tpi.MemberCode IS NULL OR tpi.MemberCode = '' OR tpi.MemberCode = 'N' THEN 0 ELSE 1 END AS IsMember
,CASE WHEN tpi.MemberCode IS NULL OR tpi.MemberCode = '' OR tpi.MemberCode = 'N' THEN NULL ELSE tpi.MemberCode END AS MemberCode
,tpi.FirstName AS FirstName
,tpi.MiddleName AS MidName
,tpi.LastName AS LastName
,tpi.FirstName + ' ' + tpi.MiddleName  + ' ' + tpi.LastName AS FullName
,CAST(getdate() AS DATE) AS Dob
,CASE tpi.Sex WHEN 'Male' THEN 'M'
	WHEN 'Female' THEN 'F'
	ELSE 'O' END AS Gender
,'' AS Address1
,'' AS Address2
,'' AS Address3
,tpi.ContactNo AS ContactNo
,isnull(tpi.EmailId,'') AS EmailId
,'' AS IdentityID
,'' AS IdentityType
,tpi.Designation AS Salutation
,'' AS ContactNo2
,'' AS ContactNo3
,tpi.CrdtPrtyId AS CrdtPrtyId
,1 AS IsActive
,CAST(getdate() AS DATE) AS CreateTs
,CAST(getdate() AS DATE) AS UpdateTs
,'' as CreditParty  -- No Credit party available
,tpi.NepaliDate
,case when tpi.Requestor = '' then 0 
   else  ri.Id 
 end as RequestorId
,tpi.Requestor
,tpi.Age
,tpi.[Date] as PDate
FROM pat.tbl_PatientInfo tpi
--left join tbl_CreditPartyType cpt on cpt.TypeId=tpi.CrdtPrtyId    -- No Credit party available
left join #tempRequestor ri on ri.Requestor=tpi.Requestor


