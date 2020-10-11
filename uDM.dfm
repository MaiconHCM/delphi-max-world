object DM: TDM
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 482
  Width = 716
  object cdsPersonagem: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerPersonagem'
    Left = 128
    Top = 192
  end
  object cdsUsuario: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerUsuario'
    Left = 24
    Top = 192
  end
  object sqlqryPersonagem: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM PERSONAGEM')
    SQLConnection = sqlCon
    Left = 128
    Top = 72
  end
  object sqlqryUsuario: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM USUARIO')
    SQLConnection = sqlCon
    Left = 24
    Top = 72
  end
  object sqlCon: TSQLConnection
    DriverName = 'DevartOracle'
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
    Left = 24
    Top = 8
  end
  object providerUsuario: TDataSetProvider
    DataSet = sqlqryUsuario
    Left = 24
    Top = 128
  end
  object providerPersonagem: TDataSetProvider
    DataSet = sqlqryPersonagem
    Left = 128
    Top = 128
  end
  object cdsObjetos_Mapa: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerObjetos_Mapa'
    Left = 456
    Top = 192
  end
  object cdsMapa: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerMapa'
    Left = 272
    Top = 192
  end
  object sqlqryMapa: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM MAPA')
    SQLConnection = sqlCon
    Left = 272
    Top = 72
  end
  object providerMapa: TDataSetProvider
    DataSet = sqlqryMapa
    Left = 272
    Top = 128
  end
  object sqlqryObjetos_Mapa: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM OBJETO_MAPA')
    SQLConnection = sqlCon
    Left = 408
    Top = 80
  end
  object providerObjetos_Mapa: TDataSetProvider
    DataSet = sqlqryObjetos_Mapa
    Left = 448
    Top = 128
  end
  object providerListaObjetos: TDataSetProvider
    DataSet = cdsObjetos_Mapa
    Left = 360
    Top = 128
  end
  object cdsListaObjetos: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerObjetos_Mapa'
    Left = 360
    Top = 192
  end
  object sqlqryv_chat: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM VIEW_CHAT')
    SQLConnection = sqlCon
    Left = 544
    Top = 80
  end
  object providerV_chat: TDataSetProvider
    DataSet = sqlqryv_chat
    Left = 544
    Top = 128
  end
  object cdsV_chat: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerChat'
    Left = 544
    Top = 192
  end
  object sqlqryItem: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM ITEM')
    SQLConnection = sqlCon
    Left = 24
    Top = 320
  end
  object providerItem: TDataSetProvider
    DataSet = sqlqryItem
    Left = 24
    Top = 368
  end
  object cdsItem: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerItem'
    Left = 24
    Top = 424
  end
  object sqlqryInventario: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM INVENTARIO')
    SQLConnection = sqlCon
    Left = 112
    Top = 320
  end
  object providerInventario: TDataSetProvider
    DataSet = sqlqryInventario
    Left = 112
    Top = 368
  end
  object cdsInventario: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerInventario'
    Left = 112
    Top = 424
  end
  object sqlqryInventario_Item: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM INVENTARIO_ITEM')
    SQLConnection = sqlCon
    Left = 224
    Top = 320
  end
  object providerInvetario_Item: TDataSetProvider
    DataSet = sqlqryInventario_Item
    Left = 224
    Top = 368
  end
  object cdsInventario_Item: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerInvetario_Item'
    Left = 224
    Top = 424
  end
  object sqlqryCheat: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = sqlCon
    Left = 128
    Top = 8
  end
  object providerConectados: TDataSetProvider
    DataSet = cdsPersonagem
    Left = 200
    Top = 128
  end
  object cdsConectados: TClientDataSet
    Aggregates = <>
    Filter = 'CONECTADO=1'
    Filtered = True
    Params = <>
    ProviderName = 'providerConectados'
    Left = 200
    Top = 192
  end
  object sqlqryChat: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM CHAT')
    SQLConnection = sqlCon
    Left = 624
    Top = 80
  end
  object providerChat: TDataSetProvider
    DataSet = sqlqryChat
    Left = 624
    Top = 128
  end
  object cdsChat: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'providerChat'
    Left = 624
    Top = 192
  end
end
