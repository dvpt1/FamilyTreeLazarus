unit kino;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  LResources, LMessages, LCLType, LCLIntf,
  Grids, Menus;

type

  { TKinoForm }

  TKinoForm = class(TForm)
    DeleButton: TToolButton;
    Dele1: TMenuItem;
    KinoGrid1: TDrawGrid;
    Edit1: TMenuItem;
    EditButton: TToolButton;
    Exit1: TMenuItem;
    ExitButton: TToolButton;
    ImageIcons: TImageList;
    HelpButton: TToolButton;
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
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure KinoGrid1DblClick(Sender: TObject);
    procedure KinoGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure KinoGrid1KeyPress(Sender: TObject; var Key: char);
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
  KinoForm: TKinoForm;

implementation

uses vars, tune, main, desc, mstring, info, utils, prozess;

{$R *.lfm}

procedure TKinoForm.DeleButtonClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if VideoLst.Count = 0 then Exit;
  if Application.MessageBox( PChar(msgDelVideo), '',mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    i := Pos(rzd2, VideoLst[iVideo]);
    if i > 0 then
      s := MainPathVID + SubDirVideo + Copy(VideoLst[iVideo], 1, i-1)
    else
      s := MainPathVID + SubDirVideo + VideoLst[iVideo];
    if FileExists(s) then
      {$IFDEF WINDOWS}
      SysUtils.DeleteFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      SysUtils.DeleteFile(s);
      {$ENDIF}
    (VideoLst.Objects[iVideo] as TJPEGImage).Free;
    VideoLst.Delete(iVideo);
    if iVideo = VideoLst.Count then Dec(iVideo);
    if iVideo = -1 then iVideo := 0;
    if (VideoLst.Count mod KinoGrid1.ColCount) = 0 then
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount
    else
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount + 1;
    s := MainPathVID+SubDirVideo+MainFileVID;
    {$IFDEF WINDOWS}
    VideoLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    VideoLst.SaveToFile(s);
    {$ENDIF}
    if KinoGrid1.ColCount = 0 then KinoGrid1.ColCount := 1;//колонок не может быть 0
    KinoGrid1.Row := iVideo div KinoGrid1.ColCount;
    KinoGrid1.Col := iVideo - KinoGrid1.ColCount * KinoGrid1.Row;
    KinoGrid1.Repaint;
  end;
end;

procedure TKinoForm.EditButtonClick(Sender: TObject);
var
  s : String;
begin
  if iVideo >= VideoLst.Count then exit;
  NameNote := VideoLst[iVideo];
  DescForm.ShowModal;
  if ModifiName then begin
    if not RightFileName(NamsDesc) then begin
      MessageDlg(msgNotSymbol, mtWarning, [mbOk], 0);
      Exit;
    end;
    if FileExists(MainPathVID + SubDirVideo + NamsDesc + ExtsDesc) and (NamsDesc <> OldsDesc) then begin
      MessageDlg(msgFileExists, mtWarning, [mbOk], 0);
      Exit;
    end;
    if  NamsDesc <> OldsDesc then begin
      //??SetFileAttributes( PChar(MainPathVID + SubDirVideo + OldsDesc + ExtsDesc),0);
      RenameFile( MainPathVID + SubDirVideo + OldsDesc + ExtsDesc, MainPathVID + SubDirVideo + NamsDesc + ExtsDesc);
      {$IFDEF WINDOWS}
      {$ENDIF}
      {$IFDEF UNIX}
      {$ENDIF}
    end;
    VideoLst[iVideo] := NameNote;
    s := MainPathVID + SubDirVideo + MainFileVID;
    {$IFDEF WINDOWS}
    VideoLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    VideoLst.SaveToFile(s);
    {$ENDIF}
    KinoGrid1.Repaint;
  end;
end;

procedure TKinoForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TKinoForm.FormActivate(Sender: TObject);
var
  i,ii : Integer;
  s,ss : String;
  Dest, Source: TRect;
begin
// размер равен размеру главного окна
  KinoForm.Height := Family.Height;
  KinoForm.Width  := Family.Width;
  KinoForm.Left := Family.Left;
  KinoForm.Top  := Family.Top;
// вычисл€ю каталог
  if PersonAll then begin
    Caption := CaptionKino;
    s := '';
  end else begin
    Caption := CaptionKino + ' ' + listMans.Strings[GridRow];
    s := Trim(listMans.Strings[GridRow]) + dZd;
    if not DirectoryExists(MainPathVID+s) then
      {$IFDEF WINDOWS}
      MkDir(UTF8toANSI(MainPathVID + s));
      {$ENDIF}
      {$IFDEF UNIX}
      MkDir(MainPathVID + s);
      {$ENDIF}
  end;
// загружаю фото
  if s <> SubDirVideo then begin// если еще не загружены
    SubDirVideo := s;
    iVideo := 0;
// освобождаю список имен файлов
    if VideoLst <> Nil then begin
      for i := VideoLst.Count-1 downto 0 do
        (VideoLst.Objects[i] as TBitmap).Free;
      VideoLst.Free;
    end;
// загружаю список имен файлов
    VideoLst := TStringList.Create;
    s := MainPathVID+SubDirVideo+MainFileVID;
    if not FileExists(s) then begin
      {$IFDEF WINDOWS}
      VideoLst.SaveToFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      VideoLst.SaveToFile(s);
      {$ENDIF}
    end;
    {$IFDEF WINDOWS}
    VideoLst.LoadFromFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    VideoLst.LoadFromFile(s);
    {$ENDIF}
// загружаю фотографии
    if VideoLst.Count > 0 then begin
    end;
// вычисл€ю количество колонок и строк
    KinoGrid1.Visible  := True;//надо чтобы правильно вычислить
    KinoGrid1.ColCount := KinoGrid1.Width div KinoGrid1.DefaultColWidth;
    if KinoGrid1.ColCount = 0 then KinoGrid1.ColCount := 1;//колонок не может быть 0
    if (VideoLst.Count mod KinoGrid1.ColCount) = 0 then
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount
    else
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount + 1;
    KinoGrid1.Repaint;
  end;
end;

procedure TKinoForm.FormResize(Sender: TObject);
begin
  if KinoGrid1.ColCount+KinoGrid1.RowCount > 2 then begin
    KinoGrid1.ColCount := KinoGrid1.Width div KinoGrid1.DefaultColWidth;
    if KinoGrid1.ColCount = 0 then KinoGrid1.ColCount := 1;//колонок не может быть 0
    if (VideoLst.Count mod KinoGrid1.ColCount) = 0 then
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount
    else
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount + 1;
  end;
end;

procedure TKinoForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TKinoForm.KinoGrid1DblClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if iVideo >= VideoLst.Count then exit;
  s := VideoLst[iVideo];
  i := Pos(':',s);
  if i > 0 then begin
    s := Copy(s,1,i-1);
  end;
  if FileExists(MainPathVID + SubDirVideo + s) then
    OpenDocument(MainPathVID + SubDirVideo + s);
end;

procedure TKinoForm.KinoGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  i, p, c, w, h, lt, rt: Integer;
  s, ss, a, ext : String;
  f : Single;
  Dest : TRect;
begin
  Dest := ARect;
  lt := ARect.Left;// запоминаю левую кромку
  rt := ARect.Right;// запоминаю правую кромку
  KinoGrid1.Canvas.Font.Name := Family.Font.Name;
  if VideoLst  = Nil then exit;
  if VideoLst.Count = 0 then exit;
  i := KinoGrid1.ColCount * ARow + ACol;// ѕересчитываем координаты €чейки в индекс списка:
  with KinoGrid1.Canvas, VideoLst do begin
  if (gdFocused in aState) then
    if i < VideoLst.Count then iVideo := i;// запоминаю текущую строку
  CopyMode := cmSrcCopy;
  Brush.Color := clWhite;
  FillRect( ARect);
  if i < VideoLst.Count then begin
    // разбираем им€ файла
    p := Pos(':',VideoLst[i]);
    if p > 0 then begin
      s  := Copy(VideoLst[i],1,p-1);
      ss := Copy(VideoLst[i],p+1,255);
    end else begin
      s  := VideoLst[i];
      ss := '';
    end;
    // рисую иконку файла
    ARect.Top := ARect.Top + TextHeight('1');      // ”меньшаем высоту картинки
    ARect.Left := ARect.Left + TextHeight('1');    // ”меньшаем высоту картинки
    ARect.Right := ARect.Right - TextHeight('1');  // ”меньшаем высоту картинки
    ARect.Bottom := ARect.Bottom - TextHeight('1');// ”меньшаем высоту картинки дл€ вывода под ней текста
    ext := ExtractFileExt(MainPathVID + SubDirVideo + s);
    case LowerCase(ext) of
    '.3gp': ImageIcons.StretchDraw(KinoGrid1.Canvas, 1, ARect, True);
    '.avi': ImageIcons.StretchDraw(KinoGrid1.Canvas, 2, ARect, True);
    '.flv': ImageIcons.StretchDraw(KinoGrid1.Canvas, 3, ARect, True);
    '.mkv': ImageIcons.StretchDraw(KinoGrid1.Canvas, 4, ARect, True);
    '.mov': ImageIcons.StretchDraw(KinoGrid1.Canvas, 5, ARect, True);
    '.mp4': ImageIcons.StretchDraw(KinoGrid1.Canvas, 6, ARect, True);
    '.mpg': ImageIcons.StretchDraw(KinoGrid1.Canvas, 7, ARect, True);
    '.wmv': ImageIcons.StretchDraw(KinoGrid1.Canvas, 8, ARect, True);
    else
         ImageIcons.StretchDraw(KinoGrid1.Canvas, 0, ARect, True);
    end;
// русую им€ файла
    Brush.Style := bsClear;
    CopyMode := cmSrcAnd;
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

procedure TKinoForm.KinoGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then Exit;
  KinoGrid1DblClick(Sender);
end;

procedure TKinoForm.PictButtonClick(Sender: TObject);
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
    if FileExists(MainPathVID + SubDirVideo + nam + ext) then begin
      MessageDlg(msgFileExists, mtWarning, [mbOk], 0);
      Exit;
    end;
    {$IFDEF WINDOWS}
    CopyFileWithProgressBar1(UTF8toANSI(OpenDialog1.FileName), UTF8toANSI(MainPathVID + SubDirVideo + nam + ext));
    {$ENDIF}
    {$IFDEF UNIX}
    CopyFileWithProgressBar1(OpenDialog1.FileName, MainPathVID + SubDirVideo + nam + ext);
    {$ENDIF}
    VideoLst.Add(nam + ext);
    if KinoGrid1.ColCount = 0 then KinoGrid1.ColCount := 1;//колонок не может быть 0
    if (VideoLst.Count mod KinoGrid1.ColCount) = 0 then
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount
    else
      KinoGrid1.RowCount := VideoLst.Count div KinoGrid1.ColCount + 1;
    s := MainPathVID + SubDirVideo + MainFileVID;
    {$IFDEF WINDOWS}
    VideoLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    VideoLst.SaveToFile(s);
    {$ENDIF}
    iVideo := VideoLst.Count - 1;
    KinoGrid1.Row := iVideo div KinoGrid1.ColCount;
    KinoGrid1.Col := iVideo - KinoGrid1.ColCount * KinoGrid1.Row;
    KinoGrid1.Repaint
  end;
end;

procedure TKinoForm.SaveButtonClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if iVideo >= VideoLst.Count then exit;
  s := VideoLst[iVideo];
  i := Pos(':',s);
  if i > 0 then begin
    s := Copy(s,1,i-1);
  end;
  SaveDialog1.FileName := s;
  if SaveDialog1.Execute then begin
    {$IFDEF WINDOWS}
    CopyFileWithProgressBar1(UTF8toANSI(MainPathVID+SubDirVideo+s), UTF8toANSI(SaveDialog1.FileName));
    {$ENDIF}
    {$IFDEF UNIX}
    CopyFileWithProgressBar1(MainPathVID+SubDirVideo+s, SaveDialog1.FileName);
    {$ENDIF}
  end;
end;

procedure TKinoForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

// To show the estimated time to copy a file:
procedure TKinoForm.CopyFileWithProgressBar1(Source, Destination: string);
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

