unit treehtm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, IpHtml, Ipfilebroker, Forms,
  LCLIntF,
  Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, ExtDlgs, StdCtrls;

type

  { TTreeHtmForm }

  TTreeHtmForm = class(TForm)
    BackButton: TToolButton;
    HelpButton: TToolButton;
    IpFileDataProvider1: TIpFileDataProvider;
    Memo1: TMemo;
    PrintDialog1: TPrintDialog;
    SaveDialog1: TSaveDialog;
    WebBrowser1: TIpHtmlPanel;
    Panel1: TPanel;
    PrinButton: TToolButton;
    SaveButton: TToolButton;
    ToolBar1: TToolBar;
    TuneButton: TToolButton;
    procedure BackButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure PrinButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
    iX1 : Integer;//левый  X
    iX2 : Integer;//правый X
    iY1 : Integer;//левый  Y
    iY2 : Integer;//правый Y
    LeftRight : Boolean;//False - лева€ часть древа, True-права€ часть древа
    GaugePos : Integer;
    procedure BeginHTML;
    procedure DrawHMen( Index, X , Y : Integer; Nams : String; Sexs : Integer);
    procedure DrawHNat( Index, X , Y : Integer; Nams : String; Sexs : Integer);
    function StrNational(Nations : String): String;
  public
    { public declarations }
    procedure DrawPaintTreeHDown;
    procedure DrawPaintTreeHAaa;
    procedure DrawPaintTreeHAll;
    procedure DrawPaintTreeHPeC;
    procedure DrawPaintTreeHNat;
    procedure DrawPaintTreeHPerDn;
    procedure DrawPaintTreeHPerUp;
  end;

var
  TreeHtmForm: TTreeHtmForm;

implementation

uses main, tune, info, vars, mstring, utils, prozess;

{$R *.lfm}

procedure TTreeHtmForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

procedure TTreeHtmForm.BackButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTreeHtmForm.BeginHTML;
begin
  HTMLText := '<html><head>';
  HTMLText := HTMLText + '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
  HTMLText := HTMLText + '</head>';
  HTMLText := HTMLText + '<style type="text/css">';
  HTMLText := HTMLText + '.shadow {';//* «адание стилей дл€ сло€ тени */
  HTMLText := HTMLText + 'background:#bbb;'; //* «адание цвета тени */
  HTMLText := HTMLText + 'border:1px solid #ddd;'; //* «адание стил€ и цвета границ тени */
  HTMLText := HTMLText + 'width:200px;'; //* «адание ширины всего блока */
  HTMLText := HTMLText + '}';
  HTMLText := HTMLText + '.blockm {';//* «адание стилей дл€ сло€ блока */
  HTMLText := HTMLText + 'background:#00ffff;'; //* «адание цвета фона дл€ блока */
  HTMLText := HTMLText + 'border:1px solid #6b6b6b;';  //* «адание стил€ и цвета границ блока */
  HTMLText := HTMLText + 'position:relative;';  //* «адание позиции блока текста относительно тени */
  HTMLText := HTMLText + 'padding:5px;';  //* «адание отступа */
  HTMLText := HTMLText + 'top:-3px;';  //* ќтступ сверху (дл€ тени) */
  HTMLText := HTMLText + 'left:-3px;'; //* ќтступ слева (дл€ тени) */
  HTMLText := HTMLText + '}';
  HTMLText := HTMLText + '.blockw {';
  HTMLText := HTMLText + 'background:#ffc0cb;'; //* «адание цвета фона дл€ блока */
  HTMLText := HTMLText + 'border:1px solid #6b6b6b;';  //* «адание стил€ и цвета границ блока */
  HTMLText := HTMLText + 'position:relative;';  //* «адание позиции блока текста относительно тени */
  HTMLText := HTMLText + 'padding:5px;';  //* «адание отступа */
  HTMLText := HTMLText + 'top:-3px;';  //* ќтступ сверху (дл€ тени) */
  HTMLText := HTMLText + 'left:-3px;'; //* ќтступ слева (дл€ тени) */
  HTMLText := HTMLText + '}';
  HTMLText := HTMLText + '.blockr {';
  HTMLText := HTMLText + 'background:#0fc;'; //* «адание цвета фона дл€ блока */
  HTMLText := HTMLText + 'border:1px solid #6b6b6b;';  //* «адание стил€ и цвета границ блока */
  HTMLText := HTMLText + 'position:relative;';  //* «адание позиции блока текста относительно тени */
  HTMLText := HTMLText + 'padding:5px;';  //* «адание отступа */
  HTMLText := HTMLText + 'top:-3px;';  //* ќтступ сверху (дл€ тени) */
  HTMLText := HTMLText + 'left:-3px;'; //* ќтступ слева (дл€ тени) */
  HTMLText := HTMLText + '}';
  HTMLText := HTMLText + '</style>';
  HTMLText := HTMLText + '<body>';
end;

//рисует иконку, рамку, ‘»ќ и дату
procedure TTreeHtmForm.DrawHMen( Index, X , Y : Integer; Nams : String; Sexs : Integer);
var
  s : String;
begin
  HTMLText := HTMLText + '<div class="shadow" style="POSITION: absolute; LEFT: '+IntToStr(X)+'px; TOP: '+IntToStr(Y)+'px; WIDTH: 205px; HEIGHT: 60px">';
  if Sexs = 0 then begin
    HTMLText := HTMLText + '<div class="blockm" style="POSITION: absolute; LEFT: 0px; TOP: 0px; WIDTH: 200px; HEIGHT: 55px">';
  end else begin
    HTMLText := HTMLText + '<div class="blockw" style="POSITION: absolute; LEFT: 0px; TOP: 0px; WIDTH: 200px; HEIGHT: 55px">';
  end;
//—одержание блока
  {??
  s := MainPathTXT+dZd+Trim(Nams)+'.txt';
  if FileExistsUTF8(s)//всплывающа€ подсказка ALT в HTML
    then Memo1.Lines.LoadFromFile(UTF8toANSI(s))
    else Memo1.Lines.Clear;
  s := Memo1.Lines.Text;
  s := '';
  }
  if FileExists(MainPathICO+Nams+'.bmp') then
    HTMLText := HTMLText + '<img src="'+MainPathICO+Nams+'.bmp" align=left width="48" height="48" alt="'+s+'">'
  else
  if FileExists(MainPathBMP+Nams+'.jpg') then
    HTMLText := HTMLText + '<img src="'+MainPathBMP+Nams+'.jpg" align=left width="48" height="48" alt="'+s+'">'
  else
    HTMLText := HTMLText + '<img src="'+MainPathEXE+'empty.gif" align=left width="48" height="48" alt="'+s+'">';
  HTMLText := HTMLText + '<font size=-1>' + Nams + '</font><br>';
  HTMLText := HTMLText + '<font size=-2><i>' + DateName(Index) + '</i></font>';
  HTMLText := HTMLText + '</div>';
  HTMLText := HTMLText + '</div>';
end;

//рисует иконку, рамку, ‘»ќ и национальность
procedure TTreeHtmForm.DrawHNat( Index, X , Y : Integer; Nams : String; Sexs : Integer);
var
  s : String;
begin
  if Sexs = 0 then begin
    HTMLText := HTMLText + '<table border=1 bordercolor=#00FFFF style="POSITION: absolute; LEFT: '+IntToStr(X)+'px; TOP: '+IntToStr(Y)+'px; WIDTH: 200px; HEIGHT: 80px">';
    HTMLText := HTMLText + '<tbody><tr><td align=center valign=left bgcolor=#00FFFF>'
  end else begin
    HTMLText := HTMLText + '<table border=1 bordercolor=#FF00FF style="POSITION: absolute; LEFT: '+IntToStr(X)+'px; TOP: '+IntToStr(Y)+'px; WIDTH: 200px; HEIGHT: 80px">';
    HTMLText := HTMLText + '<tbody><tr><td align=center valign=left bgcolor=#FF00FF>';
  end;
  if not Empty(listNati.Strings[Index]) then
    HTMLText := HTMLText + '<i>' + '('+Trim(listNati.Strings[Index])+')' + '</i>';
  if not Empty(listNull.Strings[Index]) then
  if listNull.Strings[Index] <> listNati.Strings[ Index] then
    HTMLText := HTMLText + ' ' +  StrNational(listNull.Strings[Index]);
  HTMLText := HTMLText + '</td></tr></tbody></table>';
end;

procedure TTreeHtmForm.SaveButtonClick(Sender: TObject);
var
  FileHTML : TextFile;
  i : Integer;
  s : String;
begin
  SaveDialog1.DefaultExt := '*.html';
  SaveDialog1.Filter := '*.html|*.html;*.htm|*.htm';
  SaveDialog1.FileName := 'Generation.html';
  if SaveDialog1.Execute then begin
    AssignFile(FileHTML, SaveDialog1.FileName);
    {$I-}
    ReWrite(FileHTML);
    {$I+}
    Writeln(FileHTML, HTMLText);
    CloseFile(FileHTML);
  end;
end;

procedure TTreeHtmForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TTreeHtmForm.PrinButtonClick(Sender: TObject);
var
  vaIn, vaOut: OleVariant;
begin
  //??if not PrintDialog1.Execute then Exit;
  //??WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vaIn, vaOut);
end;

procedure TTreeHtmForm.DrawPaintTreeHDown;
var
  distIndex : TStringList;
  distMans  : TStringList;
  distFather : TStringList;
  distMother : TStringList;
  distGender : TStringList;
  distSpouse : TStringList;
var
  pos : Integer;
  maxY: Integer;
  maxX : Integer;
  Ons : Boolean;
  i, j : Integer;
  s1, s2 : String;
  //индекс человека в списке
  function dRetrName(const Name: String): Integer;
  var
   ii : Integer;
  begin
   Result := -1;
   if Trim(Name) <> '' then
   for ii := 0 to listMans.Count - 1 do
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
    n, p : Integer;
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
        n := System.Pos(rzd2, ss);
        if n > 0 then begin
          s := Copy(ss,1,n-1);
          ss := Copy(ss,n+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then aSpouse.Add(s);
      until n=0;
    end;
    for n := 0 to aSpouse.Count-1 do begin
      p := System.Pos(rzd3, aSpouse.Strings[n]);
      if p > 0 then aSpouse.Strings[n] := Copy(aSpouse.Strings[n], 1, p-1);
    end;
    if (maxX < X) then maxX := X;
    if (maxY < Y) then maxY := Y;
    if (not Ons) then begin
     	HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X-10) + 'px; TOP: ' + IntToStr(Y-12) + 'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ' + IntToStr(iY2-Y+52) + 'px"><tr><td></td></tr></table>';
     	HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X-10) + 'px; TOP: ' + IntToStr(iY2+40) + 'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: 30px; HEIGHT: 0px"><tr><td></td></tr></table>';
    end;
    Ons := false;
    One := false;
    if distGender.Strings[Index] = Man then Sex := 0
    else if distGender.Strings[Index] = Woman then Sex := 1
    else Sex := -1;
    DrawHMen( StrToInt(distIndex.Strings[Index]), X, iY2, distMans.Strings[Index], Sex);
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
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X+15) + 'px; TOP: ' + IntToStr(iY2+67) + 'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: 5px"><tr><td></td></tr></table>';
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X+15) + 'px; TOP: ' + IntToStr(iY2+72) + 'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: '+IntToStr(dX-X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';//horizontal
              if distGender.Strings[iPar] = Man then Sex := 0
              else if distGender.Strings[iPar] = Woman then Sex := 1
              else Sex := -1;
              DrawHMen( StrToInt(distIndex.Strings[iPar]), dX, iY2, distMans.Strings[iPar], Sex);
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
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X+15) + 'px; TOP: ' + IntToStr(iY2+67) + 'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: 5px"><tr><td></td></tr></table>';
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X+15) + 'px; TOP: ' + IntToStr(iY2+72) + 'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: '+IntToStr(dX-X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';//horizontal
              if distGender.Strings[iPar] = Man then Sex := 0
              else if distGender.Strings[iPar] = Woman then Sex := 1
              else Sex := -1;
              DrawHMen( StrToInt(distIndex.Strings[iPar]), dX, iY2, distMans.Strings[iPar], Sex);
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
      if (one) then
        dX := dX + 220
      else
        dX := dX + 210;
      if (maxX < dX) then maxX := dX;
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X+15) + 'px; TOP: ' + IntToStr(iY2+67) + 'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: 5px"><tr><td></td></tr></table>';
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(X+15) + 'px; TOP: ' + IntToStr(iY2+72) + 'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: '+IntToStr(dX-X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';//horizontal
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(dX+15) + 'px; TOP: ' + IntToStr(iY2+67) + 'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: 8px"><tr><td></td></tr></table>';
      DrawHMen( StrToInt(distIndex.Strings[iPar]), dX, iY2, aSpouse.Strings[n], Sex);
    end;
    aSpouse.Free;
  end;
begin
  Cursor := crHourGlass;
  BeginHTML();
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
//
  maxY := 0;
  maxX := -190;
  for i := 0 to distMans.Count-1 do begin
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
// удаляю массив
  distIndex.Clear;
  distMans.Clear;
  distGender.Clear;
  distFather.Clear;
  distMother.Clear;
  distSpouse.Clear;
//
  HTMLText := HTMLText + '<tr><td></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
//  WebBrowser1.SetHtmlFromStr(HTMLText);
//  Application.ProcessMessages;
// сохраняю в файле
  Memo1.Text := HTMLText;
  Memo1.Lines.SaveToFile(MainPathTMP+dZd+MainFileHTM);
// вывожу во внешнем броузере
  OpenDocument(MainPathTMP+dZd+MainFileHTM);
//
  ProcessForm.Hide;
  Cursor := crDefault;
end;

procedure TTreeHtmForm.DrawPaintTreeHAaa;
var
  i, ii, c, cntL, cntR : Integer;
  dlt, dltX, dltY, dltXY, dltYX : Integer;
  s, ss : String;
  XmaxL, YmaxL : Integer;
  XmaxR, YmaxR : Integer;
  iXL, iYL : Integer;//лева€
  iXR, iYR : Integer;//права€
  Bougth, old : Integer;//номер ветви
  ht, wt : Integer;//размер области рисовани€
  b : Boolean;
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
  procedure ParentsFather( Name: String; Index: Integer);
  var
    i : Integer;
  begin
    pMen := Mens[Index];
    pMen^.Yes := Bougth;//запоминаю номер ветки
    for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if listFather.Strings[pMen^.Men] = Name then// ищу всех детей
        ParentsFather( listMans.Strings[pMen^.Men], i);
    end;
  end;
  //сканирую мужскую линию по женской
  procedure ParentsFatherDau( Name: String; Index: Integer; Sexs: Integer);
  var
    i, x : Integer;
  begin
    pMen := Mens[Index];
    if ((Sexs = 0) or ((Sexs = 1) and (pMen^.Yes = 0))) then begin
     x := pMen^.Sex;
     pMen^.Yes := Bougth;//запоминаю номер ветки
     for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if ((listFather.Strings[pMen^.Men] = Name)
       or (listMother.Strings[pMen^.Men] = Name)) then// ищу всех детей
        ParentsFatherDau( listMans.Strings[pMen^.Men], i, x);
     end;
    end;
  end;
  //сканирую только женскую линию
  procedure ParentsMother( Name: String; Index: Integer);
  var
    i : Integer;
  begin
    pMen := Mens[Index];
    if pMen^.Yes > 0 then exit;
    pMen^.Yes := Bougth;//запоминаю номер ветки
    for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if listMother.Strings[pMen^.Men] = Name then// ищу всех детей
        ParentsMother( listMans.Strings[pMen^.Men], i);
    end;
  end;
  //сканирую женскую линию по мужской
  procedure ParentsMotherSon( Name: String; Index: Integer; Sexs: Integer);
  var
    i, x : Integer;
  begin
    pMen := Mens[Index];
    if (((Sexs = 1) and (pMen^.Yes = Bougth)) or ((Sexs = 0) and (pMen^.Yes = 0))) then begin
     x := pMen^.Sex;
     pMen^.Yes := Bougth;//запоминаю номер ветки
     for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if ((listFather.Strings[pMen^.Men] = Name)
       or (listMother.Strings[pMen^.Men] = Name)) then// ищу всех детей
        ParentsMotherSon( listMans.Strings[pMen^.Men], i, x);
     end;
    end;
  end;
  //заполн€ю координаты
  procedure ParentsAlls( var X: Integer; const Y: Integer; Name: String; Index: Integer; LR: Boolean);
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
      if ((listFather.Strings[pMen^.Men] = Name)
       or (listMother.Strings[pMen^.Men] = Name)) then begin// ищу всех детей
        if pMen^.Yes = Bougth then
        if LR then begin
          if cnt<>0 then X := X + 230 else X := X + 110;
          ParentsAlls( X, Y + 100, listMans.Strings[pMen^.Men], i, LR);
        end else begin
          if cnt<>0 then X := X - 230 else X := X - 110;
          ParentsAlls( X, Y + 100, listMans.Strings[pMen^.Men], i, LR);
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
    pMen1 := Mens[Index];
    if pMen1^.X > 0 then begin
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(LinWidth*Count-XmaxL)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
      HTMLText := HTMLText + IntToStr(Ht-pMen1^.Y+40)+'px"><tr><td></td></tr></table>';
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(LinWidth*Count-XmaxL+1)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
      HTMLText := HTMLText + IntToStr(pMen1^.X-LinWidth*Count)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
    end else begin
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(LinWidth*Count-XmaxL)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
      HTMLText := HTMLText + IntToStr(Ht-pMen1^.Y+40)+'px"><tr><td></td></tr></table>';
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(pMen1^.X-XmaxL+197)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
      HTMLText := HTMLText + IntToStr(LinWidth*Count-pMen1^.X-197)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
    end;
  end;
  //св€зываю родител€ (отца) с ребенком
  procedure LinkFather( Name: String; iParent, iChild : Integer);
  var
    pMenC : ^TMens;
    pMenF : ^TMens;
    i : Integer;
  begin
    if pMen^.Yes <> Bougth then exit;//если ветка закончилась
    if ((pMen^.Father <> -1) or (pMen^.Mother <> -1)) then begin
     pMenC := Mens[iParent];
     pMenF := Mens[iChild];
     if pMenF^.X > 0 then begin
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+110)+'px; TOP: '+IntToStr(pMenC^.Y+50)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
      HTMLText := HTMLText + IntToStr(pMenF^.Y-pMenC^.Y-8)+'px"><tr><td></td></tr></table>';
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+187)+'px; TOP: '+IntToStr(pMenF^.Y+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
      HTMLText := HTMLText + IntToStr(pMenC^.X-pMenF^.X-76)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
     end else begin
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+100)+'px; TOP: '+IntToStr(pMenC^.Y+50)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
      HTMLText := HTMLText + IntToStr(pMenF^.Y-pMenC^.Y-8)+'px"><tr><td></td></tr></table>';
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
      HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+100)+'px; TOP: '+IntToStr(pMenF^.Y+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
      HTMLText := HTMLText + IntToStr(pMenF^.X-pMenC^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
     end;
    end;
    for i := 0 to Mens.Count-1 do begin
      pMen := Mens[i];
      if ((listFather.Strings[pMen^.Men] = Name)
       or (listMother.Strings[pMen^.Men] = Name)) then
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

    if pMenF^.X > pMenC^.X then
      dltX := pMenF^.X - pMenC^.X
    else
      dltX := pMenC^.X - pMenF^.X;
    if pMenF^.Y > pMenC^.Y then
      dltY := pMenF^.Y - pMenC^.Y
    else
      dltY := pMenC^.Y - pMenF^.Y;
    if pMenF^.X > 0 then
      dltXY := +2
    else
      dltXY := -2;
    if pMenF^.X > 0 then
      dltYX := 0
    else
      dltYX := 10;
    if pMenF^.X > 0 then
      dlt := 220
    else
      dlt := 0;
    //
    HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';//горизонтально
    HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+dlt-10)+'px; TOP: '+IntToStr(pMenF^.Y+30)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
    HTMLText := HTMLText + '10px; HEIGHT: 0px"><tr><td></td></tr></table>';
    //
    HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';//вертикально
    if (pMenF^.Y > pMenC^.Y) then begin
      if (pMenF^.X > 0) then begin
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+dlt)+'px;TOP:'+IntToStr(pMenC^.Y+80)+'px;BORDER-TOP:0pt solid;BORDER-BOTTOM:0pt solid;BORDER-RIGHT:0pt solid;BORDER-LEFT:2pt solid;WIDTH:0px;HEIGHT:';
      end else begin
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+dlt-10)+'px;TOP:'+IntToStr(pMenC^.Y+80)+'px;BORDER-TOP:0pt solid;BORDER-BOTTOM:0pt solid;BORDER-RIGHT:0pt solid;BORDER-LEFT:2pt solid;WIDTH:0px;HEIGHT:';
      end;
      HTMLText := HTMLText + IntToStr(dltY-48)+'px"><tr><td></td></tr></table>';
    end else begin
      if (pMenF^.X > 0) then begin
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+dlt)+'px;TOP:'+IntToStr(pMenF^.Y+30)+'px;BORDER-TOP:0pt solid;BORDER-BOTTOM:0pt solid;BORDER-RIGHT:0pt solid;BORDER-LEFT:2pt solid;WIDTH:0px;HEIGHT:';
      end else begin
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+dlt-10)+'px;TOP:'+IntToStr(pMenF^.Y+30)+'px;BORDER-TOP:0pt solid;BORDER-BOTTOM:0pt solid;BORDER-RIGHT:0pt solid;BORDER-LEFT:2pt solid;WIDTH:0px;HEIGHT:';
      end;
      HTMLText := HTMLText + IntToStr(dltY+52)+'px"><tr><td></td></tr></table>';
    end;
    //
    if (pMenF^.Yes <> 0) then begin
     HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';//горизонтально
     if (pMenF^.X > pMenC^.X) then begin // справо
      if (pMenF^.Y > pMenC^.Y) then begin
        if (pMenF^.X > 0) and (pMenC^.X > 0) then begin
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+110)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X < 0) then begin
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+100)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X > 0) then begin//??
          //showmessage(listMans.Strings[pMenF^.Men]+'=1');
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+110)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X > 0) and (pMenC^.X < 0) then begin
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+100)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+120)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end;
      end else begin
        if (pMenF^.X > 0) and (pMenC^.X > 0) then begin
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+110)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X < 0) then begin
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+93)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X > 0) then begin//??
          //showmessage(listMans.Strings[pMenF^.Men]+'=2');
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+110)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X > 0) and (pMenC^.X < 0) then begin
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+100)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+120)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end;
      end;
     end else begin                      // слево
      if (pMenF^.Y > pMenC^.Y) then begin
        if (pMenF^.X > 0) and (pMenC^.X > 0) then begin
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+220)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X < 0) then begin
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL-10)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X > 0) then begin
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL-10)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+120)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X > 0) and (pMenC^.X < 0) then begin//??
          //showmessage(listMans.Strings[pMenF^.Men]+'=3');
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+220)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end;
      end else begin
        if (pMenF^.X > 0) and (pMenC^.X > 0) then begin
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL+220)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X < 0) then begin
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL-10)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X < 0) and (pMenC^.X > 0) then begin
          HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL-10)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX+120)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end else
        if (pMenF^.X > 0) and (pMenC^.X < 0) then begin//??
          //showmessage(listMans.Strings[pMenF^.Men]+'=4');
          HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+220)+'px; TOP: '+IntToStr(pMenC^.Y+80)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
          HTMLText := HTMLText + IntToStr(dltX-110)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        end;
      end;
     end;
    end;
    //
    HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';//вертикально
    if (pMenC^.X > 0) then
      HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+110+dltXY)+'px;TOP:'+IntToStr(pMenC^.Y+60)+'px;BORDER-TOP:0pt solid;BORDER-BOTTOM:0pt solid;BORDER-RIGHT:0pt solid;BORDER-LEFT:2pt solid;WIDTH:0px;HEIGHT:'
    else
      HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+100+dltXY)+'px;TOP:'+IntToStr(pMenC^.Y+60)+'px;BORDER-TOP:0pt solid;BORDER-BOTTOM:0pt solid;BORDER-RIGHT:0pt solid;BORDER-LEFT:2pt solid;WIDTH:0px;HEIGHT:';
    HTMLText := HTMLText + '22px"><tr><td></td></tr></table>';
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
    if pMenF^.X > pMenC^.X then begin
      if pMenF^.Y > pMenC^.Y then begin
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL)+'px; TOP: '+IntToStr(pMenC^.Y+1)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMenF^.Y-pMenC^.Y)+'px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL-1)+'px; TOP: '+IntToStr(pMenC^.Y+1)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + IntToStr(pMenF^.X-pMenC^.X+3)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
      end else begin
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+196)+'px; TOP: '+IntToStr(pMenF^.Y)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMenC^.Y-pMenF^.Y+3)+'px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+196)+'px; TOP: '+IntToStr(pMenF^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + IntToStr(pMenF^.X-pMenC^.X-193)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
      end;
    end else begin
      if pMenF^.Y > pMenC^.Y then begin
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL)+'px; TOP: '+IntToStr(pMenC^.Y)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMenF^.Y-pMenC^.Y+3)+'px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL)+'px; TOP: '+IntToStr(pMenC^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + IntToStr(pMenC^.X-pMenF^.X+3)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
      end else begin
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenC^.X-XmaxL+1)+'px; TOP: '+IntToStr(pMenF^.Y)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMenC^.Y-pMenF^.Y+3)+'px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=Yellow style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMenF^.X-XmaxL)+'px; TOP: '+IntToStr(pMenF^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + IntToStr(pMenC^.X-pMenF^.X+3)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
      end;
    end;
  end;
begin
  Cursor := crHourGlass;
  BeginHTML();
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := 12 * listMans.Count;
  GaugePos := 0;
//создаю списки
  Mens := TList.Create;
  MaWs := TList.Create;//мужей и жен
//заполн€ю элементы списка
  for i := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    New(pMen);
    pMen^.Men := i;
    pMen^.X := 0;
    pMen^.Y := 0;
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
  for i := 0 to listMans.Count-1 do begin
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
          if listGender.Strings[i] = Man then MaW.woman := iRetrName(s)
          else if listGender.Strings[i] = Woman then MaW.man := iRetrName(s);
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
        iYR := YmaxR + 100;
        iXR := cntR * delta + 20;
        ParentsAlls( iXR, iYR, listMans.Strings[pMen^.Men], i, LeftRight);
        Inc(cntR);
        LeftRight := False;
      end else begin
        iYL := YmaxL + 100;
        iXL := cntL * delta - 230;
        ParentsAlls( iXL, iYL, listMans.Strings[pMen^.Men], i, LeftRight);
        Dec(cntL);
        LeftRight := True;
      end;
    end;
  end;
//отступ слева цент отступ с справа
  if YmaxL > YmaxR
    then Ht := YmaxL+5
    else Ht := YmaxR+5;
  XmaxR := XmaxR+220;
  XmaxL := XmaxL-220;
  Wt := XmaxR - XmaxL;
// инверси€
  for i := 0 to Mens.Count-1 do begin
    pMen := Mens[i];
    if pMen^.Yes <> 0 then pMen^.Y := Ht - pMen^.Y;
    if pMen^.X >= 0 then pMen^.X := pMen^.X + LinWidth * cntR;
    if pMen^.X < 0 then pMen^.X := pMen^.X + LinWidth * cntL;
  end;
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
  for i := 0 to Mens.Count-1 do begin//рисую
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if pMen^.Yes <> 0 then begin
      DrawHMen( pMen^.Men, pMen^.X - XmaxL, pMen^.Y, listMans.Strings[pMen^.Men], pMen^.Sex);
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
//
  HTMLText := HTMLText + '<table border=0 style="POSITION: absolute; LEFT: 0px; TOP: '+IntToStr(Ht)+'px; WIDTH: 0px; HEIGHT: 0px">';
  HTMLText := HTMLText + '<tr><td></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
//  WebBrowser1.SetHtmlFromStr(HTMLText);
//  Application.ProcessMessages;
// сохраняю в файле
  Memo1.Text := HTMLText;
  Memo1.Lines.SaveToFile(MainPathTMP+dZd+MainFileHTM);
// вывожу во внешнем броузере
  OpenDocument(MainPathTMP+dZd+MainFileHTM);
//
  ProcessForm.Hide;
  Cursor := crDefault;
end;

procedure TTreeHtmForm.DrawPaintTreeHAll;
const
  delta = 12;
var
  i, cnt : Integer;
  dltTL : Integer;      //дельта левой части ствола
  dltTR : Integer;      //дельта правой части ствола
  dlt : Integer;        //дельта кроны, левой и правой части древа
  iSdlt : Boolean;      //надо ли увеличивать дельту
  alfa : Integer;       //центральна€ ось X
  cFather : Integer;    //количество отцов
  cMother : Integer;    //количество метерей
  Xmax : Integer;       //правый
  Xmin : Integer;       //левый
  Ymax : Integer;       //высота
  ht, wt : Integer;     //размер области рисовани€
  mw : Integer;         // мужчина - 0 женщина - 1
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
      if pMen1^.X > 0 then begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(5+LinWidth*dltTR+alfa)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X-LinWidth*dltTR-5)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(5+LinWidth*dltTR+alfa)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(Ymax-pMen1^.Y+40)+'px"><tr><td></td></tr></table>';
        Inc(dltTR);
      end else begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(5+pMen1^.X+alfa+193)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + IntToStr(LinWidth*dltTL-pMen1^.X-193)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(5+LinWidth*dltTL+alfa)+'px; TOP: '+IntToStr(pMen1^.Y+40)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(Ymax-pMen1^.Y+40)+'px"><tr><td></td></tr></table>';
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
      if pMen1^.X > 0 then begin
       if pMen1^.Y > pMen2^.Y then begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa-8)+'px; TOP: '+IntToStr(pMen1^.Y+37)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + '11px; HEIGHT: 0px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa-8)+'px; TOP: '+IntToStr(pMen2^.Y+58)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.Y-pMen2^.Y-18)+'px"><tr><td></td></tr></table>';
       end else begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa-13)+'px; TOP: '+IntToStr(pMen1^.Y+37)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + '14px; HEIGHT: 0px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa-13)+'px; TOP: '+IntToStr(pMen1^.Y+17)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMen2^.Y-pMen1^.Y-15)+'px"><tr><td></td></tr></table>';
       end;
      end else begin
       if pMen1^.Y > pMen2^.Y then begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+200)+'px; TOP: '+IntToStr(pMen1^.Y+37)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + '11px; HEIGHT: 0px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+210)+'px; TOP: '+IntToStr(pMen2^.Y+58)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.Y-pMen2^.Y-18)+'px"><tr><td></td></tr></table>';
       end else begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+200)+'px; TOP: '+IntToStr(pMen1^.Y+37)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + '14px; HEIGHT: 0px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+215)+'px; TOP: '+IntToStr(pMen1^.Y+17)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + IntToStr(pMen2^.Y-pMen1^.Y-15)+'px"><tr><td></td></tr></table>';
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
      if pMen1^.X > 0 then begin                //если ребенок справа
        if (pMen1^.Y < pMen2^.Y) then begin     //если родитель ниже ребенка
          if pMen2^.X > 0 then begin            //если родитель справа
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+190)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen1^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+187)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.Y-pMen1^.Y+65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.X+alfa+190)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen2^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end else begin                        //если родитель слева
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+195)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen1^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+195)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.Y-dlt*delta+3)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+195-(Xmin+alfa-dlt*delta))+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.Y-dlt*delta+65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen2^.X-Xmin+dlt*delta)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end;
        end else begin                          //если родитель выше ребенка
          if pMen2^.X > 0 then begin            //если ребенок справа
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+190)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen1^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+187)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.Y-pMen2^.Y-65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.X+alfa+190)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen2^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end else begin                        //если ребенок слева
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X+alfa+195)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen1^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+195)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.Y-dlt*delta+3)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+195-(Xmin+alfa-dlt*delta))+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.Y-dlt*delta+65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen2^.X-Xmin+dlt*delta)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end;
        end;
      end else begin                            //если ребенок слева
        if (pMen1^.Y < pMen2^.Y) then begin     //если родитель ниже ребенка
          if pMen2^.X < 0 then begin            //если родитель слева
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen1^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X-Xmin+dlt*delta+3)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen1^.Y+65)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.Y-pMen1^.Y-65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen2^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X-Xmin+dlt*delta+26)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end else begin                        //если родитель справа
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X-Xmin+dlt*delta)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.Y-dlt*delta)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+195-(Xmin+alfa-dlt*delta))+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+192)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.Y-dlt*delta+65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.X+alfa+195)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen2^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end;
        end else begin                          //если родитель выше ребенка
          if pMen2^.X < 0 then begin            //если родитель слева
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X-Xmin+dlt*delta+3)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.Y-pMen2^.Y-65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen2^.X-Xmin+dlt*delta+3)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end else begin                        //если родитель справа
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(pMen1^.Y)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(pMen1^.X-Xmin+dlt*delta)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen1^.Y-dlt*delta)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmin+alfa-dlt*delta)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+195-(Xmin+alfa-dlt*delta))+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(Xmax+alfa+dlt*delta+192)+'px; TOP: '+IntToStr(dlt*delta)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.Y-dlt*delta+65)+'px"><tr><td></td></tr></table>';
            HTMLText := HTMLText + '<table bordercolor=#00FF00 style="POSITION: absolute; LEFT: ';
            HTMLText := HTMLText + IntToStr(pMen2^.X+alfa+195)+'px; TOP: '+IntToStr(pMen2^.Y+65)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
            HTMLText := HTMLText + IntToStr(Xmax+dlt*delta-pMen2^.X)+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
          end;
        end;
      end;
    end;
  end;
  //заполн€ю координаты
  procedure ParentsMens(const X, Y: Integer; Name: String; Index: Integer);
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
    if LeftRight then iCol := iY2+41 else iCol := iY1+41;
    for iRow := 0 to listMans.Count-1 do begin
      // ищу всех детей мужской линии
      if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Name then begin
          iPar := iRetrMother(listMother.Strings[iRow]);
          if iNam <> iPar then begin// мать
            iNam := iPar;
          end;
          if LeftRight then begin
            iY2 := iY2 + 80;
            ParentsMens( X+23, iCol-7, listMans.Strings[iRow], iRow);
          end else begin
            iY1 := iY1 + 80;
            ParentsMens( X-23, iCol-7, listMans.Strings[iRow], iRow);
          end;
        end;
      end;
      // ищу всех детей женской линии
      if TuneForm.TreeFaMo.ItemIndex = 2 then
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Name then begin
          iPar := iRetrFather(listFather.Strings[iRow]);
          if iNam <> iPar then begin// отец
            iNam := iPar;
          end;
          if LeftRight then begin
            iY2 := iY2 + 80;
            ParentsMens( X+23, iCol-7, listMans.Strings[iRow], iRow);
          end else begin
            iY1 := iY1 + 80;
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
    for i := 0 to listMans.Count-1 do begin
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
    for i := 0 to listMans.Count-1 do begin
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
//
  BeginHTML();
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := 4 * listMans.Count;
  GaugePos := 0;
//создаю списки
  Mens := TList.Create;
//заполн€ю элементы списка
  for i := 0 to listMans.Count-1 do begin
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
  if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin//отступ сверху
    mw := 0;
  end else begin
    mw := 1;
  end;
  LeftRight := False;//начинаю с левой ветви
  for i := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if ((pMen^.Father = -1) and (pMen^.Mother = -1)
     and (pMen^.Sex = mw)
     and (pMen^.Yes = 1)) then begin
      if LeftRight then begin
        ParentsMens( iX2, iY2, listMans.Strings[pMen^.Men], pMen^.Men);
        iY2 := iY2 + 80;
        LeftRight := False;
      end else begin
        ParentsMens( iX1, iY1, listMans.Strings[pMen^.Men], pMen^.Men);
        iY1 := iY1 + 80;
        LeftRight := True;
      end;
    end;
  end;
// отступ слева цент отступ с справа
  if ((TuneForm.TreeFaMo.ItemIndex = 0) or (TuneForm.TreeFaMo.ItemIndex = 1)) then begin
    Wt := 2*(Xmax+(cMother div 2)*(delta+LinWidth)+235);
    Ht:= Ymax + 80;
  end else begin
    Wt := 2*(Xmax+(cFather div 2)*(delta+LinWidth)+235);
    Ht:= Ymax + 80;
  end;
  alfa := (Wt div 2);
// –исую св€зи
  cnt := -1;
  dltTL := 0;
  dltTR := 0;
  dlt := 0;
  for i := 0 to listMans.Count-1 do begin//рисую
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
  for i := 0 to listMans.Count-1 do begin//рисую
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pMen := Mens[i];
    if (pMen^.X+pMen^.Y) <> 0 then
    if listGender.Strings[i] = Man
      then DrawHMen( i, pMen^.X+alfa, pMen^.Y, listMans.Strings[i], 0)
      else DrawHMen( i, pMen^.X+alfa, pMen^.Y, listMans.Strings[i], 1);
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
//
  HTMLText := HTMLText + '<table border=0 style="POSITION: absolute; LEFT: 0px; TOP: '+IntToStr(Ht)+'px; WIDTH: 0px; HEIGHT: 0px">';
  HTMLText := HTMLText + '<tr><td></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
//  WebBrowser1.SetHtmlFromStr(HTMLText);
//  Application.ProcessMessages;
// сохраняю в файле
  Memo1.Text := HTMLText;
  Memo1.Lines.SaveToFile(MainPathTMP+dZd+MainFileHTM);
// вывожу во внешнем броузере
  OpenDocument(MainPathTMP+dZd+MainFileHTM);
//
  ProcessForm.Hide;
  Cursor := crDefault;
end;

procedure TTreeHtmForm.DrawPaintTreeHPeC;
var
  Sex : Integer;
  zentr : Integer;//размер области рисовани€
  done : Boolean;
  i : Integer;
  level : Integer;
  peoples : TStringList;
  OldBkMode: integer;
  Nama : String;
  //вычисл€ю количество кругов дл€ генеалогического круга
  procedure ParentsHI( X, Y: Integer; Name: String; Index: Integer);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
    One : Boolean;
  begin
    Inc(level);
    if peoples.Count < level then
      peoples.Add('');
    Name := Trim(listMans.Strings[Index]);
    if FileExists(MainPathICO+Name+'.bmp') then
      peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathICO+Name+'.bmp" width="48" height="48">' + Name
    else
    if FileExists(MainPathBMP+Name+'.jpg') then
      peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.jpg" width="48" height="48">' + Name
    else
    if FileExists(MainPathBMP+Name+'.bmp') then
      peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.bmp" width="48" height="48">' + Name
    else
      peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathEXE+'empty.gif">' + Name;
    One := False;
    iNam := -1;
    if X > iX2 then iX2 := X;
    iCol := iY2+61;
    for iRow := 0 to listMans.Count - 1 do begin
      // ищу всех детей мужской линии
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Name then begin
          iPar := iRetrMother(listMother.Strings[iRow]);
          if iNam <> iPar then begin
            if One then iY2 := iY2 + 60;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 60;
          ParentsHI( X+23, iCol-7, listMans.Strings[iRow], iRow);
        end;
      end;
      // ищу всех детей женской линии
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Name then begin
          iPar := iRetrFather(listFather.Strings[iRow]);
          if iNam <> iPar then begin
            if One then iY2 := iY2 + 60;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 60;
          ParentsHI( X+23, iCol-7, listMans.Strings[iRow], iRow);
        end;
      end;
    end;
    Dec(level);
  end;
  procedure ParentsLO( X, Y: Integer; Name: String; Index: Integer);
  var
    iRow : Integer;
  begin
    if ((Empty(listFather.Strings[ Index])) and (Empty(listMother.Strings[ Index]))) then Exit;
    Inc(level);
    if peoples.Count < level then
      peoples.Add('');
    if ((Empty(listMother.Strings[ Index])) and (not Empty(listFather.Strings[ Index]))) then begin
      Name := Trim(listFather.Strings[ Index]);
      if FileExists(MainPathICO+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathICO+Name+'.bmp" width="48" height="48">' + Name
      else
      if FileExists(MainPathBMP+Name+'.jpg') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.jpg" width="48" height="48">' + Name + ' ' + SpaceNBSP(Length(Name))
      else
      if FileExists(MainPathBMP+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.bmp" width="48" height="48">' + Name + ' ' + SpaceNBSP(Length(Name))
      else
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathEXE+'empty.gif">' + Name + ' ' + SpaceNBSP(Length(Name));
    end else
    if ((Empty(listFather.Strings[ Index])) and (not Empty(listMother.Strings[ Index]))) then begin
      Name := Trim(listMother.Strings[ Index]);
      if FileExists(MainPathICO+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathICO+Name+'.bmp" width="48" height="48">' + Name
      else
      if FileExists(MainPathBMP+Name+'.jpg') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.jpg" width="48" height="48">' + SpaceNBSP(Length(Name)) + ' ' + Name
      else
      if FileExists(MainPathBMP+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.bmp" width="48" height="48">' + SpaceNBSP(Length(Name)) + ' ' + Name
      else
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathEXE+'empty.gif">' + SpaceNBSP(Length(Name)) + ' ' + Name;
    end else begin
      Name := Trim(listFather.Strings[ Index]);
      if FileExists(MainPathICO+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathICO+Name+'.bmp" width="48" height="48">' + Name
      else
      if FileExists(MainPathBMP+Name+'.jpg') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.jpg" width="48" height="48">' + Name + ' ' + SpaceNBSP(Length(Name))
      else
      if FileExists(MainPathBMP+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathBMP+Name+'.bmp" width="48" height="48">' + Name + ' ' + SpaceNBSP(Length(Name))
      else
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathEXE+'empty.gif">' + Name + ' ' + SpaceNBSP(Length(Name));
      Name := Trim(listMother.Strings[ Index]);
      if FileExists(MainPathICO+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + '<img src="'+MainPathICO+Name+'.bmp" width="48" height="48">' + Name
      else
      if FileExists(MainPathBMP+Name+'.jpg') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + SpaceNBSP(Length(Name)) + ' ' + '<img src="'+MainPathBMP+Name+'.jpg" width="48" height="48">' + Name
      else
      if FileExists(MainPathBMP+Name+'.bmp') then
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + SpaceNBSP(Length(Name)) + ' ' + '<img src="'+MainPathBMP+Name+'.bmp" width="48" height="48">' + Name
      else
        peoples.Strings[level-1] := peoples.Strings[level-1] + ' ' + SpaceNBSP(Length(Name)) + ' ' + '<img src="'+MainPathEXE+'empty.gif">' + Name;
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
begin// –исую
  Cursor := crHourGlass;
//
  BeginHTML();
//создаю списки
  peoples := TStringList.Create;
// ¬ычисл€ю количество кругов
  iX2 := 0;
  iY2 := 40;
  level := 0;
  if TuneForm.TreeHiLo.ItemIndex = 0 then begin
    Nama := Trim(listMans.Strings[GridRow]);
    if FileExists(MainPathICO+Nama+'.bmp') then
      peoples.Add('<img src="'+MainPathICO+Nama+'.bmp" width="48" height="48">'+Nama)
    else
    if FileExists(MainPathBMP+Name+'.jpg') then
      peoples.Add('<img src="'+MainPathBMP+Nama+'.jpg" width="48" height="48">'+Nama)
    else
    if FileExists(MainPathBMP+Name+'.bmp') then
      peoples.Add('<img src="'+MainPathBMP+Nama+'.bmp" width="48" height="48">'+Nama)
    else
      peoples.Add('<img src="'+MainPathEXE+'empty.gif">'+Nama);
    peoples.Add('  '+listMans.Strings[GridRow]);
    Inc(level);
    ParentsLO( 30{X}, 0{Y}, listMans.Strings[GridRow], GridRow);
  end else begin
    ParentsHI( 30{X}, 0{Y}, listMans.Strings[GridRow], GridRow);
  end;
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := peoples.Count;
// рисую
  for i := peoples.Count-1 downto 0 do begin
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    HTMLText := HTMLText + '<table style="border: '+IntToStr((i+1)*2)+'px solid green; background: silver; padding: 10px">';
    HTMLText := HTMLText + '<tr><td bordercolor=Green bordercolordark=teal align=center valign=center>';
    HTMLText := HTMLText + IntToRoman(i+1) + '. ' + peoples.Strings[i];
  end;
  for i := peoples.Count-1 downto 0 do begin
    HTMLText := HTMLText + '</td></tr></table>';
  end;
  HTMLText := HTMLText + '<table border=0><tr><td></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
//  WebBrowser1.SetHtmlFromStr(HTMLText);
//  Application.ProcessMessages;
// сохраняю в файле
  Memo1.Text := HTMLText;
  Memo1.Lines.SaveToFile(MainPathTMP+dZd+MainFileHTM);
// вывожу во внешнем броузере
  OpenDocument(MainPathTMP+dZd+MainFileHTM);
//
  peoples.Free;//уничтожаю список
  ProcessForm.Hide;// закрытие окна процесса
  Cursor := crDefault;
end;

function TTreeHtmForm.StrNational(Nations : String): String;
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

procedure TTreeHtmForm.DrawPaintTreeHNat;
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
    for n := 0 to listMans.Count-1 do begin
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
    for n := 0 to listMans.Count-1 do begin
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
      pMen^.X := lX;
      pMen^.Y := lY;
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
      pMen^.X := lX;
      pMen^.Y := lY;
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
//
  BeginHTML();
// ¬ычисл€ю Y и X
  Mens := TList.Create;//создаю списки
  lX := 0;
  lY := 0;
  listNull := TStringList.Create;
  for i := 0 to listMans.Count-1 do listNull.Add(' ');
  listNull.Strings[GridRow] := National2(GridRow);//заполн€ю списки
// –исую
//рисую первым
  if listGender.Strings[ GridRow] = Man then Sex := 0 else Sex := 1;
  DrawHMen( GridRow, 0, 0, listMans.Strings[ GridRow], Sex);
  if not Empty(listNull.Strings[GridRow]) then begin
    DrawHNat( GridRow, 0, 70, listMans.Strings[ GridRow], Sex);
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
      if pMen^.Sex = 0 then begin
       if not done then begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen^.X*220+100)+'px; TOP: '+IntToStr(pMen^.Y*180-70)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + '80px"><tr><td></td></tr></table>';
       end else begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen^.X*220+100)+'px; TOP: '+IntToStr(pMen^.Y*180-30)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: ';
        HTMLText := HTMLText + '30px"><tr><td></td></tr></table>';
       end;
      end;
      if pMen^.Sex = 1 then begin
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ';
        HTMLText := HTMLText + IntToStr(pMen^.Father*220+210)+'px; TOP: '+IntToStr(pMen^.Y*180+35)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ';
        HTMLText := HTMLText + IntToStr((pMen^.X*220)-(pMen^.Father*220+200))+'px; HEIGHT: 0px"><tr><td></td></tr></table>';
      end;
    end;
    DrawHMen( pMen^.Men, pMen^.X*220, pMen^.Y*180, listMans.Strings[ pMen^.Men], Sex);
    if not Empty(listNull.Strings[pMen^.Men]) then begin
      DrawHNat( pMen^.Men, pMen^.X*220, pMen^.Y*180+70, listMans.Strings[ pMen^.Men], Sex);
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
//
  HTMLText := HTMLText + '<table border=0 style="POSITION: absolute; LEFT: 0px; TOP: '+IntToStr(iY2+100)+'px; WIDTH: 0px; HEIGHT: 0px">';
  HTMLText := HTMLText + '<tr><td></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
//  WebBrowser1.SetHtmlFromStr(HTMLText);
//  Application.ProcessMessages;
// сохраняю в файле
  Memo1.Text := HTMLText;
  Memo1.Lines.SaveToFile(MainPathTMP+dZd+MainFileHTM);
// вывожу во внешнем броузере
  OpenDocument(MainPathTMP+dZd+MainFileHTM);
//
  ProcessForm.Hide;// закрытие окна процесса
  Cursor := crDefault;
end;

procedure TTreeHtmForm.DrawPaintTreeHPerDn;
  //рисую генеалогическую ветвь
  procedure ParentsChilds( X, Y: Integer; Name: String; Index: Integer; Ons: Boolean);
  var
    iRow, iCol : Integer;
    iNam, iPar : Integer;
    One, On1 : Boolean;
    s, ss : String;
    Sex : Integer;
    aSpouse : TStringList;
    n, p : Integer;
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
      p := System.Pos(rzd3, aSpouse.Strings[n]);
      if p > 0 then aSpouse.Strings[n] := Copy(aSpouse.Strings[n], 1, p-1);
    end;
    // отец или мать
    HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(Y+23)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: '+IntToStr(iY2-Y+18)+'px"><tr><td></td></tr></table>';
    HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(iY2+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: 30px; HEIGHT: 0px"><tr><td></td></tr></table>';
    if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
    DrawHMen( Index, X, iY2, listMans.Strings[Index], Sex);
    iCol := iY2+50;
    for iRow := 0 to listMans.Count - 1 do begin
      // ищу всех детей мужской линии
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Name then begin
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
              iY2 := iY2 + 80;
              iCol := iY2 + 45;
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(Y+23)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: '+IntToStr(iY2-Y+18)+'px"><tr><td></td></tr></table>';
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(iY2+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: 30px; HEIGHT: 0px"><tr><td></td></tr></table>';
              if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
              DrawHMen( Index, X, iY2, listMans.Strings[Index], Sex);
              On1 := True;
            end;
            if iPar > -1 then begin
              if listGender.Strings[iPar] = Man then Sex := 0 else Sex := 1;
              DrawHMen( iPar, X+200, iY2, listMans.Strings[iPar], Sex);
            end;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 80;
          ParentsChilds( X+23, iCol-7, listMans.Strings[iRow], iRow, On1);
        end;
      end;
      // ищу всех детей женской линии
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Name then begin
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
              iY2 := iY2 + 80;
              iCol := iY2 + 45;
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(Y+23)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: '+IntToStr(iY2-Y+18)+'px"><tr><td></td></tr></table>';
              HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(iY2+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: 30px; HEIGHT: 0px"><tr><td></td></tr></table>';
              if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
              DrawHMen( Index, X, iY2, listMans.Strings[Index], Sex);
              On1 := True;
            end;
            if iPar > -1 then begin
              if listGender.Strings[iPar] = Man then Sex := 0 else Sex := 1;
              DrawHMen( iPar, X+200, iY2, listMans.Strings[iPar], Sex);
            end;
            iNam := iPar;
          end;
          One := True;
          iY2 := iY2 + 80;
          ParentsChilds( X+23, iCol-7, listMans.Strings[iRow], iRow, On1);
        end;
      end;
    end;
    // рисую жен и мужей без детей
    for n := 0 to aSpouse.Count-1 do begin
      if listGender.Strings[Index] = Man then Sex := 0 else Sex := 1;
      if One then begin
        iY2 := iY2 + 80;
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(Y+23)+'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: '+IntToStr(iY2-Y+18)+'px"><tr><td></td></tr></table>';
        HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: '+IntToStr(X-10)+'px; TOP: '+IntToStr(iY2+40)+'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: 30px; HEIGHT: 0px"><tr><td></td></tr></table>';
        DrawHMen( Index, X, iY2, listMans.Strings[Index], Sex);
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
      DrawHMen( iPar, X+200, iY2, aSpouse.Strings[n], Sex);
    end;
    aSpouse.Free;
  end;
begin// –исую
  Cursor := crHourGlass;
//создаю списки
  BeginHTML();
  HTMLText := HTMLText + '<div class="shadow" style="POSITION: absolute; LEFT: 0px; TOP: 0px; WIDTH: 405px; HEIGHT: 35px">';
  HTMLText := HTMLText + '<div class="blockr" style="POSITION: absolute; LEFT: 0px; TOP: 0px; WIDTH: 400px; HEIGHT: 30px">';
  HTMLText := HTMLText + '<center>' + CaptionBranch + '</center>';
  HTMLText := HTMLText + '</div>';
  HTMLText := HTMLText + '</div>';
  iX2 := 0; iY2 := 40;
  ParentsChilds( 30{X}, 9{Y}, listMans.Strings[GridRow], GridRow, False);
  HTMLText := HTMLText + '<table border=0 style="POSITION: absolute; LEFT: 0px; TOP: '+IntToStr(iY2+100)+'px; WIDTH: 0px; HEIGHT: 0px">';
  HTMLText := HTMLText + '<tr><td></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
//  WebBrowser1.SetHtmlFromStr(HTMLText);
//  Application.ProcessMessages;
// сохраняю в файле
  Memo1.Text := HTMLText;
  Memo1.Lines.SaveToFile(MainPathTMP+dZd+MainFileHTM);
// вывожу во внешнем броузере
  OpenDocument(MainPathTMP+dZd+MainFileHTM);
//
  Cursor := crDefault;
end;

procedure TTreeHtmForm.DrawPaintTreeHPerUp;
var
  i, n, p : Integer;
  iX : Integer;
  iY : Integer;
  Sex :Integer;
  s : String;
  minX :Integer;
  maxX :Integer;
  maxY :Integer;

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
	  iX := iX + 200;
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
    HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(cX+90) + 'px; TOP: ' + IntToStr(cY-5) + 'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: 5px"><tr><td></td></tr></table>';
    if (cX < pX) then begin
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(cX+90) + 'px; TOP: ' + IntToStr(cY-7) + 'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ' + IntToStr(pX - cX + 2) + 'px; HEIGHT: 0px"><tr><td></td></tr></table>';
    end else begin
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(pX+90) + 'px; TOP: ' + IntToStr(pY+73) + 'px; BORDER-TOP: 2pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 0pt solid; WIDTH: ' + IntToStr(cX - pX + 2) + 'px; HEIGHT: 0px"><tr><td></td></tr></table>';
    end;
      HTMLText := HTMLText + '<table bordercolor=#008000 style="POSITION: absolute; LEFT: ' + IntToStr(pX+90) + 'px; TOP: ' + IntToStr(pY+68) + 'px; BORDER-TOP: 0pt solid; BORDER-BOTTOM: 0pt solid; BORDER-RIGHT: 0pt solid; BORDER-LEFT: 2pt solid; WIDTH: 0px; HEIGHT: 5px"><tr><td></td></tr></table>';
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
//открываю броузер
  BeginHTML();
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
  // –исую ‘»ќ
  for i := 0 to listMans.Count-1 do begin//рисую
    pMen := Mens[i];
    if (pMen^.Yes <> 0) then begin
      Sex := pMen^.Sex;
      DrawHMen( pMen^.Men, pMen^.X, pMen^.Y, listMans.Strings[pMen^.Men], Sex);
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
    Dispose(pMen);// уничтожаю элемент
  end;
  Mens.Free;//уничтожаю список
//
  HTMLText := HTMLText + '<table border=0 style="POSITION: absolute; LEFT: 0px; TOP: '+IntToStr(iY2+100)+'px; WIDTH: 0px; HEIGHT: 0px">';
  HTMLText := HTMLText + '<tr><td></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
//  WebBrowser1.SetHtmlFromStr(HTMLText);
//  Application.ProcessMessages;
// сохраняю в файле
  Memo1.Text := HTMLText;
  Memo1.Lines.SaveToFile(MainPathTMP+dZd+MainFileHTM);
// вывожу во внешнем броузере
  OpenDocument(MainPathTMP+dZd+MainFileHTM);
//
  Cursor := crDefault;
end;

end.

