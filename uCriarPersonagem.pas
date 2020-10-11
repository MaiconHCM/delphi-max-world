unit uCriarPersonagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TfrmCriarPersonagem = class(TForm)
    edtNome: TEdit;
    Label1: TLabel;
    btnCria: TButton;
    img1: TImage;
    btnAnt: TButton;
    btnProximo: TButton;
    lblCor: TLabel;
    procedure btnCriaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnAntClick(Sender: TObject);
  private
    countSprite:SmallInt;
    procedure atualiza;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCriarPersonagem: TfrmCriarPersonagem;

implementation

uses
  uLogin, uDM;

{$R *.fmx}

procedure TfrmCriarPersonagem.atualiza;
begin
try
  img1.Bitmap.LoadFromFile('..\..\imgs\sprites\personagens\' + IntToStr(countSprite) + '\3\2.png');
except
  if countSprite>0 then begin
    countSprite:=0
  end else begin
     countSprite:=8;
  end;
  atualiza;
end;
end;

procedure TfrmCriarPersonagem.btnAntClick(Sender: TObject);
begin
  Dec(countSprite);
  atualiza;
end;

procedure TfrmCriarPersonagem.btnCriaClick(Sender: TObject);
begin
 if (edtNome.Text='') then begin
    ShowMessage('Preencha Todos os campos');

 end else begin
 try
    DM.cdsPersonagem.Open;
    Dm.cdsPersonagem.Append;
    DM.cdsPersonagem.FieldByName('ID_PERSONAGEM').AsInteger:=0;
    DM.cdsPersonagem.FieldByName('ID_USUARIO').Asinteger:=StrToInt(frmLogin.cUsuario);
    DM.cdsPersonagem.FieldByName('NOME').AsString:=edtNome.Text;
    DM.cdsPersonagem.FieldByName('Sprite').AsInteger:=countSprite;
    DM.cdsPersonagem.Post;
    DM.cdsPersonagem.ApplyUpdates(0);
    DM.cdsPersonagem.IndexFieldNames := 'ID_PERSONAGEM';
    DM.cdsPersonagem.Refresh;
    DM.cdsPersonagem.Last;
    DM.criaInvetario(0,16);
    DM.criaInvetario(1,4);
 except
    ShowMessage('Não foi possivel criar personagem');
 end;
    ShowMessage('Personagem foi criado com sucesso!');
    Self.Close;
 end;

end;

procedure TfrmCriarPersonagem.btnProximoClick(Sender: TObject);
begin
  Inc(countSprite);
  atualiza;
end;

procedure TfrmCriarPersonagem.FormCreate(Sender: TObject);
begin
  countSprite:=0;
  atualiza;
end;

end.
