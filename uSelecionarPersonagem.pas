unit uSelecionarPersonagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Data.FMTBcd,
  System.Rtti, FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  Data.DB, Data.SqlExpr, FMX.StdCtrls, FMX.Objects, FMX.Colors;

type
  TfrmPersonagem = class(TForm)
    sqlqry: TSQLQuery;
    imgPlayer: TImage;
    btnProx: TButton;
    btnAnt: TButton;
    btnSelecionar: TButton;
    lblNome: TLabel;
    btnCriar: TButton;
    btnApagar: TButton;
    pnl: TPanel;
    img0: TImage;
    imgCapybara: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnProxClick(Sender: TObject);
    procedure btnAntClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
  private
    procedure atualizaPersonagem;
    procedure CarregaInfoPersonagem;
  public
    personagemEscolhido: String;
  end;

var
  frmPersonagem: TfrmPersonagem;

implementation

{$R *.fmx}
uses
  uLogin, uDM, uCriarPersonagem;

procedure TfrmPersonagem.atualizaPersonagem;
begin
  DM.cdsPersonagem.Filter:='ID_USUARIO='+ QuotedStr(frmLogin.cUsuario);
  DM.cdsPersonagem.Open;
  DM.cdsPersonagem.Refresh;
  if DM.cdsPersonagem.Eof then begin
  btnProx.Enabled:=False;
  btnAnt.Enabled:=false;
  btnSelecionar.Enabled:=False;
  btnApagar.Enabled:=False;
  lblNome.Text := 'Não possui Personagem';
  imgPlayer.Bitmap.LoadFromFile('..\..\imgs\sprites\personagens\capybara.png');
  end else begin
  CarregaInfoPersonagem;
  btnProx.Enabled:=True;
  btnAnt.Enabled:=True;
  btnSelecionar.Enabled:=True;
  btnApagar.Enabled:=True;
  end;

end;

procedure TfrmPersonagem.btnAntClick(Sender: TObject);
begin
DM.cdsPersonagem.Prior;
CarregaInfoPersonagem;
end;

procedure TfrmPersonagem.btnApagarClick(Sender: TObject);
begin
DM.cdsChat.Close;
DM.cdsChat.Filter:='ID_PERSONAGEM='+ IntToStr(dm.cdsPersonagem.FieldByName('ID_PERSONAGEM').AsInteger);
DM.cdsChat.Open;
while not DM.cdsChat.Eof do begin
  DM.cdsChat.Delete;
end;
DM.cdsChat.ApplyUpdates(0);
DM.cdsMapa.Close;
DM.cdsMapa.Filter:='ID_PERSONAGEM='+ IntToStr(dm.cdsPersonagem.FieldByName('ID_PERSONAGEM').AsInteger);
DM.cdsMapa.Open;
while not DM.cdsMapa.Eof do begin
  DM.cdsMapa.Delete;
end;
DM.cdsMapa.ApplyUpdates(0);
DM.cdsInventario.Close;
DM.cdsInventario.Filter:='ID_PERSONAGEM='+ IntToStr(dm.cdsPersonagem.FieldByName('ID_PERSONAGEM').AsInteger);
DM.cdsInventario.Open;
while not DM.cdsInventario.Eof do
begin
  DM.cdsInventario_Item.close;
  DM.cdsInventario_Item.Filter:='ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.open;
  while not DM.cdsInventario_Item.Eof do
  begin
  DM.cdsInventario_Item.Delete;
  end;
  DM.cdsInventario.Delete;
  dm.cdsInventario_Item.ApplyUpdates(0);
  DM.cdsInventario.ApplyUpdates(0);
end;
DM.cdsObjetos_Mapa.Filter:='ID_PERSONAGEM='+ IntToStr(dm.cdsPersonagem.FieldByName('ID_PERSONAGEM').AsInteger);
DM.cdsObjetos_Mapa.Open;
while not DM.cdsObjetos_Mapa.Eof do
begin
  DM.cdsObjetos_Mapa.Delete;
  DM.cdsObjetos_Mapa.ApplyUpdates(0);
end;
dm.cdsPersonagem.Delete;
dm.cdsPersonagem.ApplyUpdates(0);
atualizaPersonagem;
end;

procedure TfrmPersonagem.btnCriarClick(Sender: TObject);
begin
if not Assigned(frmCriarPersonagem) then begin
  frmCriarPersonagem := TfrmCriarPersonagem.create(nil);
end;
  frmCriarPersonagem.ShowModal;
  FreeAndNil(frmCriarPersonagem);
  atualizaPersonagem;
end;

procedure TfrmPersonagem.btnProxClick(Sender: TObject);
begin
DM.cdsPersonagem.Next;
CarregaInfoPersonagem;
end;

procedure TfrmPersonagem.btnSelecionarClick(Sender: TObject);
begin
personagemEscolhido:= DM.cdsPersonagem.FieldByName('ID_PERSONAGEM').Value;
Self.Close;
end;

procedure TfrmPersonagem.CarregaInfoPersonagem;
begin
lblNome.Text := DM.cdsPersonagem.FieldByName('NOME').AsString;
  Try  // para o except
    imgPlayer.Bitmap.LoadFromFile('..\..\imgs\sprites\personagens\'+IntToStr(DM.cdsPersonagem.FieldByName('Sprite').Value)+'\3\0.png');
  except
    imgPlayer.Bitmap.LoadFromFile('..\..\imgs\sprites\personagens\capybara.png');
  end;

end;

procedure TfrmPersonagem.FormCreate(Sender: TObject);
begin
  atualizaPersonagem;
end;

end.

