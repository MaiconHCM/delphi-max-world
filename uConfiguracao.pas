unit uConfiguracao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmConfiguracao = class(TForm)
    chbTempoReal: TCheckBox;
    btnconfirmar: TButton;
    btnCancelar: TButton;
    procedure btnconfirmarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfiguracao: TfrmConfiguracao;

implementation

uses
  uLogin;

{$R *.fmx}

procedure TfrmConfiguracao.btnCancelarClick(Sender: TObject);
begin
Self.Close;
end;

procedure TfrmConfiguracao.btnconfirmarClick(Sender: TObject);
begin
 frmLogin.atualizacaoTempoReal:=chbTempoReal.IsChecked;
 Self.Close;
end;

procedure TfrmConfiguracao.FormShow(Sender: TObject);
begin
 chbTempoReal.IsChecked:=frmLogin.atualizacaoTempoReal;
end;

end.
