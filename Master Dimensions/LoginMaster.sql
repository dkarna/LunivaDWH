CREATE TABLE DataWareHouse.[dbo].[LoginMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LoginType] [varchar](20) NULL,
	[LoginTypeID] [varchar](50) NULL,
	[LoginID] [varchar](50) NULL,
	[LoginPw] [varchar](50) NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTS] [datetime] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

-- Insert data

INSERT INTO  DataWareHouse.dbo.LoginMaster

SELECT 
  'MEMBER' AS LoginType
, MemberCode AS LoginTypeID
, MemberCode+ 'LOG' AS LoginID
, MemberCode + 'pwd' AS LoginPw
, getdate() AS CreateTs
, getdate() AS UpdateTS
, 1 AS IsActive
FROM DataWareHouse.[dbo].[MemberMaster]