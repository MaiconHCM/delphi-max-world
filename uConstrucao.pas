unit uConstrucao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,uPersonagem;

type
  TfrmConstrucao = class(TForm)
    pnl1: TPanel;
    GroupBox2: TGroupBox;
    img1: TImage;
    btnConstruir10: TButton;
    img2: TImage;
    lbl: TLabel;
    img3: TImage;
    lbl1: TLabel;
    pnl2: TPanel;
    grp1: TGroupBox;
    img4: TImage;
    btnFazer11: TButton;
    img5: TImage;
    lbl2: TLabel;
    img6: TImage;
    lbl3: TLabel;
    lbl4: TLabel;
    grp2: TGroupBox;
    img7: TImage;
    btnFazer12: TButton;
    img8: TImage;
    lbl5: TLabel;
    img9: TImage;
    lbl6: TLabel;
    lbl7: TLabel;
    grp3: TGroupBox;
    img10: TImage;
    btn1: TButton;
    img11: TImage;
    lbl8: TLabel;
    img12: TImage;
    lbl9: TLabel;
    GroupBox3: TGroupBox;
    Image4: TImage;
    Button2: TButton;
    Image5: TImage;
    Label3: TLabel;
    Image6: TImage;
    Label4: TLabel;
    procedure btnConstruir10Click(Sender: TObject);
    procedure btnFazer11Click(Sender: TObject);
    procedure btnFazer12Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure atualizatela;
  public
    procedure atualizar(personagem:Tpersonagem);
  end;


var
  frmConstrucao: TfrmConstrucao;

implementation

{$R *.fmx}

uses Unit1, uDM;

procedure TfrmConstrucao.atualizar(personagem: Tpersonagem);
begin
  btnConstruir10.Enabled:=false;
  btnFazer11.Enabled:=False;
  btnFazer12.Enabled:=False;
  btn1.Enabled:=False;
  Button2.Enabled:=False;
  DM.cdsInventario.Close;
  DM.cdsInventario.Filter:='TIPO=0 AND ID_PERSONAGEM='+ IntToStr(personagem.Id);
  DM.cdsInventario.Open;
  atualizatela;
end;

procedure TfrmConstrucao.atualizatela;
var madeira,pedra,tabua,blocoPedra,i:SmallInt;
begin
  madeira:=0;
  pedra:=0;
  tabua:=0;
  blocoPedra:=0;
  DM.cdsInventario_Item.Filter:='ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.IndexFieldNames := 'ID_INVENTARIO_ITEM';
  DM.cdsInventario_Item.Open;
  for i:=1 to 16 do begin
    Case DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger of
    1 : madeira:=madeira+DM.cdsInventario_Item.FieldByName('Quantidade').AsInteger;
    2 : pedra:=pedra+DM.cdsInventario_Item.FieldByName('Quantidade').AsInteger;
    11: tabua:=tabua+DM.cdsInventario_Item.FieldByName('Quantidade').AsInteger;
    12: blocoPedra:=blocoPedra+DM.cdsInventario_Item.FieldByName('Quantidade').AsInteger;
    end;
    DM.cdsInventario_Item.Next;
  end;
  if(tabua>=40) then begin
  btnConstruir10.Enabled:=true;
  end;
  if(tabua>=40)and(blocoPedra>=10) then begin
  btn1.Enabled:=true;
  end;
  if(tabua>=60)and(blocoPedra>=60) then begin
  Button2.Enabled:=true;
  end;
  if madeira>=1 then begin
  btnFazer11.Enabled:=True;
  end;
  if pedra>=1 then begin
  btnFazer12.Enabled:=True;
  end;

end;

procedure TfrmConstrucao.btn1Click(Sender: TObject);
begin
  Form1.novaConstrucao(30);
  Close;
end;

procedure TfrmConstrucao.btnConstruir10Click(Sender: TObject);
begin
Form1.novaConstrucao(10);
Close;
end;

procedure TfrmConstrucao.btnFazer11Click(Sender: TObject);
begin
   Form1.diminuiRecursos(1,1);
   Form1.atualizaRecursos(11,4);
   atualizatela;
end;

procedure TfrmConstrucao.btnFazer12Click(Sender: TObject);
begin
  Form1.diminuiRecursos(2,1);
   Form1.atualizaRecursos(12,4);
   atualizatela;
end;

procedure TfrmConstrucao.Button2Click(Sender: TObject);
begin
  Form1.novaConstrucao(31);
  Close;
end;

end.
