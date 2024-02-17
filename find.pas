unit find;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TFindForm }

  TFindForm = class(TForm)
    FindBtn: TBitBtn;
    CancelBtn: TBitBtn;
    EditName: TEdit;
    EditFather: TEdit;
    EditMother: TEdit;
    LabelName: TLabel;
    LabelFather: TLabel;
    LabelMother: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FindForm: TFindForm;

implementation

uses main, vars, mstring;

{$R *.lfm}

procedure TFindForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TFindForm.FindBtnClick(Sender: TObject);
var
  i : Integer;
  s : String;
begin
  for i := Family.StringGrid1.Row+1 to listMans.Count-1 do begin
    if not Empty(EditName.Text) then
    if Pos(UpperCase(Trim(EditName.Text)), UpperCase(listMans.Strings[i])) > 0 then begin
      Family.StringGrid1.Row := i;
      Family.StringGrid1.Repaint;
      break;
    end;
    if not Empty(EditFather.Text) then
    if Pos(UpperCase(Trim(EditFather.Text)), UpperCase(listFather.Strings[i])) > 0 then begin
      Family.StringGrid1.Row := i;
      Family.StringGrid1.Repaint;
      break;
    end;
    if not Empty(EditMother.Text) then
    if Pos(UpperCase(Trim(EditMother.Text)), UpperCase(listMother.Strings[i])) > 0 then begin
      Family.StringGrid1.Row := i;
      Family.StringGrid1.Repaint;
      break;
    end;
  end;
end;

end.

