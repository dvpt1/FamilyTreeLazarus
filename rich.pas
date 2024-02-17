unit rich;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls;

type

  { TRichForm }

  TRichForm = class(TForm)
    BackButton: TToolButton;
    HelpButton: TToolButton;
    OpenDialog1: TOpenDialog;
    PrintDialog1: TPrintDialog;
    RichEdit1: TMemo;
    PrintButton: TToolButton;
    SaveButton: TToolButton;
    SaveDialog1: TSaveDialog;
    ToolBar1: TToolBar;
    TuneButton: TToolButton;
    procedure BackButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  RichForm: TRichForm;

implementation

uses vars, main, info, tune;

{$R *.lfm}

procedure TRichForm.BackButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TRichForm.FormActivate(Sender: TObject);
var
  i,ii : Integer;
  s,ss : String;
begin
// вычисл€ю каталог
  if PersonAll then begin
    Caption := CaptionRich;
    s := MainPathDAT+MainFileRTF;
  end else begin
    Caption := CaptionRich + ' ' + listMans.Strings[GridRow];
    s := MainPathTXT +listMans.Strings[GridRow]+ '.txt';
  end;
  if FileExists(s) then
  {$IFDEF WINDOWS}
  RichEdit1.Lines.LoadFromFile(UTF8toANSI(s));
  {$ENDIF}
  {$IFDEF UNIX}
  RichEdit1.Lines.LoadFromFile(s);
  {$ENDIF}
//
  RichEdit1.SetFocus;
end;

procedure TRichForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TRichForm.PrintButtonClick(Sender: TObject);
begin
  if not PrintDialog1.Execute then Exit;
  //??RichEdit1.Print(Caption);
end;

procedure TRichForm.SaveButtonClick(Sender: TObject);
var
  s : String;
begin
  if RichEdit1.Modified then begin
    if PersonAll then begin
      s := MainPathDAT+MainFileRTF;
    end else begin
      s := MainPathTXT +listMans.Strings[GridRow]+ '.txt';
    end;
    {$IFDEF WINDOWS}
    RichEdit1.Lines.SaveToFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    RichEdit1.Lines.SaveToFile(s);
    {$ENDIF}
  end;
  Close;
end;

procedure TRichForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

end.

