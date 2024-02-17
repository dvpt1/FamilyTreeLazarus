unit tune;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  //AbBase, AbBrowse, AbZBrows, AbUnzper, AbZipper, AbArcTyp,
  StdCtrls, Buttons, ExtCtrls, MaskEdit, EditBtn, IniFiles, Registry;

type

  { TTuneForm }

  TTuneForm = class(TForm)
    EditPath1: TEdit;
    FolderButton: TBitBtn;
    ComboDate: TComboBox;
    FormTree: TComboBox;
    GroupDate: TGroupBox;
    LabelGedcom: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    TreeFaMo: TComboBox;
    TreeHiLo: TComboBox;
    CodeGedcom: TComboBox;
    Edit1Font: TComboBox;
    Edit2Font: TComboBox;
    ExportBtn: TBitBtn;
    FontList: TGroupBox;
    FontTree: TGroupBox;
    GroupFaMo: TGroupBox;
    GroupGedcom: TGroupBox;
    GroupHiLo: TGroupBox;
    GroupLang: TGroupBox;
    GroupPath: TGroupBox;
    GroupTree: TGroupBox;
    GroupView: TRadioGroup;
    GroupZip: TGroupBox;
    ImportBtn: TBitBtn;
    LngMemo1: TMemo;
    Edit1Size: TMaskEdit;
    Edit2Size: TMaskEdit;
    RadioLang: TComboBox;
    ScrollBox1: TScrollBox;
    ToolBar1: TToolBar;
    ButtonOK: TToolButton;
    ButtonSave: TToolButton;
    ButtonCancel: TToolButton;
    UnZipBtn: TBitBtn;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    ZipBtn: TBitBtn;
    procedure ExportBtnClick(Sender: TObject);
    procedure FolderButtonClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
  private
    { private declarations }
    sLang : ShortString;
    sDate : ShortString;
    GaugePos : Integer;
    aSpouse : TStringList;
    aWeddin : TStringList;
    sSpouse : String;
    sWeddin : String;
    sPlacew : String;
    function CfgXMLString(const sOption, sDefault: String): String;
    function CfgReadString(const sSection, sOption, sDefault: String): String;
    procedure LoadVersion(fname : String);
    procedure LoadFont;
    procedure ExportGedcom(GedFile : String);
    procedure ImportGedcom(GedFile : String);
  public
    { public declarations }
    procedure LoadPathData;
    procedure SavePathData;
  end;

var
  TuneForm: TTuneForm;
  Reg : TRegistry;
// сохраняю параметры
  oldCheckPanel : Boolean;
  oldCheckStatus : Boolean;
  oldFormTree : Integer;
  oldTreeFaMo : Integer;
  oldTreeHiLo : Integer;
  oldTreeView : Integer;
  oldRadioLang : Integer;
  oldComboDate : Integer;
  oldEdit1Font : Integer;
  oldEdit2Font : Integer;
  oldEdit1Size : Integer;
  oldEdit2Size : Integer;

implementation

uses main, vars, mstring, treebmp, treehtm, person, personnew,
     desc,sort, find, utils, cnsts, prozess,
     foto, kino, fold, test, vphoto, rich, genr;

{$R *.lfm}

{ TTuneForm }

procedure TTuneForm.FormCreate(Sender: TObject);
var
  i, p : Integer;
begin
  EditPath1.Text := MainPathDAT;
// загружаю конфигурацию из реестра EXE
  ConfigFile := TIniFile.Create(MainPathEXE + MainFileINI);
  sLang := UpperCase(ConfigFile.ReadString('LANGUAGES','LANGUAGE', 'English'));
  ConfigFile.Free;
// загружаю конфигурацию из папки данных
  ConfigFile := TIniFile.Create(MainPathDAT + MainFileINI);
  sLang := UpperCase(ConfigFile.ReadString('LANGUAGES','LANGUAGE', sLang));
  sDate := ConfigFile.ReadString('FORMAT','DATE', '');
  if Pos('dd', sDate) = 0 then sDate := '';
  FormTree.ItemIndex := ConfigFile.ReadInteger('TREE','TYPE', 0);
  TreeFaMo.ItemIndex := ConfigFile.ReadInteger('TREE','FAMO', 0);
  TreeHiLo.ItemIndex := ConfigFile.ReadInteger('TREE','HILO', 0);
  GroupView.ItemIndex := ConfigFile.ReadInteger('TREE','VIEW', 0);
  Edit1Font.Font.Name := ConfigFile.ReadString('FONT','LISTFONT', Family.Font.Name);
  Edit1Size.Text := IntToStr(ConfigFile.ReadInteger('FONT','LISTSIZE', Family.Font.Size));
  Edit2Font.Font.Name := ConfigFile.ReadString('FONT','TREEFONT', Family.Font.Name);
  Edit2Size.Text := IntToStr(ConfigFile.ReadInteger('FONT','TREESIZE', Family.Font.Size));
  ConfigFile.Free;
// font
  for i := 0 to Screen.Fonts.Count -1 do begin
    Edit1Font.Items.Add(Screen.Fonts[i]);
    if (Edit1Font.Font.Name = Screen.Fonts[i]) then begin
      Edit1Font.ItemIndex := i;
    end;
  end;
  Edit1Font.Text := Edit1Font.Font.Name;
  LoadFont;
  for i := 0 to Screen.Fonts.Count -1 do begin
    Edit2Font.Items.Add(Screen.Fonts[i]);
    if (Edit2Font.Font.Name = Screen.Fonts[i]) then begin
      Edit2Font.ItemIndex := i;
    end;
  end;
  Edit2Font.Text := Edit2Font.Font.Name;
  LoadFont;
// список языков
  RadioLang.ItemIndex := 0;
  RadioChar.Clear;
  if FileExists(MainPathEXE + MainFileLNG) then begin
    RadioLang.Items.LoadFromFile(MainPathEXE + MainFileLNG);
    for i := 0 to RadioLang.Items.Count-1 do begin
      RadioChar.Add(Copy(RadioLang.Items.Strings[i], Pos(';',RadioLang.Items.Strings[i])+1, Length(RadioLang.Items.Strings[i])));
      RadioLang.Items.Strings[i] := Copy(RadioLang.Items.Strings[i], 1, Pos(';',RadioLang.Items.Strings[i])-1);
      p := Pos(';',RadioChar.Strings[i]);
      if sLang=UpperCase(Copy(RadioChar.Strings[i],1,p-1)) then RadioLang.ItemIndex := i;
    end;
    if RadioLang.ItemIndex < 0 then
      RadioLang.ItemIndex := 0;
  end else begin
    RadioChar.Add('en;EASTEUROPE_CHARSET');
  end;
// язык и кодировка
  i := Pos(';',RadioChar.Strings[RadioLang.ItemIndex]);
  if i <> 0 then begin
    lng_languag := Copy(RadioChar.Strings[RadioLang.ItemIndex],1,i-1);
    lng_charset := Copy(RadioChar.Strings[RadioLang.ItemIndex],i+1,Length(RadioChar.Strings[RadioLang.ItemIndex]));
  end else begin
    lng_languag := RadioChar.Strings[RadioLang.ItemIndex];
    lng_charset := '';
  end;
  LoadVersion(MainPathRES + lng_languag + dZd + 'strings.xml');
end;

procedure TTuneForm.ImportBtnClick(Sender: TObject);
begin
  OpenDialog1.Title := pref_gedcom_title+' '+pref_gedcom_import;
  OpenDialog1.DefaultExt := '*.ged';
  OpenDialog1.Filter := '*.ged|*.ged';
  OpenDialog1.FileName := 'FamilyTree.ged';
  if OpenDialog1.Execute then begin
    ImportGedcom(OpenDialog1.FileName);
    Family.OpenProgram();
    Close;
  end;
end;

procedure TTuneForm.FormActivate(Sender: TObject);
begin
  EditPath1.Text := MainPathDAT;
  OldRadioLang := RadioLang.ItemIndex;
  OldComboDate := ComboDate.ItemIndex;
  oldFormTree := FormTree.ItemIndex;
  oldTreeHiLo := TreeHiLo.ItemIndex;
  oldTreeFaMo := TreeFaMo.ItemIndex;
  oldTreeView := GroupView.ItemIndex;
  oldEdit1Font := Edit1Font.ItemIndex;
  oldEdit2Font := Edit2Font.ItemIndex;
  oldEdit1Size := StrToInt(Edit1Size.Text);
  oldEdit2Size := StrToInt(Edit2Size.Text);
  ScrollBox1.SetFocus;
end;

procedure TTuneForm.ButtonCancelClick(Sender: TObject);
var
  i : Integer;
begin
// возвращаю старые настройки
  EditPath1.Text := MainPathDAT;
  RadioLang.ItemIndex := OldRadioLang;
  ComboDate.ItemIndex := OldComboDate;
  FormTree.ItemIndex := oldFormTree;
  TreeHiLo.ItemIndex := oldTreeHiLo;
  TreeFaMo.ItemIndex := oldTreeFaMo;
  GroupView.ItemIndex := oldTreeView;
  Edit1Font.ItemIndex := oldEdit1Font;
  Edit2Font.ItemIndex := oldEdit2Font;
  Edit1Size.Text := IntToStr(oldEdit1Size);
  Edit2Size.Text := IntToStr(oldEdit2Size);
// €зык и кодировка
  RadioLang.ItemIndex := OldRadioLang;
  i := Pos(';',RadioChar.Strings[RadioLang.ItemIndex]);
  if i <> 0 then begin
    lng_languag := Copy(RadioChar.Strings[RadioLang.ItemIndex],1,i-1);
    lng_charset := Copy(RadioChar.Strings[RadioLang.ItemIndex],i+1,Length(RadioChar.Strings[RadioLang.ItemIndex]));
  end else begin
    lng_languag := RadioChar.Strings[RadioLang.ItemIndex];
    lng_charset := '';
  end;
  Close;
end;

procedure TTuneForm.FolderButtonClick(Sender: TObject);
var
  dir : String;
begin
  dir := EditPath1.Text;
  SelectDirectory(CaptionFolder, '', dir);
  if (dir <> '') then
  if (dir <> EditPath1.Text) then
    EditPath1.Text := dir + dZd;
end;

procedure TTuneForm.ExportBtnClick(Sender: TObject);
begin
  SaveDialog1.Title := pref_gedcom_title+' '+pref_gedcom_export;
  SaveDialog1.DefaultExt := '*.ged';
  SaveDialog1.Filter := '*.ged|*.ged';
  SaveDialog1.FileName := 'FamilyTree.ged';
  if SaveDialog1.Execute then begin
    ExportGedcom(SaveDialog1.FileName);
  end;
end;

procedure TTuneForm.ButtonOKClick(Sender: TObject);
var
  i : Integer;
begin
  if (EditPath1.Text <> MainPathDAT) or Redraws then begin
    ReDraws := False;
    MainPathDAT := EditPath1.Text;
    SavePathData();// сохран€ю конфигурацию в реестре
    Family.OpenProgram();
  end;
// Ќовые настройки
  if ((ComboDate.ItemIndex <> OldComboDate) and (ComboDate.ItemIndex > -1)) then begin
    DateFormat := StrReplaceAll(ComboDate.Items.Strings[ComboDate.ItemIndex], 'm', 'M');
    if (Pos('.',DateFormat) > 0) then begin
      DateSeparate := '.';
    end else
    if (Pos('-',DateFormat) > 0) then begin
      DateSeparate := '-';
    end else
    if (Pos('/',DateFormat) > 0) then begin
    DateSeparate := '/';
  end;
  end;
  if Edit1Font.ItemIndex <> oldEdit1Font then LoadFont;
  if Edit1Size.Text <> IntToStr(oldEdit1Size) then LoadFont;
  if Edit2Font.ItemIndex <> oldEdit2Font then LoadFont;
  if Edit2Size.Text <> IntToStr(oldEdit2Size) then LoadFont;
// €зык и кодировка
  if OldRadioLang <> RadioLang.ItemIndex then sDate := '';
  i := Pos(';',RadioChar.Strings[RadioLang.ItemIndex]);
  if i <> 0 then begin
    lng_languag := Copy(RadioChar.Strings[RadioLang.ItemIndex],1,i-1);
    lng_charset := Copy(RadioChar.Strings[RadioLang.ItemIndex],i+1,Length(RadioChar.Strings[RadioLang.ItemIndex]));
  end else begin
    lng_languag := RadioChar.Strings[RadioLang.ItemIndex];
    lng_charset := '';
  end;
  LoadVersion(MainPathRES + lng_languag + dZd + 'strings.xml');
  Family.Repaint;
  Close;
end;

procedure TTuneForm.ButtonSaveClick(Sender: TObject);
var
  i : Integer;
begin
  if (EditPath1.Text <> MainPathDAT) or Redraws then begin
    ReDraws := False;
    MainPathDAT := EditPath1.Text;
    SavePathData();// сохран€ю конфигурацию в реестре
    Family.OpenProgram();
  end;
// Ќовые настройки
  if ((ComboDate.ItemIndex <> OldComboDate) and (ComboDate.ItemIndex > -1)) then begin
    DateFormat := StrReplaceAll(ComboDate.Items.Strings[ComboDate.ItemIndex], 'm', 'M');
    if (Pos('.',DateFormat) > 0) then begin
      DateSeparate := '.';
    end else
    if (Pos('-',DateFormat) > 0) then begin
      DateSeparate := '-';
    end else
    if (Pos('/',DateFormat) > 0) then begin
      DateSeparate := '/';
    end;
  end;
  if Edit1Font.ItemIndex <> oldEdit1Font then LoadFont;
  if Edit1Size.Text <> IntToStr(oldEdit1Size) then LoadFont;
  if Edit2Font.ItemIndex <> oldEdit2Font then LoadFont;
  if Edit2Size.Text <> IntToStr(oldEdit2Size) then LoadFont;
// €зык и кодировка
  if OldRadioLang <> RadioLang.ItemIndex then sDate := '';
  i := Pos(';',RadioChar.Strings[RadioLang.ItemIndex]);
  if i <> 0 then begin
    lng_languag := Copy(RadioChar.Strings[RadioLang.ItemIndex],1,i-1);
    lng_charset := Copy(RadioChar.Strings[RadioLang.ItemIndex],i+1,Length(RadioChar.Strings[RadioLang.ItemIndex]));
  end else begin
    lng_languag := RadioChar.Strings[RadioLang.ItemIndex];
    lng_charset := '';
  end;
  LoadVersion(MainPathRES + lng_languag + dZd + 'strings.xml');
// сохран€ю конфигурацию
  ConfigFile := TIniFile.Create(MainPathDAT + MainFileINI);
  ConfigFile.WriteString('LANGUAGES','LANGUAGE', lng_languag);
  ConfigFile.WriteString('FORMAT','DATE', DateFormat);
  ConfigFile.WriteInteger('TREE','TYPE', FormTree.ItemIndex);
  ConfigFile.WriteInteger('TREE','FAMO', TreeFaMo.ItemIndex);
  ConfigFile.WriteInteger('TREE','HILO', TreeHiLo.ItemIndex);
  ConfigFile.WriteInteger('TREE','VIEW', GroupView.ItemIndex);
  ConfigFile.WriteString('FONT','LISTFONT', Edit1Font.Text);
  ConfigFile.WriteString('FONT','LISTSIZE', Edit1Size.Text);
  ConfigFile.WriteString('FONT','TREEFONT', Edit2Font.Text);
  ConfigFile.WriteString('FONT','TREESIZE', Edit2Size.Text);
  ConfigFile.Free;
//
  Family.Repaint;
  Close;
end;

procedure TTuneForm.LoadFont;
begin
  if Edit1Font.ItemIndex > -1 then begin
    Family.Font.Name := Edit1Font.Items[Edit1Font.ItemIndex];
    Family.Font.Size := StrToInt(Edit1Size.Text);
    Family.StringGrid1.Font.Name := Family.Font.Name;
    Family.StringGrid1.Font.Size := Family.Font.Size;
  end;
  if Edit2Font.ItemIndex > -1 then begin
    TreeBmpForm.ScrollTree.Font.Name := Edit2Font.Items[Edit2Font.ItemIndex];
    TreeBmpForm.ScrollTree.Font.Size := StrToInt(Edit2Size.Text);
  end;
end;

function TTuneForm.CfgXMLString(const sOption, sDefault: String): String;
var
  i, j : Integer;
begin
  Result := sDefault;
  for j := 0 to LngMemo1.Lines.Count - 1 do begin
    i := Pos('name="' + Trim(sOption),LngMemo1.Lines.Strings[j] + '"');
    if i <> 0 then begin
      Result := LngMemo1.Lines.Strings[j];
      i := Pos('>', Result);
      Result := Trim(Copy(Result, i+1, 1000));
      i := Pos('</', Result);
      Result := Trim(Copy(Result, 1, i-1));
      i := Pos('(%', Result);
      if i <> 0 then Result := Copy(Result, 1, i-1);
      Break;
    end;
  end;
end;

function TTuneForm.CfgReadString(const sSection, sOption, sDefault: String): String;
var
  i, j : Integer;
begin
  Result := sDefault;
  for i:=0 to LngMemo1.Lines.Count-1 do begin
    if Pos(sSection,LngMemo1.Lines.Strings[i]) <> 0 then Break;
  end;
  if i = LngMemo1.Lines.Count then Exit;
  for j:=i to LngMemo1.Lines.Count-1 do begin
    if Empty(LngMemo1.Lines.Strings[j]) then Exit;
    i := Pos(sOption,LngMemo1.Lines.Strings[j]);
    if i <> 0 then begin
      i := Pos('=',LngMemo1.Lines.Strings[j]);
      Result := Trim(Copy(LngMemo1.Lines.Strings[j], i+1, 1000));
      Break;
    end;
  end;
end;

procedure TTuneForm.LoadVersion(fname : String);
var
  mnu : ShortString;
  i : Integer;
begin
// загружаю конфигурацию из файла .XML
  if FileExists(fname) then
    LngMemo1.Lines.LoadFromFile(fname)
  else
    LngMemo1.Clear;
// Name application
  app_name    := CfgXMLString('app_name','The Family Tree of Family');
// Fields
  field_name    := CfgXMLString('field_name    ','Person:');
  field_gender  := CfgXMLString('field_gender  ','Gender');
  field_father  := CfgXMLString('field_father  ','Father:');
  field_mother  := CfgXMLString('field_mother  ','Mother:');
  field_birth   := CfgXMLString('field_birth   ','Date of birth:');
  field_death   := CfgXMLString('field_death   ','Date of death:');
  field_placeb  := CfgXMLString('field_placeb  ','Place of birth:');
  field_placed  := CfgXMLString('field_placed  ','Place of death:');
  field_foto    := CfgXMLString('field_foto    ','Name:');
  field_note    := CfgXMLString('field_note    ','Note:');
  field_child   := CfgXMLString('field_child   ','Child:');
  field_son     := CfgXMLString('field_son     ','Son:');
  field_daughter:= CfgXMLString('field_daughter','Daughter:');
  field_brother := CfgXMLString('field_brother ','Brother:');
  field_sister  := CfgXMLString('field_sister  ','Sister:');
  field_occu    := CfgXMLString('field_occu    ','Occupation:');
  field_nati    := CfgXMLString('field_nati    ','Nationality:');
  field_spouse  := CfgXMLString('field_spouse  ','Spouse:');
  field_husband := CfgXMLString('field_husband ','Husband:');
  field_wife    := CfgXMLString('field_wife    ','Wife:');
  field_wedding := CfgXMLString('field_wedding ','Wedding Date:');
  field_placew  := CfgXMLString('field_placew  ','Wedding Venue:');
  Man           := CfgXMLString('gender_male  ', 'Male');
  Woman         := CfgXMLString('gender_female', 'Female');
  Enter         := CfgXMLString('gender_enter ', 'to Say');
// Кнопки
  ButonOK     := CfgXMLString('menu_ok',  'OK');
  ButonCancel := CfgXMLString('menu_cancel','Cancel');
  ButonYes    := CfgXMLString('menu_yes', 'Yes');
  ButonNo     := CfgXMLString('menu_no',  'No');
  ButonSave   := CfgXMLString('menu_save','Save');
  ButonLoad   := CfgXMLString('menu_load','Load');
  ButonSort   := CfgXMLString('menu_sort','Sort');
  ButonFind   := CfgXMLString('menu_find','Find');
  ButonNew    := CfgXMLString('menu_new', 'New');
  ButonBack   := CfgXMLString('menu_back','back');
// Формат данных
  if Empty(sDate) then
    DateFormat := CfgXMLString('date_format', 'dd.MM.yyyy')
  else
    DateFormat := sDate;
  for i := 0 to ComboDate.Items.Count-1 do begin
    if UpperCase(ComboDate.Items.Strings[i]) = UpperCase(DateFormat) then begin
      ComboDate.Text := DateFormat;
      ComboDate.ItemIndex := i;
      break;
    end;
  end;
  if (Pos('.',DateFormat) > 0) then begin
    DateSeparate := '.';
  end else
  if (Pos('-',DateFormat) > 0) then begin
    DateSeparate := '-';
  end else
  if (Pos('/',DateFormat) > 0) then begin
    DateSeparate := '/';
  end;
// MainForm
  CaptionList   := CfgXMLString('title_family', 'Family');
  CaptionTree   := CfgXMLString('title_tree',   'Family Tree');
  CaptionPict   := CfgXMLString('title_foto',   'Photo album');
  CaptionKino   := CfgXMLString('title_kino',   'Video album');
  CaptionFile   := CfgXMLString('title_file',   'Files album');
  CaptionGenr   := CfgXMLString('title_listgenerat', 'List of generations');
  CaptionGener  := CfgXMLString('title_generation', 'Generation');
  CaptionRich   := CfgXMLString('title_rich',   'Family History');
  CaptionBranch := CfgXMLString('title_branch', 'Genealogical branch');
  CaptionFolder := CfgXMLString('title_folder', 'Select Folder');
// кнопки
  list_button_hint := CfgXMLString('list_button_hint','Add person');
  tree_button_hint := CfgXMLString('tree_button_hint','Family tree');
  genr_button_hint := CfgXMLString('genr_button_hint','List of generations');
  rept_button_hint := CfgXMLString('rept_button_hint','Personal report');
  foto_button_hint := CfgXMLString('foto_button_hint','Photo album');
  kino_button_hint := CfgXMLString('kino_button_hint','Video album');
  file_button_hint := CfgXMLString('file_button_hint','Files album');
  rich_button_hint := CfgXMLString('rich_button_hint','Family History');
  rept_button_hint := CfgXMLString('rept_button_hint','Individual Report');
  newe_button_hint := CfgXMLString('newe_button_hint','Add');
  edit_button_hint := CfgXMLString('edit_button_hint','Edit');
  dele_button_hint := CfgXMLString('dele_button_hint','Delete');
  sort_button_hint := CfgXMLString('sort_button_hint','Sort');
  find_button_hint := CfgXMLString('find_button_hint','Find');
  pict_button_hint := CfgXMLString('pict_button_hint','Add photo');
  prin_button_hint := CfgXMLString('prin_button_hint','Print');
  save_button_hint := CfgXMLString('save_button_hint','Save');
  tune_button_hint := CfgXMLString('tune_button_hint','Preferences');
  help_button_hint := CfgXMLString('help_button_hint','Help');
  exit_button_hint := CfgXMLString('exit_button_hint','Exit');
  size_button_hint := CfgXMLString('size_button_hint','Size');
  plus_button_hint := CfgXMLString('plus_button_hint','Plus');
  minu_button_hint := CfgXMLString('minu_button_hint','Minus');
  back_button_hint := CfgXMLString('back_button_hint','Back');
// menu popup main
  Family.New1.Caption := list_button_hint;
  Family.Tree1.Caption := tree_button_hint;
  Family.Genr1.Caption := genr_button_hint;
  Family.Foto1.Caption := foto_button_hint;
  Family.Kino1.Caption := kino_button_hint;
  Family.File1.Caption := file_button_hint;
  Family.Rich1.Caption := rich_button_hint;
  Family.Edit1.Caption := edit_button_hint;
  Family.Dele1.Caption := dele_button_hint;
  Family.Find1.Caption := find_button_hint;
  Family.Sort1.Caption := sort_button_hint;
  Family.Print1.Caption:= prin_button_hint;
  Family.Tune1.Caption := tune_button_hint;
// TuneForm
  TuneForm.Caption  := CfgXMLString('pref_tree_title', 'Preferences');
  GroupPath.Caption := CfgXMLString('pref_catalog_title', 'Directory');
  GroupPath.Hint    := CfgXMLString('hint_catalog_title', 'Select a directory location data');
  GroupLang.Caption := CfgXMLString('pref_lang_title', 'Language');
  GroupLang.Hint    := CfgXMLString('hint_lang_title', 'Program language');
  GroupDate.Caption := CfgXMLString('pref_date_title','Date');
  GroupDate.Hint    := CfgXMLString('hint_date_title','Select a date format of the program');
  //
  GroupTree.Caption := CfgXMLString('pref_type_title', 'Tree View');
  GroupTree.Hint    := CfgXMLString('hint_type_title', 'Selection of the family tree');
  i := FormTree.ItemIndex;
  FormTree.Items.Clear;
  FormTree.Items.Add(CfgXMLString('pref_type_all', 'Universal'));
  FormTree.Items.Add(CfgXMLString('pref_type_commom', 'General'));
  FormTree.Items.Add(CfgXMLString('pref_type_ring', 'Rings'));
  FormTree.Items.Add(CfgXMLString('pref_type_national', 'National'));
  if i < 0 then
    FormTree.ItemIndex := 0
  else
    FormTree.ItemIndex := i;
  FormTree.Text := FormTree.Items.Strings[FormTree.ItemIndex];
  //
  GroupFaMo.Caption := CfgXMLString('pref_gender_title', 'Progenitor');
  GroupFaMo.Hint    := CfgXMLString('hint_gender_title', 'Choosing predecessors');
  i := TreeFaMo.ItemIndex;
  TreeFaMo.Items.Clear;
  TreeFaMo.Items.Add(CfgXMLString('root_all', 'all'));
  TreeFaMo.Items.Add(CfgXMLString('root_men', 'from men'));
  TreeFaMo.Items.Add(CfgXMLString('root_women', 'from women'));
  if i < 0 then
    TreeFaMo.ItemIndex := 0
  else
    TreeFaMo.ItemIndex := i;
  TreeFaMo.Text := TreeFaMo.Items.Strings[TreeFaMo.ItemIndex];
  //
  GroupHiLo.Caption := CfgXMLString('pref_view_tree_title', 'Draw a family tree');
  GroupHiLo.Hint    := CfgXMLString('hint_view_tree_title', 'Select the direction of drawing a family tree');
  i := TreeHiLo.ItemIndex;
  TreeHiLo.Items.Clear;
  TreeHiLo.Items.Add(CfgXMLString('pref_view_tree_all',  'From the bottom up'));
  TreeHiLo.Items.Add(CfgXMLString('pref_view_tree_down', 'From top to bottom'));
  if i < 0 then
    TreeHiLo.ItemIndex := 0
  else
    TreeHiLo.ItemIndex := i;
  TreeHiLo.Text := TreeHiLo.Items.Strings[TreeHiLo.ItemIndex];
  //
  GroupView.Caption := CfgXMLString('pref_form_title', 'The format of a family tree');
  GroupView.Hint    := CfgXMLString('hint_form_title', 'Select the format of drawing a family tree');
  i := GroupView.ItemIndex;
  GroupView.Items.Strings[0] := CfgXMLString('pref_form_bmp', 'Graphic');
  GroupView.Items.Strings[1] := CfgXMLString('pref_form_htm', 'Hypertext');
  if i < 0 then
    GroupView.ItemIndex := 0
  else
    GroupView.ItemIndex := i;
  //
  FontList.Caption  := CfgXMLString('pref_font_list_title', 'Font list');
  FontList.Hint     := CfgXMLString('hint_font_list_title', 'Select the font on the list of persons');
  FontTree.Caption  := CfgXMLString('pref_font_tree_title', 'Font tree');
  FontTree.Hint     := CfgXMLString('hint_font_tree_title', 'Select a font family tree');
// LABEL
  labelName   := CfgXMLString('labelName', 'Name:');
  labelNote   := CfgXMLString('labelNote', 'Note:');
// GEDCOM
  pref_gedcom_title  := CfgXMLString('pref_gedcom_title  ','GEDCOM');
  pref_gedcom_export := CfgXMLString('pref_gedcom_export ','Export');
  pref_gedcom_import := CfgXMLString('pref_gedcom_import ','Import');
  hint_gedcom_export := CfgXMLString('hint_gedcom_export ','Imports from international genealogical GEDCOM format');
  hint_gedcom_import := CfgXMLString('hint_gedcom_import ','Exports to international genealogical GEDCOM format');
  pref_gedcom_charset:= CfgXMLString('pref_gedcom_charset','Encoding');
  hint_gedcom_charset:= CfgXMLString('hint_gedcom_charset','GEDCOM file with Encoding');
  pref_gedcom_between:= CfgXMLString('code_gedcom_between','between');
  pref_gedcom_and    := CfgXMLString('code_gedcom_and    ','and');
  pref_gedcom_before := CfgXMLString('code_gedcom_before ','before');
  pref_gedcom_after  := CfgXMLString('code_gedcom_after  ','after');
// ZIP
  pref_zip_title  := CfgXMLString('pref_zip_title ','ZIP');
  pref_zip_export := CfgXMLString('pref_zip_export','Compress');
  pref_zip_import := CfgXMLString('pref_zip_import','Unpack');
  hint_zip_export := CfgXMLString('hint_zip_export','Write to a ZIP archive');
  hint_zip_import := CfgXMLString('hint_zip_import','Get information from the ZIP archive');
// TEST ERROR BASE
  msgErr0       := CfgXMLString('pref_test_err0', 'repetition of persons');
  msgErr1       := CfgXMLString('pref_test_err1', 'not entered');
  msgErr2       := CfgXMLString('pref_test_err2', 'not on the list');
  msgErr3       := CfgXMLString('pref_test_err3', 'born BEFORE');
  msgErr4       := CfgXMLString('pref_test_err4', 'repetition of spouse');
// ERROR MESSAGE
  error_msg00   := CfgXMLString('error_msg00', 'Can not');
  error_msg01   := CfgXMLString('error_msg01', 'Unable to open file:');
  error_msg02   := CfgXMLString('error_msg02', 'Unable to save file:');
  error_msg03   := CfgXMLString('error_msg03', 'File not Found:');
  error_msg04   := CfgXMLString('error_msg04', 'Error loading file:');
// сообщения
  msgDblFIO     := CfgXMLString('msg_person_already_list', 'The person is already listed!');
  msgNotSymbol  := CfgXMLString('msg_not_symbol', 'Characters /\:*?<>| Banned in the name of the file');
  msgFileExists := CfgXMLString('msg_file_exists', 'File with that name already exists!');
  msgDelPerson  := CfgXMLString('msg_del_person', 'Remove Person?');
  msgDelPhoto   := CfgXMLString('msg_del_foto', 'Remove Photo?');
  msgDelVideo   := CfgXMLString('msg_del_kino', 'Remove Video?');
  msgDelFiles   := CfgXMLString('msg_del_file', 'Remove File?');
  msgSave       := CfgXMLString('msg_save_file', 'Save?');
// задачи
  task_loading := CfgXMLString('task_loading', 'Loading ...');
  task_saveing := CfgXMLString('task_saveing', 'Saving ...');
  task_sorting := CfgXMLString('task_sorting', 'Sorting ...');
  task_growing := CfgXMLString('task_growing', 'Growing ...');
  task_waiting := CfgXMLString('task_waiting', 'Waiting ...');
  task_runing  := CfgXMLString('task_runing', 'Processing ...');
  task_calcing := CfgXMLString('task_calcing', 'Calculation ...');
  task_copying := CfgXMLString('task_copying', 'Copying ...');
  task_working := CfgXMLString('task_working', 'Work ...');
  task_testing := CfgXMLString('task_testing', 'Testing ...');
  task_printing  := CfgXMLString('task_testing', 'Printing ...');
  task_starting  := CfgXMLString('task_starting', 'Starting ...');
  task_cancelled := CfgXMLString('task_cancelled', 'Task is cancelled.');
  task_completed := CfgXMLString('task_completed', 'Task is completed.');
// REGISTRATION
  msgYesRegs := CfgXMLString('msg_yes_regs', 'Sign up!');
  msgNotReg1 := CfgXMLString('msg_not_reg1', 'Limit for unregistered copies');
  msgNotReg2 := CfgXMLString('msg_not_reg2', ' records');
// Интернационализация форм
  // TuneForm
  ButtonOK.Hint     := ButonOK;
  ButtonSave.Hint   := ButonSave;
  ButtonCancel.Hint := ButonCancel;
  GroupGedcom.Caption := pref_gedcom_title;
  ExportBtn.Caption   := pref_gedcom_export;
  ExportBtn.Hint      := hint_gedcom_export;
  ImportBtn.Caption   := pref_gedcom_import;
  ImportBtn.Hint      := hint_gedcom_import;
  LabelGedcom.Caption := pref_gedcom_charset;
  CodeGedcom.Hint     := hint_gedcom_charset;
  GroupZip.Caption := pref_zip_title;
  ZipBtn.Caption   := pref_zip_export;
  ZipBtn.Hint      := hint_zip_export;
  UnZipBtn.Caption := pref_zip_import;
  UnZipBtn.Hint    := hint_zip_import;
  // MainForm
  Family.ListButton.Hint := list_button_hint;
  Family.TreeButton.Hint := tree_button_hint;
  Family.GenrButton.Hint := genr_button_hint;
  Family.FotoButton.Hint := foto_button_hint;
  Family.KinoButton.Hint := kino_button_hint;
  Family.FileButton.Hint := file_button_hint;
  Family.RichButton.Hint := rich_button_hint;
  Family.EditButton.Hint := edit_button_hint;
  Family.DeleButton.Hint := dele_button_hint;
  Family.SortButton.Hint := sort_button_hint;
  Family.FindButton.Hint := find_button_hint;
  Family.PrinButton.Hint := prin_button_hint;
  Family.TuneButton.Hint := tune_button_hint;
  Family.HelpButton.Hint := help_button_hint;
  Family.ExitButton.Hint := exit_button_hint;
  // PersonForm
  PersonForm.ListButton.Hint := save_button_hint;
  PersonForm.TreeButton.Hint := tree_button_hint;
  PersonForm.GenrButton.Hint := rept_button_hint;
  PersonForm.FotoButton.Hint := foto_button_hint;
  PersonForm.KinoButton.Hint := kino_button_hint;
  PersonForm.FileButton.Hint := file_button_hint;
  PersonForm.RichButton.Hint := rich_button_hint;
  PersonForm.TuneButton.Hint := tune_button_hint;
  PersonForm.HelpButton.Hint := help_button_hint;
  PersonForm.ExitButton.Hint := ButonBack;
  PersonForm.LabelBEG.Caption := field_birth;
  PersonForm.LabelPlB.Caption := field_placeb;
  PersonForm.LabelFIO.Caption := field_name;
  PersonForm.LabelMen.Caption := field_gender;
  PersonForm.LabelFat.Caption := field_father;
  PersonForm.LabelMot.Caption := field_mother;
  PersonForm.LabelEND.Caption := field_death;
  PersonForm.LabelPlE.Caption := field_placed;
  PersonForm.LabelMAD.Caption := field_wedding;
  PersonForm.LabelMAP.Caption := field_placew;
  PersonForm.LabelMAF.Caption := field_spouse;
  PersonForm.LabelNAT.Caption := field_nati;
  PersonForm.LabelOCC.Caption := field_occu;
  // PersonNewForm
  PersonNewForm.ListButton.Hint := save_button_hint;
  PersonNewForm.TuneButton.Hint := tune_button_hint;
  PersonNewForm.HelpButton.Hint := help_button_hint;
  PersonNewForm.ExitButton.Hint := ButonBack;
  PersonNewForm.LabelBEG.Caption := field_birth;
  PersonNewForm.LabelPlB.Caption := field_placeb;
  PersonNewForm.LabelFIO.Caption := field_name;
  PersonNewForm.LabelMen.Caption := field_gender;
  PersonNewForm.LabelFat.Caption := field_father;
  PersonNewForm.LabelMot.Caption := field_mother;
  PersonNewForm.LabelEND.Caption := field_death;
  PersonNewForm.LabelPlE.Caption := field_placed;
  PersonNewForm.LabelMAD.Caption := field_wedding;
  PersonNewForm.LabelMAP.Caption := field_placew;
  PersonNewForm.LabelMAF.Caption := field_spouse;
  PersonNewForm.LabelNAT.Caption := field_nati;
  PersonNewForm.LabelOCC.Caption := field_occu;
  // DescForm
  DescForm.Caption := edit_button_hint;
  DescForm.LabelName.Caption := labelName;
  DescForm.LabelNote.Caption := labelNote;
  // SortForm
  SortForm.Caption := ButonSort;
  SortForm.SortItem.Items.Clear;
  SortForm.SortItem.Items.Add(field_birth);
  SortForm.SortItem.Items.Add(field_death);
  SortForm.SortItem.Items.Add(field_name);
  SortForm.SortItem.Items.Add(field_father);
  SortForm.SortItem.Items.Add(field_mother);
  SortForm.SortBtn.Caption := ButonSort;
  SortForm.CancelBtn.Caption := ButonCancel;
  // FindForm
  FindForm.Caption := ButonFind;
  FindForm.LabelName.Caption := field_name;
  FindForm.LabelFather.Caption := field_father;
  FindForm.LabelMother.Caption := field_mother;
  FindForm.FindBtn.Caption := ButonFind;
  FindForm.CancelBtn.Caption := ButonCancel;
  // FotoForm
  FotoForm.PictButton.Hint := newe_button_hint;
  FotoForm.EditButton.Hint := edit_button_hint;
  FotoForm.DeleButton.Hint := dele_button_hint;
  FotoForm.SaveButton.Hint := save_button_hint;
  FotoForm.TuneButton.Hint := tune_button_hint;
  FotoForm.HelpButton.Hint := help_button_hint;
  FotoForm.ExitButton.Hint := back_button_hint;
  FotoForm.Pict1.Caption := ButonNew;
  FotoForm.Edit1.Caption := edit_button_hint;
  FotoForm.Dele1.Caption := dele_button_hint;
  FotoForm.Save1.Caption := save_button_hint;
  FotoForm.Exit1.Caption := ButonBack;
  // KinoForm
  KinoForm.PictButton.Hint := newe_button_hint;
  KinoForm.EditButton.Hint := edit_button_hint;
  KinoForm.DeleButton.Hint := dele_button_hint;
  KinoForm.SaveButton.Hint := save_button_hint;
  KinoForm.TuneButton.Hint := tune_button_hint;
  KinoForm.HelpButton.Hint := help_button_hint;
  KinoForm.ExitButton.Hint := back_button_hint;
  KinoForm.Pict1.Caption := ButonNew;
  KinoForm.Edit1.Caption := edit_button_hint;
  KinoForm.Dele1.Caption := dele_button_hint;
  KinoForm.Save1.Caption := save_button_hint;
  KinoForm.Exit1.Caption := ButonBack;
  // FileForm
  FileForm.PictButton.Hint := newe_button_hint;
  FileForm.EditButton.Hint := edit_button_hint;
  FileForm.DeleButton.Hint := dele_button_hint;
  FileForm.SaveButton.Hint := save_button_hint;
  FileForm.TuneButton.Hint := tune_button_hint;
  FileForm.HelpButton.Hint := help_button_hint;
  FileForm.ExitButton.Hint := back_button_hint;
  FileForm.Pict1.Caption := ButonNew;
  FileForm.Edit1.Caption := edit_button_hint;
  FileForm.Dele1.Caption := dele_button_hint;
  FileForm.Save1.Caption := save_button_hint;
  FileForm.Exit1.Caption := ButonBack;
  // TreeBmp
  TreeBmpForm.SizeButton.Hint := size_button_hint;
  TreeBmpForm.PlusButton.Hint := plus_button_hint;
  TreeBmpForm.MinuButton.Hint := minu_button_hint;
  TreeBmpForm.SaveButton.Hint := save_button_hint;
  TreeBmpForm.PrinButton.Hint := prin_button_hint;
  TreeBmpForm.TuneButton.Hint := tune_button_hint;
  TreeBmpForm.HelpButton.Hint := help_button_hint;
  TreeBmpForm.BackButton.Hint := back_button_hint;
  // TreeHtm
  TreeHtmForm.SaveButton.Hint := save_button_hint;
  TreeHtmForm.PrinButton.Hint := prin_button_hint;
  TreeHtmForm.TuneButton.Hint := tune_button_hint;
  TreeHtmForm.HelpButton.Hint := help_button_hint;
  TreeHtmForm.BackButton.Hint := back_button_hint;
  // GenrHtm
  GenrForm.SaveButton.Hint := save_button_hint;
  GenrForm.PrintButton.Hint := prin_button_hint;
  GenrForm.TuneButton.Hint := tune_button_hint;
  GenrForm.HelpButton.Hint := help_button_hint;
  GenrForm.BackButton.Hint := back_button_hint;
  // DescForm
  DescForm.ButtonOK.Hint     := save_button_hint;
  DescForm.ButtonCancel.Hint := back_button_hint;
  // ViewPhotoForm
  ViewPhotoForm.SizeButton.Hint := size_button_hint;
  ViewPhotoForm.PlusButton.Hint := plus_button_hint;
  ViewPhotoForm.MinusButton.Hint := minu_button_hint;
  ViewPhotoForm.SaveButton.Hint := save_button_hint;
  ViewPhotoForm.PrintButton.Hint := prin_button_hint;
  ViewPhotoForm.TuneButton.Hint := tune_button_hint;
  ViewPhotoForm.HelpButton.Hint := help_button_hint;
  ViewPhotoForm.BackButton.Hint := back_button_hint;
  // TestForm
  TestForm.BackButton.Hint := back_button_hint;
  // RichForm
  RichForm.SaveButton.Hint := save_button_hint;
  RichForm.PrintButton.Hint := prin_button_hint;
  RichForm.TuneButton.Hint := tune_button_hint;
  RichForm.HelpButton.Hint := help_button_hint;
  RichForm.BackButton.Hint := back_button_hint;
end;

procedure TTuneForm.LoadPathData;
var
  p : Integer;
  s : String;
  FIniFile : TRegIniFile; //переменная для обращения к реестру
begin
  {$IFDEF WINDOWS}
  // загружаю конфигурацию из реестра
  FIniFile := TRegIniFile.Create('FamilyTree');
  FIniFile.OpenKey('Software', True);
  s := FIniFile.ReadString('PATH', 'DATA', MainPathDAT);
  if DirectoryExists(s) then
    MainPathDAT := s;
  {$ENDIF}
  {$IFDEF UNIX}
  // загружаю конфигурацию из файла .INI
  ConfigFile := TIniFile.Create(MainPathEXE + MainFileINI);
  s := ConfigFile.ReadString('PATH','DATA',MainPathDAT);
  if DirectoryExists(s) then
    MainPathDAT := s;
  ConfigFile.Free;
  {$ENDIF}
end;

procedure TTuneForm.SavePathData;
var
  FIniFile : TRegIniFile; //переменная для обращения к реестру
begin
  {$IFDEF WINDOWS}
  FIniFile := TRegIniFile.Create('FamilyTree');
  FIniFile.OpenKey('Software',true);
  FIniFile.WriteString('PATH', 'DATA', MainPathDAT);  //В раздел реестра HKCU/Software/..
  {$ENDIF}
  {$IFDEF UNIX}
  // сохраняю конфигурацию в файле .INI
  ConfigFile := TIniFile.Create(MainPathEXE + MainFileINI);
  ConfigFile.WriteString('PATH','DATA',MainPathDAT);
  ConfigFile.Free;
  {$ENDIF}
end;

procedure TTuneForm.ExportGedcom(GedFile : String);
var
  FileGED : TextFile;
  gedcoms : TStringList;
  b : Boolean;
  s, ss : String;
  i, n, p : Integer;
  id : Integer;//индивидуальный номер
  idf : Integer;//отец
  idm : Integer;//мать
  ids : Integer;//супруг
  pFam : ^TFamilys;//указатель
  nFam : ^TFamilys;//указатель
  pChi, pChi1 : ^TChilds;//указатель
  Fams : TList; //список семей
  Sex : Integer;
begin
  Family.Cursor := crHourGlass;
  //показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := 6 * listMans.Count;
  GaugePos := 0;
  // открываю
  gedcoms := TStringList.Create;
  // заголовок
  gedcoms.Add('0 HEAD');
  gedcoms.Add('1 SOUR FamilyTree');
  gedcoms.Add('2 VERS 1.0.0');
  gedcoms.Add('1 DEST FamilyTree');
  gedcoms.Add('1 DATE DD MMM YYYY');
  if TuneForm.CodeGedcom.ItemIndex = 1 then
    gedcoms.Add('1 CHAR UTF8')
  else
    gedcoms.Add('1 CHAR ANSI');
  gedcoms.Add('1 GEDC');
  gedcoms.Add('2 VERS 5.5');
  //создаю списки семей
  Fams := TList.Create;
  //заполн€ю элементы списка
  for id := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    if Trim(listMans.Strings[id]) <> '' then begin
      b := False;
      idf := iRetrFather(listFather.Strings[id]);
      idm := iRetrMother(listMother.Strings[id]);
      if ((idf <> -1) or (idm <> -1)) then begin
        for i := 0 to Fams.Count-1 do begin
          pFam := Fams[i];
          if ((pFam^.Father = idf) and (pFam^.Mother = idm)) then begin
            b := True;
            break;
          end;
        end;
        if not b then begin//если такой семьи в списке нет
          New(pFam);
          pFam^.id := listMans.Count+Fams.Count;
          pFam^.Father := idf;
          pFam^.Mother := idm;
          pFam^.Husband:= -1;
          pFam^.Wife   := -1;
          pFam^.Child  := Nil;
          Fams.Add(pFam);
        end;
      end;
    end;
  end;
//дозаполн€ю элементы списка супругами
  for id := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    if Trim(listSpouse.Strings[id]) <> '' then begin
      aSpouse := TStringList.Create;
      ss := listSpouse.Strings[id];
      repeat
        n := Pos(rzd2, ss);
        if n > 0 then begin
          s := Copy(ss,1,n-1);
          ss := Copy(ss,n+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then aSpouse.Add(s);
      until n=0;
      Sex := SexPerson(id);
      if (Sex = 0) then begin// мужчины
        for n := 0 to aSpouse.Count-1 do begin
          b := False;
          p := Pos(rzd3, aSpouse.Strings[n]);
          if (p > 0) then begin
            ss := Copy(aSpouse.Strings[n],1,p-1);
          end else begin
            ss := aSpouse.Strings[n];
          end;
          ids := iRetrMother(ss);
          if (ids > -1) then begin
            for i := 0 to Fams.Count-1 do begin
              pFam := Fams[i];
              if ((pFam^.Husband = id) and (pFam^.Wife = ids)) then begin
                b := True;
                break;
              end;
            end;
            if (not b) then begin//если такой семьи в списке нет
              New(pFam);
              pFam^.id := listMans.Count+Fams.Count;
              pFam^.Father := -1;
              pFam^.Mother := -1;
              pFam^.Husband:= id;
              pFam^.Wife   := ids;
              pFam^.Child := Nil;
              Fams.Add(pFam);
            end;
          end;
        end;
      end else
      if (Sex = 1) then begin// женщины
        for n := 0 to aSpouse.Count-1 do begin
          b := false;
          p := Pos(rzd3, aSpouse.Strings[n]);
          if (p > 0) then begin
            ss := Copy(aSpouse.Strings[n],1,p-1);
          end else begin
            ss := aSpouse.Strings[n];
          end;
          ids := iRetrFather(ss);
          if (ids > -1) then begin
            for i := 0 to Fams.Count-1 do begin
              pFam := Fams[i];
              if ((pFam^.Husband = ids) and (pFam^.Wife = id)) then begin
                b := True;
                break;
              end;
            end;
            if (not b) then begin//если такой семьи в списке нет
              New(pFam);
              pFam^.id := listMans.Count+Fams.Count;
              pFam^.Father := -1;
              pFam^.Mother := -1;
              pFam^.Husband:= ids;
              pFam^.Wife   := id;
              pFam^.Child := Nil;
              Fams.Add(pFam);
            end;
          end;
        end;
      end;
      aSpouse.Free;//чищу перед
    end;
  end;
  // секци€ INDI
  for id := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    gedcoms.Add('0 @' + Trim(IntToStr(id)) + '@ INDI');
    gedcoms.Add('1 NAME '+LastName(listMans.Strings[id])+' /'+FirstName(listMans.Strings[id])+'/');
    if listGender.Strings[ id] = Man then
      gedcoms.Add('1 SEX M');
    if listGender.Strings[ id] = Woman then
      gedcoms.Add('1 SEX F');
    if not Empty(listNati.Strings[id]) then
      gedcoms.Add('1 NATI '+listNati.Strings[ id]);
    if not Empty(listOccu.Strings[ id]) then
      gedcoms.Add('1 OCCU '+listOccu.Strings[ id]);
    if not Empty(listBirth.Strings[ id]) then begin
      gedcoms.Add('1 BIRT');
      gedcoms.Add('2 DATE ' + MultiFormatDatTim(listBirth.Strings[id]));
      if not Empty(listPlaceb.Strings[id]) then
        gedcoms.Add('2 PLAC '+listPlaceb.Strings[id]);
    end;
    if not Empty(listDeath.Strings[ id]) then begin
      gedcoms.Add('1 DEAT ');
      gedcoms.Add('2 DATE ' + MultiFormatDatTim(listDeath.Strings[id]));
      if not Empty(listPlaced.Strings[id]) then
        gedcoms.Add('2 PLAC '+listPlaced.Strings[id]);
    end;
    idf := iRetrFather(listFather.Strings[id]);
    idm := iRetrMother(listMother.Strings[id]);
    for i := 0 to Fams.Count-1 do begin
      pFam := Fams[i];
      if ((pFam^.Father <> -1) or (pFam^.Mother <> -1)) then
      if ((pFam^.Father = idf) and (pFam^.Mother = idm)) then begin
        gedcoms.Add('1 FAMC @'+IntToStr(pFam^.id)+'@');
        if pFam^.Child = Nil then begin
          New(pChi);
          pFam^.Child := pChi;
          pChi^.id := id;
          pChi^.Child := Nil;
        end else begin
          pChi1 := pFam^.Child;
          while pChi1^.Child <> Nil do begin
            pChi1 := pChi1^.Child;
          end;
          New(pChi);
          pChi1^.Child := pChi;
          pChi^.id := id;
          pChi^.Child := Nil;
        end;
        break;
      end;
    end;
    for i := 0 to Fams.Count-1 do begin
      pFam := Fams[i];
      if ((pFam^.Father = id) or (pFam^.Mother = id)) then begin
        gedcoms.Add('1 FAMS @' + IntToStr(pFam^.id) + '@');
        {??
        for n := i to Fams.Count-1 do begin// удал€ю из списка семей пару
          nFam := Fams[n];
          if ((nFam^.Father = -1) and (nFam^.Mother = -1)) then begin
            if ((pFam^.Father = nFam^.Husband) and (pFam^.Mother = nFam^.Wife)) then begin
              nFam^.Husband := -1;
              nFam^.Wife    := -1;
            end;
          end;
        end;
        }
      end else
      if ((pFam^.Husband <> -1) and (pFam^.Wife <> -1)) then begin// супруги
        if (Sex = 0) then begin
          if (pFam^.Husband = id) then begin// если муж
            gedcoms.Add('1 FAMS @F' + IntToStr(pFam^.id) + '@');
          end;
        end else
        if (Sex = 1) then begin
          if (pFam^.Wife = id) then begin// если жена
            gedcoms.Add('1 FAMS @F' + IntToStr(pFam^.id) + '@');
          end;
        end;
      end;
    end;
    s := MainPathTXT+Trim(listMans.Strings[id])+'.txt';
    if FileExists(s) then begin
      gedcoms.Add('1 NOTE @'+IntToStr(2*listMans.Count+id)+'@');
    end;
  end;
  // секци€ FAM
  for id := 0 to Fams.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pFam := Fams[id];
    gedcoms.Add('0 @'+IntToStr(pFam^.id)+'@ FAM');
    // отец мать
    if pFam^.Father > -1 then gedcoms.Add('1 HUSB @'+IntToStr(pFam^.Father)+'@');
    if pFam^.Mother > -1 then gedcoms.Add('1 WIFE @'+IntToStr(pFam^.Mother)+'@');
    // муж жена
    if ((pFam^.Wife > -1) and (pFam^.Husband > -1)) then begin
      gedcoms.Add('1 WIFE @I' + IntToStr(pFam^.Wife) + '@');
      gedcoms.Add('1 HUSB @I' + IntToStr(pFam^.Husband) + '@');
    end;
    if pFam^.Child <> Nil then begin
      pChi := pFam^.Child;
      gedcoms.Add('1 CHIL @'+IntToStr(pChi^.id)+'@');
      while pChi^.Child <> Nil do begin
        pChi := pChi^.Child;
        gedcoms.Add('1 CHIL @'+IntToStr(pChi^.id)+'@');
      end;
    end;
    // дата и место свадьбы
    b := false;
    if ((pFam^.Wife > -1) and (pFam^.Husband > -1)) then begin
      // провер€ю мужей если нет детей
      if (pFam^.Husband > -1) then
      if (Trim(listSpouse.Strings[pFam^.Husband]) <> '') then begin
        aSpouse := TStringList.Create;
        ss := listSpouse.Strings[pFam^.Husband];
        repeat
          n := Pos(rzd2, ss);
          if n > 0 then begin
            s := Copy(ss,1,n-1);
            ss := Copy(ss,n+1,Length(ss));
          end else
            s := ss;
          if not Empty(s) then aSpouse.Add(s);
        until n=0;
        for i := 0 to aSpouse.Count-1 do begin
          //wedding share
          aWeddin := TStringList.Create;
          ss := aSpouse.Strings[i];
          repeat
            n := Pos(rzd3, ss);
            if n > 0 then begin
              s := Copy(ss,1,n-1);
              ss := Copy(ss,n+1,Length(ss));
            end else
              s := ss;
            if not Empty(s) then aWeddin.Add(s);
          until n=0;
          if (aWeddin.Count > 0) then begin// если есть дата и место свадьбы
            if (aWeddin.Count > 0) then begin
              sSpouse := aWeddin.Strings[0];
            end else begin
              sSpouse := aSpouse.Strings[i];
            end;
            if (aWeddin.Count > 1)then begin
              sWeddin := aWeddin.Strings[1];
            end else begin
              sWeddin := '';
            end;
            if (aWeddin.Count > 2) then begin
              sPlacew := aWeddin.Strings[2];
            end else begin
              sPlacew := '';
            end;
            if (sSpouse = listMans.Strings[pFam^.Wife]) then begin
              b := true;
              break;
            end;
          end;
          aWeddin.Free;//чищу перед
        end;
        aSpouse.Free;//чищу перед
      end;
      // если ничего не нашел, провер€ю жен
      if (not b) then
      if (pFam^.Wife > -1) then begin
        if (Trim(listSpouse.Strings[pFam^.Wife]) <> '') then begin
          aSpouse := TStringList.Create;
          ss := listSpouse.Strings[pFam^.Wife];
          repeat
            n := Pos(rzd2, ss);
            if n > 0 then begin
              s := Copy(ss,1,n-1);
              ss := Copy(ss,n+1,Length(ss));
            end else
              s := ss;
            if not Empty(s) then aSpouse.Add(s);
          until n=0;
          for i := 0 to aSpouse.Count-1 do begin
            //wedding share
            aWeddin := TStringList.Create;
            ss := aSpouse.Strings[i];
            repeat
              n := Pos(rzd3, ss);
              if n > 0 then begin
                s := Copy(ss,1,n-1);
                ss := Copy(ss,n+1,Length(ss));
              end else
                s := ss;
              if not Empty(s) then aWeddin.Add(s);
            until n=0;
            if (aWeddin.Count > 0) then begin// если есть дата и место свадьбы
              if (aWeddin.Count > 0) then begin
                sSpouse := aWeddin.Strings[0];
              end else begin
                sSpouse := aSpouse.Strings[i];
              end;
              if (aWeddin.Count > 1)then begin
                sWeddin := aWeddin.Strings[1];
              end else begin
                sWeddin := '';
              end;
              if (aWeddin.Count > 2) then begin
                sPlacew := aWeddin.Strings[2];
              end else begin
                sPlacew := '';
              end;
              if (sSpouse = listMans.Strings[pFam^.Husband]) then begin
                b := true;
                break;
              end;
            end;
            aWeddin.Free;//чищу перед
          end;
          aSpouse.Free;//чищу перед
        end;
      end;
    end else begin
      // провер€ю отцов если есть дети
      b := false;
      if (pFam^.Father > -1) then
      if (Trim(listSpouse.Strings[pFam^.Father]) <> '') then begin
        aSpouse := TStringList.Create;
        ss := listSpouse.Strings[pFam^.Father];
        repeat
          n := Pos(rzd2, ss);
          if n > 0 then begin
            s := Copy(ss,1,n-1);
            ss := Copy(ss,n+1,Length(ss));
          end else
            s := ss;
          if not Empty(s) then aSpouse.Add(s);
        until n=0;
        for i := 0 to aSpouse.Count-1 do begin
          //wedding share
          aWeddin := TStringList.Create;
          ss := aSpouse.Strings[i];
          repeat
            n := Pos(rzd3, ss);
            if n > 0 then begin
              s := Copy(ss,1,n-1);
              ss := Copy(ss,n+1,Length(ss));
            end else
              s := ss;
            if not Empty(s) then aWeddin.Add(s);
          until n=0;
          if (aWeddin.Count > 0) then begin// если есть дата и место свадьбы
            if (aWeddin.Count > 0) then begin
              sSpouse := aWeddin.Strings[0];
            end else begin
              sSpouse := aSpouse.Strings[i];
            end;
            if (aWeddin.Count > 1)then begin
              sWeddin := aWeddin.Strings[1];
            end else begin
              sWeddin := '';
            end;
            if (aWeddin.Count > 2) then begin
              sPlacew := aWeddin.Strings[2];
            end else begin
              sPlacew := '';
            end;
            if (pFam^.Mother > -1) then
            if (sSpouse = listMans.Strings[pFam^.Mother]) then begin
              b := true;
              break;
            end;
          end;
          aWeddin.Free;//чищу перед
        end;
        aSpouse.Free;//чищу перед
      end;
      // если ничего не нашел, провер€ю матерей
      if (not b) then begin
        if (pFam^.Mother > -1) then
        if (Trim(listSpouse.Strings[pFam^.Mother]) <> '') then begin
          aSpouse := TStringList.Create;
          ss := listSpouse.Strings[pFam^.Mother];
          repeat
            n := Pos(rzd2, ss);
            if n > 0 then begin
              s := Copy(ss,1,n-1);
              ss := Copy(ss,n+1,Length(ss));
            end else
              s := ss;
            if not Empty(s) then aSpouse.Add(s);
          until n=0;
          for i := 0 to aSpouse.Count-1 do begin
            //wedding share
            aWeddin := TStringList.Create;
            ss := aSpouse.Strings[i];
            repeat
              n := Pos(rzd3, ss);
              if n > 0 then begin
                s := Copy(ss,1,n-1);
                ss := Copy(ss,n+1,Length(ss));
              end else
                s := ss;
              if not Empty(s) then aWeddin.Add(s);
            until n=0;
            if (aWeddin.Count > 0) then begin// если есть дата и место свадьбы
              if (aWeddin.Count > 0) then begin
                sSpouse := aWeddin.Strings[0];
              end else begin
                sSpouse := aSpouse.Strings[i];
              end;
              if (aWeddin.Count > 1)then begin
                sWeddin := aWeddin.Strings[1];
              end else begin
                sWeddin := '';
              end;
              if (aWeddin.Count > 2) then begin
                sPlacew := aWeddin.Strings[2];
              end else begin
                sPlacew := '';
              end;
              if (pFam^.Father > -1) then
              if (sSpouse = listMans.Strings[pFam^.Father]) then begin
                b := true;
                break;
              end;
            end;
            aWeddin.Free;//чищу перед
          end;
          aSpouse.Free;//чищу перед
        end;
      end;
    end;
    if (b) then begin
      if (sWeddin <> '') or (sPlacew <> '') then gedcoms.Add('1 MARR');
      if (sWeddin <> '') then gedcoms.Add('2 DATE ' + sWeddin);
      if (sPlacew <> '') then gedcoms.Add('2 PLAC ' + sPlacew);
    end;
  end;
  // секци€ NOTE
  for id := 0 to listMans.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    s := MainPathTXT+Trim(listMans.Strings[id])+'.txt';
    if FileExists(s) then begin
      gedcoms.Add('0 @'+IntToStr(2*listMans.Count+id)+'@ NOTE');
      LngMemo1.Lines.LoadFromFile(UTF8toANSI(s));
      for i := 0 to LngMemo1.Lines.Count-1 do
        gedcoms.Add('1 CONT '+ LngMemo1.Lines.Strings[i]);
    end;
  end;
  // конец
  gedcoms.Add('0 TRLR');
  //уничтожаю элементы списка
  for id := 0 to Fams.Count-1 do begin
    ProcessForm.Gauge1.Position := GaugePos;
    Inc(GaugePos);
    Application.ProcessMessages;
    pFam := Fams[id];
    if pFam^.Child <> Nil then begin
      pChi := pFam^.Child;
      while pChi^.Child <> Nil do begin
        pChi := pChi^.Child;
        //Dispose(pChi);                //здесь ошибка не вс€ пам€ть освобождаетс€
      end;
      Dispose(pChi);
    end;
    Dispose(pFam);
  end;
  Fams.Free;//уничтожаю список
  // сохран€ю
  if TuneForm.CodeGedcom.ItemIndex = 1 then begin
    gedcoms.Text := UTF8toANSI(gedcoms.Text);
    gedcoms.SaveToFile(UTF8toANSI(GedFile))
  end else
    gedcoms.SaveToFile(UTF8toANSI(GedFile));
  gedcoms.Free;
  //
  ProcessForm.Hide;
  Family.Cursor := crDefault;
end;

procedure  TTuneForm.ImportGedcom(GedFile : String);
var
  FileGED : TextFile;
  pro : Int64;
  cntMans : Integer;
  head, indi, note, fam : Boolean;
  birt, chan, dead, marr : Boolean;
  b : Boolean;
  buf, s, ss, sss, ss1, ss2, person : String;
  id, i, ii : Integer;
  father, mother, childr : Integer;
  ifather, imother, ichildr : Integer;
  pFam : ^TIndi;//указатель
  Fams : TList; //список семей
  cur : Integer; //текуща€ строка
  fd : ShortString;//формат даты
  dmy : array[1..4] of ShortString;
  fn, notes : String;
  wife, husband : String;

  procedure InsertSpouse();
  var
    i : Integer;
    nFam : ^TIndi;//указатель
    function SeekIndiIndi(ind : Integer): Integer;
    var
      j : Integer;
    begin
      Result := -1;
      if ind = -1 then exit;
      for j := 0 to Fams.Count-1 do begin
        nFam := Fams.Items[j];
        if nFam^.indi = ind then begin
          Result := j;
          break;
        end;
      end;
    end;
  begin
    i := SeekIndiIndi(father);//индекс в gedcom
    if (i <> -1) then begin
      nFam := Fams.Items[i];//указатель
      ifather := nFam^.id;//реальный индекс
    end else begin
      ifather := -1;
    end;
    i := SeekIndiIndi(mother);//индекс в gedcom
    if (i <> -1) then begin
      nFam := Fams.Items[i];//указатель
      imother := nFam^.id;//реальный индекс
    end else begin
      imother := -1;
    end;
    if ((ifather <> imother)) then
    if ((ifather <> -1) and (imother <> -1)) then begin
      if ((sWeddin <> '') or (sPlacew <> '')) then begin
        ss := rzd3 + sWeddin + rzd3 + sPlacew;
      end else begin
        ss := '';
      end;
      // вставл€ю жену мужчине
      wife := Trim(listSpouse.Strings[ifather]);
      if (wife <> '') then begin
        if (Pos(listMans.Strings[imother], wife) = 0) then begin
          listSpouse.Strings[ifather] := wife + rzd2 + listMans.Strings[imother] + ss;
        end;
      end else begin
        listSpouse.Strings[ifather] := listMans.Strings[imother] + ss;
      end;
      // вставл€ю мужа женщине
      husband := Trim(listSpouse.Strings[imother]);
      if (husband <> '') then begin
        if (Pos(listMans.Strings[ifather],husband) = 0) then begin
          listSpouse.Strings[imother] := husband + rzd2 + listMans.Strings[ifather] + ss;
        end;
      end else begin
        listSpouse.Strings[imother] := listMans.Strings[ifather] + ss;
      end;
    end;
    sWeddin := '';
    sPlacew := '';
    marr := False;
  end;

begin
  Family.Cursor := crHourGlass;
  ReDraws := True;
  // настройки
  ClearVars();//чищу грид
  // open file gedcom
  AssignFile(FileGED, GedFile);
  {$I-}
  Reset(FileGED);
  {$I+}
//показываю процесс
  ProcessForm.Caption := task_runing;
  ProcessForm.Show;
  ProcessForm.Gauge1.Max := FileUtil.FileSize(GedFile) div 100;
  //создаю списки семей
  Fams := TList.Create;
  // заполн€ю элементы списка
  fn := '';
  cur := -1;
  cntMans := 0;
  pro := 0;
  while not eof(FileGED) do begin
    Readln(FileGED, buf);
    pro := pro + Length(buf);
    ProcessForm.Gauge1.Position := pro div 100;
    Application.ProcessMessages;
    if TuneForm.CodeGedcom.ItemIndex = 1 then
      buf := UTF8toANSI(Trim(buf))
    else
      buf := Trim(buf);
    s := UpperCase(buf);
    if s[1] = '0' then begin
      head := Pos('HEAD', s) <> 0;
      indi := Pos('INDI', s) <> 0;
      if indi then begin
        New(pFam);
        Inc(cur);
        pFam^.id := cur;//индекс по пор€дку
        pFam^.indi := StrToInt( strNumBetween( Copy( s, 2, 255)));//индекс по gedcom
        pFam^.famc := -1;
        pFam^.fams := -1;
        pFam^.note := -1;
        Fams.Add(pFam);
        listBirth.Add('');
        listDeath.Add('');
        listMans.Add('');
        listGender.Add('');
        listFather.Add('');
        listMother.Add('');
        listPlaceb.Add('');
        listPlaced.Add('');
        listSpouse.Add('');
        listNati.Add('');
        listOccu.Add('');
        sWeddin := '';
        sPlacew := '';
        cntMans := cntMans + 1;
      end;
      fam  := Pos('FAM', s) <> 0;
      if fam then begin
        InsertSpouse();//добавл€ю супругов если есть
        father := -1;
        mother := -1;
      end;
      note := Pos('NOTE', s) <> 0;
      if note then begin
        if (not Empty(fn)) then begin
          ss := MainPathTXT + fn + '.txt';
          LngMemo1.Lines.Text := notes;
          LngMemo1.Lines.SaveToFile(UTF8toANSI(ss));
        end;
        try
          ii := StrToInt( StrNumChar( Copy( s, 2, 255)));
        except
          ii := -1;
        end;
        b := False;
        for id := 0 to Fams.Count-1 do begin//ищу в Grid'e
          pFam := Fams[id];
          if pFam^.note = ii then begin
            b := True;
            break;
          end;
        end;
        if b then begin
          fn := listMans.Strings[pFam^.id];
          notes := '';
        end;
      end;
    end else if s[1] = '1' then begin
      if head then begin
        if Pos('DATE', s) <> 0 then begin
          i := Pos('DATE', s);
          fd := Copy(buf,i+5,255);
        end;
      end else if indi then begin
        if Pos('NAME', s) <> 0 then begin
          i := Pos('NAME', s);
          listMans.Strings[cur] := Copy(buf,i+5,255);
          i := Pos('/',listMans.Strings[cur]);
          if i <> 0 then begin
            ss := Copy( listMans.Strings[cur],i+1,255);
            ss := StrDeleteAll( ss,'/');
            if Empty(ss) then
             person := Trim( Copy( listMans.Strings[cur],1,i-1))
            else
              person := ss +' '+ Trim( Copy( listMans.Strings[cur],1,i-1));
          end;
          person := StrDelChars(person);//убираю ненужные символы
         //если есть персона с таким ‘»ќ, добавл€ю цифру в конец ‘»ќ
          ii := 0;
          ss := person;
          while isPerson(ss) do begin
           Inc(ii);
            ss := person +' '+ IntToStr(ii);
          end;
          person := ss;
          listMans.Strings[cur] := person;
          birt := False;
         chan := False;
          dead := False;
        end else if Pos('SEX', s) <> 0 then begin
          i := Pos('SEX', s);
          ss := Trim( Copy(s, i+3, 255));
          if ss[1] = 'M' then listGender.Strings[cur] := Man;
          if ss[1] = 'F' then listGender.Strings[cur] := Woman;
        end else if Pos('NATI', s) <> 0 then begin
          i := Pos('NATI', s);
          ss := Trim( Copy(s, i+5, 255));
          listNati.Strings[cur] := ss;
        end else if Pos('OCCU', s) <> 0 then begin
          i := Pos('OCCU', s);
          ss := Trim( Copy(s, i+5, 255));
          listOccu.Strings[cur] := ss;
        end else if Pos('BIRT', s) <> 0 then begin
          birt := True;
         chan := False;
          dead := False;
        end else if Pos('CHAN', s) <> 0 then begin
          birt := False;
         chan := True;
          dead := False;
        end else if Pos('DEAT', s) <> 0 then begin
          birt := False;
         chan := False;
          dead := True;
        end else if Pos('FAMC', s) <> 0 then begin
          i := Pos('FAMC', s);
          pFam^.famc := StrToInt( StrNumChar( Copy(s, i+5, 255)));
        end else if Pos('FAMS', s) <> 0 then begin
          i := Pos('FAMS', s);
          pFam^.fams := StrToInt( StrNumChar( Copy(s, i+5, 255)));
        end else if Pos('NOTE', s) <> 0 then begin
          i := Pos('NOTE', s);
          if pos('@',Copy(s, i+5, 255)) > 0 then
            pFam^.note := StrToInt( StrNumChar( Copy(s, i+5, 255)))
          else  // ???
            notes := notes + Copy(buf, i+5, 32000) +chr(13)+chr(10);
        end;
      end else
      if fam then begin
        if Pos('HUSB', s) <> 0 then begin
          i := Pos('HUSB', s);
          father := StrToInt( StrNumChar( Copy(s, i+5, 255)));//indi
        end else if Pos('WIFE', s) <> 0 then begin
          i := Pos('WIFE', s);
          mother := StrToInt( StrNumChar( Copy(s, i+5, 255)));//indi
        end else if Pos('CHIL', s) <> 0 then begin
          i := Pos('CHIL', s);
          childr := StrToInt( StrNumChar( Copy(s, i+5, 255)));//indi
          b := False;
          for id := 0 to Fams.Count-1 do begin//ищу ребенка в Grid'e
            pFam := Fams[id];
            if pFam^.indi = childr then begin
              b := True;
              break;
            end;
          end;
          if b then begin
            childr := pFam^.id;
            if father <> -1 then begin
              b := False;
              for id := 0 to Fams.Count-1 do begin//ищу отца в Grid'e
                pFam := Fams[id];
                if pFam^.indi = father then begin
                  b := True;
                  break;
                end;
              end;
              if b then listFather.Strings[ childr] := listMans.Strings[ pFam^.id];
            end;
            if mother <> -1 then begin
              b := False;
              for id := 0 to Fams.Count-1 do begin//ищу мать в Grid'e
                pFam := Fams[id];
                if pFam^.indi = mother then begin
                  b := True;
                  break;
                end;
              end;
              if b then listMother.Strings[ childr] := listMans.Strings[ pFam^.id];
            end;
          end;
        end else if Pos('MARR', s) <> 0 then begin
          marr := True;
        end;
      end else if note then begin
        if Pos('CONT', s) <> 0 then begin
          i := Pos('CONT', s);
          notes := notes + Copy(buf, i+5, 32000) +chr(13)+chr(10);
        end;
      end;
    end else if s[1] = '2' then begin
      if indi then
      if birt then begin
        if Pos('DATE', s) <> 0 then begin
          i := Pos('DATE', s);
          ss := Trim( Copy(s,i+5,255));
          ss := StrDeleteStr(ss,'CIR');//удал€ю CIR
          ss := StrDeleteStr(ss,'ABT');//удал€ю ABT
          if Pos('BEF',ss) > 0 then begin
            i := Pos('BEF',ss);
            sss := Trim(Copy(ss, i+3, Length(ss)));
            listBirth.Strings[cur] := pref_gedcom_before+' '+DateFromStr(sss);
          end else
          if Pos('AFT',ss) > 0 then begin
            i := Pos('AFT',ss);
            sss := Trim(Copy(ss, i+3, Length(ss)));
            listBirth.Strings[cur] := pref_gedcom_after+' '+DateFromStr(sss);
          end else
          if Pos('BET',ss) > 0 then begin
            i := Pos('BET',ss);
            sss := Copy(ss, i+3, Length(ss));
            if Pos('AND',sss) > 0 then begin
              i := Pos('AND',sss);
              ss1 := Trim(Copy(sss, 1, i-1));
              ss2 := Trim(Copy(sss, i+3, Length(sss)));
              listBirth.Strings[cur] := pref_gedcom_between+' '+DateFromStr(ss1)+' '+pref_gedcom_and+' '+DateFromStr(ss2);
            end else begin
              listBirth.Strings[cur] := pref_gedcom_between+' '+DateFromStr(sss);
            end;
          end else begin
            listBirth.Strings[cur] := DateFromStr(ss);
          end;
        end else
        if Pos('PLAC', s) <> 0 then begin
          i := Pos('PLAC', s);
          listPlaceb.Strings[cur] := Copy(buf,i+5,255);
          birt := False;
        end;
      end else
      if dead then begin
        if Pos('DATE', s) <> 0 then begin
          i := Pos('DATE', s);
          ss := Trim( Copy(s,i+5,255));
          ss := StrDeleteStr(ss,'CIR');//удал€ю CIR
          ss := StrDeleteStr(ss,'ABT');//удал€ю ABT
          if Pos('BEF',ss) > 0 then begin
            i := Pos('BEF',ss);
            sss := Trim(Copy(ss, i+3, Length(ss)));
            listDeath.Strings[cur] := pref_gedcom_before+' '+DateFromStr(sss);
          end else
          if Pos('AFT',ss) > 0 then begin
            i := Pos('AFT',ss);
            sss := Trim(Copy(ss, i+3, Length(ss)));
            listDeath.Strings[cur] := pref_gedcom_after+' '+DateFromStr(sss);
          end else
          if Pos('BET',ss) > 0 then begin
            i := Pos('BET',ss);
            sss := Copy(ss, i+3, Length(ss));
            if Pos('AND',sss) > 0 then begin
              i := Pos('AND',sss);
              ss1 := Trim(Copy(sss, 1, i-1));
              ss2 := Trim(Copy(sss, i+3, Length(sss)));
              listDeath.Strings[cur] := pref_gedcom_between+' '+DateFromStr(ss1)+' '+pref_gedcom_and+' '+DateFromStr(ss2);
            end else begin
              listDeath.Strings[cur] := pref_gedcom_between+' '+DateFromStr(sss);
            end;
          end else begin
            listDeath.Strings[cur] := DateFromStr(ss);
          end;
        end else if Pos('PLAC', s) <> 0 then begin
          i := Pos('PLAC', s);
          listPlaced.Strings[cur] := Copy(buf,i+5,255);
          dead := False;
        end;
      end;
      if fam then
      if marr then begin
        if Pos('DATE', s) <> 0 then begin
          i := Pos('DATE', s);
          ss := Trim( Copy(s,i+5,255));
          ss := StrDeleteStr(ss,'CIR');//удал€ю CIR
          ss := StrDeleteStr(ss,'ABT');//удал€ю ABT
          if Pos('BEF',ss) > 0 then begin
            i := Pos('BEF',ss);
            sss := Trim(Copy(ss, i+3, Length(ss)));
            sWeddin := pref_gedcom_before+' '+DateFromStr(sss);
          end else
          if Pos('AFT',ss) > 0 then begin
            i := Pos('AFT',ss);
            sss := Trim(Copy(ss, i+3, Length(ss)));
            sWeddin := pref_gedcom_after+' '+DateFromStr(sss);
          end else
          if Pos('BET',ss) > 0 then begin
            i := Pos('BET',ss);
            sss := Copy(ss, i+3, Length(ss));
            if Pos('AND',sss) > 0 then begin
              i := Pos('AND',sss);
              ss1 := Trim(Copy(sss, 1, i-1));
              ss2 := Trim(Copy(sss, i+3, Length(sss)));
              sWeddin := pref_gedcom_between+' '+DateFromStr(ss1)+' '+pref_gedcom_and+' '+DateFromStr(ss2);
            end else begin
              sWeddin := pref_gedcom_between+' '+DateFromStr(sss);
            end;
          end else begin
            sWeddin := DateFromStr(ss);
          end;
        end else if Pos('PLAC', s) <> 0 then begin
          i := Pos('PLAC', s);
          sPlacew := Copy(buf,i+5,255);
        end;
      end;
    end;
  end;
  InsertSpouse();//добавл€ю супругов если остались
  for id := 0 to Fams.Count-1 do begin//уничтожаю элементы списка
    pFam := Fams[id];
    Dispose(pFam);
  end;
  CloseFile(FileGED);
  //
  if cntMans < 1 then// если осталось одна строка, не удал€ть
    Family.StringGrid1.RowCount := 1
  else
    Family.StringGrid1.RowCount := cntMans;
  Family.SaveStringGrid;// —охран€ю файл базы
  ProcessForm.Hide;
  Family.Cursor := crDefault;
end;

end.

