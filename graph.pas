unit graph;

interface

uses SysUtils, Classes, Dialogs, Registry, Graphics, ExtCtrls, Math, LCLIntf,
     LCLType, LCLProc;

const
  LinWidth=3;

procedure Circler( cCanvas: TCanvas; cX, cY : Integer; Radius: Integer; bl1, bl2: Double; Clr: Word);
procedure CircleArc( cCanvas: TCanvas; X1,Y1,X2,Y2: Integer; R: Integer; Clr: Word);
function GetLightColor(const Color: TColor; const Light: Byte) : TColor;
function SetClrDark(Color:TColor; Percent:Byte):TColor;
function SetClrLight(Color:TColor; Percent:Byte):TColor;
function ClrSlightlyDark(Color:TColor):TColor;
function ClrDark(Color:TColor):TColor;
function ClrVeryDark(Color:TColor):TColor;
function ClrSlightlyLight(Color:TColor):TColor;
function ClrLight(Color:TColor):TColor;
function ClrVeryLight(Color:TColor):TColor;
function EmptyBMP(Image1 : TImage): Boolean;
procedure ResizeBitmap(imgo, imgd: TBitmap; nw, nh: Integer);

implementation

// рисую большую дугу окружности
procedure Circler( cCanvas: TCanvas; cX, cY : Integer; Radius: Integer; bl1, bl2: Double; Clr: Word);
var
  i, j, g1, g2, g3 : Integer;
  h, w : Longint;
  Itera : Word;
begin
  Itera := 2*Radius;
  g3 := LinWidth-1;
  if bl1 >= bl2 then begin
    g1 := Round(Itera*bl1);
    g2 := Round(Itera*(bl2+2*Pi));
  end else begin
    g1 := Round(Itera*bl1);
    g2 := Round(Itera*bl2);
  end;
  for i:=g1 to g2 do begin
    for j:=0 to g3 do begin
      w := Round(sin(i/Itera)*(Radius+j))+cX;
      h := Round(cos(i/Itera)*(Radius+j))+cY;
      cCanvas.Pixels[w,h] := Clr;
    end;
  end;
end;

// процедура правильно работает только для R>b
procedure CircleArc(cCanvas: TCanvas; X1,Y1,X2,Y2: Integer; R: Integer; Clr: Word);
var
  x, y, b : Integer;
  X4, Y4 : Integer;
  al, bl, al1, al2 : Double;
begin
  if X1 > X2 then begin
   x := X1 - X2;
   if Y1 > Y2 then begin
    y := Y1 - Y2;
    b := Round(Sqrt(sqr(x)+sqr(y)));
    al := ArcSin((b div 2)/R);
    bl := ArcTan(x/y);
    X4 := X1 - Round(R*cos(bl-al));
    Y4 := Y1 + Round(R*sin(bl-al));
   end else if Y1 < Y2 then begin
    y := Y2 - Y1;
    b := Round(Sqrt(sqr(x)+sqr(y)));
    al := ArcSin((b div 2)/R);
    bl := ArcTan(x/y);
    X4 := X1 - Round(R*cos(bl-al));
    Y4 := Y1 - Round(R*sin(bl-al));
   end else begin//Y1 = Y2
    b := x;
    al := ArcSin((x div 2)/R);
    X4 := X1 - x div 2;
    Y4 := Y1 - Round(R*cos(al));
   end;
  end else if X1 < X2 then begin
   x := X2 - X1;
   if Y1 > Y2 then begin
    y := Y1 - Y2;
    b := Round(Sqrt(sqr(x)+sqr(y)));
    al := ArcSin((b div 2)/R);
    bl := ArcTan(x/y);
    X4 := X1 + Round(R*cos(bl-al));
    Y4 := Y1 + Round(R*sin(bl-al));
   end else if Y1 < Y2 then begin
    y := Y2 - Y1;
    b := Round(Sqrt(sqr(x)+sqr(y)));
    al := ArcSin((b div 2)/R);
    bl := ArcTan(x/y);
    X4 := X1 + Round(R*cos(bl-al));
    Y4 := Y1 - Round(R*sin(bl-al));
   end else begin//Y1 = Y2
    b := x;
    al := ArcSin((x div 2)/R);
    X4 := X2 - x div 2;
    Y4 := Y2 + Round(R*cos(al));
   end;
  end else begin//X1 = X2
   if Y1 > Y2 then begin
    y := Y1 - Y2;
    b := y;
    al := ArcSin((y div 2)/R);
    X4 := X1 - Round(R*cos(al));
    Y4 := Y2 + y div 2;
   end else if Y1 < Y2 then begin
    y := Y2 - Y1;
    b := y;
    al := ArcSin((y div 2)/R);
    X4 := X1 + Round(R*cos(al));
    Y4 := Y1 + y div 2;
   end else begin
   //Y1 = Y2 это нонсенс
   end;
  end;
  if X1 = X2 then begin
    if Y1 > Y2 then begin
      al1 := Pi/2 + arcSin((b div 2)/R);
      al2 := Pi/2 - arcSin((b div 2)/R);
    end else begin
      al1 := Pi*3/2 + arcSin((b div 2)/R);
      al2 := Pi*3/2 - arcSin((b div 2)/R);
    end;
  end else if Y1 = Y2 then begin
    if X1 > X2 then begin
      al1 := 0 + arcSin((b div 2)/R);
      al2 := 0 - arcSin((b div 2)/R);
    end else begin
      al1 := Pi + arcSin((b div 2)/R);
      al2 := Pi - arcSin((b div 2)/R);
    end;
  end else begin
    if (X1>=X4) and (Y1>=Y4) then begin           //1
      if Y2>=Y4 then begin if X2>=X4 then al1 := ArcCos(x/b)+al else al1 := ArcCos(x/b)+al end else al1 := Pi-ArcCos(x/b)+al;
    end else if (X1>=X4) and (Y1<Y4) then begin  //2
      if Y2<Y4 then begin if X2>=X4 then al1 := Pi-ArcCos(x/b)+al else al1 := Pi-ArcCos(x/b)+al end else al1 := Pi/2-ArcSin(x/b)+al;
    end else if (X1<X4) and (Y1<Y4) then begin  //3
      if Y2<Y4 then begin if X2<X4 then al1 := Pi*3/2-ArcSin(x/b)+al else al1 := Pi*3/2-ArcSin(x/b)+al end else al1 := Pi*3/2+ArcSin(x/b)+al;
    end else if (X1<X4) and (Y1>=Y4) then begin  //4
      if Y2>=Y4 then begin if X2<X4 then al1 := 2*Pi-ArcCos(x/b)+al else al1 := Pi*3/2+ArcSin(x/b)-al end else al1 := Pi*3/2-ArcSin(x/b)+al;
    end;
    if (X2>=X4) and (Y2>=Y4) then begin           //1
      if Y1>=Y4 then begin if X1>=X4 then al2 := ArcCos(x/b)-al else al2 := 2*Pi-ArcCos(x/b)+al end else al2 := Pi/2-ArcSin(x/b)-al;
    end else if (X2>=X4) and (Y2<Y4) then begin //2
      if Y1<Y4 then begin if X1>=X4 then al2 := Pi-ArcCos(x/b)-al else al2 := Pi+ArcCos(x/b)-al end else al2 := Pi-ArcCos(x/b)-al;
    end else if (X2<X4) and (Y2<Y4) then begin  //3
      if Y1<Y4 then begin if X1<X4 then al2 := Pi*3/2-ArcSin(x/b)-al else al2 := Pi-ArcCos(x/b)-al end else al2 := Pi*3/2-ArcSin(x/b)-al;
    end else if (X2<X4) and (Y2>=Y4) then begin  //4
      if Y1>=Y4 then begin if X1<X4 then al2 := 2*Pi-ArcCos(x/b)-al else al2 := ArcCos(x/b)-al end else al2 := 2*Pi-ArcCos(x/b)-al;
    end;
  end;
  if al1 > al2 then Circler( cCanvas, X4, Y4, R, al2, al1, Clr)
               else Circler( cCanvas, X4, Y4, R, al1, al2, Clr);
end;

// Получить осветлённый цвет
function GetLightColor(const Color: TColor; const Light: Byte) : TColor;
type
  TRGB = packed record
    R, G, B: Byte;
  end;
var
  fFrom: TRGB;
  function GetRGB(const Color: TColor): TRGB;
  var
    iColor: TColor;
  begin
    iColor := ColorToRGB(Color);
    Result.R := GetRValue(iColor);
    Result.G := GetGValue(iColor);
    Result.B := GetBValue(iColor);
  end;
begin
  FFrom := GetRGB(Color);
  Result := RGB(
    Round(FFrom.R + (255 - FFrom.R) * (Light / 100)),
    Round(FFrom.G + (255 - FFrom.G) * (Light / 100)),
    Round(FFrom.B + (255 - FFrom.B) * (Light / 100))
  );
end;

// Получить затемненный цвет
function GetDarkColor(const Color: TColor; const Light: Byte) : TColor;
type
  TRGB = packed record
    R, G, B: Byte;
  end;
var
  fFrom: TRGB;
  function GetRGB(const Color: TColor): TRGB;
  var
    iColor: TColor;
  begin
    iColor := ColorToRGB(Color);
    Result.R := GetRValue(iColor);
    Result.G := GetGValue(iColor);
    Result.B := GetBValue(iColor);
  end;
begin
  FFrom := GetRGB(Color);

  Result := RGB(
    Round(FFrom.R - (255 - FFrom.R) * (Light / 100)),
    Round(FFrom.G - (255 - FFrom.G) * (Light / 100)),
    Round(FFrom.B - (255 - FFrom.B) * (Light / 100))
  );
end;

function SetClrDark(Color:TColor; Percent:Byte):TColor;
var
  r, g, b: Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r-muldiv(r,Percent,100);  //процент% уменьшения яркости
  g:=g-muldiv(g,Percent,100);
  b:=b-muldiv(b,Percent,100);
  result:=RGB(r,g,b);
end;

function SetClrLight(Color:TColor; Percent:Byte):TColor;
var
  r, g, b: Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r+muldiv(255-r,Percent,100); //процент% увеличения яркости
  g:=g+muldiv(255-g,Percent,100);
  b:=b+muldiv(255-b,Percent,100);
  result:=RGB(r,g,b);
end;
function ClrSlightlyDark(Color:TColor):TColor;
begin
  Result := SetClrDark(Color,25);
end;
function ClrDark(Color:TColor):TColor;
begin
  Result := SetClrDark(Color,50);
end;
function ClrVeryDark(Color:TColor):TColor;
begin
  Result := SetClrDark(Color,75);
end;
function ClrSlightlyLight(Color:TColor):TColor;
begin
  Result := SetClrLight(Color,25);
end;
function ClrLight(Color:TColor):TColor;
begin
  Result := SetClrLight(Color,50);
end;
function ClrVeryLight(Color:TColor):TColor;
begin
  Result := SetClrLight(Color,75);
end;

function EmptyBMP(Image1 : TImage): Boolean;
var
  x, y: integer;
begin
  Result := True;
  x := 0; y := 0;
  while y < Image1.Picture.Bitmap.Height - 1 do begin//сканируем по диоганали рисунок
    while x < Image1.Picture.Bitmap.Width - 1 do begin
      if Image1.Picture.Bitmap.Canvas.Pixels[x,y]<>clWhite then begin
        Result := False;
        Exit;
      end;
      Inc(x);
    end;
    if Result then Exit;
    Inc(y);
  end;
end;

procedure ResizeBitmap(imgo, imgd: TBitmap; nw, nh: Integer);
var
  xini, xfi, yini, yfi, saltx, salty: single;
  x, y, px, py, tpix: integer;
  PixelColor: TColor;
  r, g, b: longint;

  function MyRound(const X: Double): Integer;
  begin
    Result := Trunc(x);
    if Frac(x) >= 0.5 then
      if x >= 0     // Result := Trunc(X + (-2 * Ord(X < 0) + 1) * 0.5);
        then Result := Result + 1
        else Result := Result - 1;
  end;

begin
   // Set target size
  imgd.Width  := nw;
  imgd.Height := nh;
  // Calcs width & height of every area of pixels of the source bitmap
  saltx := imgo.Width / nw;
  salty := imgo.Height / nh;
  yfi := 0;
  for y := 0 to nh - 1 do begin// Set the initial and final Y coordinate of a pixel area
    yini := yfi;
    yfi  := yini + salty;
    if yfi >= imgo.Height then yfi := imgo.Height - 1;
    xfi := 0;
    for x := 0 to nw - 1 do begin// Set the inital and final X coordinate of a pixel area
      xini := xfi;
      xfi  := xini + saltx;
      if xfi >= imgo.Width then xfi := imgo.Width - 1;
// This loop calcs del average result color of a pixel area of the imaginary grid
      r := 0;
      g := 0;
      b := 0;
      tpix := 0;
      for py := MyRound(yini) to MyRound(yfi) do begin
        for px := MyRound(xini) to MyRound(xfi) do begin
          Inc(tpix);
          PixelColor := ColorToRGB(imgo.Canvas.Pixels[px, py]);
          r := r + GetRValue(PixelColor);
          g := g + GetGValue(PixelColor);
          b := b + GetBValue(PixelColor);
        end;
      end;
       // Draws the result pixel
      imgd.Canvas.Pixels[x, y] := rgb(MyRound(r / tpix), MyRound(g / tpix), MyRound(b / tpix));
    end;
  end;
end;

end.