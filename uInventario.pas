unit uInventario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects,uPersonagem,System.StrUtils, FMX.Menus;

type
  TfrmInventario = class(TForm)
    img5: TImage;
    lbl5: TLabel;
    img6: TImage;
    lbl6: TLabel;
    img7: TImage;
    lbl7: TLabel;
    img8: TImage;
    lbl8: TLabel;
    pnl1: TPanel;
    img1: TImage;
    lbl1: TLabel;
    img2: TImage;
    lbl2: TLabel;
    img3: TImage;
    lbl3: TLabel;
    img4: TImage;
    lbl4: TLabel;
    img9: TImage;
    lbl9: TLabel;
    img10: TImage;
    lbl10: TLabel;
    img11: TImage;
    lbl11: TLabel;
    img12: TImage;
    lbl12: TLabel;
    img13: TImage;
    lbl13: TLabel;
    img14: TImage;
    lbl14: TLabel;
    img15: TImage;
    lbl15: TLabel;
    img17: TImage;
    lbl17: TLabel;
    img18: TImage;
    lbl18: TLabel;
    img19: TImage;
    lbl19: TLabel;
    img20: TImage;
    lbl20: TLabel;
    imgPersonagem: TImage;
    lblVelocidade: TLabel;
    lblAtaque: TLabel;
    imgvida: TImage;
    imgExperiencia: TImage;
    lblVida: TLabel;
    lblExperiencia: TLabel;
    img16: TImage;
    lbl16: TLabel;
    procedure img1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    mover:SmallInt;
    sprite:SmallInt;
    procedure moveItem(novaPos:string);
    procedure atualizarTela;
  public
  procedure atualizar(personagem:TPersonagem);
  end;
var
  frmInventario: TfrmInventario;

implementation

uses
  Unit1, uDM;

{$R *.fmx}

{ Tinventario }

procedure TfrmInventario.atualizar(personagem: TPersonagem);
begin
  DM.cdsInventario.Close;
  DM.cdsInventario.Filter:='TIPO=0 AND ID_PERSONAGEM='+ IntToStr(personagem.Id);
  DM.cdsInventario.Open;
  lblExperiencia.Text:=IntToStr(Personagem.experiencia)+'/'+IntToStr(Personagem.experienciaMaxima);
  lblVida.Text:=IntToStr(Personagem.vida)+'/'+IntToStr(Personagem.vidaMaxima);
  lblAtaque.Text:='Ataque: '+IntToStr(Personagem.ataque);
  lblVelocidade.Text:='Velocidade: '+IntToStr(Personagem.Velocidade);
  sprite:=personagem.Sprite;
  atualizarTela;
end;

procedure TfrmInventario.atualizarTela;
var i:SmallInt;
begin
  imgPersonagem.Bitmap:=form1.carregaBitmap('..\..\imgs\sprites\personagens\'+IntToStr(sprite)+'\3\0.png');
  DM.cdsInventario_Item.Filter:='ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.IndexFieldNames := 'ID_INVENTARIO_ITEM';
  DM.cdsInventario_Item.Open;
  for i:=1 to 16 do begin
    if DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger<>0 then begin
      TImage(FindComponent('img'+IntToStr(i))).Bitmap:=Form1.carregaBitmap('..\..\imgs\item\'+IntToStr(DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger)+'\0.png');
      TLabel(FindComponent('lbl'+IntToStr(i))).Text:=IntToStr(DM.cdsInventario_Item.FieldByName('QUANTIDADE').AsInteger);
    end else begin
      TImage(FindComponent('img'+IntToStr(i))).Bitmap:=Form1.carregaBitmap('..\..\imgs\item\x.png');
      TLabel(FindComponent('lbl'+IntToStr(i))).Text:='';
    end;
    DM.cdsInventario_Item.Next;
  end;
end;

procedure TfrmInventario.img1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
 var pnt:TPoint;
begin

  if ssLeft in Shift  then begin
    if mover=0 then begin
      mover := StrToInt(SplitString(TImage(Sender).Name, 'g')[1]);
      frmInventario.Cursor:=-12;
      TImage(Sender).Opacity:=0.6;
      //atualizarTela;
    end else  begin

      if SplitString(TImage(Sender).Name, 'g')[1]<>IntToStr(mover) then begin
      moveItem(SplitString(TImage(Sender).Name, 'g')[1]);
      end;
      TImage(FindComponent('img'+IntToStr(mover))).Opacity:=1;
      mover:=0;
      pnl1.Opacity:=1;
      frmInventario.Cursor:=0;
      atualizarTela;
    end;

  end else if ssRight in Shift then begin
  end;
end;

procedure TfrmInventario.moveItem(novaPos: string);
var item,quantidade,itemAux,quantidadeAux:SmallInt;
begin
  DM.cdsInventario_Item.Filter:='ID_INVENTARIO_ITEM='+IntToStr(mover)+' AND ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.Refresh;
  item:=DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger;
  quantidade:=DM.cdsInventario_Item.FieldByName('QUANTIDADE').AsInteger;

  DM.cdsInventario_Item.Filter:='ID_INVENTARIO_ITEM='+novaPos+' AND ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.Refresh;
  itemAux:=DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger;
  quantidadeAux:=DM.cdsInventario_Item.FieldByName('QUANTIDADE').AsInteger;

  if item=itemAux then begin
      quantidade:=quantidade+quantidadeAux;
      quantidadeAux:=0;
      itemAux:=0;
  end;

  DM.cdsInventario_Item.Edit;
  DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger:=item;
  DM.cdsInventario_Item.FieldByName('QUANTIDADE').AsInteger:=quantidade;

  DM.cdsInventario_Item.Filter:='ID_INVENTARIO_ITEM='+IntToStr(mover)+' AND ID_INVENTARIO='+IntToStr(DM.cdsInventario.FieldByName('ID_INVENTARIO').AsInteger);
  DM.cdsInventario_Item.Filtered:=False;
  DM.cdsInventario_Item.Filtered:=true;
  DM.cdsInventario_Item.Edit;
  DM.cdsInventario_Item.FieldByName('ID_ITEM').AsInteger:=itemAux;
  DM.cdsInventario_Item.FieldByName('QUANTIDADE').AsInteger:=quantidadeAux;

  DM.cdsInventario_Item.Post;
  DM.cdsInventario_Item.ApplyUpdates(0);
end;



end.
