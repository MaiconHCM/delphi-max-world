unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, Data.FMTBcd, Data.DB, Data.SqlExpr,
  FMX.Objects;

type
  TfrmLogin = class(TForm)
    edtUsuario: TEdit;
    edtSenha: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    btnLogin: TButton;
    img1: TImage;
    chbLembrar: TCheckBox;
    grp1: TGroupBox;
    btnCadastrar: TButton;
    grp2: TGroupBox;
    btnConfiguracao: TButton;
    procedure btnLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure btnConfiguracaoClick(Sender: TObject);
  private
    lLogado: boolean;
    procedure salvarUsuario;
    procedure recuperaUsuario;
  public
    cUsuario: string;
    cPersonagem:string;
    atualizacaoTempoReal:Boolean;
   end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uDM,uSelecionarPersonagem,Registry,uCadastroUsuario, uConfiguracao;


procedure TfrmLogin.btnCadastrarClick(Sender: TObject);
begin
if not Assigned(frmCadastro) then begin
  frmCadastro := TfrmCadastro.create(nil);
end;
  frmCadastro.ShowModal;
  FreeAndNil(frmCadastro);
end;

procedure TfrmLogin.btnConfiguracaoClick(Sender: TObject);
begin
if not Assigned(frmConfiguracao) then begin
  frmConfiguracao := TfrmConfiguracao.create(nil);
end;
  frmConfiguracao.ShowModal;
  FreeAndNil(frmConfiguracao);
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
try
    lLogado := False;

    //Verifica se existe o usuário e senha cadastrados no BD
    DM.cdsUsuario.Open;
    DM.cdsUsuario.Refresh;
    DM.cdsUsuario.Filter:=' NOME = '+ QuotedStr(edtUsuario.Text);
    //Verifica se está vazio a query
    if (DM.cdsUsuario.Filter.IsEmpty) then
      begin
      ShowMessage('Usuário não encontrado!');
      edtUsuario.SetFocus;
    end
    else
      begin
      if (DM.cdsUsuario.FieldByName('SENHA').AsString = edtSenha.Text) then
        begin
        //ShowMessage('Usuário validado com sucesso!');
        lLogado := true;
        cUsuario := DM.cdsUsuario.FieldByName('ID_USUARIO').Value;
        salvarUsuario;
        if not Assigned(frmPersonagem) then
        frmPersonagem := TfrmPersonagem.create(nil);
        frmPersonagem.ShowModal;

        if frmPersonagem.personagemEscolhido = '' then begin
          FreeAndNil(frmPersonagem);
        end else begin
          cPersonagem:= frmPersonagem.personagemEscolhido;
          FreeAndNil(frmPersonagem);
          Self.Close;
        end;
      end
      else
        begin
        ShowMessage('Senha inválida!');
        edtSenha.SetFocus;
      end;
    end;

    DM.cdsUsuario.Close;

  except
    on E: Exception do
      begin
      ShowMessage('Erro ao validar o usuário: '+E.Message);
      Self.Close;
    end;
  end;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
atualizacaoTempoReal:=True;
recuperaUsuario;
end;

procedure TfrmLogin.recuperaUsuario;
const raiz = 'software\programa\preferencias';
var registro:Tregistry;
begin
  registro:= TRegistry.Create;

  with registro do begin
    if OpenKey(raiz,false) then begin
      if ValueExists('Pref_Login') then begin
      edtUsuario.Text:=ReadString('Pref_Login');
      end;
      if ValueExists('Pref_Senha') then begin
      edtSenha.Text:=ReadString('Pref_Senha');
      end;
      if ValueExists('Pref_chb') then begin
      chbLembrar.IsChecked:=ReadBool('Pref_chb');
      end;
      if ValueExists('Pref_online') then begin
      atualizacaoTempoReal:=ReadBool('Pref_online');
      end;
      registro.CloseKey;
      registro.Free
    end;
  end;


end;

procedure TfrmLogin.salvarUsuario;
const raiz = 'software\programa\preferencias';
var registro:TRegistry;
begin
  registro:= TRegistry.Create;

  registro.OpenKey(raiz,true);

  if chbLembrar.IsChecked=True then begin
  registro.WriteString('Pref_Login',edtUsuario.Text);
  registro.WriteString('Pref_Senha',edtSenha.Text);
  registro.WriteBool('Pref_chb',true);
  end else begin
  registro.WriteString('Pref_Login','');
  registro.WriteString('Pref_Senha','');
  registro.WriteBool('Pref_chb',false);
  end;
  registro.WriteBool('Pref_online',atualizacaoTempoReal);

  registro.CloseKey;
  registro.Free;
end;

end.
