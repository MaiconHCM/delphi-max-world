unit uMapa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TfrmMapa = class(TForm)
    vrtscrlbx: TVertScrollBox;
    lblPlayerOnline: TLabel;
    btnCriar: TButton;
    procedure btnCriarClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure atualizar;
  end;

var
  frmMapa: TfrmMapa;

implementation

uses
  uDM, Unit1, uAtualizaMapa;

{$R *.fmx}

{ TForm2 }

procedure TfrmMapa.atualizar;
var panelaux:TPanel;
    labelaux:TLabel;
    btnAux:TButton;
    i:SmallInt;
begin
dm.cdsMapa.Filtered:=False;
DM.cdsMapa.Refresh;
i:=0;
while not DM.cdsMapa.Eof do
  begin
  panelaux := TPanel.create(vrtscrlbx);
  with panelaux do
  begin
    Parent:=TFmxObject(vrtscrlbx);
    Name := 'panel_' + IntToStr(DM.cdsMapa.FieldByName('ID_MAPA').AsInteger);
    Width:=300;
    Height:=50;
    Position.Y:=i*50;
  end;

  labelaux := TLabel.create(panelaux);
  with labelaux do
  begin
    Parent:=TFmxObject(panelaux);
    Name := 'label_' + IntToStr(DM.cdsMapa.FieldByName('ID_MAPA').AsInteger);
    Position.X:=20;
    Position.Y:=20;
    Text:=DM.cdsMapa.FieldByName('NOME').AsString;
  end;

  btnAux := TButton.create(panelaux);
  with btnAux do
  begin
    Parent:=TFmxObject(panelaux);
    Name := 'player_' + IntToStr(DM.cdsMapa.FieldByName('ID_MAPA').AsInteger);
    Position.X:=panelaux.Width-btnAux.Width;
    Height:=50;
    Text:='Teleportar';
  end;
  btnAux.OnClick:=Form1.mudaMapa;
  DM.cdsMapa.Next;
  Inc(i);
  end;


end;

procedure TfrmMapa.btnCriarClick(Sender: TObject);
begin
if not Assigned(frmAtualizaMapa) then
  begin
    frmAtualizaMapa := TfrmAtualizaMapa.create(nil);
  end;
  frmAtualizaMapa.ShowModal;
  FreeAndNil(frmAtualizaMapa);
end;

end.
