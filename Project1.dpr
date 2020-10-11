program Project1;



uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uDM in 'uDM.pas' {DM: TDataModule},
  uLogin in 'uLogin.pas' {frmLogin},
  uSelecionarPersonagem in 'uSelecionarPersonagem.pas' {frmPersonagem},
  uCadastroUsuario in 'uCadastroUsuario.pas' {frmCadastro},
  uPersonagem in 'uPersonagem.pas',
  uObjeto_Mapa in 'uObjeto_Mapa.pas',
  uCriarPersonagem in 'uCriarPersonagem.pas' {frmCriarPersonagem},
  uDescrPersonagem in 'uDescrPersonagem.pas' {frmDescrPersonagem},
  uConstrucao in 'uConstrucao.pas' {frmConstrucao},
  uInventario in 'uInventario.pas' {frmInventario},
  uConfiguracao in 'uConfiguracao.pas' {frmConfiguracao},
  uCraft in 'uCraft.pas' {frmCraft},
  ulistaOnline in 'ulistaOnline.pas' {frmplayersOnline},
  uMapa in 'uMapa.pas' {frmMapa},
  uAtualizaMapa in 'uAtualizaMapa.pas' {frmAtualizaMapa};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
