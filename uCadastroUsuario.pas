unit uCadastroUsuario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects;

type
  TfrmCadastro = class(TForm)
    grp1: TGroupBox;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtEmail: TEdit;
    Email: TLabel;
    chbTermos: TCheckBox;
    Cadastrar: TButton;
    img1: TImage;
    procedure CadastrarClick(Sender: TObject);
    procedure chbTermosChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.fmx}

uses uDm;

procedure TfrmCadastro.CadastrarClick(Sender: TObject);
begin
 if (edtUsuario.Text='')or(edtSenha.Text='')or(edtEmail.Text='') then begin
    ShowMessage('Preencha Todos os campos');

 end else begin
    DM.cdsUsuario.Open;
    Dm.cdsUsuario.Append;
    DM.cdsUsuario.FieldByName('ID_USUARIO').Value:=0;
    DM.cdsUsuario.FieldByName('NOME').AsString:=edtUsuario.Text;
    DM.cdsUsuario.FieldByName('SENHA').AsString:=edtSenha.Text;
    DM.cdsUsuario.FieldByName('EMAIL').AsString:=edtEmail.Text;
    DM.cdsUsuario.Post;
    DM.cdsUsuario.ApplyUpdates(0);
    ShowMessage('Sua conta foi criado com sucesso!');
    Self.Close;
 end;
end;

procedure TfrmCadastro.chbTermosChange(Sender: TObject);
begin
Cadastrar.Enabled:=chbTermos.IsChecked;
end;

end.
