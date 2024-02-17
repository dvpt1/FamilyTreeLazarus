unit prints;

interface

uses SysUtils, Classes, Dialogs, Registry, Graphics, ExtCtrls,
     LResources, LMessages, LCLType, LCLIntf,
     Forms, RtlConsts, printers, Controls;

procedure PrintImage(Image: TImage; ZoomPercent: Integer);

implementation

procedure PrintImage(Image: TImage; ZoomPercent: Integer);
// if ZoomPercent=100, Image will be printed across the whole page
var
  relHeight, relWidth: integer;
begin
  Screen.Cursor := crHourglass;
  Printer.BeginDoc;
  with Image.Picture.Bitmap do
  begin
    if ((Width / Height) > (Printer.PageWidth / Printer.PageHeight)) then
    begin
      // Stretch Bitmap to width of PrinterPage
      relWidth := Printer.PageWidth;
      relHeight := MulDiv(Height, Printer.PageWidth, Width);
    end
    else
    begin
      // Stretch Bitmap to height of PrinterPage
      relWidth := MulDiv(Width, Printer.PageHeight, Height);
      relHeight := Printer.PageHeight;
    end;
    relWidth := Round(relWidth * ZoomPercent / 100);
    relHeight := Round(relHeight * ZoomPercent / 100);
    try
      Printer.Canvas.StretchDraw(Rect(0, 0, relWidth, relHeight), Image.Picture.Graphic);
    except
    end;
  end;
  Printer.EndDoc;
  Screen.cursor := crDefault;
end;

end.