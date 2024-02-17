unit test;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TTestForm }

  TTestForm = class(TForm)
    BackButton: TToolButton;
    Memo1: TMemo;
    Gauge1: TProgressBar;
    ToolBar1: TToolBar;
    procedure BackButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure TestBaseFamily();
  end;

var
  TestForm: TTestForm;

implementation

uses main, vars, utils, mstring, prozess;

{ TTestForm }

{$R *.lfm}

procedure TTestForm.BackButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTestForm.TestBaseFamily;
var
  i, j : Integer;
  function RetrDateStr(Line: string): string;
  const
    Chars = ['.','-','/','0'..'9'];
  var
    RetVar: string;
    d: TDateTime;
    p : Integer;
  begin
    if Trim(Line)='' then begin
      RetVar := '00000000';
    end else begin
      for p := 1 to Length(Line) do begin
        if Line[p] in Chars then break;//проверка, есть ли символы отличные от ./-0..9
      end;
      if p > Length(Line) then begin
        d := StrRusDate(Line);
        DateTimeToString( Retvar,'yyyymmdd',d);
      end else begin
        RetVar := '00000000';
      end;
    end;
    Result := RetVar;
  end;
begin
  YesNo := False;
  Memo1.Lines.Clear;
//
  ProcessForm.Caption := task_testing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := listMans.Count-1;
// тестирую
  for i := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := i;
    Application.ProcessMessages;
    // правильно ли заполнено поле - ѕќЋ
    if Empty(listGender.Strings[i]) then begin
      Memo1.Lines.Add('"' + listMans.Strings[i] + '" ' + ' = ' + msgErr1 + '= "' + field_gender+'" ???');
      YesNo := True;
    end;
    // правильно ли заполнено поле - ќ“≈÷
    if not Empty(listFather.Strings[i]) then begin
     j := iRetrFather(listFather.Strings[i]);
     if j = -1 then begin
      Memo1.Lines.Add('"' + listMans.Strings[i] + '"' +
                      ' = ' + msgErr2 + ' - ' + field_father +
                      ' = "' + listFather.Strings[i] + '" ???');
      YesNo := True;
     end else begin
      if not Empty(listBirth.Strings[i]) then
      if (RetrDateStr(listBirth.Strings[i]) < RetrDateStr(listBirth.Strings[j])) then begin
      Memo1.Lines.Add('"' + listMans.Strings[i] + '"' +
                      ' = ' + msgErr3 + ' - ' + field_father +
                      ' = "'+listFather.Strings[i] +
                      '" ' + DateToStr(StrRusDate(listBirth.Strings[i])) +
                      ' ??? ' + DateToStr(StrRusDate(listBirth.Strings[j])));
      YesNo := True;
      end;
     end;
    end;
    // правильно ли заполнено поле - ћј“№
    if not Empty(listMother.Strings[i]) then begin
     j := iRetrMother(listMother.Strings[i]);
     if j = -1 then begin
      Memo1.Lines.Add('"' + listMans.Strings[i] + '"' +
                      ' = ' + msgErr2 + ' - ' + field_mother +
                      ' = "' + listMother.Strings[i] + '" ???');
      YesNo := True;
     end else begin
      if not Empty(listBirth.Strings[i]) then
      if (RetrDateStr(listBirth.Strings[i]) < RetrDateStr(listBirth.Strings[j])) then begin
      Memo1.Lines.Add('"' + listMans.Strings[i] + '"' +
                      ' = ' + msgErr3 + ' - ' + field_mother +
                      ' = "' + listMother.Strings[i] +
                      '" ' + DateToStr(StrRusDate(listBirth.Strings[i])) +
                      ' ??? ' + DateToStr(StrRusDate(listBirth.Strings[j])));
      YesNo := True;
      end;
     end;
    end;
  end;
//
  ProcessForm.Hide;
end;

end.

