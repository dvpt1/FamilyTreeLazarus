unit info;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLIntF,
  StdCtrls, DateUtils;

type

  { TInfoStart }

  TInfoStart = class(TForm)
    Image1: TImage;
    Image2: TImage;
    ImageTitle: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    procedure Vector(x0,y0,a,l: integer);
    procedure DrawClock;
  public
    { public declarations }
  end;

var
  InfoStart: TInfoStart;

implementation

uses utils;

{$R *.lfm}

const
  R = 50 ;    // радиус циферблата часов

var
 x0,y0: integer;         // центр циферблата
 ahr,amin,asec: integer; // положение стрелок (угол)

procedure TInfoStart.FormActivate(Sender: TObject);
begin
  Timer1.Enabled := True;  // пуск таймера
end;

procedure TInfoStart.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Timer1.Enabled := False;  // стоп таймера
end;

procedure TInfoStart.FormCreate(Sender: TObject);
begin
  // установки часов
  Timer1.Interval := 1000; // период сигнал от таймера 1 сек
  x0 := R+10;
  y0 := R+10;
end;

procedure TInfoStart.Label1Click(Sender: TObject);
begin
  OpenDocument('http://www.familytree.ru/');
end;

procedure TInfoStart.Label2Click(Sender: TObject);
begin
  OpenDocument('http://www.familytree.ru/');
end;

procedure TInfoStart.Timer1Timer(Sender: TObject);
begin
  DrawClock();
end;

// вычерчивает вектор заданной длины из точки (x0,y0)
procedure TInfoStart.Vector(x0, y0, a, l: integer);
// x0,y0 - начало вектора
// a - угол между осью x и вектором
// l - длина вектора
const
  GRAD = 0.0174532;   // коэффициент пересчета угла из градусов в радианы
var
  x,y: integer;       // координаты конца вектора
begin
  InfoStart.Image1.Canvas.MoveTo(x0,y0);
  x := Round(x0 + l*cos(a*GRAD));
  y := Round(y0 - l*sin(a*GRAD));
  InfoStart.Image1.Canvas.LineTo(x,y);
end;

// шаг секундной и минутной стрелок 6 градусов, часовой - 30.
procedure TInfoStart.DrawClock;
var
  x,y: integer;    // координаты маркера на циферблате
  a: integer;      // угол между OX и пр€мой (x0,yo) (x,y)
  pc: TColor;      // цвет карандаша
  pw: integer;     // ширина карандаша
  t: TDateTime;
begin
  // стереть изображение
  Image1.Canvas.CopyRect(Image1.Canvas.ClipRect, Image2.Canvas, Image2.Canvas.ClipRect);
  // циферблат
  pc := InfoStart.Image1.Canvas.Pen.Color;
  pw := InfoStart.Image1.Canvas.Pen.Width;
  InfoStart.Image1.Canvas.Pen.Width := 1;
  InfoStart.Image1.Canvas.Pen.Color := clBlack;
  a := 0; // метки ставим от 3-х часов, против часовой стрелки
  // циферблат
  while a < 360 do
  begin
    x := x0 + Round( R * cos(a*2*pi/360));
    y := x0 - Round( R * sin(a*2*pi/360));
    InfoStart.Image1.Canvas.MoveTo(x,y);
    if (a mod 30) = 0
        then InfoStart.Image1.Canvas.Ellipse(x-2,y-2,x+3,y+3)
        else InfoStart.Image1.Canvas.Ellipse(x-1,y-1,x+1,y+1);
    a:=a+6; // 1 минута - 6 градусов
  end;
  // восстановить карандаш кисть
  InfoStart.Image1.Canvas.Pen.Width := pw;
  InfoStart.Image1.Canvas.Pen.Color := pc;
  // положение стрелок
  t := Now();
  ahr  := 90 - HourOf(t)*30-(MinuteOf(t)div 12)*6;
  amin := 90 - MinuteOf(t)*6;
  asec := 90 - SecondOf(t)*6;
  // нарисовать стрелки
  // часова€ стрелка
  InfoStart.Image1.Canvas.Pen.Width := 3;
  InfoStart.Image1.Canvas.Pen.Color := clBlack;
  Vector(x0,y0, ahr, R-20);
  // минутна€ стрелка
  InfoStart.Image1.Canvas.Pen.Width := 2;
  InfoStart.Image1.Canvas.Pen.Color := clBlack;
  Vector(x0,y0, amin, R-15);
  // секундна€ стрелка
  InfoStart.Image1.Canvas.Pen.Width := 1;
  InfoStart.Image1.Canvas.Pen.Color := clYellow;
  Vector(x0,y0, asec, R-7);
end;

end.

