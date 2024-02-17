unit personnew;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  LResources, LMessages, LCLType, LCLIntf,
  ExtCtrls, StdCtrls, EditBtn, Buttons, ExtDlgs, types;

type

  { TPersonNewForm }

  TPersonNewForm = class(TForm)
    ButtonMinus: TBitBtn;
    ButtonPlus: TBitBtn;
    ComboBoxFather: TComboBox;
    ComboBoxMen: TComboBox;
    ComboBoxMother: TComboBox;
    ComboBoxMW: TComboBox;
    DateBeg1: TEdit;
    DateEnd1: TEdit;
    DateMar1: TEdit;
    DeleButton: TBitBtn;
    EditFIO: TEdit;
    EditMAP: TEdit;
    EditNAT: TEdit;
    EditOCC: TEdit;
    EditPLB: TEdit;
    EditPLE: TEdit;
    ExitButton: TToolButton;
    HelpButton: TToolButton;
    ImageFoto: TImage;
    ImageIcon: TImage;
    LabelBEG: TLabel;
    LabelEND: TLabel;
    LabelFat: TLabel;
    LabelFIO: TLabel;
    LabelMAD: TLabel;
    LabelMAF: TLabel;
    LabelMAP: TLabel;
    LabelMEN: TLabel;
    LabelMot: TLabel;
    LabelNAT: TLabel;
    LabelOCC: TLabel;
    LabelPLB: TLabel;
    LabelPLE: TLabel;
    ListBoxMW: TListBox;
    ListButton: TToolButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    PanelFoto: TPanel;
    PanelIcon: TPanel;
    PictButton: TBitBtn;
    ToolBar1: TToolBar;
    TuneButton: TToolButton;
    procedure ButtonMinusClick(Sender: TObject);
    procedure ButtonPlusClick(Sender: TObject);
    procedure ComboBoxFatherKeyPress(Sender: TObject; var Key: char);
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
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure HelpButtonClick(Sender: TObject);
    procedure ImageFotoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageFotoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageFotoMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ImageFotoMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ListBoxMWClick(Sender: TObject);
    procedure ListButtonClick(Sender: TObject);
    procedure PictButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PersonNewForm: TPersonNewForm;
  AddIcon : Boolean;
  AddFoto : Boolean;
  DelFoto : Boolean;
  strListMARD : TStringList;//дата свадьбы
  strListMARP : TStringList;//место свадьбы
  inxMARR : Integer;

implementation

uses main, vars, mstring, utils, tune, info;

{$R *.lfm}

procedure TPersonNewForm.FormActivate(Sender: TObject);
var
  i,ii,n : Integer;
  s,ss,c : String;
  jp : TJPEGImage;
begin
  Caption := list_button_hint;
  EditFIO.Text := '';
  DateBeg1.Text := '';
  //??DateTimeBeg1.Format := DateFormat;
  EditPLB.Text := '';
  ComboBoxMen.Text := '';
  ComboBoxMen.Items.Clear;
  ComboBoxMen.Items.Add(Man);
  ComboBoxMen.Items.Add(Woman);
  ComboBoxMen.ItemIndex := -1;
  ComboBoxFather.Text := '';
  ComboBoxFather.Items.Clear;
  ComboBoxFather.Sorted := True;
  for i := 0 to listMans.Count-1 do
      if listGender.Strings[i] = Man
        then ComboBoxFather.Items.Add(listMans.Strings[i]);
  ComboBoxMother.Text := '';
  ComboBoxMother.Items.Clear;
  ComboBoxMother.Sorted := True;
  for i := 0 to listMans.Count-1 do
      if listGender.Strings[i] = Woman
        then ComboBoxMother.Items.Add(listMans.Strings[i]);
  DateEnd1.Text := '';
  //??DateTimeEnd1.Format := DateFormat;
  DateMar1.Text := '';
  EditMAP.Text := '';
  EditPLE.Text := '';
  EditNAT.Text := '';
  EditOCC.Text := '';
  ListBoxMW.Items.Clear;
  //??DateTimeMar1.Format := DateFormat;
  strListMARD := TStringList.Create;
  strListMARP := TStringList.Create;
  inxMARR := -1;
  //ImageFoto.Picture := nil;
  try
    ImageFoto.Canvas.Brush.Color := clWhite;
    ImageFoto.Canvas.Brush.Style := bsSolid;
    ImageFoto.Canvas.FillRect(Rect(0,0,ImageFoto.Picture.Bitmap.Width,ImageFoto.Picture.Bitmap.Height));
  finally
  end;
  with ImageIcon do begin
    Width  := 64;
    Height := 64;
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(0,0,Width,Height));
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

procedure TPersonNewForm.ButtonPlusClick(Sender: TObject);
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

procedure TPersonNewForm.ComboBoxFatherKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TPersonNewForm.ComboBoxMWChange(Sender: TObject);
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

procedure TPersonNewForm.ComboBoxMWExit(Sender: TObject);
begin
  ComboBoxMW.Visible := False;
  ListBoxMW.SetFocus;
end;

procedure TPersonNewForm.DateBeg1KeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.DateEnd1KeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.DateMar1KeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.DeleButtonClick(Sender: TObject);
var
  bm : TBitMap;
begin
  if Application.MessageBox( PChar(msgDelPhoto), '',mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    DelFoto := True;
    //ImageIcon := Nil;
    bm :=  TBitMap.Create;
    bm.Height := 64;
    bm.Width  := 64;
    ImageIcon.Canvas.CopyRect(Rect(0,0,64,64), bm.Canvas, Rect(0,0,64,64));
    bm.Free;
    //ImageFoto := Nil;
    ImageFoto.Canvas.Brush.Color := clWhite;
    ImageFoto.Canvas.Brush.Style := bsSolid;
    ImageFoto.Canvas.FillRect(Rect(0,0,ImageFoto.Picture.Bitmap.Width,ImageFoto.Picture.Bitmap.Height));
  end;
end;

procedure TPersonNewForm.EditFIOKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':', '*', '?', '"', '<', '>' : key := #0;
  end;
end;

procedure TPersonNewForm.EditMAPKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.EditNATKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.EditOCCKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.EditPLBKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.EditPLEKeyPress(Sender: TObject; var Key: char);
begin
  case key of
  ';', '\', '/', ':' : key := #0;
  end;
end;

procedure TPersonNewForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TPersonNewForm.ButtonMinusClick(Sender: TObject);
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

procedure TPersonNewForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Close;
end;

procedure TPersonNewForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TPersonNewForm.ImageFotoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
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

procedure TPersonNewForm.ImageFotoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (button = mbRight) then begin
   if Application.MessageBox( PChar(msgSave), '', mb_OKCancel+MB_ICONQUESTION) = IDOK then begin
    AddIcon := True;
   end;
  end;
end;

procedure TPersonNewForm.ImageFotoMouseWheelDown(Sender: TObject;
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

procedure TPersonNewForm.ImageFotoMouseWheelUp(Sender: TObject;
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

procedure TPersonNewForm.ListBoxMWClick(Sender: TObject);
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

procedure TPersonNewForm.ListButtonClick(Sender: TObject);
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
  Family.StringGrid1.RowCount := Family.StringGrid1.RowCount + 1;
  listMans.Add(EditFIO.Text);
  listBirth.Add(DateBeg1.Text);
  listPlaceb.Add(EditPLB.Text);
  listGender.Add(ComboBoxMen.Text);
  listFather.Add(ComboBoxFather.Text);
  listMother.Add(ComboBoxMother.Text);
  listDeath.Add(DateEnd1.Text);
  listPlaced.Add(EditPLE.Text);
  listNati.Add(EditNAT.Text);
  listOccu.Add(EditOCC.Text);
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
    listSpouse.Add(s);
  end else begin
    listSpouse.Add('');
  end;
  if AddFoto then begin
    //ImageFoto.Picture.SaveToFile(MainPathBMP+Trim(EditFIO.Text)+'.jpg');
    jpg := TJpegImage.Create;//создаем экземпл€р объекта
    jpg.Assign(ImageFoto.Picture.Graphic);//присваиваем ему изображение
    jpg.CompressionQuality := 100;//устанавливаем степень сжати€ (качество) 1..100
    //jpg.Compress;//”паковываем графику
    jpg.SaveToFile(MainPathBMP+Trim(EditFIO.Text)+'.jpg');//и сохран€ем ее
    jpg.free;//уничтожаем экземпл€р объекта
  end;
  //
  Family.StringGrid1.Row := Family.StringGrid1.RowCount - 1;//добавл€ю строку
  //
  if AddIcon then begin
    ImageIcon.Picture.Bitmap.SaveToFile(MainPathICO+Trim(EditFIO.Text)+'.bmp');
    try
      bmp := TBitmap.Create;
      bmp.Height := 64;
      bmp.Width  := 64;
      bmp.Canvas.StretchDraw(classes.Rect(0,0,64,64), ImageIcon.Picture.Bitmap);
      Family.ImageIcons.AddMasked(bmp, clWhite);
      bmp.Free;
    except
      Family.ImageIcons.AddMasked( Family.ImageEmpty.Picture.Bitmap, clWhite);
    end;
  end else begin
    bmp :=  TBitMap.Create;
    bmp.Height := 64;
    bmp.Width  := 64;
    bmp.Canvas.Brush.Color := clWhite;
    bmp.Canvas.Brush.Style := bsSolid;
    bmp.Canvas.FillRect(Rect(0,0,bmp.Width,bmp.Height));
    Family.ImageIcons.AddMasked( bmp, clWhite);
    bmp.Free;
  end;
  Modified := True;
  ReDraws := True;
  Close;
end;

procedure TPersonNewForm.PictButtonClick(Sender: TObject);
var
  ext : String;
begin
  if OpenPictureDialog1.Execute then begin
    ext := AnsiLowerCase(ExtractFileExt(OpenPictureDialog1.FileName));
    if (ext = '.jpg') or (ext = '.jpeg') then begin
      try
        ImageFoto.Picture.LoadFromFile(OpenPictureDialog1.FileName);
      finally
      end;
    end;
    AddFoto := True;
  end;
end;

procedure TPersonNewForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

end.

