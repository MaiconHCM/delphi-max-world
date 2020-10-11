object DM: TDM
  OldCreateOrder = False
  Height = 318
  Width = 430
  object sqlCon: TSQLConnection
    DriverName = 'Oracle'
    LoginPrompt = False
    Params.Strings = (
      'Database=127.0.0.1:1521:XE'
      'User_Name=Banco_Jogo'
      'Password=Banco_Jogo'
      'DriverName=DevartOracleDirect'
      'DriverUnit=DBXDevartOracle'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver210.' +
        'bpl'
      
        'MetaDataPackageLoader=TDBXDevartOracleMetaDataCommandFactory,Dbx' +
        'DevartOracleDriver210.bpl'
      'ProductName=DevartOracle'
      'GetDriverFunc=getSQLDriverORADirect'
      'LibraryName=dbexpoda40.dll'
      'VendorLib=dbexpoda40.dll'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'Oracle TransIsolation=ReadCommitted'
      'RoleName=Normal'
      'LongStrings=True'
      'EnableBCD=false'
      'UseQuoteChar=False'
      'CharLength=0'
      'UseUnicode=False'
      'UnicodeEnvironment=False'
      'IPVersion=IPv4'
      'BlobSize=-1'
      'ErrorResourceFile='
      'HostName=')
    AfterConnect = sqlConAfterConnect
    Connected = True
    Left = 32
    Top = 24
  end
  object sqldtst: TSQLDataSet
    GetMetadata = False
    CommandText = 'SELECT * FROM USUARIO'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = sqlCon
    Left = 96
    Top = 24
  end
  object ds: TDataSource
    DataSet = sqldtst
    Left = 320
    Top = 24
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 248
    Top = 24
  end
  object dtstprvdr: TDataSetProvider
    DataSet = sqldtst
    Left = 176
    Top = 24
  end
end
