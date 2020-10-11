unit ulistaOnline;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmplayersOnline = class(TForm)
    vrtscrlbx: TVertScrollBox;
    lblPlayerOnline: TLabel;
  private
  public
    procedure adicionar(sprite:SmallInt;nome:string;i:SmallInt);
  end;

var
  frmplayersOnline: TfrmplayersOnline;

implementation


{$R *.fmx}

uses Unit1;



{ TForm2 }


{ TForm2 }

procedure TfrmplayersOnline.adicionar(sprite: SmallInt; nome: string; i: SmallInt);
var panelaux:TPanel;
    imageAux:TImage;
    labelaux:TLabel;
    btnAux:TButton;
begin
  panelaux := TPanel.create(vrtscrlbx);
  with panelaux do
  begin
    Parent:=TFmxObject(vrtscrlbx);
    Name := 'panel_' + inttostr(i);
    Width:=200;
    Height:=50;
    Position.Y:=i*50;
  end;

  imageAux := TImage.create(Self);
  with imageAux do
  begin
    Parent:=TFmxObject(panelaux);
    Name := 'image_' + inttostr(i);
    Position.X:=0;
    Position.Y:=0;
    Width:=50;
    Height:=50;
    Bitmap:=form1.carregaBitmap('..\..\imgs\sprites\personagens\'+IntToStr(sprite)+'\3\0.png');
  end;

  labelaux := TLabel.create(panelaux);
  with labelaux do
  begin
    Parent:=TFmxObject(panelaux);
    Name := 'label_' + inttostr(i);
    Position.X:=50;
    Position.Y:=20;
    Text:=nome;
  end;

  btnAux := TButton.create(panelaux);
  with btnAux do
  begin
    Parent:=TFmxObject(panelaux);
    Name := 'player_' + inttostr(i);
    Position.X:=panelaux.Width-btnAux.Width;
    Height:=50;
    Text:='Sobre';
  end;
  btnAux.OnClick:=Form1.playerClick;
  end;


end.


