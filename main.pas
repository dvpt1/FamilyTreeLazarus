unit main;

{$mode objfpc}{$H+}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF DARWIN}
  MacOSAll,
{$ENDIF}
{$IFDEF LINUX}
  Unix,
{$ENDIF}
  Classes, SysUtils, FileUtil, PrintersDlgs, Forms, Controls, Graphics, Dialogs,
  ComCtrls, Grids, ExtCtrls, Printers,
  LResources, LMessages, LCLType, LCLIntf,
  Menus, StdCtrls, StdActns, IniFiles, ExtDlgs, GraphType;

type

  { TFamily }

  TFamily = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    ImagePrint: TImage;
    ImageEmpty: TImage;
    ImageIcon: TImage;
    ImageIcons: TImageList;
    ImageBar48: TImageList;
    Genr1: TMenuItem;
    Foto1: TMenuItem;
    Kino1: TMenuItem;
    File1: TMenuItem;
    Rich1: TMenuItem;
    Tree1: TMenuItem;
    New1: TMenuItem;
    Edit1: TMenuItem;
    Dele1: TMenuItem;
    Find1: TMenuItem;
    Sort1: TMenuItem;
    Print1: TMenuItem;
    KinoButton: TToolButton;
    Tune1: TMenuItem;
    PopupMenu1: TPopupMenu;
    PrintDialog1: TPrintDialog;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    FileButton: TToolButton;
    HelpButton: TToolButton;
    FindButton: TToolButton;
    SortButton: TToolButton;
    PrinButton: TToolButton;
    TuneButton: TToolButton;
    FotoButton: TToolButton;
    GenrButton: TToolButton;
    ListButton: TToolButton;
    RichButton: TToolButton;
    ExitButton: TToolButton;
    TreeButton: TToolButton;
    EditButton: TToolButton;
    DeleButton: TToolButton;
    procedure ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
    procedure DeleButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FileButtonClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FotoButtonClick(Sender: TObject);
    procedure GenrButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure KinoButtonClick(Sender: TObject);
    procedure ListButtonClick(Sender: TObject);
    procedure PrinButtonClick(Sender: TObject);
    procedure RichButtonClick(Sender: TObject);
    procedure SortButtonClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure TreeButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure OpenProgram();
    procedure CreateStringGrid;
    procedure LoadStringGrid;
    procedure IconLoadForName(Nama : String);
    procedure SaveStringGrid;
  end;

var
  Family: TFamily;

implementation

uses tune, vars, utils, mstring, prints,
     person, personnew, info, prozess,
     treebmp, treehtm,
     test, genr, foto, fold, find, sort, rich, kino;

{$R *.lfm}

{ TFamily }

procedure TFamily.FormCreate(Sender: TObject);
begin
  // √лобальные переменные
  InitVars;
  // настройки
  OpenProgram();
  // ќткрываю форму и передаю фокус таблице
  Family.Show;
  StringGrid1.Focused;
end;

procedure TFamily.FormResize(Sender: TObject);
begin
  with Family.StringGrid1 do begin
  ColWidths[0] := 64;
  ColWidths[1] := StringGrid1.Width - ColWidths[0]- 20;
  end;
end;

procedure TFamily.FotoButtonClick(Sender: TObject);
begin
  PersonAll := True;
  FotoForm.ShowModal;
end;

procedure TFamily.GenrButtonClick(Sender: TObject);
begin
  TestForm.TestBaseFamily();// провер€ю базу
  if not YesNo then begin// рисую древо
    GenrForm.Caption := CaptionGenr;
    GenrForm.GenerationAll;
    GenrForm.ShowModal;
  end else
    TestForm.ShowModal;
end;

procedure TFamily.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TFamily.KinoButtonClick(Sender: TObject);
begin
  PersonAll := True;
  KinoForm.ShowModal;
end;

procedure TFamily.ListButtonClick(Sender: TObject);
begin
  PersonNewForm.ShowModal;
  if Modified then
    Family.SaveStringGrid;
end;

procedure TFamily.PrinButtonClick(Sender: TObject);
var
  s : String;
  i, j, w, h, x, y : Integer;
  relHeight : Integer;//высота страницы в пиксел€х
  relWidth : Integer; //ширина страницы в пиксел€х
  indentX : Integer;//отступ слева и справа
  indentY : Integer;//отступ сверху и снизу
  aRectRow : TRect;
  cntList : Integer;
  cntPage : Integer;
  cntRow  : Integer;

  procedure DrawRow(aRow : Integer; aRect : TRect);
  begin
    ImagePrint.Canvas.Font.Name := Family.Font.Name;
    ImagePrint.Canvas.Font.Size := 18;
    ImagePrint.Canvas.Font.Style := Font.Style;
    ImagePrint.Canvas.Brush.Color := clWhite;
    ImagePrint.Canvas.FillRect(aRect);
    ImageIcons.Draw(ImagePrint.Canvas,aRect.Left-sizeRowMiddle,aRect.Top,ARow);
    if listGender.Strings[aRow] = Man then
      ImagePrint.Canvas.Brush.Color := clFuchsia
    else
    if listGender.Strings[aRow] = Woman then
      ImagePrint.Canvas.Brush.Color := clAqua
    else
      ImagePrint.Canvas.Brush.Color := clWhite;
    ImagePrint.Canvas.Font.Color := clBlack;
    ImagePrint.Canvas.FillRect(aRect);
    w := ImagePrint.Canvas.TextWidth('A');
    h := ImagePrint.Canvas.TextHeight('X');
    x := ((aRect.Right-aRect.Left) div 2) - Length(listMans.Strings[aRow]) * w div 2;
    ImagePrint.Canvas.Font.Style := [fsBold];
    ImagePrint.Canvas.TextOut(aRect.Left+x, aRect.Top, listMans.Strings[aRow]);
    ImagePrint.Canvas.Font.Style := [fsItalic];
    if not Empty(listBirth.Strings[aRow]) then begin
      ImagePrint.Canvas.TextOut(aRect.Left+15, aRect.Top, field_birth +' '+ listBirth.Strings[aRow]);
    end;
    if not Empty(listDeath.Strings[aRow]) then begin
      s := field_death +' '+ listDeath.Strings[aRow];
      x := aRect.Right - Length(s) * w - 80;
      ImagePrint.Canvas.TextOut(x, aRect.Top, s);
    end;
    ImagePrint.Canvas.Font.Style := [];
    if not Empty(listFather.Strings[aRow]) then begin
      ImagePrint.Canvas.TextOut(aRect.Left+15, aRect.Top+40, field_father +' '+ listFather.Strings[aRow]);
    end;
    if not Empty(listMother.Strings[aRow]) then begin
      ImagePrint.Canvas.TextOut(aRect.Left+15, aRect.Top+80, field_mother +' '+ listMother.Strings[aRow]);
    end;
  end;
 // if ZoomPercent=100, Image will be printed across the whole page
 procedure PrintImage(Image: TImage; ZoomPercent: Integer);
 var
   rHeight : Integer;//высота страницы в пиксел€х
   rWidth  : Integer; //ширина страницы в пиксел€х
 begin
  with Image.Picture.Bitmap do
  begin
    if ((Width / Height) > (relWidth / relHeight)) then begin
      // Stretch Bitmap to width of PrinterPage
      rWidth := relWidth;
      rHeight := MulDiv(Height, relWidth, Width);
    end else begin
      // Stretch Bitmap to height of PrinterPage
      rWidth := MulDiv(Width, relHeight, Height);
      rHeight := relHeight;
    end;
    rWidth := Round(rWidth * ZoomPercent / 100);
    rHeight := Round(rHeight * ZoomPercent / 100);
    try
      Printer.Canvas.StretchDraw(Rect(0, 0, rWidth, rHeight), Image.Picture.Graphic);
    except
    end;
  end;
 end;
begin
  if (listMans.Count = 0) then Exit;
  if not PrintDialog1.Execute then Exit;
  Screen.Cursor := crHourglass;
  Printer.BeginDoc;
  Printer.Title := CaptionList;
// количество строк и размер RECT
  relWidth  := Printer.PageWidth;
  relHeight := Printer.PageHeight;
  indentX := relWidth div 5;
  indentY := sizeRowMiddle*2;
  cntList := Round((relHeight - indentY * 2) div (sizeRowMiddle * 2));//count rows
  cntPage := Round(listMans.Count div cntList)+1;     //колич.страниц
// рисую на ImagePrint
  cntRow := 0;
  done := True;
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := cntPage-1;
  for j := 0 to cntPage-1 do begin
   ProcessForm.Gauge1.Position := i;
   Application.ProcessMessages;
// задаю область рисовани€
   ImagePrint.Width := relWidth;
   ImagePrint.Height := relHeight;
   ImagePrint.Canvas.Brush.Color := clWhite;
   ImagePrint.Canvas.Brush.Style := bsSolid;
   ImagePrint.Canvas.FillRect(0,0,relWidth,relHeight);
   for i := 0 to cntList-1 do begin
    aRectRow := Rect(sizeRowMiddle+indentX, 2*sizeRowMiddle*i + indentY, relWidth-indentX, 2*sizeRowMiddle*(i+1) + indentY);
    DrawRow(cntRow, aRectRow);
    Inc(cntRow);
    if cntRow = listMans.Count then Break;
    if not done then break;
   end;
   if not done then  break;
   if j <> 0 then Printer.NewPage;
   PrintImage(ImagePrint, 100);
   if cntRow = listMans.Count then Break;
  end;
  ProcessForm.Hide;
//
  Printer.EndDoc;
  Screen.cursor := crDefault;
end;

procedure TFamily.RichButtonClick(Sender: TObject);
begin
  PersonAll := True;
  RichForm.ShowModal;
end;

procedure TFamily.SortButtonClick(Sender: TObject);
begin
  SortForm.ShowModal;
end;

procedure TFamily.StringGrid1DblClick(Sender: TObject);
begin
  PersonForm.ShowModal;
  if Modified then
    Family.SaveStringGrid;
end;

procedure TFamily.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  s : String;
  w, h, x, y : Integer;
begin
  if (listMans.Count = 0) then Exit;
  StringGrid1.Canvas.Font.Name := Family.Font.Name;
  StringGrid1.Canvas.Font.Size := Family.Font.Size;
  if (gdFixed in aState) then begin              // –исую фиксированную колонку
    if ACol = 0 then begin     // –исую фиксированную колонку
      StringGrid1.Canvas.Brush.Color := clWhite;
      StringGrid1.Canvas.FillRect(aRect);
      ImageIcons.Draw(StringGrid1.Canvas,aRect.Left,aRect.Top,ARow);
    end;
  end else begin                                // –исую остальные строки и колонки
    if (gdFocused in aState) then begin   // –исую выбранную €чейку строку
      StringGrid1.Canvas.Brush.Color := clBlue;
      StringGrid1.Canvas.Font.Color := clWindow;
      GridCol := ACol;             // запоминаю текущую колонку
      GridRow := ARow;             // и строку
      GridRect := aRect;           // координаты
    end else begin                               // –исую невыбранные столбцы
      if listGender.Strings[aRow] = Man then
        StringGrid1.Canvas.Brush.Color := clAqua-100
      else
      if listGender.Strings[aRow] = Woman then
        StringGrid1.Canvas.Brush.Color := clFuchsia-10
      else
        StringGrid1.Canvas.Brush.Color := clWhite;
      StringGrid1.Canvas.Font.Color := clBlack;
    end;
    StringGrid1.Canvas.FillRect(aRect);
    w := StringGrid1.Canvas.TextWidth('A');
    h := StringGrid1.Canvas.TextHeight('X');
    x := (StringGrid1.Width div 2) - Length(listMans.Strings[aRow]) * w div 2;
    StringGrid1.Canvas.Font.Style := [fsBold];
    StringGrid1.Canvas.TextOut(aRect.Left+x, aRect.Top, listMans.Strings[aRow]);
    StringGrid1.Canvas.Font.Style := [fsItalic];
    if not Empty(listBirth.Strings[aRow]) then begin
      StringGrid1.Canvas.TextOut(aRect.Left+15, aRect.Top, field_birth +' '+ listBirth.Strings[aRow]);
    end;
    if not Empty(listDeath.Strings[aRow]) then begin
      s := field_death +' '+ listDeath.Strings[aRow];
      x := StringGrid1.Width - Length(s) * w - 80;
      StringGrid1.Canvas.TextOut(aRect.Left+x, aRect.Top, s);
    end;
    StringGrid1.Canvas.Font.Style := [];
    if not Empty(listFather.Strings[aRow]) then begin
      StringGrid1.Canvas.TextOut(aRect.Left+15, aRect.Top+20, field_father +' '+ listFather.Strings[aRow]);
    end;
    if not Empty(listMother.Strings[aRow]) then begin
      StringGrid1.Canvas.TextOut(aRect.Left+15, aRect.Top+40, field_mother +' '+ listMother.Strings[aRow]);
    end;
  end;
end;

procedure TFamily.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if Key <> #13 then Exit;
  PersonForm.ShowModal;
end;

procedure TFamily.TreeButtonClick(Sender: TObject);
begin
  TestForm.TestBaseFamily();// провер€ю базу
  if not YesNo then begin// рисую древо
      if TuneForm.GroupView.ItemIndex = 0 then begin
        TreeBmpForm.Caption := CaptionTree;
        case TuneForm.FormTree.ItemIndex of
        0: if TuneForm.TreeHiLo.ItemIndex = 0 then
             TreeBmpForm.DrawPaintTreeAaa
           else
             TreeBmpForm.DrawPaintTreeDown;
        1: TreeBmpForm.DrawPaintTreeAll;
        2: TreeBmpForm.DrawPaintTreePeC;
        3: TreeBmpForm.DrawPaintTreeNat;
        end;
        TreeBmpForm.ShowModal;
      end else begin
        TreeHtmForm.Caption := CaptionTree;
        case TuneForm.FormTree.ItemIndex of
        0: if TuneForm.TreeHiLo.ItemIndex = 0 then
             TreeHtmForm.DrawPaintTreeHAaa
           else
             TreeHtmForm.DrawPaintTreeHDown;
        1: TreeHtmForm.DrawPaintTreeHAll;
        2: TreeHtmForm.DrawPaintTreeHPeC;
        3: TreeHtmForm.DrawPaintTreeHNat;
        end;
        //??TreeHtmForm.ShowModal;
      end;
  end else// if find error
    TestForm.ShowModal;
end;

procedure TFamily.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

procedure TFamily.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeVars;
end;

procedure TFamily.ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
begin
  // ќбновление панели статуса
  if not Empty(listMans.Strings[StringGrid1.Row]) then
    Caption := '[' + IntToSTr(StringGrid1.RowCount) +':'+ IntToSTr(StringGrid1.Row+1) + '] - ' + listMans.Strings[StringGrid1.Row]
  else
    Caption := app_name;
  if ReDraws then begin
    StringGrid1.Repaint;
    ReDraws := False;
  end;
end;

procedure TFamily.DeleButtonClick(Sender: TObject);
var
  l : Longint;
  i,ii,n,p : Integer;
  s,ss : String;
  aSpouse : TStringList;
  sSpouse : String;
  b : Boolean;
begin
  if StringGrid1.Row < 0 then Exit;// если не выбрана ни одна строка
  if StringGrid1.RowCount = 1 then exit;  // если осталось одна строка, не удал€ть
  if Application.MessageBox( PChar(msgDelPerson), '',mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    for i := 0 to listMans.Count - 1 do begin// удал€ю из пол€ FATHER и MOTHER
      if listFather.Strings[i] = listMans.Strings[StringGrid1.Row] then
        listFather.Strings[i] := '';
      if listMother.Strings[i] = listMans.Strings[StringGrid1.Row] then
        listMother.Strings[i] := '';
      if Pos(listMans.Strings[StringGrid1.Row], listSpouse.Strings[i]) > 0 then begin// если есть муж или жена
        aSpouse := TStringList.Create;//список жен/мужей
        ss := listSpouse.Strings[i];
        repeat
          n := Pos(rzd2, ss);
          if n > 0 then begin
            s := Copy(ss,1,n-1);
            ss := Copy(ss,n+1,Length(ss));
          end else
            s := ss;
          if not Empty(s) then aSpouse.Add(s);
        until n=0;
        b := False;
        for n := 0 to aSpouse.Count-1 do begin//ищу супруга
          p := Pos(rzd3, aSpouse.Strings[n]);
          if (p > 0) then begin
            sSpouse := Copy(aSpouse.Strings[n],1,p-1);
          end else begin
            sSpouse := aSpouse.Strings[n];
          end;
          if sSpouse = listMans.Strings[StringGrid1.Row] then begin
            b := True;
            aSpouse.Strings[n] := '';//чищу супруга
          end;
        end;
        if b then begin//соедин€ю всех супругов
          ss := '';
          for n := 0 to aSpouse.Count-1 do begin
            if not Empty(aSpouse.Strings[n]) then
              ss := ss + aSpouse.Strings[n] + rzd2;
          end;
          listSpouse.Strings[i] := ss;
        end;
        aSpouse.Free;
      end;
    end;
    if Trim(listMans.Strings[StringGrid1.Row]) <> '' then begin
      s := MainPathTXT + listMans.Strings[StringGrid1.Row]+'.txt';
      if FileExists(s) then DeleteFile(s);// удал€ю описание
      s := MainPathICO + listMans.Strings[StringGrid1.Row]+'.bmp';
      if FileExists(s) then DeleteFile(s);// удал€ю иконку
      s := MainPathBMP + listMans.Strings[StringGrid1.Row]+'.jpg';
      if FileExists(s) then DeleteFile(s);// удал€ю фото
      b := DeleteDirectory(MainPathFTS + listMans.Strings[StringGrid1.Row],True);
      if b then begin
        b := RemoveDir(MainPathFTS + listMans.Strings[StringGrid1.Row]);
      end;
      b := DeleteDirectory(MainPathVID + listMans.Strings[StringGrid1.Row],True);
      if b then begin
        b := RemoveDir(MainPathVID + listMans.Strings[StringGrid1.Row]);
      end;
      b := DeleteDirectory(MainPathFLS + listMans.Strings[StringGrid1.Row],True);
      if b then begin
        b := RemoveDir(MainPathFLS + listMans.Strings[StringGrid1.Row]);
      end;
    end;
    listBirth.Delete(StringGrid1.Row);
    listDeath.Delete(StringGrid1.Row);
    listMans.Delete(StringGrid1.Row);
    listFather.Delete(StringGrid1.Row);
    listMother.Delete(StringGrid1.Row);
    listGender.Delete(StringGrid1.Row);
    listPlaceb.Delete(StringGrid1.Row);
    listPlaced.Delete(StringGrid1.Row);
    listSpouse.Delete(StringGrid1.Row);
    listNati.Delete(StringGrid1.Row);
    listOccu.Delete(StringGrid1.Row);
    ImageIcons.Delete(StringGrid1.Row);
    StringGrid1.RowCount := StringGrid1.RowCount - 1;
    Modified := True;
    if StringGrid1.Row > StringGrid1.RowCount - 1 then
      StringGrid1.Row := StringGrid1.RowCount - 1;
    SaveStringGrid;
  end;
end;

procedure TFamily.EditButtonClick(Sender: TObject);
begin
  PersonForm.ShowModal;
  if Modified then
    Family.SaveStringGrid;
end;

procedure TFamily.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFamily.FileButtonClick(Sender: TObject);
begin
  PersonAll := True;
  FileForm.ShowModal;
end;

procedure TFamily.FindButtonClick(Sender: TObject);
begin
  FindForm.ShowModal;
end;

procedure TFamily.OpenProgram;
var
  h, w : Integer;
begin
// первоначальна€ установка логических переменных
  Modified := False;
  SubDirFoto := ' ';// -1
  SubDirVideo := ' ';// -1
  SubDirFiles := ' ';// -1
// загружаю конфигурацию из реестра
  TuneForm.LoadPathData();
// каталоги
  MainFileCSV := MainPathDAT+FileNameDB;
  MainPathTXT := MainPathDAT+PathTXT;
  MainPathICO := MainPathDAT+PathICO;
  MainPathBMP := MainPathDAT+PathBMP;
  MainPathFTS := MainPathDAT+PathFTS;
  MainPathVID := MainPathDAT+PathVID;
  MainPathFLS := MainPathDAT+PathFLS;
  MainPathTMP := MainPathDAT+'tmp';
  MainPathRES := MainPathEXE+PathRES;
// создаю файлы и каталоги
  if not DirectoryExists(MainPathDAT) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathDAT));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathDAT);
    {$ENDIF}
  if not FileExists(MainFileCSV) then CreateStringGrid;
  if not DirectoryExists(MainPathTXT) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathTXT));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathTXT);
    {$ENDIF}
  if not DirectoryExists(MainPathICO) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathICO));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathICO);
    {$ENDIF}
  if not DirectoryExists(MainPathBMP) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathBMP));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathBMP);
    {$ENDIF}
  if not DirectoryExists(MainPathFTS) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathFTS));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathFTS);
    {$ENDIF}
  if not DirectoryExists(MainPathVID) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathVID));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathVID);
    {$ENDIF}
  if not DirectoryExists(MainPathFLS) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathFLS));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathFLS);
    {$ENDIF}
  if not DirectoryExists(MainPathTMP) then
    {$IFDEF WINDOWS}
    MkDir(UTF8toANSI(MainPathTMP));
    {$ENDIF}
    {$IFDEF UNIX}
    MkDir(MainPathTMP);
    {$ENDIF}
// открываю файл базы
  LoadStringGrid;
end;

procedure TFamily.CreateStringGrid;
begin
  AssignFile(FileDB, MainFileCSV);
  {$I-}
  ReWrite(FileDB);
  {$I+}
  Writeln(FileDB,';;;;;;;;');
  CloseFile(FileDB);
end;

procedure TFamily.LoadStringGrid;
var
  s, ss : String;
  i, ii : Integer;
  prozess : Int64;
begin
  AssignFile(FileDB, MainFileCSV);
  {$I-}
  Reset(FileDB);
  {$I+}
  //
  ClearVars;
  //
  StringGrid1.Enabled := False;
  StringGrid1.ColCount := 2;
  StringGrid1.RowCount := 0;
  Family.ImageIcons.Clear;
  ProcessForm.Caption := task_loading;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := FileUtil.FileSize(MainFileCSV) div 100;
  prozess := 0;
  while not eof(FileDB) do begin{ “екст таблицы}
    Readln(FileDB,ss);
    prozess := prozess + Length(ss);
    ProcessForm.Gauge1.Position := prozess div 100;
    Application.ProcessMessages;
    for i:= 1 to CountCol do begin
      ii := Pos(';',ss);
      if ii = 0 then ii := Length(ss)+1;
      if i = CountCol then
        s := ss
      else
        s := Copy(ss,1,ii-1);
      ss := Copy(ss,ii+1,32000);
      if Pos(';',s) > 0 then s := '';
      case i of
      fldBEG: listBirth.Add(s);
      fldEND: listDeath.Add(s);
      fldNAM: listMans.Add(s);
      fldFAT: listFather.Add(s);
      fldMOT: listMother.Add(s);
      fldMEN: listGender.Add(s);
      fldPLB: listPlaceb.Add(s);
      fldPLE: listPlaced.Add(s);
      fldMAW: listSpouse.Add(s);
      fldNAT: listNati.Add(s);
      fldOCC: listOccu.Add(s);
      end;
    end;
    IconLoadForName(listMans.Strings[listMans.Count - 1]);
    StringGrid1.RowCount := StringGrid1.RowCount + 1;// ”величиваю количество строк
  end;
  if (listMans.Count < 1) then begin
    listBirth.Add('');
    listDeath.Add('');
    listMans.Add('');
    listFather.Add('');
    listMother.Add('');
    listGender.Add('');
    listPlaceb.Add('');
    listPlaced.Add('');
    listSpouse.Add('');
    listNati.Add('');
    listOccu.Add('');
    StringGrid1.RowCount := 1;
  end;
  StringGrid1.Enabled := True;
  ProcessForm.Hide;
  //end;
  CloseFile(FileDB);
  Family.FormResize(Self);
end;

procedure TFamily.IconLoadForName(Nama : String);
var
  a,c : String;
  bm : TBitMap;
begin
  c := MainPathBMP + Nama + '.jpg';
  a := MainPathICO + Nama + '.bmp';
  if FileExists(a) then begin
    try
      ImageIcon.Picture.LoadFromFile(a);
      bm :=  TBitMap.Create;
      bm.Height := 64;
      bm.Width  := 64;
      bm.Canvas.StretchDraw(classes.Rect(0,0,64,64), ImageIcon.Picture.Bitmap);
      Family.ImageIcons.AddMasked( bm, clWhite);
      bm.Free;
    except
      ImageIcons.AddMasked( ImageEmpty.Picture.Bitmap, clWhite);
    end;
  end else
  if FileExists(c) then begin
    try
      ImageIcon.Picture.LoadFromFile(c);
      bm :=  TBitMap.Create;
      bm.Height := 64;
      bm.Width  := 64;
      bm.Canvas.StretchDraw(classes.Rect(0,0,64,64), ImageIcon.Picture.Bitmap);
      Family.ImageIcons.AddMasked( bm, clWhite);
      bm.Free;
    except
      ImageIcons.AddMasked( ImageEmpty.Picture.Bitmap, clWhite);
    end;
  end else begin
    bm :=  TBitMap.Create;
    bm.Height := 64;
    bm.Width  := 64;
    bm.Canvas.Brush.Color := clWhite;
    bm.Canvas.Brush.Style := bsSolid;
    bm.Canvas.FillRect(Rect(0,0,bm.Width,bm.Height));
    Family.ImageIcons.AddMasked( bm, clWhite);
    bm.Free;
  end;
end;

procedure TFamily.SaveStringGrid;
var
  i : Longint;
begin
  ProcessForm.Caption := task_saveing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := listMans.Count;
{ —охран€ю в файл базы}
  AssignFile(FileDB, MainFileCSV);
  {$I-}
  Rewrite(FileDB);
  {$I+}
  for i := 0 to listMans.Count - 1 do begin
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    Writeln(FileDB,
      listBirth.Strings[i]  +rzd1+
      listDeath.Strings[i]  +rzd1+
      listMans.Strings[i]   +rzd1+
      listFather.Strings[i] +rzd1+
      listMother.Strings[i] +rzd1+
      listGender.Strings[i] +rzd1+
      listPlaceb.Strings[i] +rzd1+
      listPlaced.Strings[i] +rzd1+
      listSpouse.Strings[i] +rzd1+
      listNati.Strings[i]   +rzd1+
      listoccu.Strings[i]
    );
  end;
  CloseFile(FileDB);
  ProcessForm.Hide;
end;

end.

