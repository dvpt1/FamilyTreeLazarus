unit foto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  LResources, LMessages, LCLType, LCLIntf,
  Grids, ExtDlgs, Menus;

type

  { TFotoForm }

  TFotoForm = class(TForm)
    PictGrid1: TDrawGrid;
    ExitButton: TToolButton;
    Edit1: TMenuItem;
    Dele1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Pict1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    HelpButton: TToolButton;
    PopupMenu1: TPopupMenu;
    SaveButton: TToolButton;
    SavePictureDialog1: TSavePictureDialog;
    ToolBar1: TToolBar;
    PictButton: TToolButton;
    EditButton: TToolButton;
    DeleButton: TToolButton;
    TuneButton: TToolButton;
    procedure DeleButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure PictButtonClick(Sender: TObject);
    procedure PictGrid1DblClick(Sender: TObject);
    procedure PictGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure PictGrid1KeyPress(Sender: TObject; var Key: char);
    procedure SaveButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
    procedure DoWork();
    procedure CopyFileWithProgressBar1(Source, Destination: string);
  public
    { public declarations }
  end;

var
  FotoForm: TFotoForm;

implementation

uses main, vars, tune, mstring, info, desc, prozess, vphoto;

{$R *.lfm}

procedure TFotoForm.DoWork;
var
  i,ii : Integer;
  s,ss : String;
begin
  with FotoForm do begin
    ProcessForm.Caption := task_loading;
    ProcessForm.Show;
    ProcessForm.Gauge1.Max := FotosLst.Count-1;
    for i := 0 to FotosLst.Count-1 do begin
      ProcessForm.Gauge1.Position := i;
      Application.ProcessMessages;
      ii := Pos(':',FotosLst[i]);
      if ii > 0 then
        ss := Copy(FotosLst[i],1,ii-1)
      else
        ss := FotosLst[i];
      if FileExists(MainPathFTS+SubDirFoto+ss) then begin
        FotosLst.Objects[i] := TJPEGImage.Create;
       (FotosLst.Objects[i] as TJPEGImage).LoadFromFile(MainPathFTS+SubDirFoto+ss);
      end;
    end;
    ProcessForm.Hide;
    PictGrid1.Repaint;
  end;
end;

procedure TFotoForm.SaveButtonClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if iFotos >= FotosLst.Count then exit;
  s := FotosLst[iFotos];
  i := Pos(':',s);
  if i > 0 then begin
    s := Copy(s,1,i-1);
  end;
  SavePictureDialog1.FileName := s;
  if SavePictureDialog1.Execute then begin
    {$IFDEF WINDOWS}
    CopyFileWithProgressBar1(UTF8toANSI(MainPathFTS+SubDirFoto+s), UTF8toANSI(SavePictureDialog1.FileName));
    {$ENDIF}
    {$IFDEF UNIX}
    CopyFileWithProgressBar1(MainPathFTS+SubDirFoto+s, SavePictureDialog1.FileName);
    {$ENDIF}
  end;
end;

procedure TFotoForm.EditButtonClick(Sender: TObject);
var
  s : String;
begin
  if iFotos >= FotosLst.Count then exit;
  NameNote := FotosLst[iFotos];
  DescForm.ShowModal;
  if ModifiName then begin
    if not RightFileName(NamsDesc) then begin
      MessageDlg(msgNotSymbol, mtWarning, [mbOk], 0);
      Exit;
    end;
    if FileExists(MainPathFTS + SubDirFoto + NamsDesc + ExtsDesc) and (NamsDesc <> OldsDesc) then begin
      MessageDlg(msgFileExists, mtWarning, [mbOk], 0);
      Exit;
    end;
    if  NamsDesc <> OldsDesc then begin
      RenameFile( MainPathFTS + SubDirFoto + OldsDesc + ExtsDesc, MainPathFTS + SubDirFoto + NamsDesc + ExtsDesc);
      {$IFDEF WINDOWS}
      {$ENDIF}
      {$IFDEF UNIX}
      {$ENDIF}
    end;
    FotosLst[iFotos] := NameNote;
    s := MainPathFTS+SubDirFoto+MainFileFTS;
    {$IFDEF WINDOWS}
    FotosLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    FotosLst.SaveToFile(s);
    {$ENDIF}
    PictGrid1.Repaint;
  end;
end;

procedure TFotoForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFotoForm.FormActivate(Sender: TObject);
var
  i,ii : Integer;
  s,ss : String;
begin
// вычисл€ю каталог
  if PersonAll then begin
    Caption := CaptionPict;
    s := '';
  end else begin
    Caption := CaptionPict + ' ' + listMans.Strings[GridRow];
    s := Trim(listMans.Strings[GridRow]) + dZd;
    if not DirectoryExists(MainPathFTS + s) then
      {$IFDEF WINDOWS}
      MkDir(UTF8toANSI(MainPathFTS + s));
      {$ENDIF}
      {$IFDEF UNIX}
      MkDir(MainPathFTS + s);
      {$ENDIF}
  end;
// загружаю фото
  if s <> SubDirFoto then begin// если еще не загружены
    SubDirFoto := s;
    iFotos := 0;
// освобождаю список имен файлов
    if FotosLst <> Nil then begin
      for i := FotosLst.Count-1 downto 0 do
        (FotosLst.Objects[i] as TJPEGImage).Free;
      FotosLst.Free;
    end;
// загружаю список имен файлов
    FotosLst := TStringList.Create;
    s := MainPathFTS+SubDirFoto+MainFileFTS;
    if not FileExists(s) then begin
      {$IFDEF WINDOWS}
      FotosLst.SaveToFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      FotosLst.SaveToFile(s);
      {$ENDIF}
    end;
    {$IFDEF WINDOWS}
    FotosLst.LoadFromFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    FotosLst.LoadFromFile(s);
    {$ENDIF}
// загружаю фотографии
    if FotosLst.Count > 0 then begin
      DoWork()
    end;
// вычисл€ю количество колонок и строк
    PictGrid1.Visible  := True;//надо чтобы правильно вычислить
    PictGrid1.ColCount := PictGrid1.Width div PictGrid1.DefaultColWidth;
    if PictGrid1.ColCount = 0 then PictGrid1.ColCount := 1;//колонок не может быть 0
    if (FotosLst.Count mod PictGrid1.ColCount) = 0 then
      PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount
    else
      PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount + 1;
    PictGrid1.Repaint;
  end;
end;

procedure TFotoForm.FormResize(Sender: TObject);
begin
  FotoForm.Canvas.FillRect(0,0,FotoForm.Width,FotoForm.Height);
  if PictGrid1.ColCount+PictGrid1.RowCount > 2 then begin
    PictGrid1.ColCount := PictGrid1.Width div PictGrid1.DefaultColWidth;
    if PictGrid1.ColCount = 0 then PictGrid1.ColCount := 1;//колонок не может быть 0
    if (FotosLst.Count mod PictGrid1.ColCount) = 0 then
      PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount
    else
      PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount + 1;
  end;
end;

procedure TFotoForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TFotoForm.PictButtonClick(Sender: TObject);
var
  nama, nam, ext : String;
  jpeg: TJPEGImage;
  mdf : Boolean;
  s : STring;
begin
  if OpenPictureDialog1.Execute then begin
    mdf := False;
    nama := ExtractFileName(OpenPictureDialog1.FileName);
    nam := ChangeFileExt( nama, '');
    ext := AnsiLowerCase(ExtractFileExt(OpenPictureDialog1.FileName));
    if FileExists(MainPathFTS+SubDirFoto+nam+'.jpg') then begin
      MessageDlg(msgFileExists, mtWarning, [mbOk], 0);
      Exit;
    end;
    if (ext = '.jpg') or (ext = '.jpeg') then begin
      {$IFDEF WINDOWS}
      CopyFileWithProgressBar1(UTF8toANSI(OpenPictureDialog1.FileName), UTF8toANSI(MainPathFTS+SubDirFoto+nam+'.jpg'));
      {$ENDIF}
      {$IFDEF UNIX}
      CopyFileWithProgressBar1(OpenPictureDialog1.FileName, MainPathFTS+SubDirFoto+nam+'.jpg');
      {$ENDIF}
      mdf := True
    end;
    if mdf then begin
      FotosLst.Add( nam+'.jpg');
      FotosLst.Objects[FotosLst.Count-1] := TJPEGImage.Create;
      (FotosLst.Objects[FotosLst.Count-1] as TJPEGImage).LoadFromFile(MainPathFTS+SubDirFoto+FotosLst[FotosLst.Count-1]);
      if PictGrid1.ColCount = 0 then PictGrid1.ColCount := 1;//колонок не может быть 0
      if (FotosLst.Count mod PictGrid1.ColCount) = 0 then
        PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount
      else
        PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount + 1;
      s := MainPathFTS+SubDirFoto+MainFileFTS;
      {$IFDEF WINDOWS}
      FotosLst.SaveToFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      FotosLst.SaveToFile(s);
      {$ENDIF}
      iFotos := FotosLst.Count - 1;
      PictGrid1.Row := iFotos div PictGrid1.ColCount;
      PictGrid1.Col := iFotos - PictGrid1.ColCount * PictGrid1.Row;
    end;
  end;
end;

procedure TFotoForm.PictGrid1DblClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if iFotos >= FotosLst.Count then exit;
  s := FotosLst[iFotos];
  i := Pos(':',s);
  if i > 0 then begin
    s := Copy(s,1,i-1);
  end;
  PhotoFile := MainPathFTS + SubDirFoto + s;
  ViewPhotoForm.Caption := s;
  ViewPhotoForm.ShowModal;
end;

procedure TFotoForm.PictGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  i, ii, w, h, lt, rt: Integer;
  s : String;
  f : Single;
  Dest, Source : TRect;
begin
  Dest := ARect;
  lt := ARect.Left;// запоминаю левую кромку
  rt := ARect.Right;// запоминаю правую кромку
  PictGrid1.Canvas.Font.Name := Family.Font.Name;
  if FotosLst = Nil then Exit;
  if FotosLst.Count = 0 then exit;
  i := PictGrid1.ColCount * ARow + ACol;// ѕересчитываем координаты €чейки в индекс списка:
  with PictGrid1.Canvas, FotosLst do begin
  if (gdFocused in aState) then begin
    if i < FotosLst.Count then iFotos := i;// запоминаю текущую строку
  end;
  CopyMode := cmSrcCopy;
  Brush.Color := clWhite;
  FillRect( ARect);
  if i < FotosLst.Count then begin
    ARect.Top := ARect.Top + TextHeight('1') div 2;// ”меньшаем высоту картинки
    ARect.Left := ARect.Left + TextHeight('1') div 2;// ”меньшаем высоту картинки
    ARect.Right := ARect.Right - TextHeight('1') div 2;// ”меньшаем высоту картинки
    ARect.Bottom := ARect.Bottom - TextHeight('1') - 2;// ”меньшаем высоту картинки дл€ вывода под ней текста
    if (FotosLst.Objects[i] as TJPEGImage) <> nil then begin
      if (FotosLst.Objects[i] as TJPEGImage).Height > (FotosLst.Objects[i] as TJPEGImage).Width then begin // устанавливаю пропорции картинки
        f := (FotosLst.Objects[i] as TJPEGImage).Width / (FotosLst.Objects[i] as TJPEGImage).Height;
        f := (PictGrid1.DefaultColWidth - PictGrid1.DefaultColWidth * f) / 2;
        ARect.Left := ARect.Left + Trunc(f) + 2;
        ARect.Right := ARect.Right - Trunc(f) - 2;
        ARect.Top := ARect.Top + 2;
        ARect.Bottom := ARect.Bottom - 2;
      end else
      if (FotosLst.Objects[i] as TJPEGImage).Height < (FotosLst.Objects[i] as TJPEGImage).Width then begin // устанавливаю пропорции картинки
        f := (FotosLst.Objects[i] as TJPEGImage).Height / (FotosLst.Objects[i] as TJPEGImage).Width;
        f := (PictGrid1.DefaultRowHeight - PictGrid1.DefaultRowHeight * f) / 2;
        ARect.Top := ARect.Top + Trunc(f) + 2;
        ARect.Bottom := ARect.Bottom - Trunc(f) - 2;
        ARect.Left := ARect.Left + 2;
        ARect.Right := ARect.Right - 2;
      end else begin
        ARect.Top := ARect.Top + 2;
        ARect.Bottom := ARect.Bottom - 2;
        ARect.Left := ARect.Left + 2;
        ARect.Right := ARect.Right - 2;
      end;
      StretchDraw(ARect, (FotosLst.Objects[i] as TJPEGImage));// –исуем картинку:
    end;
    // ÷ентрируем им€ файла без расширени€ по горизонтали и выводим его:
    ii := Pos(':',FotosLst[i]);
    if ii > 0 then
      s := ChangeFileExt( Copy(FotosLst[i],1,ii-1), '')
    else
      s := ChangeFileExt( FotosLst[i], '');
    h := rt - lt;
    w := TextWidth(s);
    PictGrid1.Canvas.Brush.Style := bsClear;
    if w >= h
      then PictGrid1.Canvas.TextRect( Dest, lt, ARect.Bottom + 1, s)
      else PictGrid1.Canvas.TextRect( Dest, lt + (rt-lt-w) div 2, ARect.Bottom + 1, s);
    end;
  end;
end;

procedure TFotoForm.PictGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then Exit;
  PictGrid1DblClick(Sender);
end;

procedure TFotoForm.DeleButtonClick(Sender: TObject);
var
  s : String;
  i : Integer;
begin
  if FotosLst.Count = 0 then Exit;
  if Application.MessageBox( PChar(msgDelPhoto), '',mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    i := Pos(rzd2, FotosLst[iFotos]);
    if i > 0 then
      s := MainPathFTS+SubDirFoto+Copy(FotosLst[iFotos], 1, i-1)
    else
      s := MainPathFTS+SubDirFoto+FotosLst[iFotos];
    if FileExists(s) then
      {$IFDEF WINDOWS}
      SysUtils.DeleteFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      SysUtils.DeleteFile(s);
      {$ENDIF}
    (FotosLst.Objects[iFotos] as TJPEGImage).Free;
    FotosLst.Delete(iFotos);
    if iFotos = FotosLst.Count then Dec(iFotos);
    if iFotos = -1 then iFotos := 0;
    if (FotosLst.Count mod PictGrid1.ColCount) = 0 then
      PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount
    else
      PictGrid1.RowCount := FotosLst.Count div PictGrid1.ColCount + 1;
    s := MainPathFTS+SubDirFoto+MainFileFTS;
    {$IFDEF WINDOWS}
    FotosLst.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    FotosLst.SaveToFile(s);
    {$ENDIF}
    if PictGrid1.ColCount = 0 then PictGrid1.ColCount := 1;//колонок не может быть 0
    PictGrid1.Row := iFotos div PictGrid1.ColCount;
    PictGrid1.Col := iFotos - PictGrid1.ColCount * PictGrid1.Row;
    PictGrid1.Repaint;
  end;
end;

procedure TFotoForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

// To show the estimated time to copy a file:
procedure TFotoForm.CopyFileWithProgressBar1(Source, Destination: string);
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

