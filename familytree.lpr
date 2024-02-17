program familytree;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, main, tune, person, personnew,
  info, treebmp, treehtm, test, genr, foto, desc, vphoto, fold, find, sort,
  rich, kino, prozess;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  //Application.CreateForm(TProcessForm, ProcessForm);
  ProcessForm := TProcessForm.Create(Application);
  ProcessForm.Show; ProcessForm.Update;
  //
  Application.CreateForm(TFamily, Family);
  Application.CreateForm(TInfoStart, InfoStart);
  Application.CreateForm(TPersonNewForm, PersonNewForm);
  Application.CreateForm(TPersonForm, PersonForm);
  Application.CreateForm(TTreeBmpForm, TreeBmpForm);
  Application.CreateForm(TTreeHtmForm, TreeHtmForm);
  Application.CreateForm(TTestForm, TestForm);
  Application.CreateForm(TGenrForm, GenrForm);
  Application.CreateForm(TFotoForm, FotoForm);
  Application.CreateForm(TDescForm, DescForm);
  Application.CreateForm(TFileForm, FileForm);
  Application.CreateForm(TFindForm, FindForm);
  Application.CreateForm(TSortForm, SortForm);
  Application.CreateForm(TRichForm, RichForm);
  Application.CreateForm(TKinoForm, KinoForm);
  Application.CreateForm(TViewPhotoForm, ViewPhotoForm);
  Application.CreateForm(TTuneForm, TuneForm);
  //
  ProcessForm.Show; ProcessForm.Update;
  repeat
    Application.ProcessMessages;
  until ProcessForm.CloseQuery;
  ProcessForm.Hide;
  //
  Application.Run;
end.

