unit uAtualizaMapa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects;

type
  TfrmAtualizaMapa = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtNome: TEdit;
    edtLargura: TEdit;
    edtAltura: TEdit;
    dlgOpen: TOpenDialog;
    btnCarregaImagem: TButton;
    btnCriar: TButton;
    btnApagar: TButton;
    procedure btnCriarClick(Sender: TObject);
    procedure btnCarregaImagemClick(Sender: TObject);
  private
    { Private declarations }
  public
//    procedure criaMapa;
//    procedure editaMapa;
  end;

var
  frmAtualizaMapa: TfrmAtualizaMapa;

implementation

uses
  uDM, Data.DB;

{$R *.fmx}

procedure TfrmAtualizaMapa.btnCarregaImagemClick(Sender: TObject);
begin
dlgOpen.Title:='Abrir Imagem';
dlgOpen.Execute;
end;

procedure TfrmAtualizaMapa.btnCriarClick(Sender: TObject);
var id:integer;stream:TFileStream;
begin
//blob:=DM.cdsMapa.CreateBlobStream(DM.cdsMapa.('imagem'),bmread);
//Imagem.loadfromstream(stream);
if btnCriar.Text='Criar' then begin
DM.cdsMapa.Append;
DM.cdsMapa.FieldByName('NOME').AsString:=edtNome.Text;
DM.cdsMapa.FieldByName('LARGURA').AsInteger:=StrToInt(edtLargura.Text);
DM.cdsMapa.FieldByName('ALTURA').AsInteger:=StrToInt(edtAltura.Text);
stream:=TFileStream.Create(dlgOpen.FileName,fmOpenRead or fmShareDenyWrite);
(DM.cdsMapa.FieldByName('IMAGEM') as TBlobField).LoadFromStream(stream);
DM.cdsMapa.FieldByName('Tipo').AsInteger:=1;
DM.cdsMapa.FieldByName('ID_MAPA').AsInteger:=100;
DM.cdsMapa.Post;
dm.cdsMapa.ApplyUpdates(0);
end else if btnCriar.Text='Atualizar' then begin
DM.getMapa(id);
end;

end;

end.
