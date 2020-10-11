unit uDescrPersonagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation,uPersonagem;

type
  TfrmDescrPersonagem = class(TForm)
    img: TImage;
    lblnome: TLabel;
    Sobre: TGroupBox;
    lblAtaque: TLabel;
    lblVelocidade: TLabel;
    img1: TImage;
    img2: TImage;
    lblVida: TLabel;
    lblExperiencia: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  procedure AtualizaDescr(Personagem: TPersonagem);
  end;

var
  frmDescrPersonagem: TfrmDescrPersonagem;

implementation


{$R *.fmx}

{ TfrmDescrPersonagem }

procedure TfrmDescrPersonagem.AtualizaDescr(Personagem: TPersonagem);
begin
 lblnome.Text := personagem.Name;
 Caption:='Descrição de '+Personagem.name;
  try  // para o except
   img.Bitmap.LoadFromFile('..\..\imgs\sprites\personagens\' + IntToStr(Personagem.Sprite) + '\3\0.png');
  except
    img.Bitmap.LoadFromFile('..\..\imgs\sprites\personagens\capybara.png');
  end;
 lblExperiencia.Text:=IntToStr(Personagem.experiencia)+'/'+IntToStr(Personagem.experienciaMaxima);
 lblVida.Text:=IntToStr(Personagem.vida)+'/'+IntToStr(Personagem.vidaMaxima);
 lblAtaque.Text:='Ataque: '+IntToStr(Personagem.ataque);
 lblVelocidade.Text:='Velocidade: '+IntToStr(Personagem.Velocidade);
end;

end.

