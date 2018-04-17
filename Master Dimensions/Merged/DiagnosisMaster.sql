--drop table DataWareTest.[dbo].[DiagnosisMaster]
CREATE TABLE DataWareTest.[dbo].[DiagnosisMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID][int] NOT NULL,
	[_OrigClientId][int] NOT NULL,
	[ClientDiagID] [int] NOT NULL,
	[_DiagnosisIDOrig] [varchar](255) NULL,
	[DiagnosisName] [varchar](255) NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


Insert into DataWareTest.[dbo].[DiagnosisMaster]
select c.CID as ClientID
,c._OrigClientId as _OrigClientId
,dm.ID as ClientDiagID
,dm._DiagnosisIDOrig as _DiagnosisIDOrig
,dm.DiagnosisName
,dm.CreateTs
,dm.UpdateTs
from DataWareHouse.dbo.DiagnosisMaster dm,DataWareTest.dbo.ClientMaster c
where c._OrigClientId=1

UNION

select c.CID as ClientID
,c._OrigClientId as _OrigClientId
,dm.ID as ClientDiagID
,dm._DiagnosisIDOrig as _DiagnosisIDOrig
,dm.DiagnosisName
,dm.CreateTs
,dm.UpdateTs
from DataWareHouse.dbo.DiagnosisMaster_Mah dm,DataWareTest.dbo.ClientMaster c
where c._OrigClientId=2
--select top 1 * from DataWareHouse.dbo.DiagnosisMaster
--select top 1 * from DataWareHouse.dbo.DiagnosisMaster_Mah
--select top 1 * from DataWareTest.dbo.ClientMaster c
--select * from DataWareTest.[dbo].[DiagnosisMaster]