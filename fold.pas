unit fold;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  LResources, LMessages, LCLType, LCLIntf,
  Grids, Menus;

type

  { TFileForm }

  TFileForm = class(TForm)
    DeleButton: TToolButton;
    Dele1: TMenuItem;
    FileGrid1: TDrawGrid;
    Edit1: TMenuItem;
    EditButton: TToolButton;
    Exit1: TMenuItem;
    ExitButton: TToolButton;
    HelpButton: TToolButton;
    ImageIcons: TImageList;
    OpenDialog1: TOpenDialog;
    Pict1: TMenuItem;
    PictButton: TToolButton;
    PopupMenu1: TPopupMenu;
    Save1: TMenuItem;
    SaveButton: TToolButton;
    SaveDialog1: TSaveDialog;
    ToolBar1: TToolBar;
    TuneButton: TToolButton;
    procedure DeleButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FileGrid1DblClick(Sender: TObject);
    procedure FileGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure FileGrid1KeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure PictButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
    procedure CopyFileWithProgressBar1(Source, Destination: string);
  public
    { public declarations }
  end;

var
  FileForm: TFileForm;

implementation

uses vars, tune, main, desc, mstring, info, utils, prozess;

{$R *.lfm}

procedure TFileForm.DeleButtonClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if FilesLst.Count = 0 then Exit;
  if Application.MessageBox( PChar(msgDelFiles), '',mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    i := Pos(rzd2, FilesLst[iFiles]);
    if i > 0 then
      s := MainPathFLS + SubDirFiles + Copy(FilesLst[iFiles], 1, i-1)
    else
      s := MainPathFLS + SubDirFiles + FilesLst[iFiles];
    if FileExists(s) then
      {$IFDEF WINDOWS}
      SysUtils.DeleteFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      SysUtils.DeleteFile(s);
      {$ENDIF}
    (FilesLst.Objects[iFiles] as TBitmap).Free;
    FilesLst.Delete(iFiles);
    if iFiles = FilesLst.Count then Dec(iFiles);
    if iFiles = -1 then iFiles := 0;
    if (FilesLst.Count mod FileGrid1.ColCount) = 0 then
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount
    else
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount + 1;
    s := MainPathFLS + SubDirFiles + MainFileFLS;
    {$IFDEF WINDOWS}
    FilesLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    FilesLst.SaveToFile(s);
    {$ENDIF}
    if FileGrid1.ColCount = 0 then FileGrid1.ColCount := 1;//колонок не может быть 0
    FileGrid1.Row := iFiles div FileGrid1.ColCount;
    FileGrid1.Col := iFiles - FileGrid1.ColCount * FileGrid1.Row;
    FileGrid1.Repaint;
  end;
end;

procedure TFileForm.EditButtonClick(Sender: TObject);
var
  s : String;
begin
  if iFiles >= FilesLst.Count then exit;
  NameNote := FilesLst[iFiles];
  DescForm.ShowModal;
  if ModifiName then begin
    if not RightFileName(NamsDesc) then begin
      MessageDlg(msgNotSymbol, mtWarning, [mbOk], 0);
      Exit;
    end;
    if FileExists(MainPathFLS + SubDirFiles + NamsDesc + ExtsDesc) and (NamsDesc <> OldsDesc) then begin
      MessageDlg(msgFileExists, mtWarning, [mbOk], 0);
      Exit;
    end;
    if  NamsDesc <> OldsDesc then begin
      RenameFile( MainPathFLS + SubDirFiles + OldsDesc + ExtsDesc, MainPathFLS + SubDirFiles + NamsDesc + ExtsDesc);
      {$IFDEF WINDOWS}
      {$ENDIF}
      {$IFDEF UNIX}
      {$ENDIF}
    end;
    FilesLst[iFiles] := NameNote;
    s := MainPathFLS + SubDirFiles + MainFileFLS;
    {$IFDEF WINDOWS}
    FilesLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    FilesLst.SaveToFile(s);
    {$ENDIF}
    FileGrid1.Repaint;
  end;
end;

procedure TFileForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFileForm.FileGrid1DblClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if iFiles >= FilesLst.Count then exit;
  if FilesLst.Count = 0 then Exit;
  i := Pos(':',FilesLst[iFiles]);
  if i > 0 then
    s := Copy(FilesLst[iFiles],1,i-1)
  else
    s := FilesLst[iFiles];
  if FileExists(MainPathFLS + SubDirFiles + s) then
    OpenDocument(MainPathFLS + SubDirFiles + s);
end;

procedure TFileForm.FileGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  i, p, w, h, c, rt, rl: Integer;
  s, ss, a, ext : String;
  f : Single;
  Dest, Source : TRect;
begin
  Dest := aRect;
  if FilesLst = Nil then exit;
  if FilesLst.Count = 0 then exit;
  i := FileGrid1.ColCount * ARow + ACol;// ѕересчитываем координаты €чейки в индекс списка:
  with FileGrid1.Canvas, FilesLst do begin
  if (gdFocused in aState) then
    if i < FilesLst.Count then iFiles := i;// запоминаю текущую строку
  CopyMode := cmSrcCopy;
  Brush.Color := clWhite;
  FillRect(aRect);
  if i < FilesLst.Count then begin
// разбираем им€ файла
    p := Pos(':',FilesLst[i]);
    if p > 0 then begin
      s  := Copy(FilesLst[i],1,p-1);
      ss := Copy(FilesLst[i],p+1,255);
    end else begin
      s  := FilesLst[i];
      ss := '';
    end;
// рисую иконку файла
   ARect.Top := ARect.Top + TextHeight('1');      // ”меньшаем высоту картинки
   ARect.Left := ARect.Left + TextHeight('1');    // ”меньшаем высоту картинки
   ARect.Right := ARect.Right - TextHeight('1');  // ”меньшаем высоту картинки
   ARect.Bottom := ARect.Bottom - TextHeight('1');// ”меньшаем высоту картинки дл€ вывода под ней текста
   ext := ExtractFileExt(MainPathFLS + SubDirFiles + s);
   case LowerCase(ext) of
   '.3gp': ImageIcons.StretchDraw(FileGrid1.Canvas, 1, ARect, True);
   '.avi': ImageIcons.StretchDraw(FileGrid1.Canvas, 2, ARect, True);
   '.flv': ImageIcons.StretchDraw(FileGrid1.Canvas, 3, ARect, True);
   '.mkv': ImageIcons.StretchDraw(FileGrid1.Canvas, 4, ARect, True);
   '.mov': ImageIcons.StretchDraw(FileGrid1.Canvas, 5, ARect, True);
   '.mp4': ImageIcons.StretchDraw(FileGrid1.Canvas, 6, ARect, True);
   '.mpg': ImageIcons.StretchDraw(FileGrid1.Canvas, 7, ARect, True);
   '.wmv': ImageIcons.StretchDraw(FileGrid1.Canvas, 8, ARect, True);
   else
        ImageIcons.StretchDraw(FileGrid1.Canvas, 0, ARect, True);
   end;
// русую им€ файла
    FileGrid1.Canvas.Brush.Style := bsClear;
    CopyMode := cmSrcAnd;
    //Font.Size := 8;
    Font.Color := clGreen;
    c := TextWidth('W');//ширина одного символа
    h := TextHeight('W');//высота одного символа
    p := 1;
    a := '';
    for i := 1 to Length(s) do begin
      a := a + Copy(s,i,1);
      if (((TextWidth(a)+c) >= (Dest.Bottom - Dest.Top)) or (i = Length(s))) then begin
        TextRect( Dest, Dest.Left+4, Dest.Top+(p-1)*h, a);
        a := '';
        Inc(p);
        if (p > (((Dest.Bottom - Dest.Top)) div h)) then break;//max колич. строк
      end;
    end;
//русую по€снени€ файла
    Font.Color := clBlue;
    c := TextWidth('W');//ширина одного символа
    h := TextHeight('W');//высота одного символа
    while Pos(Chr(11), ss) <> 0 do
      ss := StrReplaceStr( ss, Chr(11), Chr(32));
    while Pos(Chr(12), ss) <> 0 do
      ss := StrReplaceStr( ss, Chr(12), Chr(32));
    a := '';
    for i := 1 to Length(ss) do begin
      a := a + Copy(ss,i,1);
      if (((TextWidth(a)+c) >= (Dest.Bottom - Dest.Top)) or (i = Length(ss))) then begin
        TextRect( Dest, Dest.Left+4, Dest.Top+(p-1)*h, a);
        a := '';
        Inc(p);
        if (p > (((Dest.Bottom - Dest.Top)) div h)) then break;//max колич. строк
      end;
    end;
  end;
  end;
end;

procedure TFileForm.FileGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then Exit;
  FileGrid1DblClick(Sender);
end;

procedure TFileForm.FormActivate(Sender: TObject);
var
  i,ii : Integer;
  s,ss : String;
begin
// вычисл€ю каталог
  if PersonAll then begin
    Caption := CaptionFile;
    s := '';
  end else begin
    Caption := CaptionFile + ' ' + listMans.Strings[GridRow];
    s := Trim(listMans.Strings[GridRow]) + dZd;
    if not DirectoryExists(MainPathFLS + s) then
      {$IFDEF WINDOWS}
      MkDir(UTF8toANSI(MainPathFLS + s));
      {$ENDIF}
      {$IFDEF UNIX}
      MkDir(MainPathFLS + s);
      {$ENDIF}
  end;
// загружаю фото
  if s <> SubDirFiles then begin// если еще не загружены
    SubDirFiles := s;
    iFiles := 0;
// освобождаю список имен файлов
    if FilesLst <> Nil then begin
      for i := FilesLst.Count-1 downto 0 do
        (FilesLst.Objects[i] as TBitmap).Free;
      FilesLst.Free;
    end;
// загружаю список имен файлов
    FilesLst := TStringList.Create;
    s := MainPathFLS + SubDirFiles + MainFileFLS;
    if not FileExists(s) then begin
      {$IFDEF WINDOWS}
      FilesLst.SaveToFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      FilesLst.SaveToFile(s);
      {$ENDIF}
    end;
    {$IFDEF WINDOWS}
    FilesLst.LoadFromFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    FilesLst.LoadFromFile(s);
    {$ENDIF}
// вычисл€ю количество колонок и строк
    FileGrid1.Visible  := True;//надо чтобы правильно вычислить
    FileGrid1.ColCount := FileGrid1.Width div FileGrid1.DefaultColWidth;
    if FileGrid1.ColCount = 0 then FileGrid1.ColCount := 1;//колонок не может быть 0
    if (FilesLst.Count mod FileGrid1.ColCount) = 0 then
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount
    else
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount + 1;
    FileGrid1.Repaint;
  end;
end;

procedure TFileForm.FormResize(Sender: TObject);
begin
  if FileGrid1.ColCount+FileGrid1.RowCount > 2 then begin
    FileGrid1.ColCount := FileGrid1.Width div FileGrid1.DefaultColWidth;
    if FileGrid1.ColCount = 0 then FileGrid1.ColCount := 1;//колонок не может быть 0
    if (FilesLst.Count mod FileGrid1.ColCount) = 0 then
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount
    else
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount + 1;
  end;
end;

procedure TFileForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TFileForm.PictButtonClick(Sender: TObject);
var
  nama, nam, ext : String;
  s : String;
begin
  OpenDialog1.DefaultExt := '*.*';
  OpenDialog1.Filter := '*.*';
  OpenDialog1.FileName := '';
  if OpenDialog1.Execute then begin
    nama := ExtractFileName(OpenDialog1.FileName);
    nam := ChangeFileExt( nama, '');
    ext := AnsiLowerCase(ExtractFileExt(OpenDialog1.FileName));
    if FileExists(MainPathFLS + SubDirFiles + nam + ext) then begin
      MessageDlg(msgFileExists, mtWarning, [mbOk], 0);
      Exit;
    end;
    {$IFDEF WINDOWS}
    CopyFileWithProgressBar1(UTF8toANSI(OpenDialog1.FileName), UTF8toANSI(MainPathFLS + SubDirFiles + nam + ext));
    {$ENDIF}
    {$IFDEF UNIX}
    CopyFileWithProgressBar1(OpenDialog1.FileName, MainPathFLS + SubDirFiles + nam + ext);
    {$ENDIF}
    FilesLst.Add(nam + ext);
    if FileGrid1.ColCount = 0 then FileGrid1.ColCount := 1;//колонок не может быть 0
    if (FilesLst.Count mod FileGrid1.ColCount) = 0 then
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount
    else
      FileGrid1.RowCount := FilesLst.Count div FileGrid1.ColCount + 1;
    s := MainPathFLS + SubDirFiles + MainFileFLS;
    {$IFDEF WINDOWS}
    FilesLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    FilesLst.SaveToFile(s);
    {$ENDIF}
    iFiles := FilesLst.Count - 1;
    FileGrid1.Row := iFiles div FileGrid1.ColCount;
    FileGrid1.Col := iFiles - FileGrid1.ColCount * FileGrid1.Row;
    FileGrid1.Repaint
  end;
end;

procedure TFileForm.SaveButtonClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if iFiles >= FilesLst.Count then exit;
  s := FilesLst[iFiles];
  i := Pos(':',s);
  if i > 0 then begin
    s := Copy(s,1,i-1);
  end;
  SaveDialog1.FileName := s;
  if SaveDialog1.Execute then begin
    {$IFDEF WINDOWS}
    CopyFileWithProgressBar1(UTF8toANSI(MainPathFLS + SubDirFiles + s), UTF8toANSI(SaveDialog1.FileName));
    {$ENDIF}
    {$IFDEF UNIX}
    CopyFileWithProgressBar1(MainPathFLS + SubDirFiles + s, SaveDialog1.FileName);
    {$ENDIF}
  end;
end;

procedure TFileForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

// To show the estimated time to copy a file:
procedure TFileForm.CopyFileWithProgressBar1(Source, Destination: string);
var
  FromF, ToF: file of byte;
  Buffer: array[0..4096] of char;
  NumRead: integer;
  prozes : Int64;
begin
  AssignFile(FromF, Source);
  Reset(FromF);
  AssignFile(ToF, Destination);
  Rewrite(ToF);
  ProcessForm.Caption := task_copying;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := System.FileSize(FromF) div 100;
  NumRead := 1;
  prozes := 0;
  while NumRead > 0 do begin
    BlockRead(FromF, Buffer[0], SizeOf(Buffer), NumRead);
    BlockWrite(ToF, Buffer[0], NumRead);
    prozes := prozes + NumRead;
    ProcessForm.Gauge1.Position := prozes div 100;
    Application.ProcessMessages;
  end;
  CloseFile(FromF);
  CloseFile(ToF);
  ProcessForm.Hide;
end;

end.

