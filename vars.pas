unit vars;

interface

uses Forms, Types, Classes, SysUtils, utils, Graphics, IniFiles, mstring;

const
  MaxMens = 32768;

const// ������ ������ ������
  sizeRowSmall = 48; //
  sizeRowMiddle = 64;//
  sizeRowBig = 96;   //

const
  CountCol = 11;    // ���������� �������
  fldNUL = 0;       // ����� ������� � �������
  fldBEG = 1;       // ����� ������� "������"
  fldEND = 2;       // ����� ������� "����"
  fldNAM = 3;       // ����� ������� "���"
  fldFAT = 4;       // ����� ������� "����"
  fldMOT = 5;       // ����� ������� "����"
  fldMEN = 6;       // ����� ������� "���"
  fldPLB = 7;       // ����� ������� "����� ��������"
  fldPLE = 8;       // ����� ������� "����� ������"
  fldMAW = 9;       // ����� ������� "���-����"
  fldNAT = 10;      // ����� ������� "��������������"
  fldOCC = 11;      // ����� ������� "��� �������"

const
  rzd1 = ';';
  rzd2 = ':';
  rzd3 = '/';

const
  {$IFDEF WINDOWS}
  dZd = '\';//Windows
  {$ENDIF}
  {$IFDEF UNIX}
  dZd = '/';//Mac OS
  {$ENDIF}

const
  CountRegs = 10;    // ���������� ������� � �������������������� �����

const
  SMonth3: array[1..12] of String[3]= ( 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');

// ��������� � ���� ��� ����������� �����
const
  delta = 8;
  LinWidth = 3;//������ ����� �����
  BoxWidth = 2;//������ ����� �����
  DrawMenHight = 52;//������ ����� � �����
  DrawMenWidht = 185;//������ ����� � �����

// ��������� GEDCOM
const
	code_gedcom_between = 'between';
	code_gedcom_and = 'and';
	code_gedcom_before = 'before';
	code_gedcom_after = 'after';

// ������ ��� ���������� ����
type
  TMens = record
    Dat : TDateTime;//���� ��������
    Men : Integer;//�������
    Sex : Integer;//���
    Father : Integer;//����
    Mother : Integer;//����
    X : Integer;//���������� X
    Y : Integer;//���������� Y
    Yes : Integer;//0 - ������; 1.. ����� �����
  end;

// ��������� � ���� ��� ��������/������� GETCOM
type
  TFamilys = record
    id : Integer;
    Father : Integer;//����
    Mother : Integer;//����
    Husband: Integer;//���
    Wife   : Integer;//����
    Child  : Pointer;//������ �����
  end;
  TChilds = record
    id : Integer;
    Child  : Pointer;//������ �����
  end;
  TIndi = record
    id : Integer;
    indi : Integer;
    famc : Integer;
    fams : Integer;
    note : Integer;
  end;

//����� � ����
type
  TMaWs = record
    man : Integer;
    woman : Integer;
  end;

//���������� ���������������
type
  TNats = record
    cnt : Integer;
    nat : ShortString;
  end;

var
  listNull : TStringList;
  listBirth : TStringList;
  listDeath : TStringList;
  listMans : TStringList;
  listFather : TStringList;
  listMother : TStringList;
  listGender : TStringList;
  listPlaceb : TStringList;
  listPlaced : TStringList;
  listSpouse : TStringList;
  listNati : TStringList;
  listOccu : TStringList;

var
  pMen : ^TMens;//��������� �������
  fMen : ^TMens;//��������� ����
  mMen : ^TMens;//��������� ����
  Mens : TList; //������ �����
  pMaW : ^TMaWs;//���������
  MaWs : TList; //������ �����
  MaW : TMaWs;
  MensCnt : Integer;
  MensM : array[0..MaxMens-1] of Integer;
  MensX : array[0..MaxMens-1] of Integer;
  MensY : array[0..MaxMens-1] of Integer;

var
//   
  ConfigFile : TIniFile;
//   
  FileDB : TextFile;         //  
  MainPathEXE : String;      //    
  MainPathDAT : String;      //    
  PathRES : String;          //    RES
  PathTXT : String;          //    TXT
  PathICO : String;          //    ICONS
  PathBMP : String;          //    FOTO
  PathFTS : String;          //    FOTOS
  PathVID : String;          //    VIDEO
  PathFLS : String;          //    FILES
  MainPathRES : String;      //     RES
  MainPathTXT : String;      //     TXT
  MainPathICO : String;      //     ICONS
  MainPathBMP : String;      //     FOTO
  MainPathFTS : String;      //     FOTOS
  MainPathVID : String;      //     VIDEO
  MainPathFLS : String;      //     FILES
  MainPathTMP : String;      // '\TMP';
  //??  MainPathTEMP: String;      // 'WINDOWS\TEMP\';
  FileNameDB  : String;      //    
  MainFileCSV : String;      //      
  MainFileFTS : String;      // �   
  MainFileVID : String;      // �   
  MainFileFLS : String;      // �    
  MainFileHLP : String;      // �  
  MainFileINI : String;      // �  ini
  MainFileTMP : String;      // �  temp
  MainFileLNG : String;      // �  Language
  MainFileRTF : String;      // �  RTF
  MainFileSND : String;      // �  SND
  MainFileZIP : String;      // �  ZIP
  MainFileHTM : String;      // HTM
//  
  Modified : Boolean;   //  
  ReDraws  : Boolean;   //  
  ModCells : Integer;   //   1-; 0-; -1-
  OldCells : String;    //   
  //AddIcons : Boolean;   //  
  InfoLoad : Boolean;   //  
  YesNo : Boolean;      // /
  PersonAll : Boolean;  // (true)  (false)
  done : Boolean;       //  
// �
  RadioChar : TStringList;
  lng_languag : ShortString;
  lng_charset : ShortString;
  cst : TFontCharset;
// Grid
  oldItemIndex : Integer;
  GridCol, GridRow : Integer;   //  ()/  
  GridRect : TRect;             //   
  SPos : Integer;               //    RTF
//
  app_name : String;
// 
  field_name    : String;
  field_gender  : String;
  field_father  : String;
  field_mother  : String;
  field_birth   : String;
  field_death   : String;
  field_placeb  : String;
  field_placed  : String;
  field_foto    : String;
  field_note    : String;
  field_child   : String;
  field_son     : String;
  field_daughter: String;
  field_brother : String;
  field_sister  : String;
  field_occu    : String;
  field_nati    : String;
  field_spouse  : String;
  field_husband : String;
  field_wife    : String;
  field_wedding : String;
  field_placew  : String;
  Man   : String;
  Woman : String;
  Enter : String;
// ������� �����
  CaptionList   : String;
  CaptionTree   : String;
  CaptionPict   : String;
  CaptionKino   : String;
  CaptionFile   : String;
  CaptionRich   : String;
  CaptionGenr   : String;
  CaptionBranch : String;
  CaptionGener  : String;
  CaptionFolder : String;
// ������
  list_button_hint : String;
  tree_button_hint : String;
  pict_button_hint : String;
  kino_button_hint : String;
  file_button_hint : String;
  rich_button_hint : String;
  genr_button_hint : String;
  rept_button_hint : String;
  newe_button_hint : String;
  edit_button_hint : String;
  dele_button_hint : String;
  find_button_hint : String;
  foto_button_hint : String;
  help_button_hint : String;
  tune_button_hint : String;
  prin_button_hint : String;
  save_button_hint : String;
  sort_button_hint : String;
  exit_button_hint : String;
  size_button_hint : String;
  plus_button_hint : String;
  minu_button_hint : String;
  back_button_hint : String;
// ���������� �����
  HTMLText : String;
  OX, OY : Integer;
  btLeft : Boolean;
// ���������� ������
  ico : Integer; //������� ������ � ��������
// ���������� �����������
  FotosLst : TStringList;
  SubDirFoto : String;
  iFotos : Integer;
// ���������� ������������
  VideoLst : TStringList;
  SubDirVideo : String;
  iVideo : Integer;
  ScreenFull : Boolean;
// ���������� ������ ������
  FilesLst : TStringList;
  SubDirFiles : String;
  iFiles : Integer;
// ���������� ��������� �� �����
// ������ ����
  DateFormat : String[10];
  DateSeparate : Char;//������ ����������� ����
  PrgDateSeparate : Char;
  PrgDateFormat : String[10];
  DateNull : TDateTime;
// ������
  ButonOK : String;
  ButonCancel : String;
  ButonYes : String;
  ButonNo : String;
  ButonSave : String;
  ButonLoad : String;
  ButonSort : String;
  ButonFind : String;
  ButonNew : String;
  ButonBack : String;
// LABEL
  labelName : ShortString;
  labelNote : ShortString;
// Test
  msgErr0 : ShortString;
  msgErr1 : ShortString;
  msgErr2 : ShortString;
  msgErr3 : ShortString;
  msgErr4 : ShortString;
// ERROR
  error_msg00 : String;
  error_msg01 : String;
  error_msg02 : String;
  error_msg03 : String;
  error_msg04 : String;
// GEDCOM
  pref_gedcom_title  : String;
  pref_gedcom_import : String;
  pref_gedcom_export : String;
  hint_gedcom_import : String;
  hint_gedcom_export : String;
  pref_gedcom_charset: String;
  hint_gedcom_charset: String;
// ������� GEDCOM
  pref_gedcom_between: String;
  pref_gedcom_and    : String;
  pref_gedcom_before : String;
  pref_gedcom_after  : String;
// ZIP
  pref_zip_title  : String;
  pref_zip_export : String;
  pref_zip_import : String;
  hint_zip_export : String;
  hint_zip_import : String;
// MESSAGE
  msgDblFIO : ShortString;
  msgNotSymbol : ShortString;
  msgFileExists : ShortString;
  msgDelPerson : String;
  msgDelPhoto : String;
  msgDelVideo : String;
  msgDelFiles : String;
  msgSave : String;
// TASK
  task_loading : String;
  task_saveing : String;
  task_sorting : String;
  task_growing : String;
  task_waiting : String;
  task_runing  : String;
  task_calcing : String;
  task_copying : String;
  task_working : String;
  task_testing : String;
  task_printing : String;
  task_starting : String;
  task_cancelled : String;
  task_completed : String;
// �����������
  Registration : Boolean;
  email, pswrd : String;
  msgYesRegs : ShortString;
  msgNotReg1 : ShortString;
  msgNotReg2 : ShortString;

procedure InitVars;
procedure FreeVars;
procedure ClearVars;

implementation

procedure InitVars;
var
  p : Integer;
begin
// ������ �����
  listBirth := TStringList.Create;
  listDeath := TStringList.Create;
  listMans := TStringList.Create;
  listGender := TStringList.Create;
  listFather := TStringList.Create;
  listMother := TStringList.Create;
  listPlaceb := TStringList.Create;
  listPlaced := TStringList.Create;
  listSpouse := TStringList.Create;
  listNati := TStringList.Create;
  listOccu := TStringList.Create;
// �������
  RadioChar := TStringList.Create;
// ���������� ����������
  MainPathEXE := ExtractFilePath(Application.ExeName);
  {$IFDEF WINDOWS}
  MainPathDAT := GetEnvironmentVariableUtf8('HOMEDRIVE') + GetEnvironmentVariableUtf8('HOMEPATH') + dZd +'FamilyTree' + dZd;
  {$ENDIF}
  {$IFDEF DARWIN}
  MainPathDAT := GetEnvironmentVariableUtf8('HOME') + dZd +'FamilyTree' + dZd;
  {$ENDIF}
  {$IFDEF UNIX}
  MainPathDAT := GetEnvironmentVariableUtf8('HOME') + dZd +'FamilyTree' + dZd;
  {$ENDIF}
  if Empty(MainPathDAT) then begin
    MainPathDAT := MainPathEXE
  end;
  FileNameDB  := 'FamilyTree.csv';
  PathRES := 'res' + dZd + 'values-';
  PathTXT := 'text' + dZd;
  PathICO := 'icon' + dZd;
  PathBMP := 'foto' + dZd;
  PathFTS := 'fotos' + dZd;
  PathVID := 'video' + dZd;
  PathFLS := 'files' + dZd;
  MainFileCSV := MainPathDAT+FileNameDB;
  MainPathTXT := MainPathDAT+PathTXT;
  MainPathICO := MainPathDAT+PathICO;
  MainPathBMP := MainPathDAT+PathBMP;
  MainPathFTS := MainPathDAT+PathFTS;
  MainPathVID := MainPathDAT+PathVID;
  MainPathFLS := MainPathDAT+PathFLS;
  MainPathTMP := MainPathDAT+'tmp';
  MainPathRES := MainPathEXE+PathRES;
  //??MainPathTEMP:= GGetTempPath;
  MainFileFTS := 'FamilyTree.fts';
  MainFileVID := 'FamilyTree.vid';
  MainFileFLS := 'FamilyTree.fls';
  MainFileINI := 'FamilyTree.ini';
  MainFileLNG := 'FamilyTree.lng';
  MainFileRTF := 'FamilyTree.rtf';
  MainFileTMP := 'Tree.bmp';
  MainFileSND := 'birthday.wav';
  MainFileHTM := 'FamilyTree.html';
  MainFileZIP := 'FamilyTree.zip';
//   
  ico := 256;
// ������ ����
  if Pos('.',DateToStr(date())) <> 0 then DateSeparate := '.'
  else if Pos('/',DateToStr(date())) <> 0 then DateSeparate := '/'
  else if Pos('-',DateToStr(date())) <> 0 then DateSeparate := '-'
  else DateSeparate := ' ';
end;

procedure FreeVars;
begin
  listBirth.Free;
  listDeath.Free;
  listMans.Free;
  listGender.Free;
  listFather.Free;
  listMother.Free;
  listPlaceb.Free;
  listPlaced.Free;
  listSpouse.Free;
  listNati.Free;
  listOccu.Free;
// �������
  RadioChar.Free;
end;

procedure ClearVars;
begin
  listBirth.Clear;
  listDeath.Clear;
  listMans.Clear;
  listGender.Clear;
  listFather.Clear;
  listMother.Clear;
  listPlaceb.Clear;
  listPlaced.Clear;
  listSpouse.Clear;
  listNati.Clear;
  listOccu.Clear;
end;

end.
