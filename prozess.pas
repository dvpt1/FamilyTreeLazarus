unit prozess;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls;

type

  { TProcessForm }

  TProcessForm = class(TForm)
    Gauge1: TProgressBar;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcessForm: TProcessForm;

implementation

{$R *.lfm}

end.

