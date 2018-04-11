CREATE TABLE DataWareHouse.[dbo].[DiagnosisMaster_Mah](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_DiagnosisIDOrig] [varchar](255) NULL,
	[DiagnosisName] [varchar](255) NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


INSERT INTO DataWareHouse.dbo.DiagnosisMaster_Mah

SELECT
  diag.Id		AS _DiagnosisIDOrig
, Diagnosis		AS DiagnosisName
,getdate() as CreateTs
,getdate() as UpdateTs
FROM tbl_DiagnosisGroup Diag



