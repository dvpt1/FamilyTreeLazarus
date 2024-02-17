unit desc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TDescForm }

  TDescForm = class(TForm)
    ButtonCancel: TToolButton;
    ButtonOK: TToolButton;
    EditName: TEdit;
    LabelName: TLabel;
    LabelNote: TLabel;
    EditNote: TMemo;
    ToolBar1: TToolBar;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DescForm: TDescForm;
  ModifiName : Boolean;
  NameNote : String;
  NamsDesc, ExtsDesc, NotsDesc, OldsDesc : String;

implementation

uses main, mstring;

{$R *.lfm}

procedure TDescForm.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TDescForm.ButtonOKClick(Sender: TObject);
begin
  if EditName.Modified or EditNote.Modified then begin
    NamsDesc := Trim(EditName.Text);
    while Copy(NamsDesc, Length(NamsDesc), 1) = '.' do begin
      NamsDesc := Copy(NamsDesc, 1 , Length(NamsDesc) - 1);
    end;
    NotsDesc := StrDelEoln(EditNote.Text);
    NameNote := NamsDesc + ExtsDesc + ':' + NotsDesc;
    ModifiName := True;
  end;
  Close;
end;

procedure TDescForm.FormActivate(Sender: TObject);
var
  i : Integer;
begin
  i := Pos(':',NameNote);
  if i > 0 then begin
    EditName.Text := Copy(NameNote,1,i-1);
    EditNote.Text := StrAddEoln(Copy(NameNote,i+1,Length(NameNote)));
  end else begin
    EditName.Text := NameNote;
    EditNote.Text := '';
  end;
  OldsDesc := EditName.Text;
  ModifiName := False;
end;

end.

