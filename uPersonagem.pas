unit uPersonagem;
interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,uDM,FMX.Graphics,FMX.Objects,FMX.Types;

type TPersonagem = class
  private
    Fid: Integer;
    FName: string;
    Fandando:Boolean;
    Flado:SmallInt;
    Fsprite:SmallInt;
    Fvelocidade:SmallInt;
    Fconectado:Integer;
    Fmapa:SmallInt;
    Fimagem:Timage;
    Fchat:TText;
    FVidaMax:SmallInt;
    Fvida:SmallInt;
    FExperienciaMax:SmallInt;
    FExperiencia:SmallInt;
    FAtaque:SmallInt;
    FNivel: SmallInt;
  published
  property Id : Integer read Fid write Fid;
  property Name : String read FName write FName;
  property Andando : Boolean read FAndando write Fandando;
  property Lado : SmallInt read FLado write Flado;
  property Sprite : SmallInt read Fsprite write Fsprite;
  property Velocidade : SmallInt read Fvelocidade write Fvelocidade;
  property Conectado : integer read Fconectado write Fconectado;
  property Mapa : SmallInt read Fmapa write Fmapa;
  property Imagem : TImage read Fimagem write Fimagem;
  property vida : SmallInt read Fvida write Fvida;
  property vidaMaxima : SmallInt read FVidaMax write FVidaMax;
  property ataque : SmallInt read FAtaque write FAtaque;
  property experiencia : SmallInt read FExperiencia write FExperiencia;
  property experienciaMaxima : SmallInt read FExperienciaMax write FExperienciaMax;
  property nivel : SmallInt read FNivel write FNivel;
  property Chat : TText read Fchat write Fchat;
  constructor Create(Owner : TFmxObject; id,i : integer);
  destructor Destroy;
  procedure atualizaConexao;

end;


implementation

uses
  Unit1;


{ TPersonagem }



{ TPersonagem }

constructor TPersonagem.Create(Owner : TFmxObject; id,i : integer);
begin
 DM.getPersonagem(id);
 Fid := DM.cdsPersonagem.FieldByName('ID_PERSONAGEM').Value;
 Fname:= DM.cdsPersonagem.FieldByName('NOME').AsString;
 Fandando:=False;
 Flado := DM.cdsPersonagem.FieldByName('LADO').Value;
 Fsprite:=DM.cdsPersonagem.FieldByName('SPRITE').Value;
 Fvelocidade:=DM.cdsPersonagem.FieldByName('VELOCIDADE').Value;
 Fconectado:=DM.cdsPersonagem.FieldByName('CONECTADO').AsInteger;
 Fmapa:=DM.cdsPersonagem.FieldByName('ID_MAPA').AsInteger;
 FExperienciaMax:=DM.cdsPersonagem.FieldByName('EXPERIENCIAMAX').AsInteger;
 FExperiencia:=DM.cdsPersonagem.FieldByName('EXPERIENCIA').AsInteger;
 FAtaque:=DM.cdsPersonagem.FieldByName('ATAQUE').AsInteger;
 FVidaMax:=DM.cdsPersonagem.FieldByName('VIDAMAX').AsInteger;
 Fvida:=DM.cdsPersonagem.FieldByName('VIDA').AsInteger;
 Fnivel:=DM.cdsPersonagem.FieldByName('NIVEL').AsInteger;
 Fimagem := TImage.create(Owner);
 try
  with Fimagem do
  begin
    Parent:=TFmxObject(Owner);
    Name := 'player_' + inttostr(i);
    Position.X := DM.cdsPersonagem.FieldByName('POSX').AsSingle;
    Position.y := DM.cdsPersonagem.FieldByName('POSY').AsSingle;
    Cursor:=-21;
  end;
  FImagem.OnClick := Form1.playerClick;
 except
  Form1.destroiTimage('player_' + inttostr(i));
 end;
  Fchat := TText.Create(Fimagem);
  with Fchat do
  begin
    Parent := Fimagem;
    Name := 'chat_' + IntToStr(Fid);
    Position.X := -40;
    Position.y := -40;
    width := Fimagem.Width + 80;
  end;
end;

destructor TPersonagem.Destroy;
begin
  inherited Destroy;
end;

procedure TPersonagem.atualizaConexao;
begin
  DM.getPersonagem(Fid);
   Fname:= DM.cdsPersonagem.FieldByName('NOME').AsString;
   Flado := DM.cdsPersonagem.FieldByName('LADO').Value;
   Fsprite:=DM.cdsPersonagem.FieldByName('SPRITE').Value;
   Fvelocidade:=DM.cdsPersonagem.FieldByName('VELOCIDADE').Value;
   Fconectado:=DM.cdsPersonagem.FieldByName('CONECTADO').AsInteger;
   FExperienciaMax:=DM.cdsPersonagem.FieldByName('EXPERIENCIAMAX').AsInteger;
   FExperiencia:=DM.cdsPersonagem.FieldByName('EXPERIENCIA').AsInteger;
   FAtaque:=DM.cdsPersonagem.FieldByName('ATAQUE').AsInteger;
   FVidaMax:=DM.cdsPersonagem.FieldByName('VIDAMAX').AsInteger;
   Fvida:=DM.cdsPersonagem.FieldByName('VIDA').AsInteger;
   Fnivel:=DM.cdsPersonagem.FieldByName('NIVEL').AsInteger;
   if (Fimagem.Position.X <> DM.cdsPersonagem.FieldByName('POSX').Value) or (Fimagem.Position.Y <> DM.cdsPersonagem.FieldByName('POSY').Value) then
   begin
      Fimagem.Position.X := DM.cdsPersonagem.FieldByName('POSX').Value;
      Fimagem.Position.Y := DM.cdsPersonagem.FieldByName('POSY').Value;
      Fandando := True;
   end else begin
      Fandando := False;
   end;
   if (Fmapa<>DM.cdsPersonagem.FieldByName('ID_MAPA').AsInteger) and (form1.verificaMain(Fid)=true) then begin
   Form1.carregaMapa(DM.cdsPersonagem.FieldByName('ID_MAPA').AsInteger);
   Form1.limparObjectList(DM.cdsPersonagem.FieldByName('ID_MAPA').AsInteger);
   end;
   Fmapa:=DM.cdsPersonagem.FieldByName('ID_MAPA').AsInteger;
   DM.getVchat(Fid);
   if DM.cdsV_chat.IsEmpty=false then begin
   Fchat.Text:=DM.cdsV_chat.FieldByName('TEXTO').AsString;
   end else begin
   Fchat.Text:='';
   end;
end;

end.
