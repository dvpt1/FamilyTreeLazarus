unit vphoto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, types;

type

  { TViewPhotoForm }

  TViewPhotoForm = class(TForm)
    BackButton: TToolButton;
    Gauge1: TProgressBar;
    HelpButton: TToolButton;
    MinusButton: TToolButton;
    ImagePhoto: TImage;
    PlusButton: TToolButton;
    PrintButton: TToolButton;
    PrintDialog1: TPrintDialog;
    SaveButton: TToolButton;
    ScrollPhoto: TScrollBox;
    SizeButton: TToolButton;
    ToolBar1: TToolBar;
    TuneButton: TToolButton;
    procedure BackButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure HelpButtonClick(Sender: TObject);
    procedure ImagePhotoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImagePhotoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImagePhotoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MinusButtonClick(Sender: TObject);
    procedure PlusButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SizeButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
    OX, OY : Integer;
    btLeft : Boolean;
    procedure ResizePaintTree(k : Real);
  public
    { public declarations }
  end;

var
  ViewPhotoForm: TViewPhotoForm;
  PhotoFile : String;

implementation

uses foto, tune, info, utils, prints, main;

{ TViewPhotoForm }

{$R *.lfm}

procedure TViewPhotoForm.BackButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TViewPhotoForm.FormActivate(Sender: TObject);
begin
  // размер равен размеру главного окна
  ViewPhotoForm.Height := Family.Height;
  ViewPhotoForm.Width  := Family.Width;
  ViewPhotoForm.Left := Family.Left;
  ViewPhotoForm.Top  := Family.Top;
  //
  if FileExists(PhotoFile) then
    ImagePhoto.Picture.LoadFromFile(PhotoFile);
end;

procedure TViewPhotoForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ResizePaintTree(1.1);
end;

procedure TViewPhotoForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ResizePaintTree(1 / 1.1);
end;

procedure TViewPhotoForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TViewPhotoForm.ImagePhotoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    btLeft := True;
    OX := X;
    OY := Y;
    ImagePhoto.Cursor := crHandPoint;
  end;
end;

procedure TViewPhotoForm.ImagePhotoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if btLeft then begin
    with ScrollPhoto do begin
     if X > OX then with HorzScrollBar do if (X-OX)>Increment then begin
      Position := Position - Increment;
      OX := X;
     end;
     if X < OX then with HorzScrollBar do if (OX-X)>Increment then begin
      Position := Position + Increment;
      OX := X;
     end;
     if Y > OY then with VertScrollBar do if (Y-OY)>Increment then begin
      Position := Position - Increment;
      OY := Y;
     end;
     if Y < OY then with VertScrollBar do if (OY-Y)>Increment then begin
      Position := Position + Increment;
      OY := Y;
     end;
    end;
  end;
end;

procedure TViewPhotoForm.ImagePhotoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    btLeft := False;
    ImagePhoto.Cursor := crDefault;
  end;
end;

procedure TViewPhotoForm.MinusButtonClick(Sender: TObject);
begin
  ResizePaintTree(1.1);
end;

procedure TViewPhotoForm.PlusButtonClick(Sender: TObject);
begin
  ResizePaintTree(1 / 1.1);
end;

procedure TViewPhotoForm.PrintButtonClick(Sender: TObject);
begin
  if not PrintDialog1.Execute then Exit;
  PrintImage(ImagePhoto, 100);
end;

procedure TViewPhotoForm.SaveButtonClick(Sender: TObject);
begin
  FotoForm.SavePictureDialog1.FileName := ExtractFileName(PhotoFile);
  if FotoForm.SavePictureDialog1.Execute then begin
    CopyFile( PChar(PhotoFile), PChar(FotoForm.SavePictureDialog1.FileName), False);
  end;
end;

procedure TViewPhotoForm.SizeButtonClick(Sender: TObject);
begin
  if ImagePhoto.Align = alNone then begin
    ImagePhoto.Align := alClient;
    ImagePhoto.Stretch := True;
    ImagePhoto.AutoSize := False;
  end else begin
    ImagePhoto.Align := alNone;
    ImagePhoto.Stretch := False;
    ImagePhoto.AutoSize := True;
  end;
end;

procedure TViewPhotoForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

procedure TViewPhotoForm.ResizePaintTree(k : Real);
var
  w, h, sh, sv: Real;
begin
  ImagePhoto.AutoSize := False;
  ImagePhoto.Align    := alNone;
  ImagePhoto.Stretch  := True;
  w := ImagePhoto.Picture.Width  / ImagePhoto.Width ;
  h := ImagePhoto.Picture.Height / ImagePhoto.Height;
  if w > h then
    ImagePhoto.Height := Round (ImagePhoto.Picture.Height / w)
  else
    ImagePhoto.Width  := Round (ImagePhoto.Picture.Width  / h);
  sh := (ScrollPhoto.HorzScrollBar.Position + ScrollPhoto.ClientWidth /2) / ImagePhoto.Width ;
  sv := (ScrollPhoto.VertScrollBar.Position + ScrollPhoto.ClientHeight/2) / ImagePhoto.Height;
  if (ImagePhoto.Height*k + ImagePhoto.Width*k) > 60 then begin
    ImagePhoto.Height := Round (ImagePhoto.Height * k);
    ImagePhoto.Width  := Round (ImagePhoto.Width  * k);
  end;
  ScrollPhoto.HorzScrollBar.Position := Round (sh * ImagePhoto.Width  - ScrollPhoto.ClientWidth /2);
  ScrollPhoto.VertScrollBar.Position := Round (sv * ImagePhoto.Height - ScrollPhoto.ClientHeight/2);
end;

end.

