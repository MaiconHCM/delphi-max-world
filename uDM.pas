unit uDM;

interface

uses
  System.SysUtils, System.Classes, DBXDevartOracle, Data.DB, Data.SqlExpr,
  Data.FMTBcd, Datasnap.DBClient, Datasnap.Provider, Data.DbxDatasnap,
  Data.DBXCommon, IPPeerClient, Datasnap.DSConnect, Data.DBXOracle;

type
  TDM = class(TDataModule)
    cdsPersonagem: TClientDataSet;
    cdsUsuario: TClientDataSet;
    sqlqryPersonagem: TSQLQuery;
    sqlqryUsuario: TSQLQuery;
    sqlCon: TSQLConnection;
    providerUsuario: TDataSetProvider;
    providerPersonagem: TDataSetProvider;
    cdsObjetos_Mapa: TClientDataSet;
    cdsMapa: TClientDataSet;
    sqlqryMapa: TSQLQuery;
    providerMapa: TDataSetProvider;
    sqlqryObjetos_Mapa: TSQLQuery;
    providerObjetos_Mapa: TDataSetProvider;
    providerListaObjetos: TDataSetProvider;
    cdsListaObjetos: TClientDataSet;
    sqlqryv_chat: TSQLQuery;
    providerV_chat: TDataSetProvider;
    cdsV_chat: TClientDataSet;
    sqlqryItem: TSQLQuery;
    providerItem: TDataSetProvider;
    cdsItem: TClientDataSet;
    sqlqryInventario: TSQLQuery;
    providerInventario: TDataSetProvider;
    cdsInventario: TClientDataSet;
    sqlqryInventario_Item: TSQLQuery;
    providerInvetario_Item: TDataSetProvider;
    cdsInventario_Item: TClientDataSet;
    sqlqryCheat: TSQLQuery;
    providerConectados: TDataSetProvider;
    cdsConectados: TClientDataSet;
    sqlqryChat: TSQLQuery;
    providerChat: TDataSetProvider;
    cdsChat: TClientDataSet;
    procedure sqlConAfterConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure getPersonagem(id:integer);
    procedure alteraConectado(cPersonagem:string;conectado:Boolean);
    procedure ConectaBanco;
    procedure sqlCon2BeforeConnect(Sender: TObject);
    procedure getMapa(id:SmallInt);
    procedure getObjetosMapa(id:SmallInt);
    procedure listaObjetosMapa(id:SmallInt);
    procedure removeRegistroObjeto(id:SmallInt);
    procedure getChat(id:SmallInt);
    procedure criaInvetario(tipo,quantidade:SmallInt);
  private
  public
   procedure getVchat(id:SmallInt);
  end;

var
  DM: TDM;

implementation

uses
  Unit1;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.alteraConectado(cPersonagem: String; conectado: Boolean);
begin
  cdsPersonagem.Filter:='ID_PERSONAGEM='+QuotedStr(cPersonagem);
  cdsPersonagem.Edit;
  if conectado then begin
    cdsPersonagem.FieldByName('CONECTADO').AsInteger:= 1;
  end else begin
    cdsPersonagem.FieldByName('CONECTADO').AsInteger := 0;
  end;
  cdsPersonagem.Post;
  cdsPersonagem.ApplyUpdates(0);
end;


procedure TDM.ConectaBanco;
begin
  DM.sqlCon.Close;
  DM.sqlCon.Params.Clear;
  DM.sqlCon.Params.LoadFromFile('..\..\ConfigBDoracle.ini');
  DM.sqlCon.Open;
end;

procedure TDM.criaInvetario(tipo,quantidade: SmallInt);
var i:SmallInt;
begin
    DM.cdsInventario.Open;
    DM.cdsInventario.Append;
    DM.cdsInventario.FieldByName('ID_PERSONAGEM').AsInteger:=DM.cdsPersonagem.FieldByName('ID_PERSONAGEM').AsInteger;
    DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger:=1;
    DM.cdsInventario.FieldByName('TIPO').AsInteger:=tipo;
    DM.cdsInventario.FieldByName('TAMANHO').AsInteger:=quantidade;
    DM.cdsInventario.Post;
    DM.cdsInventario.ApplyUpdates(0);
    DM.cdsInventario.Close;
    DM.cdsInventario.Filter:='ID_PERSONAGEM='+ IntToStr(DM.cdsPersonagem.FieldByName('ID_PERSONAGEM').AsInteger);
    DM.cdsInventario.IndexFieldNames:='ID_INVENTARIO';
    DM.cdsInventario.Open;
    DM.cdsInventario.Last;
    DM.cdsInventario_Item.Open;
    for i:=1 to quantidade do begin
    DM.cdsInventario_Item.Append;
    DM.cdsInventario_Item.FieldByName('ID_INVENTARIO').AsInteger:=DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger;
    DM.cdsInventario_Item.FieldByName('ID_INVENTARIO_ITEM').AsInteger:=i;
    DM.cdsInventario_Item.Post;
    end;
    DM.cdsInventario_Item.ApplyUpdates(0);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  if sqlCon.Connected then
    sqlCon.Close;
end;

procedure TDM.getMapa(id:SmallInt);
begin
  cdsMapa.Filtered:=false;
  cdsMapa.Filter:='ID_MAPA='+ IntToStr(id);
  cdsMapa.Filtered:=True;
end;

procedure TDM.getObjetosMapa(id: SmallInt);
begin
  cdsObjetos_Mapa.Filtered:=False;
  cdsObjetos_Mapa.Filter:='ID_OBJETO='+ IntToStr(id);
  cdsObjetos_Mapa.Filtered:=True;
end;

procedure TDM.getPersonagem(id: integer);
begin
  cdsPersonagem.Filtered:=False;
  cdsPersonagem.Filter:='ID_PERSONAGEM='+IntToStr(id);
  cdsPersonagem.Filtered:=True;
end;

procedure TDM.getVchat(id: SmallInt);
begin
DM.cdsV_chat.Close;
DM.cdsV_chat.Filter:='ID_PERSONAGEM='+ IntToStr(id);
DM.cdsV_chat.Open;
end;

procedure TDM.listaObjetosMapa(id: SmallInt);
begin
  cdsListaObjetos.Filtered:=False;
  cdsListaObjetos.Filter:='ID_MAPA='+ IntToStr(id);
  cdsListaObjetos.Filtered:=true;
end;

procedure TDM.removeRegistroObjeto(id: SmallInt);
begin
try
DM.cdsObjetos_Mapa.Filtered:=FALSE;
DM.cdsObjetos_Mapa.Filter:='ID_OBJETO='+ IntToStr(id);
DM.cdsObjetos_Mapa.Filtered:=TRUE;
dm.cdsObjetos_Mapa.Delete;
dm.cdsObjetos_Mapa.ApplyUpdates(0);
except end;
end;

procedure TDM.sqlConAfterConnect(Sender: TObject);
begin
  //IMPORTANTE - Configura os parâmetros do Oracle para a sessão
  //Linguagem
  sqlCon.Execute('ALTER SESSION SET NLS_LANGUAGE = "BRAZILIAN PORTUGUESE"',
     NIL, NIL);
  //País
  sqlCon.Execute('ALTER SESSION SET NLS_TERRITORY = BRAZIL', NIL, NIL);
  //Formato de data
  sqlCon.Execute('ALTER SESSION SET NLS_DATE_FORMAT = ''MM/DD/YYYY''',
    NIL, NIL);
  //Tratamento de campos numéricos, se não colocar da problema com campos inteiros
  sqlCon.Execute('ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''',
    NIL, NIL);
end;

procedure TDM.getChat(id: SmallInt);
begin
DM.cdsChat.Close;
DM.cdsChat.Filter:='ID_PERSONAGEM='+ IntToStr(id);
DM.cdsChat.Open;
end;

procedure TDM.sqlCon2BeforeConnect(Sender: TObject);
begin
  //
  if (Self.sqlCon.Connected) then
    //
end;

end.
