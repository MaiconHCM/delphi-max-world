unit uObjeto_Mapa;
interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants
  ,uDM,FMX.Graphics,FMX.Objects,FMX.Types,FMX.Effects;

type TObjeto_Mapa = class
  private
    Fid: Integer;
    Fid_Personagem: Integer;
    Ftipo:Integer;
    FposX:Single;
    FposY:Single;
    Fimagem:TImage;
    Fanimacao:SmallInt;
    Fvida:SmallInt;
    Fsombra:TShadowEffect;
    FMapa: integer;
  published
  property id : Integer read Fid write Fid;
  property PosX : Single read FPosX write FPosX;
  property PosY : Single read FPosY write FPosY;
  property Tipo : integer read Ftipo write Ftipo;
  property Id_personagem : integer read Fid_Personagem write Fid_Personagem;
  property Mapa : integer read FMapa write FMapa;
  property Imagem : TImage read Fimagem write Fimagem;
  property animacao : SmallInt read Fanimacao write Fanimacao;
  property vida : SmallInt read Fvida write Fvida;
  property sombra :  TShadowEffect read Fsombra write Fsombra;
  constructor Create(Owner : TFmxObject; id,i : integer);
  destructor Destroy;
  procedure atualizaConexao();

end;

implementation

uses
  Unit1;

{ TPersonagem }



{ TPersonagem }

constructor TObjeto_Mapa.Create(Owner : TFmxObject; id,i : integer);
begin
 DM.getObjetosMapa(id);
 Fid := DM.cdsObjetos_Mapa.FieldByName('ID_OBJETO').Value;
 Ftipo:= DM.cdsObjetos_Mapa.FieldByName('TIPO').Value;
 Fanimacao:=0;
 if DM.cdsObjetos_Mapa.FieldByName('ID_PERSONAGEM').Value<>Null then begin
   Fid_Personagem := DM.cdsObjetos_Mapa.FieldByName('ID_PERSONAGEM').Value;
 end;
 Fvida:=DM.cdsObjetos_Mapa.FieldByName('VIDA').Value;
 Fmapa:=DM.cdsObjetos_Mapa.FieldByName('ID_MAPA').Value;
 Fimagem := TImage.create(Owner);
 with Fimagem do
  begin
    Parent := TFmxObject(Owner);
    Name := 'construcao_' + IntToStr(i);
    Position.X := DM.cdsObjetos_Mapa.FieldByName('POSX').Value;
    Position.y := DM.cdsObjetos_Mapa.FieldByName('POSY').Value;
    try
    Bitmap:=Form1.carregaBitmap('..\..\imgs\camada3\' + IntToStr(Ftipo)  + '\'+intTostr(Fanimacao)+'\0.png');
    except end;
    Width := Bitmap.Width / 7;
    Height := Bitmap.Height / 7;
    WrapMode := TImageWrapMode.Stretch;
    Cursor:=-3;
  end;
 Fimagem.OnMouseDown := Form1.objetoClick;
 Fsombra := TShadowEffect.Create(Fimagem);
 with Fsombra do
  begin
    Parent := TFmxObject(Fimagem);
    Name := 'sombra_' + IntToStr(id);
    Direction:=300;
    Distance:=20;
  end;

end;

destructor TObjeto_mapa.Destroy;
begin
  inherited Destroy;
end;

procedure TObjeto_mapa.atualizaConexao;
begin
 DM.getObjetosMapa(Fid);
 Fvida := DM.cdsObjetos_Mapa.FieldByName('vida').AsInteger;
 if Fanimacao=-1 then begin
 Fanimacao:=0;
 Fimagem.Bitmap:=Form1.carregaBitmap('..\..\imgs\camada3\' + IntToStr(Ftipo)  + '\'+intTostr(Fanimacao)+'\0.png');
 end else if (Fanimacao<>0) then begin
 Fimagem.Bitmap:=Form1.carregaBitmap('..\..\imgs\camada3\' + IntToStr(Ftipo)  + '\'+intTostr(Fanimacao)+'\0.png');
 Fanimacao:=-1;
 end;

end;

end.

