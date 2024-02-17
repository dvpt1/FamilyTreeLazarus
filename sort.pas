unit sort;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ComCtrls;

type

  { TSortForm }

  TSortForm = class(TForm)
    SortBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SortItem: TRadioGroup;
    procedure CancelBtnClick(Sender: TObject);
    procedure SortBtnClick(Sender: TObject);
  private
    { private declarations }
    procedure SwapPerson(source, dest : Integer);
  public
    { public declarations }
  end;

var
  SortForm: TSortForm;

implementation

uses main, vars, mstring, utils, prozess;

{$R *.lfm}

procedure TSortForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSortForm.SortBtnClick(Sender: TObject);
var
  i, j : Integer;
  s1, s2 : String;
  d1, d2 : TDateTime;
begin
  ProcessForm.Caption := task_sorting;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := listMans.Count-1;
  for j := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := j;
    Application.ProcessMessages;
    for i := 0 to listMans.Count-j-2 do begin
      case SortForm.SortItem.ItemIndex of
      0:begin
          s1 := Trim(listBirth.Strings[i]);  //d1 := StrRusDate(Trim(listBirth.Strings[i]));
          s2 := Trim(listBirth.Strings[i+1]);//d2 := StrRusDate(Trim(listBirth.Strings[i+1]));
          if (s1 > s2) then SwapPerson(i, i+1);
        end;
      1:begin
          s1 := Trim(listDeath.Strings[i]);  //d1 := StrRusDate(Trim(listDeath.Strings[i]));
          s2 := Trim(listDeath.Strings[i+1]);//d2 := StrRusDate(Trim(listDeath.Strings[i+1]));
          if (s1 > s2) then SwapPerson(i, i+1);
        end;
      2:begin
          s1 := listMans.Strings[i];
          s2 := listMans.Strings[i+1];
          if (s1 > s2) then SwapPerson(i, i+1);
        end;
      3:begin
          s1 := listFather.Strings[i];
          s2 := listFather.Strings[i+1];
          if (s1 > s2) then SwapPerson(i, i+1);
        end;
      4:begin
          s1 := listMother.Strings[i];
          s2 := listMother.Strings[i+1];
          if (s1 > s2) then SwapPerson(i, i+1);
        end;
      end;
    end;
  end;
  ProcessForm.Hide;
  Family.SaveStringGrid;
  Family.StringGrid1.Repaint;
  Close;
end;

procedure TSortForm.SwapPerson(source, dest : Integer);
var
  tmp : String;
begin
  tmp := listBirth.Strings[source];
  listBirth.Strings[source] := listBirth.Strings[dest];
  listBirth.Strings[dest] := tmp;

  tmp := listDeath.Strings[source];
  listDeath.Strings[source] := listDeath.Strings[dest];
  listDeath.Strings[dest] := tmp;

  tmp := listMans.Strings[source];
  listMans.Strings[source] := listMans.Strings[dest];
  listMans.Strings[dest] := tmp;

  tmp := listFather.Strings[source];
  listFather.Strings[source] := listFather.Strings[dest];
  listFather.Strings[dest] := tmp;

  tmp := listMother.Strings[source];
  listMother.Strings[source] := listMother.Strings[dest];
  listMother.Strings[dest] := tmp;

  tmp := listGender.Strings[source];
  listGender.Strings[source] := listGender.Strings[dest];
  listGender.Strings[dest] := tmp;

  tmp := listPlaceb.Strings[source];
  listPlaceb.Strings[source] := listPlaceb.Strings[dest];
  listPlaceb.Strings[dest] := tmp;

  tmp := listPlaced.Strings[source];
  listPlaced.Strings[source] := listPlaced.Strings[dest];
  listPlaced.Strings[dest] := tmp;

  tmp := listSpouse.Strings[source];
  listSpouse.Strings[source] := listSpouse.Strings[dest];
  listSpouse.Strings[dest] := tmp;

  tmp := listNati.Strings[source];
  listNati.Strings[source] := listNati.Strings[dest];
  listNati.Strings[dest] := tmp;

  tmp := listOccu.Strings[source];
  listOccu.Strings[source] := listOccu.Strings[dest];
  listOccu.Strings[dest] := tmp;

  Family.ImageIcons.Move(source, dest);
end;

end.

