unit treebmp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, ExtDlgs, types, LCLType, StdCtrls;

type

  { TTreeBmpForm }

  TTreeBmpForm = class(TForm)
    BackButton: TToolButton;
    HelpButton: TToolButton;
    ImageEmpty: TImage;
    ImageTmp: TImage;
    ImageICO: TImage;
    ImageList1: TImageList;
    ImageList3: TImageList;
    ImageList5: TImageList;
    Memo1: TMemo;
    SizeButton: TToolButton;
    PaintTree: TImage;
    PlusButton: TToolButton;
    PrintDialog1: TPrintDialog;
    SavePictureDialog1: TSavePictureDialog;
    ScrollTree: TScrollBox;
    ToolBar1: TToolBar;
    MinuButton: TToolButton;
    SaveButton: TToolButton;
    PrinButton: TToolButton;
    TuneButton: TToolButton;
    procedure BackButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure HelpButtonClick(Sender: TObject);
    procedure MinuButtonClick(Sender: TObject);
    procedure PaintTreeClick(Sender: TObject);
    procedure PaintTreeDblClick(Sender: TObject);
    procedure PaintTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintTreeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintTreeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlusButtonClick(Sender: TObject);
    procedure PrinButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SizeButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
    iX1 : Integer;//левый  X
    iX2 : Integer;//правый X
    iY1 : Integer;//левый  Y
    iY2 : Integer;//правый Y
    LeftRight : Boolean;//False - лева€ часть древа, True-права€ часть древа
    GaugePos : Integer;
    function iRetrNama(const Nama: String): Integer;
    function iRetrFather(const Nama: String): Integer;
    function iRetrMother(const Nama: String): Integer;
    function FirstNama( Nama : String): String;
    function LastNama( Nama : String): String;
    function DateNama( Index : Integer): String;
    procedure DrawMen( Index, X , Y : Integer; Nama : String; Sexs : Integer);
    procedure DrawNat( Index, X , Y : Integer; Nama : String; Sexs : Integer);
    procedure Arc1( X, Y : Integer);
    procedure Arc3( X, Y : Integer);
    procedure Arc2( X, Y : Integer);
    procedure Arc4( X, Y : Integer);
    procedure AngleTextOut(CV: TCanvas; const sText: string; x, y, angle: integer);
    procedure DrawTextArc(CV: TCanvas; centerx, centery, rad : Integer; arcbeg, arcend : Real; sText : String);
    function StrNational(Nations : String): String;
    procedure ResizePaintTree(k : Real);
  public
    { public declarations }
    procedure DrawPaintTreeDown;
    procedure DrawPaintTreeAaa;
    procedure DrawPaintTreeAll;
    procedure DrawPaintTreePeC;
    procedure DrawPaintTreeNat;
    procedure DrawPaintTreePerDn;
    procedure DrawPaintTreePerUp;
  end;

var
  TreeBmpForm: TTreeBmpForm;

implementation

uses main, vars, utils, info, tune, mstring, prints, graph, prozess;

{$R *.lfm}

procedure TTreeBmpForm.BackButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTreeBmpForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 with ScrollTree do begin
  case Key of
    VK_UP:
      with VertScrollBar do
        Position := Position - Increment;
    VK_DOWN:
      with VertScrollBar do
        Position := Position + Increment;
    VK_LEFT:
      with HorzScrollBar do
        Position := Position - Increment;
    VK_RIGHT:
      with HorzScrollBar do
        Position := Position + Increment;
    VK_HOME:
    begin
      VertScrollBar.Position := 0;
      HorzScrollBar.Position := 0;
    end;
    VK_END:
    begin
      with VertScrollBar do
        Position := Range;
      HorzScrollBar.Position := 0;
    end;
    VK_PRIOR:
    begin
      VertScrollBar.Position := 0;
      with HorzScrollBar do
        Position := Range;
     end;
    VK_NEXT:
    begin
      with VertScrollBar do
        Position := Range;
      with HorzScrollBar do
        Position := Range;
    end;
  end;
 end;
end;

procedure TTreeBmpForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ResizePaintTree(1.1);
end;

procedure TTreeBmpForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ResizePaintTree(1 / 1.1);
end;

procedure TTreeBmpForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TTreeBmpForm.SizeButtonClick(Sender: TObject);
begin
  if PaintTree.Align = alNone then begin
    PaintTree.Align := alClient;
    PaintTree.Stretch := True;
    PaintTree.AutoSize := False;
  end else begin
    PaintTree.Align := alNone;
    PaintTree.Stretch := False;
    PaintTree.AutoSize := True;
  end;
end;

procedure TTreeBmpForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

//индекс человека в списке
function TTreeBmpForm.iRetrNama(const Nama: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  if Trim(Nama) <> '' then
  for i := 0 to listMans.Count - 1 do
    if Trim(listMans.Strings[i]) = Nama then begin
      Result := i;
      exit;
    end;
end;
//индекс отца в списке
function TTreeBmpForm.iRetrFather(const Nama: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  if Trim(Nama) <> '' then
  for i := 0 to listMans.Count - 1 do
    if Trim(listMans.Strings[i]) = Nama then begin
      Result := i;
      exit;
    end;
end;
//индекс матери в списке
function TTreeBmpForm.iRetrMother(const Nama: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  if Trim(Nama) <> '' then
  for i := 0 to listMans.Count - 1 do
    if Trim(listMans.Strings[i]) = Nama then begin
      Result := i;
      exit;
    end;
end;
// фамили€
function TTreeBmpForm.FirstNama( Nama : String): String;
begin
  Result := Copy( Nama, 1, Pos(' ', Nama)-1);
end;
// им€ и отчество
function TTreeBmpForm.LastNama( Nama : String): String;
begin
  Result := Copy( Nama, Pos(' ', Nama)+1, 255);
end;
procedure TTreeBmpForm.MinuButtonClick(Sender: TObject);
begin
  ResizePaintTree(1.1);
end;

procedure TTreeBmpForm.PaintTreeClick(Sender: TObject);
var
  i : Integer;
  s : String;
begin
  if not btLeft then Exit;
  if MensCnt = 0 then Exit;
  PaintTree.Hint := '';
  for i := 0 to MensCnt-1 do begin
   if (((OX >= MensX[i]) and (OX <= (MensX[i] + DrawMenWidht))) and
       ((OY >= MensY[i]) and (OY <= (MensY[i] + DrawMenHight)))) then begin
     btLeft := False;
     if MensM[i] < listMans.Count then begin
       s := MainPathTXT+Trim(listMans.Strings[MensM[i]])+'.txt';
       if FileExists(s) then begin
         {$IFDEF WINDOWS}
         Memo1.Lines.LoadFromFile(UTF8toANSI(s));
         {$ENDIF}
         {$IFDEF UNIX}
         Memo1.Lines.LoadFromFile(s);
         {$ENDIF}
         PaintTree.Hint := Memo1.Text;
       end;
     end;
   end;
  end;
  if Empty(PaintTree.Hint) then PaintTree.ShowHint := False;
end;

procedure TTreeBmpForm.PaintTreeDblClick(Sender: TObject);
var
  i : Integer;
begin
  if MensCnt = 0 then Exit;
  for i := 0 to MensCnt-1 do begin
   if (((OX >= MensX[i]) and (OX <= (MensX[i] + DrawMenWidht))) and
       ((OY >= MensY[i]) and (OY <= (MensY[i] + DrawMenHight)))) then begin
     btLeft := False;
     if MensM[i] < listMans.Count then begin
       Family.StringGrid1.Row := MensM[i];
       Family.StringGrid1.Repaint;
       Close;
     end;
   end;
  end;
end;

procedure TTreeBmpForm.PaintTreeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    btLeft := True;
    OX := X;
    OY := Y;
    PaintTree.ShowHint := True;
    Cursor := crHandPoint;
  end;
end;

procedure TTreeBmpForm.PaintTreeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if btLeft then begin
    with ScrollTree do begin
    if X > OX then with HorzScrollBar do Position := Position - Increment;
    if X < OX then with HorzScrollBar do Position := Position + Increment;
    if Y > OY then with VertScrollBar do Position := Position - Increment;
    if Y < OY then with VertScrollBar do Position := Position + Increment;
    end;
    OX := X;
    OY := Y;
    PaintTree.ShowHint := False;//чтобы устаревша€ подсказка невылетала
  end;
end;

procedure TTreeBmpForm.PaintTreeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    btLeft := False;
    Cursor := crDefault;
  end;
end;

procedure TTreeBmpForm.PlusButtonClick(Sender: TObject);
begin
  ResizePaintTree(1 / 1.1);
end;

procedure TTreeBmpForm.PrinButtonClick(Sender: TObject);
begin
  if not PrintDialog1.Execute then Exit;
  PrintImage(PaintTree, 100);
end;

// ƒата
function TTreeBmpForm.DateNama( Index : Integer): String;
begin
  Result := '';
  if (Index < 0) or (Index > listMans.Count-1) then Exit;
  if ((not Empty(listBirth.Strings[Index])) or
      (not Empty(listDeath.Strings[Index]))) then begin
    Result := '('+listBirth.Strings[Index];
    if Trim(listDeath.Strings[Index]) <> ''
      then Result := Result + '-' + listDeath.Strings[Index];
    Result := Result + ')';
  end;
end;

//рисует иконку, рамку, ‘»ќ и дату
procedure TTreeBmpForm.DrawMen( Index, X , Y : Integer; Nama : String; Sexs : Integer);
var
  bm : TBitmap;
begin
//  PaintTree.Canvas.CopyMode := cmMergePaint;
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Color := clTeal;
  if Sexs = 0
    then PaintTree.Canvas.Brush.Color := ClrVeryLight(clAqua)
    else PaintTree.Canvas.Brush.Color := ClrVeryLight(clFuchsia);
  PaintTree.Canvas.Pen.Width := BoxWidth;//толщина рамки
  PaintTree.Canvas.RoundRect( X+2,Y+12, X+190,Y+59, 12,12); //рамка обща€
  PaintTree.Canvas.Font.Name := ScrollTree.Font.Name;
  PaintTree.Canvas.Font.Size := ScrollTree.Font.Size;
  PaintTree.Canvas.Font.Color := clBlack;
  PaintTree.Canvas.Font.Style := [];
  PaintTree.Canvas.TextOut( X+45, Y+13, FirstNama( Nama));
  PaintTree.Canvas.TextOut( X+45, Y+27, LastNama( Nama));
  //PaintTree.Canvas.Font.Size := ScrollTree.Font.Size - 2;
  PaintTree.Canvas.Font.Style := [fsItalic];
  PaintTree.Canvas.TextOut( X+45, Y+41, DateNama( Index));
  ImageTmp.Picture := Nil;//чищу
  Family.ImageIcons.Draw( ImageTmp.Canvas, 0, 0, Index);
  if not EmptyBMP(ImageTmp) then begin//иконка
    Family.ImageIcons.StretchDraw(PaintTree.Canvas, Index, Rect(X+7, Y+17, X+39, Y+49),True);
    PaintTree.Canvas.Draw(X+7, Y+17, ImageICO.Picture.Graphic);
    if Sexs = 0 then
      PaintTree.Canvas.Pen.Color := ClrVeryLight(clAqua)
    else
      PaintTree.Canvas.Pen.Color := ClrVeryLight(clFuchsia);
    PaintTree.Canvas.Brush.Color := clWhite;
    PaintTree.Canvas.Brush.Style := bsClear;
    PaintTree.Canvas.RoundRect( X+4,Y+15, X+42,Y+51, 22,22); //рамка иконки
  end;
  PaintTree.Canvas.Pen.Width := LinWidth;//толщина линий
end;

//рисует иконку, рамку, ‘»ќ и национальность
procedure TTreeBmpForm.DrawNat( Index, X , Y : Integer; Nama : String; Sexs : Integer);
var
  s : String;
  function sDraw(ss : String; n : Integer): String;
  begin
    Result := Copy(ss,31*n+1,31);
  end;
begin//ширина X=177; Y=37
  s := '';
  PaintTree.Canvas.Font.Name := ScrollTree.Font.Name;
  PaintTree.Canvas.Font.Size := ScrollTree.Font.Size;
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Color := clTeal;
  PaintTree.Canvas.Font.Style := [];
  if Sexs = 0
    then PaintTree.Canvas.Brush.Color := ClrVeryLight(clAqua)
    else PaintTree.Canvas.Brush.Color := ClrVeryLight(clFuchsia);
  PaintTree.Canvas.Pen.Width := BoxWidth;//толщина рамки
  PaintTree.Canvas.RoundRect( X+5,Y+13, X+189,Y+54, 12,12); //рамка обща€
  PaintTree.Canvas.Font.Style := [fsItalic];
  if not Empty(listNati.Strings[Index]) then
    s := '('+Trim(listNati.Strings[Index])+') ';
  if not Empty(listNull.Strings[Index]) then
  if listNull.Strings[Index] <> listNati.Strings[ Index] then
    s := s + StrNational(listNull.Strings[Index]);
  PaintTree.Canvas.TextOut( X+9, Y+14, sDraw(s,0));
  PaintTree.Canvas.TextOut( X+9, Y+26, sDraw(s,1));
  PaintTree.Canvas.TextOut( X+9, Y+38, sDraw(s,2));
  PaintTree.Canvas.Pen.Width := LinWidth;//толщина линий
end;

//рисую дуги окружности
procedure TTreeBmpForm.Arc1( X, Y : Integer);
begin// лева€ нижн€€ дуга окружности
  PaintTree.Canvas.Arc( X,Y, X+20,Y+20, X,Y+10, X+10,Y+20);
end;

procedure TTreeBmpForm.Arc3( X, Y : Integer);
begin// права€ верхн€€ дуга окружности
  PaintTree.Canvas.Arc( X,Y, X+20,Y+20, X+20,Y+10, X+10,Y);
end;

procedure TTreeBmpForm.Arc4( X, Y : Integer);
begin// лева€ верхн€€ дуга окружности
  {$IFDEF WINDOWS}
  PaintTree.Canvas.Arc( X+20,Y+20, X,Y, X+10,Y+20, X+20,Y+10);
  {$ENDIF}
  {$IFDEF DARWIN}
  PaintTree.Canvas.Arc( X+20,Y+20, X,Y, X+10,Y, X,Y+10);
  {$ENDIF}
  {$IFDEF UNIX}
  PaintTree.Canvas.Arc( X,Y, X+20,Y+20, X+10,Y+20, X+20,Y+10);
  {$ENDIF}
end;

procedure TTreeBmpForm.Arc2( X, Y : Integer);
begin// права€ нижн€€ дуга окружности
  {$IFDEF WINDOWS}
  PaintTree.Canvas.Arc( X+20,Y+20, X,Y, X+10,Y, X,Y+10);
  {$ENDIF}
  {$IFDEF DARWIN}
  PaintTree.Canvas.Arc( X+20,Y+20, X,Y, X+10,Y+20, X+20,Y+10);
  {$ENDIF}
  {$IFDEF UNIX}
  PaintTree.Canvas.Arc( X,Y, X+20,Y+20, X+10,Y, X,Y+10);
  {$ENDIF}
end;

procedure TTreeBmpForm.DrawPaintTreeDown;
var
  distIndex : TStringList;
  distMans  : TStringList;
  distFather : TStringList;
  distMother : TStringList;
  distGender : TStringList;
  distSpouse : TStringList;
var
  pos : Integer;
  maxY : Integer;
  maxX : Integer;
  Ons : Boolean;
  Sex : Integer;
  done : Boolean;
  ht, wt : Integer;//размер области рисования
  i, j : Integer;
  s1, s2 : String;
  //индекс человека в списке
  function dRetrName(const Name: String): Integer;
  var
   ii : Integer;
  begin
   Result := -1;
   if Trim(Name) <> '' then
   for ii := 0 to distMans.Count - 1 do
   if Trim(distMans.Strings[ii]) = Trim(Name) then begin
     Result := ii;
     exit;
   end;
  end;
  procedure SwapPerson(source, dest : Integer);
  var
   tmp : String;
  begin
   tmp := distIndex.Strings[source];
   distIndex.Strings[source] := distIndex.Strings[dest];
   distIndex.Strings[dest] := tmp;
   tmp := distMans.Strings[source];
   distMans.Strings[source] := distMans.Strings[dest];
   distMans.Strings[dest] := tmp;
   tmp := distFather.Strings[source];
   distFather.Strings[source] := distFather.Strings[dest];
   distFather.Strings[dest] := tmp;
   tmp := distMother.Strings[source];
   distMother.Strings[source] := distMother.Strings[dest];
   distMother.Strings[dest] := tmp;
   tmp := distGender.Strings[source];
   distGender.Strings[source] := distGender.Strings[dest];
   distGender.Strings[dest] := tmp;
   tmp := distSpouse.Strings[source];
   distSpouse.Strings[source] := distSpouse.Strings[dest];
   distSpouse.Strings[dest] := tmp;
  end;
  //рисую генеалогическую ветвь
  procedure ParentsChilds(X, Y: Integer; Person: String; Index: Integer);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
    One : Boolean;
    dX, dY : Integer;
    s, ss : String;
    Sex : Integer;
    aSpouse : TStringList;
    i, n, p : Integer;
    procedure SaveMen( Index, X, Y : Integer);
    begin
      New(pMen);
      pMen^.Men := Index;
      pMen^.X := X;
      pMen^.Y := Y;
      Mens.Add(pMen);
    end;
  begin
    dX := X;
    dY := Y;
    iCol := 0;
    iNam := -1;
    iPar := -1;
    aSpouse := TStringList.Create;
    if (not Empty(distSpouse.Strings[Index])) then begin
      ss := distSpouse.Strings[Index];
      repeat
        i := System.Pos(rzd2, ss);
        if i > 0 then begin
          s := Copy(ss,1,i-1);
          ss := Copy(ss,i+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then aSpouse.Add(s);
      until i=0;
    end;
    for n := 0 to aSpouse.Count-1 do begin
      p := System.Pos(rzd3, aSpouse.Strings[n]);
      if p > 0 then aSpouse.Strings[n] := Copy(aSpouse.Strings[n], 1, p-1);
    end;
    if (maxX < X) then maxX := X;
    if (maxY < Y) then maxY := Y;
    PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
    if not Ons then begin
      PaintTree.Canvas.MoveTo(X-26,Y-25);
      PaintTree.Canvas.LineTo(X-26,iY2-5);
      PaintTree.Canvas.MoveTo(X-15,iY2+3);
      PaintTree.Canvas.LineTo(X+16,iY2+3);
      Arc1( X-26, iY2-16);      // ветка вверх
      Arc3( X+8, iY2+3);        // ветка вниз в право
      ImageList1.Draw( PaintTree.Canvas, X-15, iY2+5, 1); //листочки
      ImageList3.Draw( PaintTree.Canvas, X-65, iY2-10, 0);
    end;
    Arc2( X-1, iY2+44);       // ветка вниз в лево
    Ons := false;
    One := false;
    if distGender.Strings[Index] = Man then Sex := 0
    else if distGender.Strings[Index] = Woman then Sex := 1
    else Sex := -1;
    DrawMen( StrToInt(distIndex.Strings[Index]), X, iY2, distMans.Strings[ Index], Sex);
    SaveMen( StrToInt(distIndex.Strings[Index]), X, iY2);
    iCol := iY2 + 80;
    for iRow := 0 to distMans.Count-1 do begin
      // ищу всех детей мужской линии
      if distGender.Strings[Index] = Man then begin
        if distFather.Strings[iRow] = Person then begin// если отец
          iPar := dRetrName(distMother.Strings[iRow]);
          if (iNam <> iPar) then begin// мать
       	    // есть ли такая жена в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (distMother.Strings[iRow] = aSpouse.Strings[n]) then begin
            	aSpouse.Delete(n);// если есть, удаляю его из списка
                break;
              end;
            end;
            if (One) then begin
              iY2 := dY;
              iCol := iY2 + 80;
              dX := maxX;
            end else begin
              dY := iY2;
            end;
            if (iPar > -1) then begin
              dX := dX + 210;
              PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
              PaintTree.Canvas.MoveTo(X+5 ,iY2+64);
              PaintTree.Canvas.LineTo(dX-10,iY2+64);
              Arc1(  X-2, iY2+45);
              Arc4(dX-21, iY2+45);
              ImageList1.Draw( PaintTree.Canvas, X+50, iY2+65, 1);
              ImageList3.Draw( PaintTree.Canvas, X-15, iY2+65, 0);
              if distGender.Strings[iPar] = Man then Sex := 0
              else if distGender.Strings[iPar] = Woman then Sex := 1
              else Sex := -1;
              DrawMen( StrToInt(distIndex.Strings[iPar]), dX-2, iY2, distMans.Strings[ iPar], Sex);
              SaveMen( StrToInt(distIndex.Strings[iPar]), dX-2, iY2);
            end;
            iNam := iPar;
          end;
          One := true;
          iY2 := iY2 + 80;
          ParentsChilds( dX+25, iCol, distMans.Strings[iRow], iRow);
        end;
      end;
      // ищу всех детей женской линии
      if distGender.Strings[Index] = Woman then begin
        if distMother.Strings[iRow] = Person then begin// если мать
          iPar := dRetrName(distFather.Strings[iRow]);
          if (iNam <> iPar) then begin// отец
       	    // есть ли такой муж в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (distFather.Strings[iRow] = aSpouse.Strings[n]) then begin
                aSpouse.Delete(n);// если есть, удаляю его из списка
                break;
              end;
            end;
            if (One) then begin
              iY2 := dY;
              iCol := iY2 + 80;
              dX := maxX;
            end else begin
              dY := iY2;
            end;
            if (iPar > -1) then begin
              dX := dX + 210;
              PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
              PaintTree.Canvas.MoveTo(X+5 ,iY2+64);
              PaintTree.Canvas.LineTo(dX-10,iY2+64);
              Arc1(  X-2, iY2+45);
              Arc4(dX-21, iY2+45);
              ImageList1.Draw( PaintTree.Canvas, X+50, iY2+65, 1);
              ImageList3.Draw( PaintTree.Canvas, X-15, iY2+65, 0);
              if distGender.Strings[iPar] = Man then Sex := 0
              else if distGender.Strings[iPar] = Woman then Sex := 1
              else Sex := -1;
              DrawMen( StrToInt(distIndex.Strings[iPar]), dX-2, iY2, distMans.Strings[ iPar], Sex);
              SaveMen( StrToInt(distIndex.Strings[iPar]), dX-2, iY2);
            end;
            iNam := iPar;
          end;
          One := true;
          iY2 := iY2 + 80;
          ParentsChilds( dX+25, iCol, distMans.Strings[iRow], iRow);
        end;
      end;
    end;
    // рисую жен и мужей без детей
    for n := 0 to aSpouse.Count-1 do begin
      if distGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
      if (Sex = 0) then begin
 	Sex := 1;
      end else
      if (Sex = 1) then begin
 	Sex := 0;
      end;
      iPar := dRetrName(aSpouse.Strings[n]);
      if (One) then iY2 := dY;
      dX := dX + 210;
      if (maxX < dX) then maxX := dX;
      PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
      PaintTree.Canvas.MoveTo(X+5 ,iY2+64);
      PaintTree.Canvas.LineTo(dX-10,iY2+64);
      Arc1(  X-3, iY2+45);
      Arc4(dX-21, iY2+45);
      ImageList1.Draw( PaintTree.Canvas, X+50, iY2+65, 1);
      ImageList3.Draw( PaintTree.Canvas, X-15, iY2+65, 0);
      DrawMen( StrToInt(distIndex.Strings[iPar]), dX-2, iY2, aSpouse.Strings[n], Sex);
      SaveMen( StrToInt(distIndex.Strings[iPar]), dX-2, iY2);
    end;
    aSpouse.Free;
  end;
  //вычисляю размеры X и Y для генеалогической ветви
  procedure ParentsY( X, Y: Integer; Person: String; Index: Integer);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
    One : Boolean;
    dX, dY : Integer;
    s, ss : String;
    Sex : Integer;
    aSpouse : TStringList;
    i, n, p : Integer;
  begin
    dX := X;
    dY := Y;
    iCol := 0;
    iNam := -1;
    iPar := -1;
    aSpouse := TStringList.Create;
    if (not Empty(distSpouse.Strings[Index])) then begin
      ss := distSpouse.Strings[Index];
      repeat
        i := System.Pos(rzd2, ss);
        if i > 0 then begin
          s := Copy(ss,1,i-1);
          ss := Copy(ss,i+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then aSpouse.Add(s);
      until i=0;
    end;
    for n := 0 to aSpouse.Count-1 do begin
      p := System.Pos(rzd3, aSpouse.Strings[n]);
      if p > 0 then aSpouse.Strings[n] := Copy(aSpouse.Strings[n], 1, p-1);
    end;
    if (maxX < X) then maxX := X;
    if (maxY < Y) then maxY := Y;
    Ons := false;
    One := false;
    iCol := iY2 + 80;
    for iRow := 0 to distMans.Count - 1 do begin
      // ищу всех детей мужской линии
      if distGender.Strings[Index] = Man then begin
        if distFather.Strings[iRow] = Person then begin// если отец
          iPar := dRetrName(distMother.Strings[iRow]);
          if (iNam <> iPar) then begin// мать
       	    // есть ли такая жена в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (distMother.Strings[iRow] = aSpouse.Strings[n]) then begin
                aSpouse.Delete(n);// если есть, удаляю его из списка
                break;
              end;
            end;
            if (One) then begin
              iY2 := dY;
              iCol := iY2 + 80;
              dX := maxX;
            end else begin
              dY := iY2;
            end;
            if (iPar > -1) then begin
              dX := dX + 210;
            end;
            iNam := iPar;
          end;
          One := true;
          iY2 := iY2 + 80;
          ParentsChilds( dX+25, iCol, distMans.Strings[iRow], iRow);
        end;
      end;
      // ищу всех детей женской линии
      if distGender.Strings[Index] = Woman then begin
        if distMother.Strings[iRow] = Person then begin// если мать
          iPar := dRetrName(distFather.Strings[iRow]);
          if (iNam <> iPar) then begin// отец
       	    // есть ли такой муж в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (distFather.Strings[iRow] = aSpouse.Strings[n]) then begin
                aSpouse.Delete(n);// если есть, удаляю его из списка
                break;
              end;
            end;
            if (One) then begin
              iY2 := dY;
              iCol := iY2 + 80;
              dX := maxX;
            end else begin
              dY := iY2;
            end;
            if (iPar > -1) then begin
              dX := dX + 210;
            end;
            iNam := iPar;
          end;
          One := true;
          iY2 := iY2 + 80;
          ParentsChilds( dX+25, iCol, distMans.Strings[iRow], iRow);
        end;
      end;
    end;
    // рисую жен и мужей без детей
    for n := 0 to aSpouse.Count-1 do begin
      if distGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
      if (Sex = 0) then begin
        Sex := 1;
      end else
      if (Sex = 1) then begin
        Sex := 0;
      end;
      iPar := dRetrName(aSpouse.Strings[n]);
      if (One) then iY2 := dY;
      dX := dX + 210;
    end;
    aSpouse.Free;
  end;
begin
  Cursor := crHourGlass;
  PaintTree.Visible := False;//на время рисования отключаю
// Создаю дубль массива строк
  distIndex := TStringList.Create;
  distMans  := TStringList.Create;
  distGender := TStringList.Create;
  distFather := TStringList.Create;
  distMother := TStringList.Create;
  distSpouse := TStringList.Create;
// копирую дубль массива строк
  distMans.text := listMans.text;
  distGender.text := listGender.text;
  distFather.text := listFather.text;
  distMother.text := listMother.text;
  distSpouse.text := listSpouse.text;
//создаю списки
  Mens := TList.Create;
//показываю процесс
  ProcessForm.Gauge1.Caption := task_growing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := distMans.Count;
// запоминаю номер строки
  for i := 0 to distMans.Count-1 do begin
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    distIndex.Add(IntToStr(i));
  end;
// сортирую строки
  for j := 0 to distMans.Count-1 do begin
    ProcessForm.Gauge1.Position := j;
    Application.ProcessMessages;
    for i := 0 to distMans.Count-j-2 do begin
      s1 := distFather.Strings[i] + distMother.Strings[i];
      s2 := distFather.Strings[i+1] + distMother.Strings[i+1];
      if (s1 > s2) then SwapPerson(i, i+1);
    end;
  end;
// Вычисляю Y и X
  maxY := 0;
  maxX := -190;
  for i := 0 to distMans.Count - 1 do begin
    Inc(pos);
    if ((Empty(distFather.Strings[i]))
     and (Empty(distMother.Strings[i]))) then begin
      // сканирую только мужские линии
      if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then
      if distGender.Strings[i] = Man then begin//родоначальник
        iX2 := maxX + 200;
        iY2 := 10;
        ParentsY( iX2, iY2, distMans.Strings[i], i);
      end;
      // сканирую только женские линии
      if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 2)) then
      if distGender.Strings[i] = Woman then begin//родоначальник
        iX2 := maxX + 200;
        iY2 := 10;
        ParentsY( iX2, iY2, distMans.Strings[i], i);
      end;
    end;
  end;
// чищу область рисования
  PaintTree.Width := 0;
  PaintTree.Height := 0;
  PaintTree.Picture := nil;
// задаю область рисования
  Ht := maxY + 300;
  Wt := maxX + 300;
  if ((Wt*Ht)>(MemAvail div 2)) then Wt := (MemAvail div 2) div Ht;
  done := True;
  while done do begin
   try
    done := False;
    PaintTree.Height := Ht;
    PaintTree.Width := Wt;
    PaintTree.Canvas.Pixels[0,0] := clWhite;// тест пам€ти
   except
    Ht := Ht - 100;
    Wt := Wt - 100;
    done := True;
   end;
  end;
  with PaintTree do begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(0,0,Wt,Ht);
  end;
// Рисую
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Style := psSolid;// сплошной линией
  PaintTree.Canvas.Pen.Width := LinWidth;// толщиной пикселя
  ProcessForm.Gauge1.Visible := True;
  ProcessForm.Gauge1.Min := 0;
  ProcessForm.Gauge1.Max := distMans.Count;
  maxY := 0;
  maxX := -190;
  for i := 0 to distMans.Count - 1 do begin
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    Inc(pos);
    if ((Empty(distFather.Strings[i]))
     and (Empty(distMother.Strings[i]))) then begin
      // сканирую только мужские линии
      if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then
      if distGender.Strings[i] = Man then begin//родоначальник
        Ons := true;
        iX2 := maxX + 200;
        iY2 := 10;
        ParentsChilds( iX2, iY2, distMans.Strings[i], i);
      end;
      // сканирую только женские линии
      if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 2)) then
      if distGender.Strings[i] = Woman then begin//родоначальник
        Ons := true;
        iX2 := maxX + 200;
        iY2 := 10;
        ParentsChilds( iX2, iY2, distMans.Strings[i], i);
      end;
    end;
  end;
//уничтожаю элементы списка
  MensCnt := Mens.Count;
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    MensM[i] := pMen^.Men;//копирую координаты
    MensX[i] := pMen^.X;
    MensY[i] := pMen^.Y;
    Dispose(pMen);// уничтожаю элемент
  end;
//уничтожаю список
  Mens.Free;
// удаляю массив
  distIndex.Clear;
  distMans.Clear;
  distGender.Clear;
  distFather.Clear;
  distMother.Clear;
  distSpouse.Clear;
//
  ProcessForm.Hide;
  PaintTree.Visible := True;//на время рисования отключаю
  Cursor := crDefault;
end;

procedure TTreeBmpForm.DrawPaintTreeAaa;
var
  i, ii, c, cntL, cntR : Integer;
  s, ss : String;
  XmaxL, YmaxL : Integer;
  XmaxR, YmaxR : Integer;
  iXL, iYL : Integer;//лева€
  iXR, iYR : Integer;//права€
  Bougth, old : Integer;//номер ветви
  ht, wt : Integer;//размер области рисовани€
  done, b : Boolean;
  //сортирую список по дате рождени€
  function CompDate(Item1, Item2 : Pointer): Integer;
  var
    p1, p2 : ^TMens;
  begin
    p1 := Item1; p2 := Item2;
    if p1^.Dat < p2^.Dat then
      Result := -1
    else if p1^.Dat  > p2^.Dat then
      Result := 1
    else
      Result := 0;
  end;
  //сканирую только мужскую линию
  procedure ParentsFather( Nama: String; Index: Integer);
  var
    i : Integer;
  begin
    pMen := Mens[Index];
    pMen^.Yes := Bougth;//запоминаю номер ветки
    for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if listFather.Strings[pMen^.Men] = Nama then// ищу всех детей
        ParentsFather( listMans.Strings[pMen^.Men], i);
    end;
  end;
  //сканирую мужскую линию по женской
  procedure ParentsFatherDau( Nama: String; Index: Integer; Sexs: Integer);
  var
    i, x : Integer;
  begin
    pMen := Mens[Index];
    if ((Sexs = 0) or ((Sexs = 1) and (pMen^.Yes = 0))) then begin
     x := pMen^.Sex;
     pMen^.Yes := Bougth;//запоминаю номер ветки
     for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if ((listFather.Strings[pMen^.Men] = Nama)
       or (listMother.Strings[pMen^.Men] = Nama)) then// ищу всех детей
        ParentsFatherDau( listMans.Strings[pMen^.Men], i, x);
     end;
    end;
  end;
  //сканирую только женскую линию
  procedure ParentsMother( Nama: String; Index: Integer);
  var
    i : Integer;
  begin
    pMen := Mens[Index];
    if pMen^.Yes > 0 then exit;
    pMen^.Yes := Bougth;//запоминаю номер ветки
    for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if listMother.Strings[pMen^.Men] = Nama then// ищу всех детей
        ParentsMother( listMans.Strings[pMen^.Men], i);
    end;
  end;
  //сканирую женскую линию по мужской
  procedure ParentsMotherSon( Nama: String; Index: Integer; Sexs: Integer);
  var
    i, x : Integer;
  begin
    pMen := Mens[Index];
    if (((Sexs = 1) and (pMen^.Yes = Bougth)) or ((Sexs = 0) and (pMen^.Yes = 0))) then begin
     x := pMen^.Sex;
     pMen^.Yes := Bougth;//запоминаю номер ветки
     for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if ((listFather.Strings[pMen^.Men] = Nama)
       or (listMother.Strings[pMen^.Men] = Nama)) then// ищу всех детей
        ParentsMotherSon( listMans.Strings[pMen^.Men], i, x);
     end;
    end;
  end;
  //заполн€ю координаты
  procedure ParentsAlls( var X: Integer; const Y: Integer; Nama: String; Index: Integer; LR: Boolean);
  var
    i, cnt : Integer;
  begin
    pMen := Mens[Index];
    if pMen^.Yes <> Bougth then exit;//если ветка закончилась
    pMen^.Y := Y;//запоминаю
    pMen^.X := X;
    if LR then begin
      if X > XmaxR then XmaxR := X;
      if Y > YmaxR then YmaxR := Y;
    end else begin
      if X < XmaxL then XmaxL := X;
      if Y > YmaxL then YmaxL := Y;
    end;
    cnt := 0;
    for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if ((listFather.Strings[pMen^.Men] = Nama)
       or (listMother.Strings[pMen^.Men] = Nama)) then begin// ищу всех детей
        if pMen^.Yes = Bougth then
        if LR then begin
          if cnt<>0 then X := X + 200 else X := X + 100;
          ParentsAlls( X, Y + 60, listMans.Strings[pMen^.Men], i, LR);
        end else begin
          if cnt<>0 then X := X - 200 else X := X - 100;
          ParentsAlls( X, Y + 60, listMans.Strings[pMen^.Men], i, LR);
        end;
        Inc(cnt);
      end;
    end;
  end;
  //св€зываю человека со стволом древа
  procedure LinkTree( Index, Count: Integer);
  var
   pMen1 : ^TMens;
  begin
    PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
//    if Count >= 0// ветки рисую зеленым и светлее
//      then PaintTree.Canvas.Pen.Color := ClrSlightlyDark( GetLightColor( clGreen, Count))
//      else PaintTree.Canvas.Pen.Color := ClrSlightlyDark( GetLightColor( clGreen, -Count));
    pMen1 := Mens[Index];
    if pMen1^.X > 0 then begin
      PaintTree.Canvas.MoveTo( LinWidth*Count-XmaxL, PaintTree.Height);
      PaintTree.Canvas.LineTo( LinWidth*Count-XmaxL, pMen1^.Y+37);
      Arc2( LinWidth*Count-XmaxL, pMen1^.Y+32);
      PaintTree.Canvas.MoveTo( LinWidth*Count-XmaxL+8,pMen1^.Y+32);
      PaintTree.Canvas.LineTo( pMen1^.X-XmaxL+1,pMen1^.Y+32);
      ImageList5.Draw( PaintTree.Canvas, LinWidth*Count-XmaxL, pMen1^.Y-6, 3); //листочки
    end else begin
      PaintTree.Canvas.MoveTo( LinWidth*Count-XmaxL, PaintTree.Height);
      PaintTree.Canvas.LineTo( LinWidth*Count-XmaxL, pMen1^.Y+37);
      Arc3( LinWidth*Count-XmaxL-19, pMen1^.Y+32);
      PaintTree.Canvas.MoveTo( LinWidth*Count-XmaxL-10,pMen1^.Y+32);
      PaintTree.Canvas.LineTo( pMen1^.X-XmaxL+189,pMen1^.Y+32);
      ImageList5.Draw( PaintTree.Canvas, LinWidth*Count-XmaxL-50, pMen1^.Y-6, 2); //листочки
    end;
  end;
  //св€зываю родител€ (отца) с ребенком
  procedure LinkFather( Nama: String; iParent, iChild : Integer);
  var
    pMenC : ^TMens;
    pMenF : ^TMens;
    i : Integer;
  begin
    if pMen^.Yes <> Bougth then exit;//если ветка закончилась
    if ((pMen^.Father <> -1) or (pMen^.Mother <> -1)) then begin
     pMenC := Mens[iParent];
     pMenF := Mens[iChild];
     PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
     if pMenF^.X > 0 then begin
      PaintTree.Canvas.MoveTo( pMenC^.X-XmaxL+98, pMenC^.Y+60);
      PaintTree.Canvas.LineTo( pMenC^.X-XmaxL+98, pMenF^.Y+23);
      Arc4( pMenC^.X-XmaxL+79, pMenF^.Y+12);
      PaintTree.Canvas.MoveTo( pMenC^.X-XmaxL+87, pMenF^.Y+32);
      PaintTree.Canvas.LineTo( pMenF^.X-XmaxL+193, pMenF^.Y+32);
      ImageList3.Draw( PaintTree.Canvas, pMenC^.X-XmaxL+99, pMenF^.Y-9, 3);
     end else begin
      PaintTree.Canvas.MoveTo( pMenC^.X-XmaxL+92, pMenC^.Y+60);
      PaintTree.Canvas.LineTo( pMenC^.X-XmaxL+92, pMenF^.Y+23);
      Arc1( pMenC^.X-XmaxL+92, pMenF^.Y+12);
      PaintTree.Canvas.MoveTo( pMenC^.X-XmaxL+101, pMenF^.Y+32);
      PaintTree.Canvas.LineTo( pMenF^.X-XmaxL+3, pMenF^.Y+32);
      ImageList3.Draw( PaintTree.Canvas, pMenC^.X-XmaxL+54, pMenF^.Y-9, 2);
     end;
    end;
    for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if ((listFather.Strings[pMen^.Men] = Nama)
       or (listMother.Strings[pMen^.Men] = Nama)) then
        LinkFather( listMans.Strings[pMen^.Men], i, iParent);
    end;
  end;
  //св€зываю родител€ (мать) с ребенком
  procedure LinkMother( iParent, iChild : Integer);
  var
    pMenC : ^TMens;
    pMenF : ^TMens;
    i : Integer;
  begin
    for i := 0 to Mens.Count-1 do begin
      pMenF := Mens[i];
      if pMenF^.Men = iParent then break;
    end;
    if i = Mens.Count then exit;//
    if ((pMenF^.Father=-10) and (pMenF^.Mother=-10)) then exit;
    pMenC := Mens[iChild];
    if pMenC^.Yes = pMenF^.Yes then exit;
    CircleArc( PaintTree.Canvas, pMenF^.X-XmaxL+7, pMenF^.Y+12, pMenC^.X-XmaxL+96, pMenC^.Y+12, Round(2*Sqrt(sqr(pMenC^.X - pMenF^.X)+sqr(pMenC^.Y - pMenF^.Y))),clLime);
    //??Circler( PaintTree.Canvas, pMenC^.X-XmaxL+91, pMenC^.Y+16, 5,Pi/2,Pi*3/2,clGreen);
  end;
  procedure LinkMatrimony( iMan, iWoman : Integer);
  var
    pMenC : ^TMens;
    pMenF : ^TMens;
    i : Integer;
  begin
    for i := 0 to Mens.Count-1 do begin//ищу координаты мужчины в списке
      pMenF := Mens[i];
      if pMenF^.Men = iMan then break;
    end;
    if i = Mens.Count then exit;//
    for i := 0 to Mens.Count-1 do begin//ищу координаты женщины в списке
      pMenC := Mens[i];
      if pMenC^.Men = iWoman then break;
    end;
    if i = Mens.Count then exit;//
    CircleArc( PaintTree.Canvas, pMenF^.X-XmaxL+96, pMenF^.Y+18, pMenC^.X-XmaxL+96, pMenC^.Y+18, Round(2*Sqrt(sqr(pMenC^.X - pMenF^.X)+sqr(pMenC^.Y - pMenF^.Y))),clYellow);
  end;
begin
  Cursor := crHourGlass;
// чищу область рисовани€
  PaintTree.Width := 0;
  PaintTree.Height := 0;
  PaintTree.Picture := nil;
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := 12 * listMans.Count;
  GaugePos := 0;
//создаю списки
  Mens := TList.Create;//всех членов
  MaWs := TList.Create;//мужей и жен
//заполн€ю элементы списка
  for i := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    New(pMen);
    pMen^.Men := i;
    if not Empty(listBirth.Strings[i])
      then pMen^.Dat := Date()//??StrRusDate( listBirth.Strings[i])
      else pMen^.Dat := Date();
    if listGender.Strings[i] = Man then pMen^.Sex := 0
    else if listGender.Strings[i] = Woman then pMen^.Sex := 1
    else pMen^.Sex := -1;
    if not Empty(listMans.Strings[i]) then begin
      if TuneForm.TreeFaMo.ItemIndex = 0 then begin
        pMen^.Father := iRetrFather(listFather.Strings[i]);
        pMen^.Mother := iRetrMother(listMother.Strings[i]);
      end else if TuneForm.TreeFaMo.ItemIndex = 1 then begin
        if (Empty(listFather.Strings[i]) and Empty(listMother.Strings[i]) and (listGender.Strings[i] <> Man)) then begin
          pMen^.Father := -10;
          pMen^.Mother := -10;
        end else begin
          pMen^.Father := iRetrFather(listFather.Strings[i]);
          pMen^.Mother := iRetrMother(listMother.Strings[i]);
        end;
      end else if TuneForm.TreeFaMo.ItemIndex = 2 then begin
        if (Empty(listFather.Strings[i]) and Empty(listMother.Strings[i]) and (listGender.Strings[i] <> Woman)) then begin
          pMen^.Father := -10;
          pMen^.Mother := -10;
        end else begin
          pMen^.Father := iRetrFather(listFather.Strings[i]);
          pMen^.Mother := iRetrMother(listMother.Strings[i]);
        end;
      end;
    end else begin
      pMen^.Father := -10;
      pMen^.Mother := -10;
    end;
    pMen^.X := 0;
    pMen^.Y := 0;
    pMen^.Yes := 0;
    Mens.Add(pMen);
  end;
//сортирую по дате рождени€
  //??Mens.Sort(@CompDate);
//сканирую только мужские линии
  Bougth := 0;//номер ветви
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)) then
    if (pMen^.Sex = 0) then begin//родоначальник
      Inc(Bougth);
      ParentsFather( listMans.Strings[pMen^.Men], i);
    end;
  end;
//сканирую мужскую линию по женской
  Bougth := 0;//номер ветви
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)) then
    if (pMen^.Sex = 0) then begin//родоначальник
      Inc(Bougth);
      ParentsFatherDau( listMans.Strings[pMen^.Men], i, pMen^.Sex);
    end;
  end;
//сканирую только женские линии
  old := Bougth;
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)) then
    if (pMen^.Sex = 1) then begin//родоначальница
      Inc(Bougth);
      ParentsMother( listMans.Strings[pMen^.Men], i);
    end;
  end;
//сканирую женскую линии по мужской
  Bougth := old;
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)) then
    if (pMen^.Sex = 1) then begin//родоначальница
      Inc(Bougth);
      ParentsMotherSon( listMans.Strings[pMen^.Men], i, pMen^.Sex);
    end;
  end;
//составл€ю список мужей и жен
  for i := 0 to listMans.Count - 1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    if not Empty(listSpouse.Strings[i]) then begin
      if listGender.Strings[i] = Man then MaW.man := i//индекс члена
      else if listGender.Strings[i] = Woman then MaW.woman := i;
      ss := listSpouse.Strings[i];
      repeat
        ii := Pos(rzd2, ss);
        if ii > 0 then begin
          s := Copy(ss,1,ii-1);
          ss := Copy(ss,ii+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then begin//индекс супруги(а)
          if listGender.Strings[i] = Man then MaW.woman := iRetrNama(s)
          else if listGender.Strings[i] = Woman then MaW.man := iRetrNama(s);
        end;
        b := True;//провер€ю нет ли такой пары
        for c := 0 to MaWs.Count-1 do begin
          pMaW := MaWs[c];
          if (pMaW^.man = MaW.man) and (pMaW^.woman = MaW.woman) then begin
            b := False;
            break;
          end;
        end;
        if b then begin//если нет добавл€ю в список
          New(pMaW);
          pMaW^.Man := MaW.man;
          pMaW^.Woman := MaW.woman;
          MaWs.Add(pMaW);
        end;
      until ii=0
    end;
  end;
//заполн€ю координаты
  XmaxL := 0; YmaxL := 0;
  XmaxR := 0; YmaxR := 0;
  cntL := 0; cntR := 0;
  LeftRight := False;//начинаю с левой ветви
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)) then begin
      Bougth := pMen^.Yes;
      if LeftRight then begin
        iYR := YmaxR + 60;
        iXR := cntR * delta + 40;
        ParentsAlls( iXR, iYR, listMans.Strings[pMen^.Men], i, LeftRight);
        Inc(cntR);
        LeftRight := False;
      end else begin
        iYL := YmaxL + 60;
        iXL := cntL * delta - 230;
        ParentsAlls( iXL, iYL, listMans.Strings[pMen^.Men], i, LeftRight);
        Dec(cntL);
        LeftRight := True;
      end;
    end;
  end;
//отступ слева цент отступ с справа
  if listMans.Count < 100 then begin
    YmaxL := YmaxL + 50;
    YmaxR := YmaxR + 50;
  end;
  if YmaxL > YmaxR
    then Ht := YmaxL+5
    else Ht := YmaxR+5;
  XmaxR := XmaxR+220;
  XmaxL := XmaxL-30;
  Wt := XmaxR - XmaxL;
  if ((Wt*Ht)>(MemAvail div 2)) then Wt := (MemAvail div 2) div Ht;
  done := True;
  while done do begin
   try
    done := False;
    PaintTree.Height := Ht;
    PaintTree.Width := Wt;
    PaintTree.Canvas.Pixels[0,0] := clWhite;// тест пам€ти
   except
    Ht := Ht - 100;
    Wt := Wt - 100;
    done := True;
   end;
  end;
  with PaintTree do begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(0,0,Wt,Ht);
  end;
// инверси€
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    if pMen^.Yes <> 0 then pMen^.Y := PaintTree.Height - pMen^.Y;
    if pMen^.X >= 0 then pMen^.X := pMen^.X + LinWidth * cntR;
    if pMen^.X < 0 then pMen^.X := pMen^.X + LinWidth * cntL;
  end;
// ѕараметры рисовани€
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Style := psSolid;  // сплошной линией
  PaintTree.Canvas.Pen.Width := LinWidth; // толщиной 3 пиксел€
  PaintTree.Visible := False;//на врем€ рисовани€ отключаю
// св€зываю супругов
  if TuneForm.TreeFaMo.ItemIndex = 0 then
  for i := 0 to MaWs.Count-1 do begin
    pMaW := MaWs[i];
    LinkMatrimony(pMaw^.man,pMaw^.woman);
  end;
// св€зываю родител€(мать) с ребенком
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if pMen^.Father > -1 then LinkMother( pMen^.Father, i);
    if pMen^.Mother > -1 then LinkMother( pMen^.Mother, i);
  end;
// св€зываю родител€(отца) с ребенком
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)) then begin
      Bougth := pMen^.Yes;
      LinkFather( listMans.Strings[pMen^.Men], i, 0);
    end;
  end;
// св€зываю родоначальников с древом
  Inc(cntL);
  LeftRight := False;//начинаю с левой ветви
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)) then
    if LeftRight then begin
      LinkTree( i, cntR);
      Dec(cntR);
      LeftRight := False;
    end else begin
      LinkTree( i, cntL);
      Inc(cntL);
      LeftRight := True;
    end;
  end;
// –исую ‘»ќ
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    pMen^.X := pMen^.X - XmaxL;
  end;
  for i := 0 to Mens.Count-1 do begin//рисую
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    pMen := Mens[i];
    if pMen^.Yes <> 0 then begin
      DrawMen( pMen^.Men, pMen^.X{ - XmaxL}, pMen^.Y, listMans.Strings[pMen^.Men], pMen^.Sex);
    end;
  end;
//уничтожаю элементы списка
  for i := 0 to MaWs.Count-1 do begin
    pMaW := MaWs[i];
    Dispose(pMaW);
  end;
  MaWs.Free;//уничтожаю список
  MensCnt := Mens.Count;
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    MensM[i] := pMen^.Men;//копирую координаты
    MensX[i] := pMen^.X;
    MensY[i] := pMen^.Y;
    Dispose(pMen);// уничтожаю элемент
  end;
  Mens.Free;//уничтожаю список
// закрытие окна
  ProcessForm.Hide;
  PaintTree.Visible := True;
  Cursor := crDefault;
end;

procedure TTreeBmpForm.DrawPaintTreeAll;
var
  i, cnt : Integer;
  dltTL : Integer;      // делта левой части ствола
  dltTR : Integer;      // делта правой части ствола
  dlt : Integer;        // делта кроны, левой и правой части древа
  iSdlt : Boolean;      // надо ли увеличивать дельту
  alfa : Integer;       // центральна€ ось X
  cFather : Integer;    //количество отцов
  cMother : Integer;    //количество метерей
  Xmax : Integer;       //правый
  Xmin : Integer;       //левый
  Ymax : Integer;       //высота
  ht, wt : Integer;     //размер области рисовани€
  done : Boolean;
  //сортирую список по отцу
  function CompFather(Item1, Item2 : Pointer): Integer;
  var
    p1 : ^TMens;
    p2 : ^TMens;
  begin
    p1 := Item1;
    p2 := Item2;
    if p1^.Father < p2^.Father then
      Result := -1
    else if p1^.Father > p2^.Father then
      Result := 1
    else
      Result := 0;
  end;
  //сортирую список по матери
  function CompMother(Item1, Item2 : Pointer): Integer;
  var
    p1 : ^TMens;
    p2 : ^TMens;
  begin
    p1 := Item1;
    p2 := Item2;
    if p1^.Mother < p2^.Mother then
      Result := -1
    else if p1^.Mother > p2^.Mother then
      Result := 1
    else
      Result := 0;
  end;
  //св€зываю человека со стволом древа
  procedure LinkTree( iChild, iFather: Integer);
  var
   pMen1 : ^TMens;
  begin
    pMen1 := Mens[iChild];
    if (pMen1^.X+pMen1^.Y <> 0) then begin
      PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
      if pMen1^.X > 0 then begin
        PaintTree.Canvas.MoveTo(15+LinWidth*dltTR+alfa,pMen1^.Y+3);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa+16,pMen1^.Y+3);
        PaintTree.Canvas.MoveTo( 5+LinWidth*dltTR+alfa,pMen1^.Y+13);
        PaintTree.Canvas.LineTo( 5+LinWidth*dltTR+alfa,Ymax+60);
        ImageList5.Draw( PaintTree.Canvas, 5+LinWidth*dltTR+alfa-3, pMen1^.Y-34, 3); //листочки
        Arc2( 5+LinWidth*dltTR+alfa, pMen1^.Y+3);
        Arc3( pMen1^.X+alfa+8, pMen1^.Y+3);
        Inc(dltTR);
      end else begin
        PaintTree.Canvas.MoveTo( pMen1^.X+alfa+179,pMen1^.Y+3);
        PaintTree.Canvas.LineTo(-5+LinWidth*dltTL+alfa,pMen1^.Y+3);
        PaintTree.Canvas.MoveTo( 5+LinWidth*dltTL+alfa,pMen1^.Y+13);
        PaintTree.Canvas.LineTo( 5+LinWidth*dltTL+alfa,Ymax+60);
        ImageList5.Draw( PaintTree.Canvas, -15+LinWidth*dltTL+alfa-26, pMen1^.Y-34, 2); //листочки
        Arc2( pMen1^.X+alfa+169, pMen1^.Y+3);
        Arc3( -15+LinWidth*dltTL+alfa, pMen1^.Y+3);
        Dec(dltTL);
      end;
    end;
  end;
  //св€зываю отца/мать с ребенком
  procedure LinkFather( iChild, iFather: Integer);
  var
   pMen1 : ^TMens;
   pMen2 : ^TMens;
  begin
    pMen1 := Mens[iChild];
    pMen2 := Mens[iFather];
    if (pMen1^.X+pMen1^.Y <> 0) then begin
      PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
      if pMen1^.X > 0 then begin
       if pMen1^.Y > pMen2^.Y then begin
        Arc3( pMen1^.X+alfa+8, pMen1^.Y+3);        // ветка вниз
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa-15,pMen1^.Y+3);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa+16,pMen1^.Y+3);
        Arc1( pMen1^.X+alfa-26, pMen1^.Y-16);      // ветка вверх
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa-26,pMen1^.Y-5);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa-26,pMen2^.Y+55);
        Arc2( pMen2^.X+alfa-3, pMen2^.Y+43);
        ImageList3.Draw( PaintTree.Canvas, pMen1^.X+alfa-63, pMen1^.Y-43, 2);
       end else begin
        Arc3( pMen1^.X+alfa+8, pMen1^.Y+3);        // ветка вниз
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa-18,pMen1^.Y+3);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa+16,pMen1^.Y+3);
        Arc2( pMen1^.X+alfa-29, pMen1^.Y+3);      // ветка вверх
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa-30,pMen1^.Y+14);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa-30,pMen2^.Y+36);
        Arc1( pMen2^.X+alfa-6, pMen2^.Y+24);
        ImageList3.Draw( PaintTree.Canvas, pMen1^.X+alfa-67, pMen1^.Y-23, 2);
       end;
      end else begin
       if pMen1^.Y > pMen2^.Y then begin
        Arc2( pMen1^.X+alfa+166, pMen1^.Y+3);        // ветка вниз
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa+175,pMen1^.Y+3);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa+213,pMen1^.Y+3);
        Arc4( pMen1^.X+alfa+200, pMen1^.Y-16);      // ветка вверх
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa+219,pMen1^.Y-5);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa+219,pMen2^.Y+55);
        Arc3( pMen2^.X+alfa+177, pMen2^.Y+43);
        ImageList3.Draw( PaintTree.Canvas,  pMen1^.X+alfa+220, pMen1^.Y-43, 3);
       end else begin
        Arc2( pMen1^.X+alfa+166, pMen1^.Y+3);        // ветка вниз
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa+175,pMen1^.Y+3);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa+215,pMen1^.Y+3);
        Arc3( pMen1^.X+alfa+203, pMen1^.Y+3);      // ветка вверх
        PaintTree.Canvas.MoveTo(pMen1^.X+alfa+223,pMen1^.Y+14);
        PaintTree.Canvas.LineTo(pMen1^.X+alfa+223,pMen2^.Y+36);
        Arc4( pMen2^.X+alfa+180, pMen2^.Y+24);
        ImageList3.Draw( PaintTree.Canvas,  pMen1^.X+alfa+224, pMen1^.Y-23, 3);
       end;
      end;
    end;
  end;
  //св€зываю мать/отца с ребенком
  procedure LinkMother( iChild, iMother: Integer);
  var
   pMen1 : ^TMens;
   pMen2 : ^TMens;
  begin
    pMen1 := Mens[iChild];
    pMen2 := Mens[iMother];
    if (((pMen1^.X+pMen1^.Y) <> 0) and ((pMen2^.X+pMen2^.Y) <> 0)) then begin
      if isdlt then Inc(dlt);
      PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
      if pMen1^.X > 0 then begin                //если ребенок справа
        if (pMen1^.Y < pMen2^.Y) then begin     //если родитель ниже ребенка
          if pMen2^.X > 0 then begin            //если родитель справа
            Arc2( pMen1^.X+alfa+28, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+35,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+178,pMen1^.Y+3);
            Arc3(Xmax+alfa+dlt*delta+168, pMen1^.Y+3);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+22, pMen1^.Y-7, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+188,pMen1^.Y+12);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+188,pMen2^.Y+23);
            Arc4(Xmax+alfa+dlt*delta+168, pMen2^.Y+14);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+22, pMen2^.Y+2, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+178,pMen2^.Y+33);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+187, pMen2^.Y+33);
          end else begin                        //если родитель слева
            Arc2( pMen1^.X+alfa+28, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+35,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+178,pMen1^.Y+3);
            Arc4(Xmax+alfa+dlt*delta+168, pMen1^.Y-16);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+20, pMen1^.Y-25, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+188,pMen1^.Y-3);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+188,dlt*delta+10);
            Arc3(Xmax+alfa+dlt*delta+168, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+178, dlt*delta);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta+10, dlt*delta);
            Arc2(Xmin+alfa-dlt*delta, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta, dlt*delta+10);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta, pMen2^.Y+26);
            Arc1(Xmin+alfa-dlt*delta, pMen2^.Y+16);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen2^.Y+5, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta+10, pMen2^.Y+36);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+6, pMen2^.Y+36);
          end;
        end else begin                          //если родитель выше ребенка
          if pMen2^.X > 0 then begin            //если ребенок справа
            Arc2( pMen1^.X+alfa+28, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+35,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+178,pMen1^.Y+3);
            Arc4(Xmax+alfa+dlt*delta+168, pMen1^.Y-16);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+22, pMen1^.Y-25, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+188,pMen1^.Y-5);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+188,pMen2^.Y+40);
            Arc3(Xmax+alfa+dlt*delta+168, pMen2^.Y+33);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+22, pMen2^.Y+18, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+178,pMen2^.Y+33);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+187, pMen2^.Y+33);
          end else begin                        //если ребенок слева
            Arc2( pMen1^.X+alfa+28, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+35,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+178,pMen1^.Y+3);
            Arc4(Xmax+alfa+dlt*delta+168, pMen1^.Y-16);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+20, pMen1^.Y-25, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+188,pMen1^.Y-3);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+188,dlt*delta+10);
            Arc3(Xmax+alfa+dlt*delta+168, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+178, dlt*delta);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta+10, dlt*delta);
            Arc2(Xmin+alfa-dlt*delta, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta, dlt*delta+10);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta, pMen2^.Y+26);
            Arc1(Xmin+alfa-dlt*delta, pMen2^.Y+16);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen2^.Y+5, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta+10, pMen2^.Y+36);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+6, pMen2^.Y+36);
          end;
        end;
      end else begin                            //если ребенок слева
        if (pMen1^.Y < pMen2^.Y) then begin     //если родитель ниже ребенка
          if pMen2^.X < 0 then begin            //если родитель слева
            Arc3(pMen1^.X+alfa+148, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+155,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta+10,pMen1^.Y+3);
            Arc2(Xmin+alfa-dlt*delta, pMen1^.Y+3);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen1^.Y-4, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta,pMen1^.Y+13);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta,pMen2^.Y+20);
            Arc1(Xmin+alfa-dlt*delta, pMen2^.Y+13);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen2^.Y+3, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta+10,pMen2^.Y+33);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+5,pMen2^.Y+33);
          end else begin                        //если родитель справа
            Arc3(pMen1^.X+alfa+148, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+155,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta+10,pMen1^.Y+3);
            Arc1(Xmin+alfa-dlt*delta, pMen1^.Y-16);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen1^.Y-25, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta, dlt*delta+10);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta, pMen1^.Y-3);
            Arc2(Xmin+alfa-dlt*delta, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta+10, dlt*delta);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+178, dlt*delta);
            Arc3(Xmax+alfa+dlt*delta+168, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+188, dlt*delta+10);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+188, pMen2^.Y+26);
            Arc4(Xmax+alfa+dlt*delta+168, pMen2^.Y+16);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+20, pMen2^.Y+5, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+178, pMen2^.Y+36);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+187, pMen2^.Y+36);
          end;
        end else begin                          //если родитель выше ребенка
          if pMen2^.X < 0 then begin            //если родитель слева
            Arc3( pMen1^.X+alfa+148, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+155,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta+10,pMen1^.Y+3);
            Arc1(Xmin+alfa-dlt*delta, pMen1^.Y-16);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen1^.Y-23, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta,pMen1^.Y-3);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta,pMen2^.Y+43);
            Arc2(Xmin+alfa-dlt*delta, pMen2^.Y+33);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen2^.Y+23, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta+10,pMen2^.Y+33);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+5,pMen2^.Y+33);
          end else begin                        //если родитель справа
            Arc3( pMen1^.X+alfa+148, pMen1^.Y+3);
            PaintTree.Canvas.MoveTo(pMen1^.X+alfa+155,pMen1^.Y+3);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta+10,pMen1^.Y+3);
            Arc1(Xmin+alfa-dlt*delta, pMen1^.Y-16);
            ImageList1.Draw( PaintTree.Canvas, Xmin+alfa-dlt*delta-23, pMen1^.Y-25, 2);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta, dlt*delta+10);
            PaintTree.Canvas.LineTo(Xmin+alfa-dlt*delta, pMen1^.Y-3);
            Arc2(Xmin+alfa-dlt*delta, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmin+alfa-dlt*delta+10, dlt*delta);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+178, dlt*delta);
            Arc3(Xmax+alfa+dlt*delta+168, dlt*delta);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+188, dlt*delta+10);
            PaintTree.Canvas.LineTo(Xmax+alfa+dlt*delta+188, pMen2^.Y+26);
            Arc4(Xmax+alfa+dlt*delta+168, pMen2^.Y+16);
            ImageList1.Draw( PaintTree.Canvas, Xmax+alfa+dlt*delta+168+20, pMen2^.Y+5, 3);
            PaintTree.Canvas.MoveTo(Xmax+alfa+dlt*delta+178, pMen2^.Y+36);
            PaintTree.Canvas.LineTo(pMen2^.X+alfa+187, pMen2^.Y+36);
          end;
        end;
      end;
    end;
  end;
  //заполн€ю координаты
  procedure ParentsMens(const X, Y: Integer; Nama: String; Index: Integer);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
  begin
    iNam := -1;
    if X > Xmax then Xmax := X;
    if X < Xmin then Xmin := X;
    if iY1 > Ymax then Ymax := iY1;
    if iY2 > Ymax then Ymax := iY2;
    // отец или мать
    pMen := Mens[Index];
    if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin
      if listGender.Strings[Index] = Man then begin
        pMen^.X := X;
        if LeftRight then pMen^.Y := iY2 else pMen^.Y := iY1;
      end else
      if (pMen^.X+pMen^.Y) = 0 then begin
        pMen^.X := X;
        if LeftRight then pMen^.Y := iY2 else pMen^.Y := iY1;
      end;
    end else begin
      if listGender.Strings[Index] = Woman then begin
        pMen^.X := X;
        if LeftRight then pMen^.Y := iY2 else pMen^.Y := iY1;
      end else
      if (pMen^.X+pMen^.Y) = 0 then begin
        pMen^.X := X;
        if LeftRight then pMen^.Y := iY2 else pMen^.Y := iY1;
      end;
    end;
    if LeftRight then iCol := iY2+61 else iCol := iY1+61;
    for iRow := 0 to listMans.Count-1 do begin
      // ищу всех детей мужской линии
      if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Nama then begin
          iPar := iRetrMother(listMother.Strings[iRow]);
          if iNam <> iPar then begin// мать
            iNam := iPar;
          end;
          if LeftRight then begin
            iY2 := iY2 + 60;
            ParentsMens( X+23, iCol-7, listMans.Strings[iRow], iRow);
          end else begin
            iY1 := iY1 + 60;
            ParentsMens( X-23, iCol-7, listMans.Strings[iRow], iRow);
          end;
        end;
      end;
      // ищу всех детей женской линии
      if TuneForm.TreeFaMo.ItemIndex = 2 then
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Nama then begin
          iPar := iRetrFather(listFather.Strings[iRow]);
          if iNam <> iPar then begin// отец
            iNam := iPar;
          end;
          if LeftRight then begin
            iY2 := iY2 + 60;
            ParentsMens( X+23, iCol-7, listMans.Strings[iRow], iRow);
          end else begin
            iY1 := iY1 + 60;
            ParentsMens( X-23, iCol-7, listMans.Strings[iRow], iRow);
          end;
        end;
      end;
    end;
  end;
  //количество отцов
  function CntFather : Integer;
  var
    i, cnt : Integer;
  begin
    cnt := 0;
    Result := 0;
    for i := 0 to listMans.Count - 1 do begin
      pMen := Mens[i];
      if (pMen^.Father <> -1) then
      if (pMen^.Father <> cnt) then begin
        Inc(Result);
        cnt := pMen^.Father;
      end;
    end;
  end;
  //количество матерей
  function CntMother : Integer;
  var
    i, cnt : Integer;
  begin
    cnt := 0;
    Result := 0;
    for i := 0 to listMans.Count - 1 do begin
      pMen := Mens[i];
      if (pMen^.Mother <> -1) then
      if (pMen^.Mother <> cnt) then begin
        Inc(Result);
        cnt := pMen^.Mother;
      end;
    end;
  end;
begin
  Cursor := crHourGlass;
// чищу область рисовани€
  PaintTree.Width := 0;
  PaintTree.Height := 0;
  PaintTree.Picture := nil;
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := 4 * listMans.Count;
  GaugePos := 0;
//создаю списки
  Mens := TList.Create;
//заполн€ю элементы списка
  for i := 0 to listMans.Count - 1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    New(pMen);
    pMen^.Men := i;
    if listGender.Strings[i] = Man then pMen^.Sex := 0
    else if listGender.Strings[i] = Woman then pMen^.Sex := 1
    else pMen^.Sex := -1;
    if Trim(listMans.Strings[i]) <> ''
      then pMen^.Yes := 1
      else pMen^.Yes := -1;
    pMen^.Father := iRetrFather(listFather.Strings[i]);
    pMen^.Mother := iRetrMother(listMother.Strings[i]);
    pMen^.X := 0;
    pMen^.Y := 0;
    Mens.Add(pMen);
  end;
//сортирую список и выщитываю количество отцов и матерей
  if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin
    //??Mens.Sort(@CompFather);
    cFather := CntFather;
    //??Mens.Sort(@CompMother);
    cMother := CntMother;
  end else begin
    //??Mens.Sort(@CompMother);
    cMother := CntMother;
    //??Mens.Sort(@CompFather);
    cFather := CntFather;
  end;
//заполн€ю координаты
  Xmax := 0;
  Xmin := 0;
  Ymax := 0;
  if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin//отступ слева и справа от ствола
    iX1 := (-LinWidth*cFather div 3)-213;
    iX2 := (LinWidth*cFather div 3)+30;
  end else begin
    iX1 := (-LinWidth*cMother div 3)-213;
    iX2 := (LinWidth*cMother div 3)+30;
  end;
  if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin//отступ сверху
    iY1 := delta*(cFather+1) div 2;
    iY2 := delta*(cFather+1) div 2;
  end else begin
    iY1 := delta*(cMother+1) div 2;
    iY2 := delta*(cMother+1) div 2;
  end;
  LeftRight := False;//начинаю с левой ветви
  for i := 0 to listMans.Count - 1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)
     and ((pMen^.Sex = TuneForm.TreeFaMo.ItemIndex) or (pMen^.Sex = TuneForm.TreeFaMo.ItemIndex-1))
     and (pMen^.Yes = 1)) then begin
      if LeftRight then begin
        ParentsMens( iX2, iY2, listMans.Strings[pMen^.Men], pMen^.Men);
        iY2 := iY2 + 60;
        LeftRight := False;
      end else begin
        ParentsMens( iX1, iY1, listMans.Strings[pMen^.Men], pMen^.Men);
        iY1 := iY1 + 60;
        LeftRight := True;
      end;
    end;
  end;
// отступ слева цент отступ с справа
  if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin
    Wt := 2*(Xmax+(cMother div 2)*(delta+LinWidth)+300);
    Ht:= Ymax+60;
  end else begin
    Wt := 2*(Xmax+(cFather div 2)*(delta+LinWidth)+300);
    Ht:= Ymax+60;
  end;
  alfa := (Wt div 2);
  if ((Wt*Ht)>(MemAvail div 2)) then Wt := (MemAvail div 2) div Ht;
  done := True;
  while done do begin
   try
    done := False;
    PaintTree.Height := Ht;
    PaintTree.Width := Wt;
    PaintTree.Canvas.Pixels[0,0] := clWhite;// тест пам€ти
   except
    Ht := Ht - 100;
    Wt := Wt - 100;
    done := True;
   end;
  end;
  with PaintTree do begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(0,0,Wt,Ht);
  end;
// ѕараметры рисовани€
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Style := psSolid;  // сплошной линией
  PaintTree.Canvas.Pen.Width := LinWidth; // толщиной 3 пиксел€
// –исую св€зи
  cnt := -1;
  dltTL := 0;
  dltTR := 0;
  dlt := 0;
  PaintTree.Visible := False;//на врем€ рисовани€ отключаю
  for i := 0 to listMans.Count - 1 do begin//рисую
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if pMen^.Yes = 1 then begin
     if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin
      if pMen^.Father = -1
        then LinkTree( pMen^.Men, pMen^.Father)
        else LinkFather( pMen^.Men, pMen^.Father);
      if pMen^.Mother <> -1 then begin
        if (pMen^.Mother <> cnt) then begin
          cnt := pMen^.Mother;
          iSdlt := True;
        end else iSdlt := False;
        LinkMother( pMen^.Men, pMen^.Mother);
      end;
     end else begin
      if pMen^.Mother = -1
        then LinkTree( pMen^.Men, pMen^.Mother)
        else LinkFather( pMen^.Men, pMen^.Mother);
      if pMen^.Father <> -1 then begin
        if (pMen^.Father <> cnt) then begin
          cnt := pMen^.Father;
          iSdlt := True;
        end else iSdlt := False;
        LinkMother( pMen^.Men, pMen^.Father);
      end;
     end;
    end;
  end;
// –исую фио
  for i := 0 to Mens.Count-1 do begin//добавл€ю смщение к X
    pMen := Mens[i];
    pMen^.X := pMen^.X + alfa;
  end;
  for i := 0 to listMans.Count - 1 do begin//рисую
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.X-alfa)+pMen^.Y) <> 0 then
    if listGender.Strings[i] = Man
      then DrawMen( i, pMen^.X, pMen^.Y, listMans.Strings[i], 0)
      else DrawMen( i, pMen^.X, pMen^.Y, listMans.Strings[i], 1);
  end;
//уничтожаю элементы списка
  MensCnt := Mens.Count;
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    MensM[i] := pMen^.Men;//копирую координаты
    MensX[i] := pMen^.X;
    MensY[i] := pMen^.Y;
    Dispose(pMen);// уничтожаю элемент
  end;
  Mens.Free;//уничтожаю список
// закрытие окна
  ProcessForm.Hide;
  PaintTree.Visible := True;
  Cursor := crDefault;
end;

procedure TTreeBmpForm.AngleTextOut(CV: TCanvas; const sText: string; x, y, angle: integer);
var
  lf: TLogFont;
begin
  FillChar(lf, SizeOf(lf), 0);
  with lf do begin
    lfHeight := ScrollTree.Font.Size;// ¬ысота буквы
    lfWidth  := ScrollTree.Font.Size;// Ўирина буквы
    lfEscapement := angle;       // ”гол наклона в дес€тых градуса
    lfWeight := 1000;            // ∆ирность 0..1000, 0 - по умолчанию
    lfItalic := 0;               //  урсив
    lfUnderline := 0;            // ѕодчеркнут
    lfStrikeOut := 0;            // «ачеркнут
    lfCharSet := cst;            // CharSet
    StrCopy(lfFaceName, PChar(ScrollTree.Font.Name));// Ќазвание шрифта
  end;
  with CV do begin
//    FillRect(ClipRect);
    //??Font.Handle := CreateFontIndirect(lf);
    TextOut(x, y, sText);
  end;
end;

procedure TTreeBmpForm.DrawTextArc(CV: TCanvas; centerx, centery, rad : Integer; arcbeg, arcend : Real; sText : String);
var
  angle, duga : real;      //угол
  i, l, x, y : Integer;
  c : String;
begin
  l := Length(sText);
  angle := arcbeg - Pi;//начальный угол
  duga := Pi / (arcend - arcbeg);//шаг изменени€ угла
  for i := 1 to l do begin
    x := centerx + Round(rad * cos(angle));
    y := centery + Round(rad * sin(angle));
    c := sText[i];
    AngleTextOut(CV, c, centerx + x, centery+y, 0);
//    if angle > Pi/2 then
//      AngleTextOut(CV, c, centerx + x, centery+y, Round(angle)*150)
//    else
//      AngleTextOut(CV, c, centerx + x, centery+y, Round(angle)*150);
    angle:=angle+pi/(l * duga);//изменение угла
  end;
end;

procedure TTreeBmpForm.DrawPaintTreePeC;
var
  Sex : Integer;
  ht, wt, zentr : Integer;//размер области рисовани€
  done : Boolean;
  i, ii, p : Integer;
  level : Integer;
  peoples : TStringList;
  OldBkMode: integer;
  s, ss : String;
  ugl : Real;
  //вычисл€ю количество кругов дл€ генеалогического круга
  procedure ParentsHI( X, Y: Integer; Nama: String; Index: Integer);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
    One : Boolean;
  begin
    Inc(level);
    if peoples.Count < level then
      peoples.Add('');
    peoples.Strings[level-1] := peoples.Strings[level-1] + listMans.Strings[ Index] + '|';
    One := False;
    iNam := -1;
    if X > iX2 then iX2 := X;
    iCol := iY2+61;
    for iRow := 0 to listMans.Count - 1 do begin
      // ищу всех детей мужской линии
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Nama then begin
          iPar := iRetrMother(listMother.Strings[iRow]);
          if iNam <> iPar then begin
            if One then iY2 := iY2 + 60;
            One := True;
            iNam := iPar;
          end;
          iY2 := iY2 + 60;
          ParentsHI( X+23, iCol-7, listMans.Strings[iRow], iRow);
        end;
      end;
      // ищу всех детей женской линии
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Nama then begin
          iPar := iRetrFather(listFather.Strings[iRow]);
          if iNam <> iPar then begin
            if One then iY2 := iY2 + 60;
            One := True;
            iNam := iPar;
          end;
          iY2 := iY2 + 60;
          ParentsHI( X+23, iCol-7, listMans.Strings[iRow], iRow);
        end;
      end;
    end;
    Dec(level);
  end;
  procedure ParentsLO( X, Y: Integer; Nama: String; Index: Integer);
  var
    iRow : Integer;
  begin
    if ((Empty(listFather.Strings[ Index])) and (Empty(listMother.Strings[ Index]))) then Exit;
    Inc(level);
    if peoples.Count < level then
      peoples.Add('');
    if ((Empty(listMother.Strings[ Index])) and (not Empty(listFather.Strings[ Index]))) then begin
      peoples.Strings[level-1] := peoples.Strings[level-1] + listFather.Strings[ Index] + '|' + Space(Length(listFather.Strings[ Index])) + '|';
    end else
    if ((Empty(listFather.Strings[ Index])) and (not Empty(listMother.Strings[ Index]))) then begin
      peoples.Strings[level-1] := peoples.Strings[level-1] + Space(Length(listMother.Strings[ Index])) + '|' + listMother.Strings[ Index] + '|';
    end else begin
      peoples.Strings[level-1] := peoples.Strings[level-1] + listFather.Strings[ Index] + '|' + listMother.Strings[ Index] + '|';
    end;
    for iRow := 0 to listMans.Count - 1 do begin
      // ищу всех родителей
      if listMans.Strings[iRow] = listFather.Strings[ Index] then begin//отца
        ParentsLO( 0, 0, listMans.Strings[iRow], iRow);
      end;
      if listMans.Strings[iRow] = listMother.Strings[ Index] then begin//мать
        ParentsLO( 0, 0, listMans.Strings[iRow], iRow);
      end;
    end;
    Dec(level);
  end;
  function ASQN(cn : Integer) : Integer;
  begin
    if cn = 1 then
      Result := cn
    else
      Result := Round(Exp((cn-1)*Ln(2)));
  end;
  function CountZ(cns : String) : Integer;
  var
    n : Integer;
  begin
    Result := 0;
    for n := 1 to Length(cns) do
      if Copy(cns,n,1) = '|' then
        Inc(Result);
  end;
begin
  Cursor := crHourGlass;
// чищу область рисовани€
  PaintTree.Width := 0;
  PaintTree.Height := 0;
  PaintTree.Picture := nil;
//создаю списки
  Mens := TList.Create;
  peoples := TStringList.Create;
// ¬ычисл€ю количество кругов
  iX2 := 0;
  iY2 := 40;
  level := 0;
  if TuneForm.TreeHiLo.ItemIndex = 0 then begin
    peoples.Add(listMans.Strings[GridRow] + '|');
    Inc(level);
    ParentsLO( 30{X}, 0{Y}, listMans.Strings[GridRow], GridRow);
  end else begin
    ParentsHI( 30{X}, 0{Y}, listMans.Strings[GridRow], GridRow);
  end;
// задаю область рисовани€
  Ht := 120 * peoples.Count * 2 +25;
  Wt := 120 * peoples.Count * 2 +25;
  if ((Wt*Ht)>(MemAvail div 2)) then Wt := (MemAvail div 2) div Ht;
  done := True;
  while done do begin
   try
    done := False;
    PaintTree.Height := Ht;
    PaintTree.Width := Wt;
    PaintTree.Canvas.Pixels[0,0] := clWhite;// тест пам€ти
   except
    Ht := Ht - 120;
    Wt := Wt - 120;
    done := True;
   end;
  end;
  with PaintTree do begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(0,0,Wt,Ht);
  end;
// –исую
  iY2 := 40;
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Style := psSolid;// сплошной линией
  PaintTree.Canvas.Pen.Width := ScrollTree.Font.Size*3;// толщиной линии
  PaintTree.Canvas.Pen.Color := clGreen;// рамку рисую зеленым
  PaintTree.Canvas.Brush.Color := clMoneyGreen;// заливка
  //??OldBkMode := SetBkMode(PaintTree.Canvas.Handle, TRANSPARENT);
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := peoples.Count;
//
  zentr := Wt div 4;
  for i := peoples.Count-1 downto 0 do begin
    PaintTree.Canvas.Ellipse(zentr * 2 - (i + 1) * 120, zentr * 2 - (i + 1) * 120, zentr * 2 + (i + 1) * 120 + 2, zentr * 2 + (i + 1) * 120 + 2);
  end;
  for i := 0 to peoples.Count-1 do begin
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    s := peoples.Strings[i];
    ugl := 2 * Pi / (CountZ(s));//ASQN(i+1);
    for ii := 1 to CountZ(s){ASQN(i+1)} do begin
      p := Pos('|', s);
      if p = 0 then begin
        ss := Copy(s, p+1, Length(s));
        s := '';
      end else begin
        ss := Copy(s, 1, p-1);
        s := Copy(s, p+1, Length(s));
      end;
      p := iRetrNama(ss);
      ImageTmp.Picture := Nil;//чищу
      Family.ImageIcons.Draw( ImageTmp.Canvas, 0, 0, p);
      if not EmptyBMP(ImageTmp) then begin//иконка
        if i = 0 then
          Family.ImageIcons.Draw( PaintTree.Canvas, zentr * 2 - 32, zentr * 2 - 32, p)
        else
          Family.ImageIcons.Draw( PaintTree.Canvas, zentr * 2 + Round((i+1) * 120 * cos((ii - 1) * ugl - Pi) - 32), zentr * 2 + Round((i+1) * 120 * sin((ii - 1) * ugl - Pi) - 32), p);
      end;
      ss := ' ' + ss;
      DrawTextArc(PaintTree.Canvas, zentr - 2, zentr - 2, (i + 1) * 120, (ii - 1) * ugl, (ii - 1) * ugl + ugl, ss);
    end;
  end;
  //??SetBkMode(Handle, OldBkMode);
//уничтожаю элементы списка
  MensCnt := Mens.Count;
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    MensM[i] := pMen^.Men;//копирую координаты
    MensX[i] := pMen^.X;
    MensY[i] := pMen^.Y;
    Dispose(pMen);// уничтожаю элемент
  end;
  peoples.Free;
  Mens.Free;//уничтожаю список
  ProcessForm.Hide;// закрытие окна процесса
  Cursor := crDefault;
end;

procedure TTreeBmpForm.SaveButtonClick(Sender: TObject);
begin
  SavePictureDialog1.DefaultExt := '*.bmp';
  SavePictureDialog1.Filter := 'Bitmaps (*.bmp)|*.bmp';
  SavePictureDialog1.FileName := 'FamilyTree.bmp';
  if SavePictureDialog1.Execute then
    PaintTree.Picture.SaveToFile(UTF8toANSI(SavePictureDialog1.FileName));
end;

function TTreeBmpForm.StrNational(Nations : String): String;
var
  pNat : ^TNats;   //указатель
  Nats : TList;    //список национальность
  p : Integer;
  s, ss : String;
  n, nn : Integer;
  cntnat : Integer;
begin
  Result := '';
  if not Empty(Nations) then begin
    Nats := TList.Create;//создаю списки
    s := Nations;
    repeat
      p := Pos(';',s);
      if p > 0 then
        ss := Copy(s,1,p-1)
      else
        ss := s;
      s := Copy(s,p+1,32000);
      nn := -1;
      for n := 0 to Nats.Count-1 do begin//провер€ю список национальностей
        pNat := Nats[n];
        if pNat^.nat = ss then begin
          nn := n;
          break;
        end;
      end;
      if nn = -1 then begin//добавл€ю в список
        if not Empty(ss) then begin
          New(pNat);
          pNat^.cnt := 1;
          pNat^.nat := ss;
          Nats.Add(pNat);
        end;
      end else begin
        pNat^.cnt := pNat^.cnt + 1;
      end;
    until p < 1;
    cntnat := 0;
    for n := 0 to Nats.Count-1 do begin//количество национальностей
      pNat := Nats[n];
      cntnat := cntnat + pNat^.cnt;
    end;
    for n := 0 to Nats.Count-1 do begin
      pNat := Nats[n];
      Result := Result + IntToStr(pNat^.cnt*100 div cntnat) +'%-'+ pNat^.nat + '; ';
    end;
    Nats.Free;
  end;
end;

procedure TTreeBmpForm.DrawPaintTreeNat;
var
  i : Integer;
  Sex : Integer;
  ht, wt : Integer;//размер области рисовани€
  done : Boolean;
  cntnat : Integer;
  lX, lY : Integer;
  function FindFather(Father : String) : Integer;
  var
    n : Integer;
  begin
    Result := -1;
    for n := 0 to listMans.Count - 1 do begin
      if listGender.Strings[n] = Man then
      if listMans.Strings[n] = Father then begin
        Result := n;
        break;
      end;
    end;
  end;
  function FindMother(Mother : String) : Integer;
  var
    n : Integer;
  begin
    Result := -1;
    for n := 0 to listMans.Count - 1 do begin
      if listGender.Strings[n] = Woman then
      if listMans.Strings[n] = Mother then begin
        Result := n;
        break;
      end;
    end;
  end;
  function National2(Child : Integer) : String;
  var
    n : Integer;
    fX, fY : Integer;
    s : String;
  begin
    Result := '';
    Inc(lY);
    fX := 0;
    fY := 0;
    if iY2 < lY then iY2 := lY;
    n := FindFather(listFather.Strings[Child]);
    if n <> -1 then begin
      New(pMen);
      pMen^.Men := n;
      pMen^.Sex := 0;
      pMen^.X := lX*200;
      pMen^.Y := lY*90;
      fX := lX;
      fY := lY;
      Mens.Add(pMen);
      s := National2( n);
      Result := Result +s+';'+ listNati.Strings[n];
    end else
      Inc(lX);
    n := FindMother(listMother.Strings[Child]);
    if n <> -1 then begin
      New(pMen);
      pMen^.Men := n;
      pMen^.Sex := 1;
      pMen^.X := lX*200;
      pMen^.Y := lY*90;
      pMen^.Father := fX;
      pMen^.Mother := fY;
      Mens.Add(pMen);
      s := National2( n);
      Result := Result +s+';'+ listNati.Strings[n];
    end;
    Dec(lY);
    if Empty(Result) then
      listNull.Strings[Child] := listNati.Strings[Child]
    else
      listNull.Strings[Child] := Result;
  end;
begin
  Cursor := crHourGlass;
// чищу область рисовани€
  PaintTree.Width := 0;
  PaintTree.Height := 0;
  PaintTree.Picture := nil;
//создаю списки
  Mens := TList.Create;
// ¬ычисл€ю Y и X
  lX := 0;
  lY := 0;
  listNull := TStringList.Create;
  for i := 0 to listMans.Count-1 do listNull.Add(' ');
  listNull.Strings[GridRow] := National2(GridRow);//заполн€ю списки
// задаю область рисовани€
  Ht := iY2*90 + 80;
  Wt := lX*200;
  if ((Wt*Ht)>(MemAvail div 2)) then Wt := (MemAvail div 2) div Ht;
  done := True;
  while done do begin
   try
    done := False;
    PaintTree.Height := Ht;
    PaintTree.Width := Wt;
    PaintTree.Canvas.Pixels[0,0] := clWhite;// тест пам€ти
   except
    Ht := Ht - 100;
    Wt := Wt - 100;
    done := True;
   end;
  end;
  with PaintTree do begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(0,0,Wt,Ht);
  end;
// –исую
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Style := psSolid;// сплошной линией
  PaintTree.Canvas.Pen.Width := LinWidth;// толщиной пиксел€
  PaintTree.Canvas.Pen.Color := clGreen;// рамку рисую зеленым
//рисую первым
  if listGender.Strings[ GridRow] = Man then Sex := 0 else Sex := 1;
  DrawMen( GridRow, 0, 0, listMans.Strings[ GridRow], Sex);
  if not Empty(listNull.Strings[GridRow]) then begin
    DrawNat( GridRow, 0, 44, listMans.Strings[GridRow], Sex);
    done := True;
  end else
    done := False;
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := Mens.Count;
//рисую списки людей и рисую св€зи
  for i := 0 to Mens.Count-1 do begin
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    pMen := Mens[i];
    if listGender.Strings[ pMen^.Men] = Man then Sex := 0 else Sex := 1;
    if pMen^.Sex <> -1 then begin
      PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
      if pMen^.Sex = 0 then begin
       if not done then begin
        PaintTree.Canvas.MoveTo(pMen^.X+100,pMen^.Y-1);
        PaintTree.Canvas.LineTo(pMen^.X+100,pMen^.Y+12);
       end else begin
        PaintTree.Canvas.MoveTo(pMen^.X+100,pMen^.Y+7);
        PaintTree.Canvas.LineTo(pMen^.X+100,pMen^.Y+11);
       end;
      end;
      if pMen^.Sex = 1 then begin
        PaintTree.Canvas.MoveTo(pMen^.Father*200+188,pMen^.Y+32);
        PaintTree.Canvas.LineTo(pMen^.X+3,pMen^.Y+32);
      end;
    end;
    DrawMen( pMen^.Men, pMen^.X, pMen^.Y, listMans.Strings[pMen^.Men], Sex);
    if not Empty(listNull.Strings[pMen^.Men]) then begin
      DrawNat( pMen^.Men, pMen^.X, pMen^.Y+44, listMans.Strings[pMen^.Men], Sex);
      done := True;
    end else
      done := False;
  end;
//уничтожаю элементы списка
  listNull.Free;
  MensCnt := Mens.Count;
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    MensM[i] := pMen^.Men;//копирую координаты
    MensX[i] := pMen^.X;
    MensY[i] := pMen^.Y;
    Dispose(pMen);// уничтожаю элемент
  end;
  Mens.Free;//уничтожаю список
  ProcessForm.Hide;// закрытие окна процесса
  Cursor := crDefault;
end;

procedure TTreeBmpForm.DrawPaintTreePerDn;
var
  ht, wt : Integer;//размер области рисовани€
  done : Boolean;
  i : Integer;
  //рисую генеалогическую ветвь
  procedure ParentsChilds( X, Y: Integer; Nama: String; Index: Integer; Ons: Boolean);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
    One, On1 : Boolean;
    s, ss : String;
    Sex : Integer;
    aSpouse : TStringList;
    n, p : Integer;
    procedure SaveMen( Index, X, Y : Integer);
    begin
      New(pMen);
      pMen^.Men := Index;
      pMen^.X := X;
      pMen^.Y := Y;
      Mens.Add(pMen);
    end;
  begin
    One := False;
    On1 := False;
    iNam := -1;
    aSpouse := TStringList.Create;
		if (not Empty(listSpouse.Strings[Index])) then begin
      ss := listSpouse.Strings[Index];
      repeat
        n := Pos(rzd2, ss);
        if n > 0 then begin
          s := Copy(ss,1,n-1);
          ss := Copy(ss,n+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then aSpouse.Add(s);
      until n=0;
		end;
    for n := 0 to aSpouse.Count-1 do begin
      p := Pos(rzd3, aSpouse.Strings[n]);
      if p > 0 then aSpouse.Strings[n] := Copy(aSpouse.Strings[n], 1, p-1);
    end;
    // отец или мать
    PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
    PaintTree.Canvas.MoveTo(X-26,Y-5);
    PaintTree.Canvas.LineTo(X-26,iY2-5);
    PaintTree.Canvas.MoveTo(X-15,iY2+3);
    PaintTree.Canvas.LineTo(X+16,iY2+3);
    Arc1( X-26, iY2-16);      // ветка вверх
    Arc3( X+ 6, iY2+ 2);      // ветка вниз в право
    Arc2( X- 3, iY2+43);      // ветка вниз в лево
    ImageList1.Draw( PaintTree.Canvas, X-15, iY2+5, 1); //листочки
    ImageList3.Draw( PaintTree.Canvas, X-65, iY2-10, 0);
    if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
    DrawMen( Index, X, iY2, listMans.Strings[ Index], Sex);
    SaveMen( Index, X, iY2);
    iCol := iY2+61;
    for iRow := 0 to listMans.Count - 1 do begin
      // ищу всех детей мужской линии
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Nama then begin
          iPar := iRetrMother(listMother.Strings[iRow]);
          if iNam <> iPar then begin// мать
       	  // есть ли така€ жена в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (listMother.Strings[iRow] = aSpouse.Strings[n]) then begin
                aSpouse.Delete(n);// если есть, удал€ю его из списка
                break;
              end;
            end;
            if One then begin
              iY2 := iY2 + 60;
              PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
              PaintTree.Canvas.MoveTo(X-26,Y-5);
              PaintTree.Canvas.LineTo(X-26,iY2-5);
              PaintTree.Canvas.MoveTo(X-15,iY2+3);
              PaintTree.Canvas.LineTo(X+16,iY2+3);
              Arc1( X-26, iY2-16);      // ветка вверх
              Arc3( X+8, iY2+3);        // ветка вниз
              Arc2( X-3, iY2+43);
              ImageList1.Draw( PaintTree.Canvas, X-15, iY2+5, 1);
              ImageList3.Draw( PaintTree.Canvas, X-65, iY2-10, 0);
              if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
              DrawMen( Index, X, iY2, listMans.Strings[ Index], Sex);
              SaveMen( Index, X, iY2);
              On1 := True;
            end;
            if iPar > -1 then begin
              if listGender.Strings[iPar] = Man then Sex := 0 else Sex := 1;
              DrawMen( iPar, X+187, iY2, listMans.Strings[ iPar], Sex);
              SaveMen( iPar, X+187, iY2);
            end;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 60;
          ParentsChilds( X+23, iCol-7, listMans.Strings[iRow], iRow, On1);
        end;
      end;
      // ищу всех детей женской линии
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Nama then begin
          iPar := iRetrFather(listFather.Strings[iRow]);
          if iNam <> iPar then begin// отец
       	  // есть ли такой муж в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (listFather.Strings[iRow] = aSpouse.Strings[n]) then begin
                aSpouse.Delete(n);// если есть, удал€ю его из списка
                break;
              end;
            end;
            if One then begin
              iY2 := iY2 + 60;
              PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
              PaintTree.Canvas.MoveTo(X-26,Y-5);
              PaintTree.Canvas.LineTo(X-26,iY2-5);
              PaintTree.Canvas.MoveTo(X-15,iY2+3);
              PaintTree.Canvas.LineTo(X+16,iY2+3);
              Arc1( X-26, iY2-16);      // ветка вверх
              Arc3( X+8, iY2+3);        // ветка вниз
              Arc2( X-3, iY2+43);
              ImageList1.Draw( PaintTree.Canvas, X-15, iY2+5, 1);
              ImageList3.Draw( PaintTree.Canvas, X-65, iY2-10, 0);
              if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
              DrawMen( Index, X, iY2, listMans.Strings[ Index], Sex);
              SaveMen( Index, X, iY2);
              On1 := True;
            end;
            if iPar > -1 then begin
              if listGender.Strings[iPar] = Man then Sex := 0 else Sex := 1;
              DrawMen( iPar, X+187, iY2, listMans.Strings[ iPar], Sex);
              SaveMen( iPar, X+187, iY2);
            end;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 60;
          ParentsChilds( X+23, iCol-7, listMans.Strings[iRow], iRow, On1);
        end;
      end;
    end;
    // рисую жен и мужей без детей
    for n := 0 to aSpouse.Count-1 do begin
      if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
      if One then begin
        // отец или мать
        iY2 := iY2 + 80;
        PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
        PaintTree.Canvas.MoveTo(X-26, Y- 5);
        PaintTree.Canvas.LineTo(X-26,iY2-5);
        PaintTree.Canvas.MoveTo(X-15,iY2+3);
        PaintTree.Canvas.LineTo(X+16,iY2+3);
        Arc1( X-26, iY2-16);      // ветка вверх
        Arc3( X+8, iY2+3);        // ветка вниз в право
        Arc2( X-3, iY2+43);       // ветка вниз в лево
        ImageList1.Draw( PaintTree.Canvas, X-15, iY2+5, 1); //листочки
        ImageList3.Draw( PaintTree.Canvas, X-65, iY2-10, 0);
        DrawMen( Index, X, iY2, listMans.Strings[ Index], Sex);
      end;
      if (Sex = 0) then begin
        Sex := 1;
 	iPar := iRetrMother(aSpouse.Strings[n]);
      end else
      if (Sex = 1) then begin
        Sex := 0;
 	iPar := iRetrFather(aSpouse.Strings[n]);
      end  else begin
        iPar := -1;
      end;
      DrawMen( iPar, X+187, iY2, aSpouse.Strings[n], Sex);
      SaveMen( iPar, X+187, iY2);
    end;
    aSpouse.Free;
  end;
  //вычисл€ю размеры X и Y дл€ генеалогической ветви
  procedure ParentsY( X, Y: Integer; Nama: String; Index: Integer);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
    One : Boolean;
    s, ss : String;
    Sex : Integer;
    aSpouse : TStringList;
    i, n, p : Integer;
  begin
    One := False;
    iNam := -1;
    aSpouse := TStringList.Create;
		if (not Empty(listSpouse.Strings[Index])) then begin
      ss := listSpouse.Strings[Index];
      repeat
        i := Pos(rzd2, ss);
        if i > 0 then begin
          s := Copy(ss,1,i-1);
          ss := Copy(ss,i+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then aSpouse.Add(s);
      until i=0;
		end;
    for n := 0 to aSpouse.Count-1 do begin
      p := System.Pos(rzd3, aSpouse.Strings[n]);
      if p > 0 then aSpouse.Strings[n] := Copy(aSpouse.Strings[n], 1, p-1);
    end;
    if X > iX2 then iX2 := X;
    iCol := iY2+61;
    for iRow := 0 to listMans.Count - 1 do begin
      // ищу всех детей мужской линии
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Nama then begin
          iPar := iRetrMother(listMother.Strings[iRow]);
          if iNam <> iPar then begin
       	  // есть ли така€ жена в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (listMother.Strings[iRow] = aSpouse.Strings[n]) then begin
                aSpouse.Delete(n);// если есть, удал€ю его из списка
                break;
              end;
            end;
            if One then iY2 := iY2 + 60;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 60;
          ParentsY( X+23, iCol-7, listMans.Strings[iRow], iRow);
        end;
      end;
      // ищу всех детей женской линии
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Nama then begin
          iPar := iRetrFather(listFather.Strings[iRow]);
          if iNam <> iPar then begin
       	  // есть ли такой муж в списке
            for n := 0 to aSpouse.Count-1 do begin
              if (listFather.Strings[iRow] = aSpouse.Strings[n]) then begin
                aSpouse.Delete(n);// если есть, удал€ю его из списка
                break;
              end;
            end;
            if One then iY2 := iY2 + 60;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 60;
          ParentsY( X+23, iCol-7, listMans.Strings[iRow], iRow);
        end;
      end;
    end;
    // рисую жен и мужей без детей
    for n := 0 to aSpouse.Count-1 do begin
      if One then begin
        iY2 := iY2 + 80;
      end;
    end;
    aSpouse.Free;
  end;
begin
  Cursor := crHourGlass;
// чищу область рисовани€
  PaintTree.Width := 0;
  PaintTree.Height := 0;
  PaintTree.Picture := nil;
//создаю списки
  Mens := TList.Create;
// ¬ычисл€ю Y и X
  iX2 := 0;
  iY2 := 40;
  ParentsY( 30{X}, 0{Y}, listMans.Strings[GridRow], GridRow);
// задаю область рисования
  Ht := iY2 + 80;
  Wt := iX2 + 380;
  if ((Wt*Ht)>(MemAvail div 2)) then Wt := (MemAvail div 2) div Ht;
  done := True;
  while done do begin
    try
      done := False;
      PaintTree.Height := Ht;
      PaintTree.Width := Wt;
      PaintTree.Canvas.Pixels[0,0] := clWhite;// тест памяти
    except
      Ht := Ht - 100;
      Wt := Wt - 100;
      done := True;
    end;
  end;
  with PaintTree do begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(0,0,Wt,Ht);
  end;
// –исую
  iY2 := 40;
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Style := psSolid;// сплошной линией
  PaintTree.Canvas.Pen.Width := LinWidth;// толщиной пиксел€
  PaintTree.Canvas.Pen.Color := clGreen;// рамку рисую зеленым
  PaintTree.Canvas.Brush.Color := clMoneyGreen;// заливка
  PaintTree.Canvas.RoundRect( 5,5, 270,30, 12,12); //рамка
  PaintTree.Canvas.Font.Color := clBlack;
  PaintTree.Canvas.Font.Size := 10;  // размер
  PaintTree.Canvas.Font.Style := [fsBold];
  PaintTree.Canvas.TextOut( 50, 10, CaptionBranch);
  ParentsChilds( 30{X}, 0{Y}, listMans.Strings[GridRow], GridRow, False);
//уничтожаю элементы списка
  MensCnt := Mens.Count;
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    MensM[i] := pMen^.Men;//копирую координаты
    MensX[i] := pMen^.X;
    MensY[i] := pMen^.Y;
    Dispose(pMen);// уничтожаю элемент
  end;
  Mens.Free;//уничтожаю список
// закрытие окна
  Cursor := crDefault;
end;

procedure TTreeBmpForm.DrawPaintTreePerUp;
var
  i, n, p : Integer;
  iX : Integer;
  iY : Integer;
  Sex :Integer;
  s : String;
  minX :Integer;
  maxX :Integer;
  maxY :Integer;
  ht, wt : Integer;//размер области рисовани€

  // проверка на зан€тость координаты X
  function newX(X, Y : Integer) : Integer;
  var
    i : Integer;
  begin
    Result := 0;
    for i := 0 to listMans.Count-1 do begin//провер€ю
      pMen := Mens[i];
      if (pMen^.Yes <> 0) then begin
        if (pMen^.Y = Y) then begin
          if (pMen^.X = X) then begin
            Result := 200;
            break;
          end;
    	end;
      end;
    end;
  end;

  //рисую генеалогическую ветвь по отцу
  function ParentsFather(X, Y : Integer; person : String; Index : Integer; one : Boolean) : Integer;
  var
    delta : Integer;
    dX : Integer;
    dY : Integer;
    dF : Integer;
    dM : Integer;
  begin
    delta := newX(X, iY);
    dX := X + delta;
    dY := Y;
    dF := 0;
    dM := 0;
    // отец или мать
    pMen := Mens[Index];
    pMen^.X := X + delta;
    pMen^.Y := iY;
    pMen^.Yes := 1;
    if not Empty(listFather.Strings[Index]) then begin
      n := iRetrFather(listFather.Strings[Index]);
      if (n > -1) then begin
        //iX := dX + 50;
	if (one) then begin
	  iX := iX + 150;
	end else begin
	  iX := iX + 50;
	end;
	iY := iY + 80;
	dF := ParentsFather( iX, iY, listFather.Strings[Index], n, False);
	if (dF <> 0) then pMen^.X := pMen^.X + dF;
      end;
    end;
    if (not one) then begin
      if not Empty(listMother.Strings[Index]) then begin
        n := iRetrMother(listMother.Strings[Index]);
	if (n > -1) then begin
	  //iX := dX + 50;
	  iY := dY;
	  iX := iX + 190;
	  iY := iY + 80;
	  dM := ParentsFather( iX, iY, listMother.Strings[Index], n, false);
	  if (dF = 0) then pMen^.X := pMen^.X + dM;
	end;
      end;
    end;
    if ((iX+delta) > maxX) then maxX := iX + delta;
    if (iY > maxY) then maxY := iY;
    Result := delta;
  end;

  //рисую генеалогическую ветвь по матери
  function ParentsMother(X, Y : Integer; person : String; Index : Integer; one : Boolean) : Integer;
  var
    delta : Integer;
    dX : Integer;
    dY : Integer;
    dF : Integer;
    dM : Integer;
  begin
    delta := newX(X, iY);
    dX := X - delta;
    dY := Y;
    dF := 0;
    dM := 0;
    // отец или мать
    pMen := Mens[Index];
    if (not one) then begin
    	pMen^.X := X - delta;
    	pMen^.Y := iY;
    	pMen^.Yes := 1;
    end else begin
     	dX := X + 100;
    end;
    if (not one) then begin
      if not Empty(listFather.Strings[Index]) then begin
        n := iRetrFather(listFather.Strings[Index]);
	if (n > -1) then begin
	  iX := iX - 50;
	  iY := iY + 80;
	  dF := ParentsMother( iX, iY, listFather.Strings[Index], n, false);
	  if (dF = 0) then pMen^.X := pMen^.X - dF;
	end;
      end;
    end else begin
      iX := iX + 100;
      iY := iY + 80;
    end;
    if not Empty(listMother.Strings[Index]) then begin
      n := iRetrMother(listMother.Strings[Index]);
      if (n > -1) then begin
        //iX := dX;
	iY := dY;
        if one then
  	  iX := iX - 250
        else
  	  iX := iX - 200;
	iY := iY + 80;
	dM := ParentsMother( iX, iY, listMother.Strings[Index], n, False);
	if (dF <> 0) then pMen^.X := pMen^.X - dM;
      end;
    end;
    if ((iX-delta) < minX) then minX := iX - delta;
    if (iY > maxY) then maxY := iY;
    Result := delta;
  end;

  procedure drawLines( cX, cY, pX, pY : Integer);
  begin
    PaintTree.Canvas.Pen.Color := clGreen;// ветки рисую зеленым
    PaintTree.Canvas.MoveTo(cX+90,cY+ 3);
    PaintTree.Canvas.LineTo(cX+90,cY+10);
    if (cX < pX) then begin
      Arc2(cX+90, cY- 5);       // ветка вниз в лево
      Arc4(pX+71, pY+55);      // ветка вниз в право
      PaintTree.Canvas.MoveTo(cX+97,cY-5);
      PaintTree.Canvas.LineTo(pX+83,cY-5);
      ImageList1.Draw( PaintTree.Canvas, cX+70, cY-10, 2); //листочки
      ImageList1.Draw( PaintTree.Canvas, pX+90, pY+60, 1); //листочки
    end else begin
      Arc1(pX+90, pY+56);      // ветка вверх
      Arc3(cX+71, cY- 6);       // ветка вниз в право
      PaintTree.Canvas.MoveTo(cX+85,cY-5);
      PaintTree.Canvas.LineTo(pX+95,cY-5);
      ImageList1.Draw( PaintTree.Canvas, cX+90, cY-10, 3); //листочки
      ImageList1.Draw( PaintTree.Canvas, pX+70, pY+60, 0); //листочки
    end;
    PaintTree.Canvas.MoveTo(pX+90,pY+59);
    PaintTree.Canvas.LineTo(pX+90,pY+65);
  end;

begin
// –исую
  Cursor := crHourGlass;
//
  iX := 0;
  iY := 40;
  minX := 0;
  maxX := 0;
  maxY := 0;
//создаю списки
  Mens := TList.Create;
//заполн€ю элементы списка
  for i := 0 to listMans.Count-1 do begin
    New(pMen);
    pMen^.Men := i;
    if listGender.Strings[i] = Man then pMen^.Sex := 0
    else if listGender.Strings[i] = Woman then pMen^.Sex := 1
    else pMen^.Sex := -1;
    pMen^.Father := iRetrFather(listFather.Strings[i]);
    pMen^.Mother := iRetrMother(listMother.Strings[i]);
    pMen^.X := 0;
    pMen^.Y := 0;
    pMen^.Yes := 0;
    Mens.Add(pMen);
  end;
// считаю
  iX := 0;
  iY := 0;
  ParentsFather( iX, iY, listMans.Strings[GridRow], GridRow, true);
  iX := 0;
  iY := 0;
  ParentsMother( iX, iY, listMans.Strings[GridRow], GridRow, true);
// «еркально мен€ю координаты
  minX := minX + 200;
  for i := 0 to listMans.Count-1 do begin//рисую
    pMen := Mens[i];
  	if (pMen^.Yes <> 0) then begin
     	pMen^.X := pMen^.X - minX;
     	pMen^.Y := maxY - pMen^.Y;
  	end;
  end;
// чищу область рисовани€
  PaintTree.Width := 0;
  PaintTree.Height := 0;
  PaintTree.Picture := nil;
// задаю область рисовани€
  Ht := maxY + 80;
  Wt := maxX - minX + 200;
  if ((Wt*Ht)>(MemAvail div 2)) then Wt := (MemAvail div 2) div Ht;
  done := True;
  while done do begin
   try
    done := False;
    PaintTree.Height := Ht;
    PaintTree.Width := Wt;
    PaintTree.Canvas.Pixels[0,0] := clWhite;// тест пам€ти
   except
    Ht := Ht - 100;
    Wt := Wt - 100;
    done := True;
   end;
  end;
  with PaintTree do begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(0,0,Wt,Ht);
  end;
// –исую
  PaintTree.Canvas.Brush.Style := bsClear;// нет заливки
  PaintTree.Canvas.Pen.Style := psSolid;// сплошной линией
  PaintTree.Canvas.Pen.Width := LinWidth;// толщиной пиксел€
  PaintTree.Canvas.Pen.Color := clGreen;// рамку рисую зеленым
// –исую ‘»ќ
  for i := 0 to listMans.Count-1 do begin//рисую
    pMen := Mens[i];
    if (pMen^.Yes <> 0) then begin
      Sex := pMen^.Sex;
      DrawMen( pMen^.Men, pMen^.X, pMen^.Y, listMans.Strings[pMen^.Men], Sex);
      if (pMen^.Father <> -1) then begin
        fMen := Mens[pMen^.Father];
  	drawLines(pMen^.X, pMen^.Y, fMen^.X, fMen^.Y);
      end;
      if (pMen^.Mother <> -1) then begin
        mMen := Mens[pMen^.Mother];
  	drawLines(pMen^.X, pMen^.Y, mMen^.X, mMen^.Y);
      end;
    end;
  end;
//уничтожаю элементы списка
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    MensM[i] := pMen^.Men;//копирую координаты
    MensX[i] := pMen^.X;
    MensY[i] := pMen^.Y;
    Dispose(pMen);// уничтожаю элемент
  end;
  Mens.Free;//уничтожаю список
//
  Application.ProcessMessages;
  Cursor := crDefault;
end;

procedure TTreeBmpForm.ResizePaintTree(k : Real);
var
  w, h, sh, sv: Real;
begin
  PaintTree.AutoSize := False;
  PaintTree.Align    := alNone;
  PaintTree.Stretch  := True;
  w := PaintTree.Picture.Width  / PaintTree.Width ;
  h := PaintTree.Picture.Height / PaintTree.Height;
  if w > h then
    PaintTree.Height := Round (PaintTree.Picture.Height / w)
  else
    PaintTree.Width  := Round (PaintTree.Picture.Width  / h);
  sh := (ScrollTree.HorzScrollBar.Position + ScrollTree.ClientWidth /2) / PaintTree.Width ;
  sv := (ScrollTree.VertScrollBar.Position + ScrollTree.ClientHeight/2) / PaintTree.Height;
  if (PaintTree.Height*k + PaintTree.Width*k) > 60 then begin
    PaintTree.Height := Round (PaintTree.Height * k);
    PaintTree.Width  := Round (PaintTree.Width  * k);
  end;
  ScrollTree.HorzScrollBar.Position := Round (sh * PaintTree.Width  - ScrollTree.ClientWidth /2);
  ScrollTree.VertScrollBar.Position := Round (sv * PaintTree.Height - ScrollTree.ClientHeight/2);
end;

end.

