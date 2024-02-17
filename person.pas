unit person;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  LResources, LMessages, LCLType, LCLIntf,
  ExtCtrls, StdCtrls, EditBtn, Buttons, ExtDlgs, types;

type

  { TPersonForm }

  TPersonForm = class(TForm)
    PictButton: TBitBtn;
    DeleButton: TBitBtn;
    ButtonPlus: TBitBtn;
    ButtonMinus: TBitBtn;
    ComboBoxMW: TComboBox;
    ComboBoxFather: TComboBox;
    ComboBoxMother: TComboBox;
    ComboBoxMen: TComboBox;
    DateBeg1: TEdit;
    DateEnd1: TEdit;
    EditMAP: TEdit;
    EditPLE: TEdit;
    EditPLB: TEdit;
    DateMar1: TEdit;
    EditNAT: TEdit;
    EditOCC: TEdit;
    EditFIO: TEdit;
    ImageIcon: TImage;
    ImageFoto: TImage;
    LabelEND: TLabel;
    LabelPLB: TLabel;
    LabelMAP: TLabel;
    LabelPLE: TLabel;
    LabelMEN: TLabel;
    LabelMAF: TLabel;
    LabelMAD: TLabel;
    LabelNAT: TLabel;
    LabelOCC: TLabel;
    LabelFat: TLabel;
    LabelMot: TLabel;
    LabelBEG: TLabel;
    LabelFIO: TLabel;
    ListBoxMW: TListBox;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    PanelIcon: TPanel;
    PanelFoto: TPanel;
    ToolBar1: TToolBar;
    FileButton: TToolButton;
    FotoButton: TToolButton;
    GenrButton: TToolButton;
    ExitButton: TToolButton;
    KinoButton: TToolButton;
    TreeButton: TToolButton;
    ListButton: TToolButton;
    RichButton: TToolButton;
    TuneButton: TToolButton;
    HelpButton: TToolButton;
    procedure ButtonMinusClick(Sender: TObject);
    procedure ButtonPlusClick(Sender: TObject);
    procedure ComboBoxMWChange(Sender: TObject);
    procedure ComboBoxMWExit(Sender: TObject);
    procedure DateBeg1KeyPress(Sender: TObject; var Key: char);
    procedure DateEnd1KeyPress(Sender: TObject; var Key: char);
    procedure DateMar1KeyPress(Sender: TObject; var Key: char);
    procedure DeleButtonClick(Sender: TObject);
    procedure EditFIOKeyPress(Sender: TObject; var Key: char);
    procedure EditMAPKeyPress(Sender: TObject; var Key: char);
    procedure EditNATKeyPress(Sender: TObject; var Key: char);
    procedure EditOCCKeyPress(Sender: TObject; var Key: char);
    procedure EditPLBKeyPress(Sender: TObject; var Key: char);
    procedure EditPLEKeyPress(Sender: TObject; var Key: char);
    procedure ExitButtonClick(Sender: TObject);
    procedure FileButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FotoButtonClick(Sender: TObject);
    procedure GenrButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure ImageFotoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageFotoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageFotoMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ImageFotoMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure KinoButtonClick(Sender: TObject);
    procedure ListBoxMWClick(Sender: TObject);
    procedure ListButtonClick(Sender: TObject);
    procedure PictButtonClick(Sender: TObject);
    procedure RichButtonClick(Sender: TObject);
    procedure TreeButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
    procedure RenameFIO(OldText, NewText : String);
  public
    { public declarations }
  end;

var
  PersonForm: TPersonForm;
  AddIcon : Boolean;
  AddFoto : Boolean;
  DelFoto : Boolean;
  strListMARD : TStringList;//дата свадьбы
  strListMARP : TStringList;//место свадьбы
  inxMARR : Integer;

implementation

uses main, vars, mstring, utils, tune, info, test, treebmp, treehtm, genr, foto, kino, fold, rich, graph;

{ TPersonForm }

{$R *.lfm}

procedure TPersonForm.FormActivate(Sender: TObject);
var
  i,ii,n : Integer;
  s,ss,c : String;
  jp : TJPEGImage;
begin
  Caption := listMans.Strings[GridRow];
  DateBeg1.Text := listBirth.Strings[GridRow];
  //??DateTimeBeg1.Format := DateFormat;
  EditPLB.Text := listPlaceb.Strings[GridRow];
  EditFIO.Text := listMans.Strings[GridRow];
  ComboBoxMen.Text := listGender.Strings[GridRow];
  ComboBoxMen.Items.Clear;
  ComboBoxMen.Items.Add(Man);
  ComboBoxMen.Items.Add(Woman);
  ComboBoxFather.Text := listFather.Strings[GridRow];
  ComboBoxFather.Items.Clear;
  ComboBoxFather.Sorted := True;
  for i := 0 to listMans.Count-1 do
    if i <> GridRow then
      if listGender.Strings[i] = Man
        then ComboBoxFather.Items.Add(listMans.Strings[i]);
  ComboBoxMother.Text := listMother.Strings[GridRow];
  ComboBoxMother.Items.Clear;
  ComboBoxMother.Sorted := True;
  for i := 0 to listMans.Count-1 do
    if i <> GridRow then
      if listGender.Strings[i] = Woman
        then ComboBoxMother.Items.Add(listMans.Strings[i]);
  DateEnd1.Text := listDeath.Strings[GridRow];
  //??DateTimeEnd1.Format := DateFormat;
  EditPLE.Text := listPlaced.Strings[GridRow];
  EditNAT.Text := listNati.Strings[GridRow];
  EditOCC.Text := listOccu.Strings[GridRow];
  ListBoxMW.Items.Clear;
  DateMar1.Text := '';
  EditMAP.Text := '';
  //??DateTimeMar1.Format := DateFormat;
  strListMARD := TStringList.Create;
  strListMARP := TStringList.Create;
  if not Empty(listSpouse.Strings[GridRow]) then begin
    ss := listSpouse.Strings[GridRow];
    repeat
       ii := Pos(rzd2, ss);
       if ii > 0 then begin
         s := Copy(ss,1,ii-1);
         ss := Copy(ss,ii+1,Length(ss));
       end else
         s := ss;
       if not Empty(s) then
         ListBoxMW.Items.Add(s);
    until ii=0;
    for i := 0 to ListBoxMW.Count-1 do begin
      strListMARD.Add('');
      strListMARP.Add('');
    end;
    for i := 0 to ListBoxMW.Count-1 do begin
      n := 0;
      ss := ListBoxMW.Items.Strings[i];
      repeat
         ii := Pos(rzd3, ss);
         if ii > 0 then begin
           s := Copy(ss,1,ii-1);
           ss := Copy(ss,ii+1,Length(ss));
         end else
           s := ss;
         case n of
         0: ListBoxMW.Items.Strings[i] := s;
         1: strListMARD.Strings[i] := s;
         2: strListMARP.Strings[i] := s;
         end;
         Inc(n);
      until ii=0;
    end;
    if ListBoxMW.Count > 0 then begin
      DateMar1.Text := strListMARD.Strings[0];
      EditMAP.Text := strListMARP.Strings[0];
    end;
    inxMARR := 0;
  end else begin
    inxMARR := -1;
  end;
  s := MainPathBMP + Trim(EditFIO.Text) + '.bmp';
  c := MainPathBMP + Trim(EditFIO.Text) + '.jpg';
  if FileExists(c) then begin
    jp := TJPEGImage.Create;
    try
      jp.CompressionQuality := 100; {Default Value}
      jp.LoadFromFile(c);
      ImageFoto.Picture.Bitmap.Assign(jp);
    finally
      jp.Free
    end;
  end else
  if FileExists(s) then
    ImageFoto.Picture.Bitmap.LoadFromFile(s)
  else begin
    //ImageFoto.Picture := nil;
    try
    ImageFoto.Canvas.Brush.Color := clWhite;
    ImageFoto.Canvas.Brush.Style := bsSolid;
    ImageFoto.Canvas.FillRect(Rect(0,0,ImageFoto.Picture.Bitmap.Width,ImageFoto.Picture.Bitmap.Height));
    finally
    end;
  end;
  s := MainPathICO + Trim(EditFIO.Text) + '.bmp';
  c := MainPathICO + Trim(EditFIO.Text) + '.jpg';
  if FileExists(c) then
    ImageIcon.Picture.LoadFromFile(c)
  else
  if FileExists(s) then
    ImageIcon.Picture.Bitmap.LoadFromFile(s)
  else begin
   with ImageIcon do begin
    Width  := 64;
    Height := 64;
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(0,0,Width,Height));
   end;
  end;
  with ImageIcon.Picture.Bitmap do begin
    Width  := 64;
    Height := 64;
  end;
  AddIcon := False;
  AddFoto := False;
  DelFoto := False;
  Modified := False;
  EditFIO.SetFocus;
end;

procedure TPersonForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TPersonForm.ButtonPlusClick(Sender: TObject);
var
  i : Integer;
  MW : ShortString;
begin
  ComboBoxMW.Visible := True;
  ComboBoxMW.Items.Clear;
  ComboBoxMW.Text := '';
  ComboBoxMW.Sorted := True;
  if ComboBoxMen.Text = Man then MW := Woman
  else if ComboBoxMen.Text = Woman then MW := Man
  else MW := '';
  for i := 0 to listMans.Count-1 do
    if i <> GridRow then
      if listGender.Strings[i] = MW
        then ComboBoxMW.Items.Add(listMans.Strings[i]);
end;

procedure TPersonForm.ComboBoxMWChange(Sender: TObject);
begin
  if ListBoxMW.Items.IndexOf(ComboBoxMW.Items.Strings[ComboBoxMW.ItemIndex]) < 0 then begin
    ListBoxMW.Items.Add(ComboBoxMW.Items.Strings[ComboBoxMW.ItemIndex]);
    strListMARD.Add('');
    strListMARP.Add('');
    DateMar1.Text := '';
    EditMAP.Text := '';
    inxMARR := ListBoxMW.Count - 1;
    ListBoxMW.ItemIndex := inxMARR;
    Modified := True;
  end;
  ComboBoxMW.Visible := False;
  ListBoxMW.SetFocus;
end;

procedure TPersonForm.ComboBoxMWExit(Sender: TObject);
begin
  ComboBoxMW.Visible := False;
  ListBoxMW.SetFocus;
end;

procedure TPersonForm.DateBeg1KeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.DateEnd1KeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.DateMar1KeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.DeleButtonClick(Sender: TObject);
var
  bm : TBitMap;
begin
  if Application.MessageBox( PChar(msgDelPhoto), '',mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    DelFoto := True;
    //ImageIcon := Nil;
    bm :=  TBitMap.Create;
    bm.Height := 64;
    bm.Width  := 64;
    bm.Canvas.Brush.Color := clWhite;
    bm.Canvas.Brush.Style := bsSolid;
    bm.Canvas.FillRect(Rect(0,0,bm.Width,bm.Height));
    ImageIcon.Canvas.CopyRect(Rect(0,0,64,64), bm.Canvas, Rect(0,0,64,64));
    Family.ImageIcons.Delete(GridRow);
    Family.ImageIcons.InsertMasked(GridRow, bm, clWhite);
    bm.Free;
    //ImageFoto := Nil;
    ImageFoto.Canvas.Brush.Color := clWhite;
    ImageFoto.Canvas.Brush.Style := bsSolid;
    ImageFoto.Canvas.FillRect(Rect(0,0,ImageFoto.Picture.Bitmap.Width,ImageFoto.Picture.Bitmap.Height));
  end;
end;

procedure TPersonForm.EditFIOKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':', '*', '?', '"', '<', '>' : key := #0;
  end;
end;

procedure TPersonForm.EditMAPKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.EditNATKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.EditOCCKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.EditPLBKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.EditPLEKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonForm.ButtonMinusClick(Sender: TObject);
begin
  if ListBoxMW.Count > 0 then begin
    ListBoxMW.Items.Delete(inxMARR);
    strListMARD.Delete(inxMARR);
    strListMARP.Delete(inxMARR);
    if ListBoxMW.Count > 0 then begin
      inxMARR := 0;
      DateMar1.Text := strListMARD.Strings[inxMARR];
      EditMAP.Text := strListMARP.Strings[inxMARR];
    end else begin
      inxMARR := -1;
      DateMar1.Text := '';
      EditMAP.Text := '';
    end;
    Modified := True;
    ListBoxMW.SetFocus;
  end;
end;

procedure TPersonForm.FileButtonClick(Sender: TObject);
begin
  PersonAll := False;
  FileForm.ShowModal;
end;

procedure TPersonForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ComboBoxMW.Visible := False;
  strListMARD.Free;
  strListMARP.Free;
end;

procedure TPersonForm.FotoButtonClick(Sender: TObject);
begin
  PersonAll := False;
  FotoForm.ShowModal;
end;

procedure TPersonForm.GenrButtonClick(Sender: TObject);
begin
  TestForm.TestBaseFamily();// провер€ю базу
  if not YesNo then begin// рисую древо
    GenrForm.Caption := rept_button_hint;
    GenrForm.GenerationPerson();
    GenrForm.ShowModal;
  end else
    TestForm.ShowModal;
end;

procedure TPersonForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TPersonForm.ListBoxMWClick(Sender: TObject);
begin
  if ListBoxMW.Count > 0 then begin
    strListMARD.Strings[inxMARR] := DateMar1.Text;
    strListMARP.Strings[inxMARR] := EditMAP.Text;
    inxMARR := ListBoxMW.ItemIndex;
    DateMar1.Text := strListMARD.Strings[inxMARR];
    EditMAP.Text := strListMARP.Strings[inxMARR];
    Modified := True;
  end;
end;

procedure TPersonForm.ListButtonClick(Sender: TObject);
var
  i, ii : Integer;
  b : Boolean;
  s : String;
  jpg : TJpegImage;
  bmp : TBitMap;
begin// сохранение данных
  if Empty(EditFIO.Text) then begin Close; Exit; end;
  EditFIO.Text := Trim(EditFIO.Text);
  b := False;
  for i := 0 to listMans.Count - 1 do begin
    if ((AnsiLowerCase(EditFIO.Text) = AnsiLowerCase(Trim(listMans.Strings[i]))) and (i <> GridRow)) then b := True;
  end;
  if b then begin
    ShowMessage(msgDblFIO);
    Exit;
  end;
  OldCells := Trim(listMans.Strings[GridRow]);
  if OldCells <> EditFIO.Text then begin
    RenameFIO( OldCells, EditFIO.Text);
    listMans.Strings[GridRow] := EditFIO.Text;// ѕеребросим выбранное в значение из EditBox1 в grid
  end;
  if listBirth.Strings[GridRow] <> DateBeg1.Text then begin
    listBirth.Strings[GridRow] := DateBeg1.Text;
  end;
  if listPlaceb.Strings[GridRow] <> EditPLB.Text then begin
    listPlaceb.Strings[GridRow] := EditPLB.Text;
  end;
  if listGender.Strings[GridRow] <> ComboBoxMen.Text then begin
    listGender.Strings[GridRow] := ComboBoxMen.Text;
  end;
  if listFather.Strings[GridRow] <> ComboBoxFather.Text then begin
    listFather.Strings[GridRow] := ComboBoxFather.Text;
  end;
  if listMother.Strings[GridRow] <> ComboBoxMother.Text then begin
    listMother.Strings[GridRow] := ComboBoxMother.Text;
  end;
  if listDeath.Strings[GridRow] <> DateEnd1.Text then begin
    listDeath.Strings[GridRow] := DateEnd1.Text;
  end;
  if listPlaced.Strings[GridRow] <> EditPLE.Text then begin
    listPlaced.Strings[GridRow] := EditPLE.Text;
  end;
  if listNati.Strings[GridRow] <> EditNAT.Text then begin
    listNati.Strings[GridRow] := EditNAT.Text;
  end;
  if listOccu.Strings[GridRow] <> EditOCC.Text then begin
    listOccu.Strings[GridRow] := EditOCC.Text;
  end;
  if ListBoxMW.Count > 0 then begin
    listSpouse.Strings[GridRow] := '';
    strListMARD.Strings[inxMARR] := DateMar1.Text;
    strListMARP.Strings[inxMARR] := EditMAP.Text;
    s := '';
    for i := 0 to ListBoxMW.Count-1 do begin
      for ii := 0 to 2 do begin
        case ii of
        0: if Empty(strListMARD.Strings[i]) and Empty(strListMARP.Strings[i]) then
             s := s + ListBoxMW.Items.Strings[i] + rzd2
           else
             s := s + ListBoxMW.Items.Strings[i] + rzd3;
        1: if Empty(strListMARD.Strings[i]) and Empty(strListMARP.Strings[i]) then
             //
           else
             s := s + strListMARD.Strings[i] + rzd3;
        2: if Empty(strListMARD.Strings[i]) and Empty(strListMARP.Strings[i]) then
             //
           else
             s := s + strListMARP.Strings[i] + rzd2;
        end;
      end;
    end;
    listSpouse.Strings[GridRow] := s;
  end else begin
    listSpouse.Strings[GridRow] := '';
  end;
  if AddFoto then begin
    //ImageFoto.Picture.Graphic.SaveToFile(MainPathBMP+Trim(EditFIO.Text)+'.jpg');
    jpg := TJpegImage.Create;//создаем экземпл€р объекта
    jpg.Assign(ImageFoto.Picture.Graphic);//присваиваем ему изображение
    jpg.CompressionQuality := 100;//устанавливаем степень сжати€ (качество) 1..100
    //jpg.Compress;//”паковываем графику
    jpg.SaveToFile(MainPathBMP+Trim(EditFIO.Text)+'.jpg');//и сохран€ем ее
    jpg.free;//уничтожаем экземпл€р объекта
  end;
  if AddIcon then begin
    ImageIcon.Picture.Bitmap.SaveToFile(MainPathICO+Trim(EditFIO.Text)+'.bmp');
    try
      bmp := TBitmap.Create;
      bmp.Height := 64;
      bmp.Width  := 64;
      bmp.Canvas.StretchDraw(classes.Rect(0,0,64,64), ImageIcon.Picture.Bitmap);
      Family.ImageIcons.Delete(GridRow);
      Family.ImageIcons.InsertMasked(GridRow, bmp, clWhite);
      bmp.Free;
    except
      Family.ImageIcons.AddMasked( Family.ImageEmpty.Picture.Bitmap, clWhite);
    end;
  end;
  if DelFoto then begin
    if FileExists(MainPathBMP+Trim(EditFIO.Text)+'.jpg') then
      DeleteFile(MainPathBMP+Trim(EditFIO.Text)+'.jpg');
    if FileExists(MainPathICO+Trim(EditFIO.Text)+'.bmp') then
      DeleteFile(MainPathICO+Trim(EditFIO.Text)+'.bmp');
  end;
  Modified := True;
  ReDraws := True;
  Close;
end;

procedure TPersonForm.PictButtonClick(Sender: TObject);
var
  jp : TJPEGImage;
begin
  if OpenPictureDialog1.Execute then begin
    try
      jp := TJPEGImage.Create;
      try
        jp.CompressionQuality := 100; {Default Value}
        jp.LoadFromFile(OpenPictureDialog1.FileName);
        ImageFoto.Picture.Bitmap.Assign(jp);
      finally
        jp.Free
      end;
    finally
    end;
    AddFoto := True;
    DelFoto := False;
  end;
end;

procedure TPersonForm.RichButtonClick(Sender: TObject);
begin
  PersonAll := False;
  RichForm.ShowModal;
end;

procedure TPersonForm.TreeButtonClick(Sender: TObject);
begin
  TestForm.TestBaseFamily();// провер€ю базу
  if not YesNo then begin// рисую древо
    PersonAll := False;
    if TuneForm.GroupView.ItemIndex = 0 then begin
      TreeBmpForm.Caption := CaptionBranch;
      if TuneForm.TreeHiLo.ItemIndex = 0 then
        TreeBmpForm.DrawPaintTreePerUp
      else
        TreeBmpForm.DrawPaintTreePerDn;
      TreeBmpForm.ShowModal;
    end else begin
      TreeHtmForm.Caption := CaptionBranch;
      if TuneForm.TreeHiLo.ItemIndex = 0 then
        TreeHtmForm.DrawPaintTreeHPerUp
      else
        TreeHtmForm.DrawPaintTreeHPerDn;
      //??TreeHtmForm.ShowModal;
    end;
  end else
    TestForm.ShowModal;
end;

procedure TPersonForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

procedure TPersonForm.RenameFIO(OldText, NewText : String);
var
  i,ii,n,p : Integer;
  s,ss : String;
  aSpouse : TStringList;
  sSpouse : String;
  b : Boolean;
begin
  if not Empty(OldText) then begin
  // переименовываю фото, иконку и текст, каталог с фотографи€ми
    RenameFile( UTF8toANSI( MainPathTXT+OldText+'.txt'), UTF8toANSI( MainPathTXT+NewText+'.txt'));
    RenameFile( UTF8toANSI( MainPathICO+OldText+'.bmp'), UTF8toANSI( MainPathICO+NewText+'.bmp'));
    RenameFile( UTF8toANSI( MainPathBMP+OldText+'.bmp'), UTF8toANSI( MainPathBMP+NewText+'.bmp'));
    RenameFile( UTF8toANSI( MainPathBMP+OldText+'.jpg'), UTF8toANSI( MainPathBMP+NewText+'.jpg'));
    RenameDir( MainPathFTS+OldText, MainPathFTS+NewText);
    RenameDir( MainPathVID+OldText, MainPathVID+NewText);
    RenameDir( MainPathFLS+OldText, MainPathFLS+NewText);
  // переименовываю пол€ FATHER и MOTHER и MAW
    for i := 0 to listMans.Count - 1 do begin
      if listFather.Strings[i] = OldText then
        listFather.Strings[i] := NewText;
      if listMother.Strings[i] = OldText then
        listMother.Strings[i] := NewText;
      if Pos( OldText, listSpouse.Strings[i]) > 0 then begin
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
          if sSpouse = OldText then begin//мен€ю супруга
            b := True;
            if (p > 0) then begin
              aSpouse.Strings[n] := NewText + Copy(aSpouse.Strings[n], p, Length(aSpouse.Strings[n]));
            end else begin
              aSpouse.Strings[n] := NewText;
            end;
          end;
        end;
        if b then begin//соедин€ю всех супругов
          ss := '';
          for n := 0 to aSpouse.Count-1 do begin
            if ss = '' then
              ss := aSpouse.Strings[n]
            else
              ss := ss + rzd2 + aSpouse.Strings[n];
          end;
          listSpouse.Strings[i] := ss;
        end;
        aSpouse.Free;
      end;
    end;
  end;
end;

procedure TPersonForm.ImageFotoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ScaleX, ScaleY : Integer;
  Sourse : TRect;
begin
  if (Shift = [ssRight]) then begin
    if (ImageFoto.Picture.Bitmap.Height - PanelFoto.Height) > 0 then
      ScaleX := ImageFoto.Picture.Bitmap.Height div PanelFoto.Height
    else
      ScaleX := PanelFoto.Height div ImageFoto.Picture.Bitmap.Height;
    if (ImageFoto.Picture.Bitmap.Width - PanelFoto.Width) > 0 then
      ScaleY := ImageFoto.Picture.Bitmap.Width div PanelFoto.Width
    else
      ScaleY := PanelFoto.Width div ImageFoto.Picture.Bitmap.Width;
    if ScaleX = 0 then ScaleX := 1;
    if ScaleY = 0 then ScaleY := 1;
    Sourse := Rect(X * ScaleX - (ico div 2), Y * ScaleY - (ico div 2), X * ScaleX + (ico div 2), Y * ScaleY + (ico div 2));
    ImageIcon.Canvas.CopyRect(ImageIcon.ClientRect,ImageFoto.Picture.Bitmap.Canvas,Sourse);
    OX := X;
    OY := Y;
  end;
end;

procedure TPersonForm.ImageFotoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (button = mbRight) then begin
   if Application.MessageBox( PChar(msgSave), '', mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    AddIcon := True;
   end;
  end;
end;

procedure TPersonForm.ImageFotoMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  ScaleX, ScaleY : Integer;
  Sourse : TRect;
begin
  if (Shift = [ssRight]) then begin
    if ico > 17 then ico := ico - 5;
    if (ImageFoto.Picture.Bitmap.Height - PanelFoto.Height) > 0 then
      ScaleX := ImageFoto.Picture.Bitmap.Height div PanelFoto.Height
    else
      ScaleX := PanelFoto.Height div ImageFoto.Picture.Bitmap.Height;
    if (ImageFoto.Picture.Bitmap.Width - PanelFoto.Width) > 0 then
      ScaleY := ImageFoto.Picture.Bitmap.Width div PanelFoto.Width
    else
      ScaleY := PanelFoto.Width div ImageFoto.Picture.Bitmap.Width;
    if ScaleX = 0 then ScaleX := 1;
    if ScaleY = 0 then ScaleY := 1;
    Sourse := Rect(OX * ScaleX - (ico div 2), OY * ScaleY - (ico div 2), OX * ScaleX + (ico div 2), OY * ScaleY + (ico div 2));
    ImageIcon.Canvas.CopyRect(ImageIcon.ClientRect,ImageFoto.Picture.Bitmap.Canvas,Sourse);
  end;
end;

procedure TPersonForm.ImageFotoMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  ScaleX, ScaleY : Integer;
  Sourse : TRect;
begin
  if (Shift = [ssRight]) then begin
    if ico < 1500 then ico := ico + 5;
    if (ImageFoto.Picture.Bitmap.Height - PanelFoto.Height) > 0 then
      ScaleX := ImageFoto.Picture.Bitmap.Height div PanelFoto.Height
    else
      ScaleX := PanelFoto.Height div ImageFoto.Picture.Bitmap.Height;
    if (ImageFoto.Picture.Bitmap.Width - PanelFoto.Width) > 0 then
      ScaleY := ImageFoto.Picture.Bitmap.Width div PanelFoto.Width
    else
      ScaleY := PanelFoto.Width div ImageFoto.Picture.Bitmap.Width;
    if ScaleX = 0 then ScaleX := 1;
    if ScaleY = 0 then ScaleY := 1;
    Sourse := Rect(OX * ScaleX - (ico div 2), OY * ScaleY - (ico div 2), OX * ScaleX + (ico div 2), OY * ScaleY + (ico div 2));
    ImageIcon.Canvas.CopyRect(ImageIcon.ClientRect,ImageFoto.Picture.Bitmap.Canvas,Sourse);
  end;
end;

procedure TPersonForm.KinoButtonClick(Sender: TObject);
begin
  PersonAll := False;
  KinoForm.ShowModal;
end;

end.

