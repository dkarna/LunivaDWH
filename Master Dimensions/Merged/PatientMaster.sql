--drop table DataWareTest.[dbo].[PatientMaster]

CREATE TABLE DataWareTest.[dbo].[PatientMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID][int] NOT NULL,
	[_OrigClientId][int] NOT NULL,
	[ClientPatID] [int] NOT NULL,
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
	[ReferredDoctorId] [int] NULL,
	[RequestorId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- Insert Data

Insert into DataWareTest.dbo.PatientMaster
select 
c.CID as ClientID
,c._OrigClientId as _OrigClientId
,pm.ID as ClientPatID
,pm.MainPatID
,pm.IsMember
,ISNULL(pm.MemberCode,'') as MemberCode
,pm.FirstName
,pm.MidName
,pm.LastName
,pm.FullName
,pm.Dob
,pm.Gender
,pm.Address1
,pm.Address2
,pm.Address3
,pm.ContactNo
,pm.EmailId
,pm.IdentityID
,pm.IdentityType
,pm.Salutation
,pm.ContactNo2
,pm.ContactNo3
,pm.CrdtPrtyId
,pm.IsActive
,pm.CreateTs
,pm.UpdateTs
,pm.CreditParty
,pm.NepaliDate
,pm.Requestor
,pm.Age
,pm.PDate
,pm.ReferredDoctorId
,pm.RequestorId
from DataWareHouse.dbo.PatientMaster pm,DataWareTest.dbo.ClientMaster c
where c._OrigClientId=1

UNION

select 
c.CID as ClientID
,c._OrigClientId as _OrigClientId
,pm.ID as ClientPatID
,pm.MainPatID
,pm.IsMember
,ISNULL(pm.MemberCode,'') as MemberCode
,pm.FirstName
,pm.MidName
,pm.LastName
,pm.FullName
,pm.Dob
,pm.Gender
,pm.Address1
,pm.Address2
,pm.Address3
,pm.ContactNo
,pm.EmailId
,pm.IdentityID
,pm.IdentityType
,pm.Salutation
,pm.ContactNo2
,pm.ContactNo3
,pm.CrdtPrtyId
,pm.IsActive
,pm.CreateTs
,pm.UpdateTs
,pm.CreditParty
,pm.NepaliDate
,pm.Requestor
,pm.Age
,pm.PDate
,pm.ReferredDoctorId
,pm.RequestorId
from DataWareHouse.dbo.PatientMaster_Mah pm,DataWareTest.dbo.ClientMaster c
where c._OrigClientId=2
