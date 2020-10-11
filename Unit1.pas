unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList, FMX.ImgList, FMX.Layouts,
  FMX.ExtCtrls, FMX.Effects, FMX.Filter.Effects, Data.FMTBcd, Data.DB, Data.SqlExpr,
  uPersonagem, System.Generics.Collections, System.Math.Vectors, System.StrUtils,
  FMX.ScrollBox, FMX.Memo, FMX.Colors, FMX.Edit, uObjeto_Mapa, System.Classes;

type
  TForm1 = class(TForm)
    pnlGame: TPanel;
    tmrFrames: TTimer;
    tmrGame: TTimer;
    camada3: TImage;
    camada1: TImage;
    ScrollBox1: TScrollBox;
    camada2: TImage;
    edtChat: TEdit;
    player: TImage;
    tmrColeta: TTimer;
    imgHora: TImage;
    lblHora: TLabel;
    lblDia: TLabel;
    shdwfct: TShadowEffect;
    imgAlerta: TImage;
    lblAlerta: TLabel;
    imgAlertaItem: TImage;
    tmrConexao: TTimer;
    imgFazer: TImage;
    procedure tmrFramesTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrGameTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtChatKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure camada3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure tmrColetaTimer(Sender: TObject);
    procedure tmrConexaoTimer(Sender: TObject);
    procedure imgFazerClick(Sender: TObject);
  private
    cPersonagem: string;
    velocidade: SmallInt;
    lado: SmallInt;
    Andando: SmallInt;
    PosX: Single;
    PosY: Single;
    PersonagemList: TObjectList<TPersonagem>;
    Objetos_MapaList: TObjectList<TObjeto_Mapa>;
    modoConstrucao: SmallInt;
    modoRecolher: integer;
    bloqueioX:Integer;
    bloqueioY:Integer;
    tempoAlerta:SmallInt;
    mostraAlerta:SmallInt;
    shadowDirection:Single;
    shadowDistance:Single;
    procedure mudaLado(ladoaux: SmallInt);
    procedure anda(ladoaux, velocidade: SmallInt; Sender: TObject);
    procedure AtualizaConexao;
    procedure EnviaConexao;
    procedure criaPersonagem(id: Integer);
    procedure atualizaPersonagem(i: Integer);
    procedure carregaObjetosMapa;
    procedure CriaObjetosMapa(id: Integer);
    procedure atualizaObjetosMapa(i: Integer);
    function atualizaRecursosConstrucao(tipo:Integer):boolean;
    procedure atualizaRecursosColeta;
    procedure atualizaObjeto(vida:SmallInt);
    procedure verificaModoRecolher;
    procedure atualizaAlerta;
    procedure atualizaHora;
    procedure atualizaSombra(i:integer);
    public
    atualizacaoTempoReal:Boolean;
    procedure playerClick(Sender: TObject);
    procedure objetoClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure novaConstrucao(construcao:SmallInt);
    function carregaBitmap(caminho:string):TBitmap;
    procedure destroiTimage(nome:string);
    procedure atualizaRecursos(id_item,quantidade:Integer);
    procedure diminuiRecursos(id_item,quantidade:Integer);
    procedure carregaMapa(id: SmallInt);
    procedure mudaMapa(Sender: TObject);
    procedure limparObjectList(id:SmallInt);
    function verificaMain(id:integer):boolean;
    procedure atualizaExperiencia(exp:SmallInt);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  uDM, uLogin, uDescrPersonagem,uConstrucao, uInventario, ulistaOnline, uMapa;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if cPersonagem <> '' then
  begin
    tmrGame.Enabled := false;
    DM.alteraConectado(cPersonagem, False);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
    DM.ConectaBanco;
    if Application.FindComponent('frmLogin') = nil then
      Application.CreateForm(TfrmLogin, frmLogin);
    frmLogin.ShowModal;
  except
    ShowMessage('Não foi possivel conectar ao banco de dados, verifique sua Conexão');
  end;
  cPersonagem := '';
  cPersonagem := frmLogin.cPersonagem;
  atualizacaoTempoReal:=frmLogin.atualizacaoTempoReal;
  FreeAndNil(frmLogin);
  if cPersonagem = '' then
  begin
    Application.Terminate;
  end
  else
  begin
    DM.cdsListaObjetos.Open;
    DM.cdsObjetos_Mapa.Open;
    DM.cdsPersonagem.Open;
    DM.cdsConectados.Open;
    DM.cdsInventario.Open;
    DM.cdsInventario_Item.Open;
    DM.cdsChat.Open;
    criaPersonagem(StrToInt(cPersonagem));
    Caption:='Jogando com '+PersonagemList[0].Name;
    Lado := PersonagemList[0].Lado;
    carregaMapa(PersonagemList[0].Mapa);
    Player.Position.X := PersonagemList[0].Imagem.Position.X;
    Player.Position.Y := PersonagemList[0].Imagem.Position.Y;
    PosX := Player.Position.X;
    PosY := Player.Position.Y;
    velocidade := PersonagemList[0].velocidade;
    DM.alteraConectado(cPersonagem, true);
    Andando := 0;
    modoConstrucao := -1;
    modoRecolher:=-1;
    carregaObjetosMapa;
    tmrGame.Enabled := True;
    tmrFrames.Enabled := True;
    tmrConexao.Enabled:=true;
    end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var i:SmallInt;
begin
  modoconstrucao:=-1;
  modoRecolher:=-1;
  pnlGame.Cursor:=0;
  if KeyChar in ['Z', 'z'] then
  begin
  if not Assigned(frmConstrucao) then
  begin
    frmConstrucao := TfrmConstrucao.create(nil);
  end;
  frmConstrucao.atualizar(PersonagemList[0]);
  frmConstrucao.Show;

  end else if KeyChar in ['E', 'e'] then
  begin
  if not Assigned(frmInventario) then
  begin
    frmInventario := TfrmInventario.create(nil);
  end;
  frmInventario.atualizar(PersonagemList[0]);
  frmInventario.Show;

  end else if Key=9 then begin

  if not Assigned(frmplayersOnline) then
  begin
    frmplayersOnline := TfrmplayersOnline.create(nil);
  end else begin
      frmplayersOnline.Release;
      frmplayersOnline:= nil;
      frmplayersOnline := TfrmplayersOnline.create(nil);
  end;
  try
  for i:=0 to PersonagemList.Count-1 do begin
        frmplayersOnline.adicionar(PersonagemList[i].Sprite,PersonagemList[i].Name,i);
  end;
  except end;
  frmplayersOnline.Show;
  end else if KeyChar in ['M', 'm'] then begin
    if not Assigned(frmMapa) then
    begin
      frmMapa := TfrmMapa.create(nil);
    end else begin
      frmMapa.Release;
      frmMapa:= nil;
      frmMapa:= TfrmMapa.create(nil);
    end;
    frmMapa.atualizar;
    frmMapa.Show;
  end;
end;

procedure TForm1.imgFazerClick(Sender: TObject);
begin
if not Assigned(frmConstrucao) then
  begin
    frmConstrucao := TfrmConstrucao.create(nil);
  end;
  frmConstrucao.atualizar(PersonagemList[0]);
  frmConstrucao.Show;
end;

procedure TForm1.limparObjectList(id:SmallInt);
var i:SmallInt;
begin
  i:=0;
  try
  if Objetos_MapaList<>nil then begin
    while (i<=Objetos_MapaList.Count-1) do begin
    if Objetos_MapaList[i].Mapa<>id then begin
    Objetos_MapaList[i].Imagem.Name:='constr_destroy'+IntToStr(Objetos_MapaList[i].id);
    Objetos_MapaList[i].Imagem.Destroy;
    Objetos_MapaList.delete(i);
    end else begin
    Objetos_MapaList[i].Imagem.Name:='construcao_'+IntToStr(Objetos_MapaList[i].id);
    Inc(i);
    end;
    end;
  end;
  except

  end;
  carregaObjetosMapa;
end;
procedure TForm1.camada3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if modoConstrucao>=0 then
  begin
      if atualizaRecursosConstrucao(modoConstrucao) then begin
      DM.cdsObjetos_Mapa.Append;
      DM.cdsObjetos_Mapa.FieldByName('ID_OBJETO').AsInteger := 1;
      DM.cdsObjetos_Mapa.FieldByName('ID_MAPA').AsInteger := PersonagemList[0].Mapa;
      DM.cdsObjetos_Mapa.FieldByName('ID_Personagem').AsInteger := PersonagemList[0].id;
      DM.cdsObjetos_Mapa.FieldByName('TIPO').AsInteger := modoConstrucao;
      DM.cdsObjetos_Mapa.FieldByName('POSX').AsSingle := X - 25;
      DM.cdsObjetos_Mapa.FieldByName('POSY').AsSingle := Y - 40;
      DM.cdsObjetos_Mapa.Post;
      DM.cdsObjetos_Mapa.ApplyUpdates(0);
      modoConstrucao:=-1;
      pnlGame.Cursor:=0;
      end;
  end
  else
  begin
    PosX := X - 25;
    PosY := Y - 40;
  end;
  modoconstrucao:=-1;
  tmrColeta.Enabled:=False;
  modoRecolher:=-1;
  pnlGame.Cursor:=0;
end;

function TForm1.carregaBitmap(caminho:string):Tbitmap;
var imagemAux:TImage;nome:string;
begin
nome:=StringReplace(caminho,'\','',[rfReplaceAll]);
nome:=StringReplace(nome,'.','',[rfReplaceAll]);
if (not Assigned(TImage(FindComponent(nome))))then begin
 imagemAux:=TImage.Create(Self);
 with imagemAux do
  begin
    Name := nome;
    Bitmap.LoadFromFile(caminho);
  end;
end;
Result:=TImage(FindComponent(nome)).Bitmap;
end;

procedure TForm1.carregaMapa(id: SmallInt);
var stream:TStream;
begin
  DM.getMapa(id);
  DM.listaObjetosMapa(id);
  DM.cdsMapa.Open;
  camada1.Width := Dm.cdsMapa.FieldByName('LARGURA').Value;
  camada1.Height := Dm.cdsMapa.FieldByName('ALTURA').Value;
  if not Dm.cdsMapa.FieldByName('imagem').IsNull then begin
  stream:=DM.cdsMapa.CreateBlobStream(DM.cdsMapa.FieldByName('imagem'),bmread);
  camada1.Bitmap.loadfromstream(stream);
  end else begin
  camada1.Bitmap:=carregaBitmap('..\..\imgs\camada1\'+IntToStr(DM.cdsMapa.FieldByName('TIPO').AsInteger)+'\0.png');
  end;
  player.Position.X:=Dm.cdsMapa.FieldByName('LARGURA').Value/2;
  player.Position.Y:=Dm.cdsMapa.FieldByName('ALTURA').Value/2;
  PosX:=Dm.cdsMapa.FieldByName('LARGURA').Value/2;
  PosY:=Dm.cdsMapa.FieldByName('ALTURA').Value/2;
end;

procedure TForm1.carregaObjetosMapa;
var
  i,existente: SmallInt;
begin
  DM.cdsObjetos_Mapa.Filtered:=False;
  DM.cdsObjetos_Mapa.Filter:='ID_MAPA='+IntToStr(PersonagemList[0].Mapa);
  DM.cdsObjetos_Mapa.Filtered:=True;
  DM.cdsObjetos_Mapa.Refresh;
  DM.cdsListaObjetos.Refresh;
  DM.cdsListaObjetos.First;
  existente:=0;
  while not DM.cdsListaObjetos.Eof do
  begin
    if Assigned(Objetos_MapaList) then
    begin
      if (Objetos_MapaList.Count=0)then begin
         CriaObjetosMapa(DM.cdsListaObjetos.FieldByName('ID_OBJETO').value);
      end;
      for i := 0 to Objetos_MapaList.Count - 1 do
      begin
        if (Objetos_MapaList[i].id = DM.cdsListaObjetos.FieldByName('ID_OBJETO').value) then
        begin
          atualizaObjetosMapa(i);

          Break;
        end
        else if (i = Objetos_MapaList.Count - 1) then
        begin
          CriaObjetosMapa(DM.cdsListaObjetos.FieldByName('ID_OBJETO').value);
        end;
      end;
    end
    else
    begin
      CriaObjetosMapa(DM.cdsListaObjetos.FieldByName('ID_OBJETO').value);
    end;
    Inc(existente);
    DM.cdsListaObjetos.Next;
  end;
  if  Assigned(Objetos_MapaList) then begin
    if (Objetos_MapaList.Count>existente) then begin
    try
      for i := 0 to Objetos_MapaList.Count - 1 do
      begin
        atualizaObjetosMapa(i);
      end;
    except
    end;
    end;

  end;

end;

procedure TForm1.CriaObjetosMapa(id: Integer);
var
  i: SmallInt;
  vazio: Boolean;
begin
  vazio := false;
  if Assigned(Objetos_MapaList) then
  begin
    for i := 0 to Objetos_MapaList.Count - 1 do
    begin
      if Objetos_MapaList[i] = nil then
      begin
        Objetos_MapaList[i] := Tobjeto_mapa.Create(camada3,id,i);
        vazio := True;
        break;
      end;
    end;
  end
  else
  begin
    i := 0;
    Objetos_MapaList := TObjectList<TObjeto_Mapa>.Create;
    Objetos_MapaList.Add(TObjeto_Mapa.Create(camada3,id,i));
    vazio := True;
  end;
  if vazio = False then
  begin
    i := Objetos_MapaList.Count;
    Objetos_MapaList.Add(Tobjeto_mapa.Create(camada3,id,i));
  end;

end;


procedure TForm1.mudaLado(ladoaux: SmallInt);
begin
  tmrFrames.Enabled := True;
  lado := ladoaux;
end;

procedure TForm1.mudaMapa(Sender: TObject);
begin
  DM.cdsPersonagem.Filtered:=False;
  DM.cdsPersonagem.Filter := 'ID_PERSONAGEM=' + IntToStr(PersonagemList[0].Id);
  DM.cdsPersonagem.Filtered:=True;
  DM.cdsPersonagem.Edit;
  DM.cdsPersonagem.FieldByName('ID_MAPA').AsInteger:=StrToInt(SplitString(TButton(Sender).Name, '_')[1]);
  DM.cdsPersonagem.FieldByName('POSX').AsInteger:=100;
  DM.cdsPersonagem.FieldByName('POSY').AsInteger:=100;
  DM.cdsPersonagem.Post;
  if atualizacaoTempoReal then begin
    DM.cdsPersonagem.ApplyUpdates(0);
  end;
end;

procedure TForm1.novaConstrucao(construcao: SmallInt);
begin
modoConstrucao:=construcao;
pnlGame.Cursor:=-12;
end;

procedure TForm1.objetoClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  i: integer;
begin
  i := StrToInt(SplitString(TImage(Sender).Name, '_')[1]);
  if ssRight in Shift  then begin
  modoRecolher:=i;
  end;
end;

procedure TForm1.playerClick(sender: TObject);
var
  i: integer;
begin
  i := StrToInt(SplitString(TImage(Sender).Name, '_')[1]);
  if not Assigned(frmDescrPersonagem) then
  begin
    frmDescrPersonagem := TfrmDescrPersonagem.create(nil);
  end;
  frmDescrPersonagem.atualizaDescr(PersonagemList[i]);
  frmDescrPersonagem.Show;
end;

procedure TForm1.anda(ladoaux, velocidade: SmallInt; Sender: TObject);
var
  i: smallint;
var
  AndarY, AndarX: boolean;
begin
  AndarY := true;
  AndarX := true;
  bloqueioX:=-1;
  bloqueioY:=-1;
  if(Objetos_MapaList<>nil) then begin
  for i := Objetos_MapaList.Count - 1 downto 0 do begin
      if (ladoaux = 1) or (ladoaux = 3) then
      begin
        if (((Objetos_MapaList[i].Imagem.BoundsRect.Top) <= Player.BoundsRect.Bottom + velocidade) and ((Objetos_MapaList[i].Imagem.BoundsRect.Bottom - 35) >= Player.BoundsRect.Bottom + velocidade)) and (((Objetos_MapaList[i].Imagem.BoundsRect.Left - 35) <= Player.BoundsRect.Right) and (Objetos_MapaList[i].Imagem.BoundsRect.Right - 15 >= Player.BoundsRect.Left)) then
        begin
          AndarY := false;
          bloqueioY:=i;
        end;
      end
      else if (ladoaux = 2) or (ladoaux = 4) then
      begin
        if ((Objetos_MapaList[i].Imagem.BoundsRect.Top<= Player.BoundsRect.Bottom) and ((Objetos_MapaList[i].Imagem.BoundsRect.Bottom - 35 >= Player.BoundsRect.Bottom))) and ((Objetos_MapaList[i].Imagem.BoundsRect.Left - 35) <= Player.BoundsRect.Right + velocidade) and ((Objetos_MapaList[i].Imagem.BoundsRect.Right - 15) >=( Player.BoundsRect.Left + velocidade)) then
        begin
          AndarX := false;
          bloqueioX:=i;
        end;
      end;
  end;
  end;
  if (ladoaux = 1) or (ladoaux = 3) then
  begin
    if AndarY then
    begin
      Player.Position.Y := Player.Position.Y + velocidade;
    end
    else
    begin
      PosY := Player.Position.Y;
    end;
  end;
  if (ladoaux = 2) or (ladoaux = 4) then
  begin
    if AndarX then
    begin
      Player.Position.X := Player.Position.X + velocidade;
    end
    else
    begin
      PosX := Player.Position.X;
    end;
  end;

end;

procedure TForm1.tmrColetaTimer(Sender: TObject);
begin
verificaModoRecolher;
end;

procedure TForm1.tmrConexaoTimer(Sender: TObject);
begin
  carregaObjetosMapa;
  EnviaConexao;
  AtualizaConexao;
  end;

procedure TForm1.tmrFramesTimer(Sender: TObject);
var
  I: Integer;
begin
try
  for I := 0 to PersonagemList.Count - 1 do
  begin
    if PersonagemList[i].Andando = True then
    begin
      case Andando of
        0:
         PersonagemList[i].Imagem.Bitmap:=carregaBitmap('..\..\imgs\sprites\personagens\' + IntToStr(personagemList[I].Sprite) + '\' + IntTostr(personagemList[I].lado) + '\0.png');
        1:
          PersonagemList[i].Imagem.Bitmap:=carregaBitmap('..\..\imgs\sprites\personagens\' + IntToStr(personagemList[I].Sprite) + '\' + IntTostr(personagemList[I].lado) + '\1.png');
        2:
          PersonagemList[i].Imagem.Bitmap:=carregaBitmap('..\..\imgs\sprites\personagens\' + IntToStr(personagemList[I].Sprite) + '\' + IntTostr(personagemList[I].lado) + '\2.png');
      end;
    end
    else
    begin
      PersonagemList[i].Imagem.Bitmap:=carregaBitmap('..\..\imgs\sprites\personagens\' + IntToStr(personagemList[I].Sprite) + '\' + IntTostr(personagemList[I].lado) + '\0.png');
    end;
  end;
  Inc(Andando);
  if Andando = 3 then
  begin
    Andando := 0;
  end;
  except end;

  atualizaAlerta;

end;

procedure TForm1.tmrGameTimer(Sender: TObject);
var
  auxX, auxY, auxVelocidade: SmallInt;
var
  DiferencaX, DiferencaY: Single;
begin
  atualizaHora;
  auxVelocidade := velocidade;
  DiferencaY := 0;
  DiferencaX := 0;
  auxX := 0;
  auxY := 0;

  if (PosX <> Player.Position.X) or (PosY <> Player.Position.Y) then
  begin
    if PosX > Player.Position.X then
    begin
      if PosX < Player.Position.X + velocidade then
        auxVelocidade := Trunc(PosX - Player.Position.X);
      auxX := 2;
      DiferencaX := PosX - Player.Position.X;
      anda(auxX, auxVelocidade, Sender);

    end
    else if PosX < Player.Position.X then
    begin
      if PosX > Player.Position.X - velocidade then
        auxVelocidade := Trunc(Player.Position.X - PosX);
      auxX := 4;
      DiferencaX := Player.Position.X - PosX;
      anda(auxX, -auxVelocidade, Sender);
    end;



    if (PosY > Player.Position.Y) then
    begin
      if PosY < Player.Position.Y + velocidade then
        auxVelocidade := Trunc(PosY - Player.Position.Y);
      auxY := 3;
      DiferencaY := PosY - Player.Position.Y;
      anda(auxY, auxVelocidade, Sender);
    end
    else if (PosY < Player.Position.Y) then
    begin
      auxY := 1;
      if PosY > Player.Position.Y - velocidade then
        auxVelocidade := Trunc(Player.Position.Y - PosY);
      DiferencaY := Player.Position.Y - PosY;
      anda(auxY, -auxVelocidade, Sender);
    end;


    if (DiferencaX < DiferencaY) then
    begin
      Mudalado(auxY);
    end
    else if (DiferencaX > DiferencaY) then
    begin
      Mudalado(auxX);
    end;
  end;
  if Player.Position.X < ScrollBox1.ViewportPosition.X + ScrollBox1.Width / 2 - 5 then begin
      ScrollBox1.ScrollBy(auxVelocidade, 0);
  end
  else if Player.Position.X > ScrollBox1.ViewportPosition.X + ScrollBox1.Width / 2 + 5 then begin
      ScrollBox1.ScrollBy(-auxVelocidade, 0);
  end;

  if Player.Position.Y < (ScrollBox1.ViewportPosition.Y + ScrollBox1.Height / 2) - 5 then begin
      ScrollBox1.ScrollBy(0, auxVelocidade);
  end
  else if Player.Position.Y > (ScrollBox1.ViewportPosition.Y + ScrollBox1.Height / 2) + 5 then begin
      ScrollBox1.ScrollBy(0, -auxVelocidade);
  end;

  if modoRecolher>-1 then begin
      tmrColeta.Enabled:=True;
  end else begin
      tmrColeta.Enabled:=False;
  end;
end;

function TForm1.verificaMain(id: integer):Boolean;
begin
  if PersonagemList[0].Id=id then begin
  Result:=True;
  end;
end;

procedure TForm1.verificaModoRecolher;
begin
try
  PosX:=Objetos_MapaList[modoRecolher].Imagem.Position.X;
  PosY:=Objetos_MapaList[modoRecolher].Imagem.Position.Y+Objetos_MapaList[modoRecolher].Imagem.Height/2;
  if (bloqueioX=modoRecolher)or(bloqueioY=modoRecolher) then begin
  atualizaRecursosColeta;
  end;
except
modoRecolher:=-1;
tmrColeta.enabled:=false;
end;

end;

procedure TForm1.criaPersonagem(id: Integer);
var
  i: SmallInt;
  vazio: Boolean;
begin
  vazio := false;
  if Assigned(PersonagemList) then
  begin
    for i := 0 to PersonagemList.Count - 1 do
    begin
      if PersonagemList[i] = nil then
      begin
        PersonagemList[i] := TPersonagem.Create(camada2 ,id,i);
        vazio := True;
        break;
      end;
    end;
  end
  else
  begin
    i := 0;
    PersonagemList := TObjectList<TPersonagem>.Create;
    PersonagemList.Add(TPersonagem.Create(camada2,id,i));
    vazio := True;
  end;
  if vazio = False then
  begin
    i := PersonagemList.Count;
    PersonagemList.Add(TPersonagem.Create(camada2,id,i));
  end;

end;

procedure TForm1.destroiTimage(nome:string);
begin
Timage(FindComponent(nome)).destroy;
end;

procedure TForm1.diminuiRecursos(id_item, quantidade: Integer);
begin
  DM.cdsInventario.Filtered:=False;
  DM.cdsInventario.Filter := 'TIPO=0 AND ID_PERSONAGEM='+IntToStr(PersonagemList[0].Id);
  DM.cdsInventario.Filtered:=True;
  DM.cdsInventario_Item.Filtered:=False;
  DM.cdsInventario_Item.Filter:='ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.Filtered:=True;
  while (not DM.cdsInventario_Item.Eof) and (quantidade>0) do begin
    if(DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger=id_item) then begin
       DM.cdsInventario_Item.Edit;
       if DM.cdsInventario_Item.FieldByName('quantidade').AsInteger>quantidade then begin
        DM.cdsInventario_Item.FieldByName('quantidade').AsInteger:=DM.cdsInventario_Item.FieldByName('quantidade').AsInteger-quantidade;
        quantidade:=0;
       end else begin
        quantidade:=quantidade-DM.cdsInventario_Item.FieldByName('quantidade').AsInteger;
        DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger:=0;
        DM.cdsInventario_Item.FieldByName('quantidade').AsInteger:=0;
       end;
      DM.cdsInventario_Item.Post;
    end;
     DM.cdsInventario_Item.Next;
  end;
  DM.cdsInventario_Item.ApplyUpdates(0);
end;

procedure TForm1.edtChatKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = 13) then
  begin
      if edtChat.Text[1]=':' then begin

      end else begin
      DM.cdsV_chat.Append;
      DM.cdsV_chat.FieldByName('ID_CHAT').AsInteger:=1;
      DM.cdsV_chat.FieldByName('ID_PERSONAGEM').AsInteger := PersonagemList[0].Id;
      DM.cdsV_chat.FieldByName('TEXTO').AsString := edtChat.Text;
      DM.cdsV_chat.Post;
      DM.cdsV_chat.ApplyUpdates(0);
      edtChat.Text := '';
      end;
  end;
end;

procedure TForm1.EnviaConexao;
begin
  DM.cdsPersonagem.Filter := 'ID_PERSONAGEM=' + QuotedStr(cPersonagem);

  if (DM.cdsPersonagem.FieldByName('POSX').Value <> posX) or (DM.cdsPersonagem.FieldByName('LADO').Value <> Lado) or (DM.cdsPersonagem.FieldByName('POSY').Value <> PosY) then
  begin
    DM.cdsPersonagem.Edit;
    DM.cdsPersonagem.FieldByName('POSX').AsSingle := Player.Position.X;
    DM.cdsPersonagem.FieldByName('POSY').AsSingle := Player.Position.Y;
    DM.cdsPersonagem.FieldByName('LADO').AsInteger := Lado;
    DM.cdsPersonagem.Post;
    if atualizacaoTempoReal then begin
    DM.cdsPersonagem.ApplyUpdates(0);
    end;
  end;

end;

procedure TForm1.atualizaAlerta;
begin
  if (mostraAlerta=1)and(tempoAlerta<=10) then begin
  Inc(tempoAlerta);
  imgAlerta.Position.y:=imgAlerta.Position.y/tempoAlerta;
  imgAlerta.Opacity:=0.1*tempoAlerta;
  end else if(mostraAlerta=1)and (tempoAlerta>10) then begin
  mostraAlerta:=2;
  tempoAlerta:=0;
  end else if(mostraAlerta=2)and (tempoAlerta<50) then begin
  Inc(tempoAlerta);
  end else if(mostraAlerta=2)and (tempoAlerta>=50) then begin
  mostraAlerta:=3;
  tempoAlerta:=0;
  end else if(mostraAlerta=3)and (tempoAlerta<=10) then begin
  Inc(tempoAlerta);
  imgAlerta.Opacity:=1-(tempoAlerta/10);
    imgAlerta.Position.y:=(imgAlerta.Position.y*tempoAlerta);
  end else if(mostraAlerta=3)and (tempoAlerta>10) then begin
  mostraAlerta:=0;
  tempoAlerta:=0;
  end;
end;

procedure TForm1.AtualizaConexao;
var
  i: integer;existente:Integer;
begin
  existente:=0;
  Dm.cdsPersonagem.Filtered:=false;
  DM.cdsConectados.Filter:='CONECTADO=1 AND ID_MAPA='+IntToStr(PersonagemList[0].Mapa);
  DM.cdsPersonagem.Refresh;
  DM.cdsConectados.Refresh;
  DM.cdsConectados.First;
  while not DM.cdsConectados.Eof do
  begin
    for i := 0 to PersonagemList.Count - 1 do
    begin
      if (PersonagemList[i].id = DM.cdsConectados.FieldByName('ID_PERSONAGEM').value) then
      begin
        atualizaPersonagem(i);
        Break;
      end
      else if (i = PersonagemList.Count - 1) then
      begin
        criaPersonagem(DM.cdsConectados.FieldByName('ID_PERSONAGEM').value);
      end;
    end;
    Inc(existente);
    DM.cdsConectados.Next;
  end;
  if (PersonagemList.Count>existente) then begin
  try
    for i := 0 to PersonagemList.Count - 1 do
    begin
      atualizaPersonagem(i);
    end;
  except end;
  end;
end;

procedure TForm1.atualizaExperiencia(exp: SmallInt);
var nivel:SmallInt;
begin
  nivel:=0;
  DM.cdsPersonagem.Filtered:=FALSE;
  DM.cdsPersonagem.Filter := 'ID_PERSONAGEM=' + cPersonagem;
  DM.cdsPersonagem.Filtered:=True;
  while (PersonagemList[0].experiencia+exp)>=(PersonagemList[0].experienciaMaxima) do begin
  exp:=(PersonagemList[0].experiencia+exp)-PersonagemList[0].experienciaMaxima;
  PersonagemList[0].experiencia:=0;
  PersonagemList[0].experienciaMaxima:=PersonagemList[0].experienciaMaxima+PersonagemList[0].experienciaMaxima;
  Inc(nivel);
  PersonagemList[0].ataque:=PersonagemList[0].ataque+(Random(3)+1);
  PersonagemList[0].vidaMaxima:=PersonagemList[0].vidaMaxima+(Random(10)+5);
  end;
  DM.cdsPersonagem.Edit;
  DM.cdsPersonagem.FieldByName('NIVEL').AsInteger := PersonagemList[0].nivel+nivel;
  DM.cdsPersonagem.FieldByName('EXPERIENCIA').AsInteger :=PersonagemList[0].experiencia+exp;
  DM.cdsPersonagem.FieldByName('EXPERIENCIAMAX').AsInteger := PersonagemList[0].experienciaMaxima;
  DM.cdsPersonagem.FieldByName('VIDAMAX').AsInteger :=PersonagemList[0].vidaMaxima;
  DM.cdsPersonagem.FieldByName('ATAQUE').AsInteger :=PersonagemList[0].ataque;
  DM.cdsPersonagem.Post;
  if atualizacaoTempoReal then begin
    DM.cdsPersonagem.ApplyUpdates(0);
  end;
end;

procedure TForm1.atualizaHora;
begin
  lblHora.Text:=FormatDateTime('hh:nn',now);
  lblDia.Text:=FormatDateTime('dd/mm',Now);
  if '18:00:00'< TimeToStr(Now) then begin
    shadowDirection:=360;
    shadowDistance:=20;
  end else if '12:00:00'< TimeToStr(Now) then begin
    shadowDirection:=300;
    shadowDistance:=15;
  end else begin
    shadowDirection:=200;
    shadowDistance:=20;
  end;
end;

procedure TForm1.atualizaObjeto(vida:SmallInt);
begin
  DM.cdsObjetos_Mapa.Filter := 'ID_OBJETO=' + IntToStr(Objetos_MapaList[modoRecolher].id);
  DM.cdsObjetos_Mapa.Edit;
  DM.cdsObjetos_Mapa.FieldByName('VIDA').AsInteger := Objetos_MapaList[modoRecolher].vida+vida;
  DM.cdsObjetos_Mapa.Post;
  DM.cdsObjetos_Mapa.ApplyUpdates(0);
end;

procedure TForm1.atualizaObjetosMapa(i: Integer);
begin
Objetos_MapaList[i].atualizaConexao;
  if (Objetos_MapaList[i].vida<=0) then begin
    if i=modoRecolher then begin
    tmrColeta.Enabled:=false;
    modoRecolher:=-1;
    end;
  DM.removeRegistroObjeto(Objetos_MapaList[i].id);
  Objetos_MapaList[i].Imagem.Name:='constr_destroy'+IntToStr(Objetos_MapaList[i].id);
  Objetos_MapaList[i].Imagem.Destroy;
  Objetos_MapaList.delete(i);
  end else begin
    Objetos_MapaList[i].Imagem.Name:='construcao_' + IntToStr(i);
  end;

end;

procedure TForm1.atualizaPersonagem(i: Integer);
begin
  PersonagemList[i].atualizaConexao;
  atualizaSombra(i);
  if (PersonagemList[i].Conectado=0) or (PersonagemList[i].Mapa<>PersonagemList[0].Mapa) then begin
    PersonagemList[i].Imagem.Destroy;
    PersonagemList.delete(i);
  end else begin
    PersonagemList[i].Imagem.Name:='player_' + inttostr(i);
  end;

end;

procedure TForm1.atualizaRecursos(id_item,quantidade:Integer);
begin
  mostraAlerta:=1;
  lblAlerta.Text:='Coletou '+IntToStr(quantidade);
  imgAlertaItem.Bitmap:=carregaBitmap('..\..\imgs\item\'+IntToStr(id_item)+'\0.png');
  DM.cdsInventario.Filtered:=False;
  DM.cdsInventario.Filter := 'TIPO=0 AND ID_PERSONAGEM='+IntToStr(PersonagemList[0].Id);
  DM.cdsInventario.Filtered:=True;
  DM.cdsInventario_Item.Filtered:=False;
  DM.cdsInventario_Item.Filter:='ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.Filtered:=True;
  while not DM.cdsInventario_Item.Eof do begin
    if (DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger=0) or
       (DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger=id_item) then begin
       DM.cdsInventario_Item.Edit;
       DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger:=id_item;
       DM.cdsInventario_Item.FieldByName('quantidade').AsInteger:=DM.cdsInventario_Item.FieldByName('quantidade').AsInteger+quantidade;
       DM.cdsInventario_Item.Post;
      Break;
    end;
     DM.cdsInventario_Item.Next;
  end;
  if atualizacaoTempoReal then begin
  DM.cdsInventario_Item.ApplyUpdates(0);
  end;
  atualizaExperiencia(quantidade);
end;

procedure TForm1.atualizaRecursosColeta;
var ataque:SmallInt;
begin
ataque:=Trunc(((Random(100)/100)+1)*PersonagemList[0].ataque);
if Objetos_MapaList[modoRecolher].Tipo=0 then begin
  atualizaRecursos(1,ataque);
  Objetos_MapaList[modoRecolher].animacao:=1;
  atualizaObjeto(-ataque);
end else if Objetos_MapaList[modoRecolher].Tipo=1 then begin
  atualizaRecursos(2,ataque);
  Objetos_MapaList[modoRecolher].animacao:=1;
  atualizaObjeto(-ataque);
end else if Objetos_MapaList[modoRecolher].Tipo=10 then begin

end else if Objetos_MapaList[modoRecolher].Tipo=10 then begin

end else if Objetos_MapaList[modoRecolher].Tipo=10 then begin

end else if Objetos_MapaList[modoRecolher].Tipo=10 then begin

end;
end;

function TForm1.atualizaRecursosConstrucao(tipo: Integer):boolean;
begin
  mostraAlerta:=1;
  lblAlerta.Text:='Construiu';
  imgAlertaItem.Bitmap:=carregaBitmap('..\..\imgs\camada3\' + IntToStr(tipo)  + '\0\0.png');
try

  if tipo=10 then begin
    diminuiRecursos(11,40);
  end else if tipo=30 then begin
    diminuiRecursos(11,40);
    diminuiRecursos(12,10)
  end else if tipo =31 then begin
    diminuiRecursos(11,60);
    diminuiRecursos(12,60);
  end;
  Result:=True;
except
  Result:=false;
end;
end;

procedure TForm1.atualizaSombra(i: Integer);
var h:integer; atras:Boolean;
begin
atras:=false;
  if(Objetos_MapaList<>nil) then begin
    for h := 0 to Objetos_MapaList.Count - 1 do begin
      //Objetos_MapaList[h].sombra.Distance:=shadowDistance;
      //Objetos_MapaList[h].sombra.Direction:=shadowDirection;
        if ((Objetos_MapaList[h].Imagem.BoundsRect.Top<=PersonagemList[i].Imagem.BoundsRect.Bottom)and
           (Objetos_MapaList[h].Imagem.BoundsRect.Bottom-40>=PersonagemList[i].Imagem.BoundsRect.top))and
           ((Objetos_MapaList[h].Imagem.BoundsRect.Right>=PersonagemList[i].Imagem.BoundsRect.Left)and
           (Objetos_MapaList[h].Imagem.BoundsRect.Left<=PersonagemList[i].Imagem.BoundsRect.Right))then
        begin
          atras:=True;
        end;
    end;
  end;
  if atras then begin
  PersonagemList[i].Imagem.SendToBack;
  end else begin
  PersonagemList[i].Imagem.BringToFront;
  end;

end;

end.

