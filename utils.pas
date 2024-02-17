unit utils;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF DARWIN}
  MacOSAll,
{$ENDIF}
{$IFDEF UNIX}
  Unix,
{$ENDIF}
  FileUtil, SysUtils, Classes, Forms, Graphics, ExtCtrls, Printers,
  LCLIntF,
  Grids, Dialogs, Registry, LConvEncoding;

const
  {римские цифры}
  RomeDigits: array [1..13] of string[2] =
  ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M');
  {числа, соответствующие римским цифрам}
  ArabicNumbers: array [1..13] of integer =
  (1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
var
  arabic: integer; {арабское число}
  rome: string; {римское число}
  ask: char; {режим перевода чисел}

function IntToRoman(num: Cardinal): string;
function ArabicToRome (n: integer): string;
function RomeToArabic (s: string): integer;
function LatToRim(const I: Integer): String;

function isPerson(nama : String): boolean;
function iRetrName(const Name: String): Integer;
function iRetrFather(const Name: String): Integer;
function iRetrMother(const Name: String): Integer;
function SexPerson(Index : Integer): Integer;
function FirstName( Name : String): String;
function LastName( Name : String): String;
function DateName( Index : Integer): String;
function StrRusDate(const SDate : String): TDateTime;
function RusDate(const SDate : String): String;
function DateRus(const SDate : String): String;
function FormatDatTim(str : String): String;
function MultiFormatDatTim(str : String): String;
function DateDMY(D, M, Y, DateFormat : String): String;
function DateFromStr(s : String): String;

function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders, StopIfNotAllDeleted, RemoveRoot: boolean): Boolean;
function RenameDir(DirFrom, DirTo: AnsiString): Boolean;
procedure CopyFiles(const FileName, DestName: string);

function MemAvail: Longint;

function GetEnvironmentVariableUtf8(const s: String): String;

implementation

uses vars, mstring;

{returns num in capital roman digits}
function IntToRoman(num: Cardinal): string;
const
  Nvals = 13;
  vals: array[1..Nvals] of word = (1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500,
    900, 1000);
  roms: array[1..Nvals] of string[2] = ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L',
    'XC', 'C', 'CD', 'D', 'CM', 'M');
var
  b: 1..Nvals;
begin
  result := '';
  b := Nvals;
  while num > 0 do
  begin
    while vals[b] > num do
      dec(b);
    dec(num, vals[b]);
    result := result + roms[b]
  end;
end;

(*----------------------------------------
Функция перевода арабского числа
в римское
----------------------------------------*)
function ArabicToRome (n: integer): string;
var
  i: integer;
  res: string;
begin
  res:='';
  i:=13; {проверяем от больших чисел к меньшим}
  while n>0 do begin
    {находим следующее число, из которого будем формировать римскую цифру}
    while ArabicNumbers[i]>n do
      i:=i-1;
	res:=res+RomeDigits[i];
    n:=n-ArabicNumbers[i];
  end;
  ArabicToRome := res;
end;


(*----------------------------------------
Функция перевода римского числа
в арабское. Возвращает -1, если в
исходной строке (римском числе)
присутствуют неверные цифры
----------------------------------------*)
function RomeToArabic (s: string): integer;
var
  i, j, res: integer;
begin
  res:=0;
  i:=13; {рассматриваем цифры от больших к меньшим}
  {переводим строку в верхний регистр}
  for j:=1 to length(s) do
    s[j]:=UpCase(s[j]);
  j:=1; {текущий символ строки}
  while j<=length(s) do begin
    {ищем следующую римскую цифру - 1 или 2 символа}
	while (copy(s, j, length(RomeDigits[i]))<>RomeDigits[i])and(i>0) do
	  i:=i-1;
	{нашли, добавляем число}
	res:=res+ArabicNumbers[i];
	j:=j+length(RomeDigits[i]);
  end;
  {проверка на случай неверного римского числа (в строке были неверные символы)}
  if ArabicToRome(res)=s then
    RomeToArabic:=res
  else
    RomeToArabic:=-1;
end;

function LatToRim(const I: Integer): String;
var
  s : Integer;
begin
 s := I;
 Result := '';
 if (s div 1000)=1 then begin Result := 'M'; s:=s-1000; end;
 if (s div 100)=9 then Result := Result + 'CM';
 if (s div 100)=8 then Result := Result + 'DCCC';
 if (s div 100)=7 then Result := Result + 'DCC';
 if (s div 100)=6 then Result := Result + 'DC';
 if (s div 100)=5 then Result := Result + 'D';
 if (s div 100)=4 then Result := Result + 'CD';
 if (s div 100)=3 then Result := Result + 'CCC';
 if (s div 100)=2 then Result := Result + 'CC';
 if (s div 100)=1 then Result := Result + 'C';
 s:=s-(s div 100) *100;
 if (s div 10)=9 then Result := Result + 'XC';
 if (s div 10)=8 then Result := Result + 'LXXX';
 if (s div 10)=7 then Result := Result + 'LXX';
 if (s div 10)=6 then Result := Result + 'LX';
 if (s div 10)=5 then Result := Result + 'L';
 if (s div 10)=4 then Result := Result + 'XL';
 if (s div 10)=3 then Result := Result + 'XXX';
 if (s div 10)=2 then Result := Result + 'XX';
 if (s div 10)=1 then Result := Result + 'X';
 s:=s-(s div 10)*10;
 if (s div 1)=9 then Result := Result + 'IX';
 if (s div 1)=8 then Result := Result + 'VIII';
 if (s div 1)=7 then Result := Result + 'VII';
 if (s div 1)=6 then Result := Result + 'VI';
 if (s div 1)=5 then Result := Result + 'V';
 if (s div 1)=4 then Result := Result + 'IV';
 if (s div 1)=3 then Result := Result + 'III';
 if (s div 1)=2 then Result := Result + 'II';
 if (s div 1)=1 then Result := Result + 'I';
end;

//есть ли человек в списке
function isPerson(nama : String): boolean;
var
  n : Integer;
begin
  Result := False;
  for n := 0 to listMans.Count - 1 do begin
    if listMans.Strings[n] = nama then begin
      Result := True;
      break;
    end;
  end;
end;
//индекс человека в списке
function iRetrName(const Name: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  if Trim(Name) <> '' then
  for i := 0 to listMans.Count - 1 do
    if Trim(listMans.Strings[i]) = Trim(Name) then begin
      Result := i;
      exit;
    end;
end;
//индекс отца в списке
function iRetrFather(const Name: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  if Trim(Name) <> '' then
  for i := 0 to listMans.Count - 1 do
    if Trim(listMans.Strings[i]) = Trim(Name) then begin
      Result := i;
      exit;
    end;
end;
//индекс матери в списке
function iRetrMother(const Name: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  if Trim(Name) <> '' then
  for i := 0 to listMans.Count - 1 do
    if Trim(listMans.Strings[i]) = Trim(Name) then begin
      Result := i;
      exit;
    end;
end;
//пол человека в списке
function SexPerson(Index : Integer): Integer;
var
  i : Integer;
begin
  Result := -1;
  if listGender.Strings[Index] = Man then Result := 0
  else if listGender.Strings[Index] = Woman then Result := 1;
end;
// фамилия
function FirstName( Name : String): String;
begin
  Result := Copy( Name, 1, Pos(' ', Name)-1);
end;
// имя и отчество
function LastName( Name : String): String;
begin
  Result := Copy( Name, Pos(' ', Name)+1, 255);
end;
// Дата
function DateName( Index : Integer): String;
begin
  Result := '';
  if (Index < 0) or (Index > listMans.Count - 1) then Exit;
  if ((not Empty(listBirth.Strings[Index])) or
      (not Empty(listDeath.Strings[Index]))) then begin
    Result := '('+listBirth.Strings[Index];
    if SysUtils.Trim(listDeath.Strings[Index]) <> ''
      then Result := Result + '-' + listDeath.Strings[Index];
    Result := Result + ')';
  end;
end;

function StrRusDate(const SDate : String): TDateTime;
begin
  try
    Result := StrToDate(RusDate(SDate));
  except
    Result := Date();
  end;
end;

function RusDate(const SDate : String): String;
var
  i : Integer;
  s, ss : String;
 function RDate(const SDate : String): String;
 var
   d,M,y : Integer;
 begin
   d := Pos('d',DateFormat);
   M := Pos('M',DateFormat);
   y := Pos('y',DateFormat);
   if ((d < M) and (d < y)) then begin
     Result := Copy(SDate,d,2) + DateSeparate;
     if (M < y) then Result := Result + Copy(SDate,M,2) + DateSeparate + Copy(SDate,y,4)
     else Result := Result + Copy(SDate,y,4) + DateSeparate + Copy(SDate,M,2);
   end else if ((M < d) and (M < y)) then begin
     Result := Copy(SDate,M,2) + DateSeparate;
     if (d < y) then Result := Result + Copy(SDate,d,2) + DateSeparate + Copy(SDate,y,4)
     else Result := Result + Copy(SDate,y,4) + DateSeparate + Copy(SDate,d,2);
   end else if ((y < d) and (y < M)) then begin
     Result := Copy(SDate,y,4) + DateSeparate;
     if (d < M) then Result := Result + Copy(SDate,d,2) + DateSeparate + Copy(SDate,M,2)
     else Result := Result + Copy(SDate,M,2) + DateSeparate + Copy(SDate,d,2);
   end else Result := SDate;
 end;
begin
  s := '';
  ss := StrReplaceStr(SDate, ' '+pref_gedcom_and+' ', '..');
  for i := 1 to Length(ss) do begin
    if ((ss[i] >= '0') and (ss[i] <= '9'))
     or (ss[i] = '.')
     or (ss[i] = '-')
     or (ss[i] = '/') then
      s := s + ss[i];
  end;
  case DateSeparate of
   '.' : begin
     if Pos('..', s) <> 0 then Result := '01.01.'+Copy(s,1,4)
     else if Pos('/', s) <> 0 then Result := Copy(s,4,2)+'.'+Copy(s,1,2)+'.'+Copy(s,7,4)
     else if Pos('-', s) <> 0 then Result := Copy(s,9,2)+'.'+Copy(s,6,2)+'.'+Copy(s,1,4)
     else if Pos('.', s) <> 0 then Result := RDate(s)
     else if Empty(s) then Result := '30.12.1899' else Result := '01.01.'+s;
   end;
   '/' : begin
     if Pos('..', s) <> 0 then Result := '01/01/'+Copy(s,1,4)
     else if Pos('.', s) <> 0 then Result := Copy(s,4,2)+'/'+Copy(s,1,2)+'/'+Copy(s,7,4)
     else if Pos('-', s) <> 0 then Result := Copy(s,6,2)+'/'+Copy(s,9,2)+'/'+Copy(s,1,4)
     else if Pos('/', s) <> 0 then Result := RDate(s)
     else if Empty(s) then Result := '12/30/1899' else Result := '01/01/'+s;
   end;
   '-' : begin
     if Pos('..', s) <> 0 then Result := '01-01-'+Copy(s,1,4)
     else if Pos('/', s) <> 0 then Result := Copy(s,7,4)+'-'+Copy(s,1,2)+'-'+Copy(s,4,2)
     else if Pos('.', s) <> 0 then Result := Copy(s,7,4)+'-'+Copy(s,4,2)+'-'+Copy(s,1,2)
     else if Pos('-', s) <> 0 then Result := RDate(s)
     else if Empty(s) then Result := '1899-12-30' else Result := s+'-12-30';
   end;
  else
    Result := SDate;
  end;
end;

function DateRus(const SDate : String): String;
begin
  case DateSeparate of
   '.' : begin
     if Pos('/', DateFormat) <> 0 then Result := StrReplaceAll(SDate,'.','/')
     else if Pos('-', DateFormat) <> 0 then Result := StrReplaceAll(SDate,'.','-')
     else Result := SDate;
   end;
   '/' : begin
     if Pos('.', DateFormat) <> 0 then Result := StrReplaceAll(SDate,'/','.')
     else if Pos('-', DateFormat) <> 0 then Result := StrReplaceAll(SDate,'/','-')
     else Result := SDate;
   end;
   '-' : begin
     if Pos('.', DateFormat) <> 0 then Result := StrReplaceAll(SDate,'-','.')
     else if Pos('/', DateFormat) <> 0 then Result := StrReplaceAll(SDate,'-','/')
     else Result := SDate;
   end;
  else
    Result := SDate;
  end;
end;

function FormatDatTim(str : String): String;
var
	s,d,m,y : String;
	i,p,n : Integer;
  fmt : array[0..3] of ShortString;
  dte : array[0..3] of ShortString;
  nf : Integer;
  nd : Integer;
begin
	Result := '';
	d := ''; m := ''; y := '';
  // раскладываю формат даты
  s := DateFormat;
  nf := 0;
  for i := 0 to 3 do begin
    p := Pos(DateSeparate,s);
    if p > 0 then begin
      fmt[i] := Copy( s, 1, p-1);
      s := Copy(s, p+1, Length(s));
    end else begin
      if not Empty(s) then begin
        fmt[i] := s;
        nf := i + 1;
        break;
      end else begin
        nf := i;
        break;
      end;
    end;
  end;
  // раскладываю дату
  s := str;
  nd := 0;
  for i := 0 to 3 do begin
    p := Pos(DateSeparate,s);
    if p > 0 then begin
      dte[i] := Copy( s, 1, p-1);
      s := Copy(s, p+1, Length(s));
    end else begin
      if not Empty(s) then begin
        dte[i] := s;
        nd := i + 1;
        break;
      end else begin
        nd := i;
        break;
      end;
    end;
  end;
  if (nd = 1) then begin
		Result := dte[0];
  end else
  if (nd = 2) then begin
     if Pos('M',fmt[0]) > 0 then begin
		  m := dte[0];
     end else
     if Pos('y',fmt[0]) > 0 then begin
			y := dte[0];
     end;
     if Pos('M',fmt[1]) > 0 then begin
			m := dte[1];
     end else
     if Pos('y',fmt[1]) > 0 then begin
		  y := dte[1];
     end;
     if Pos('M',fmt[2]) > 0 then begin
			m := dte[2];
     end else
     if Pos('y',fmt[2]) > 0 then begin
			y := dte[2];
     end;
     if m = '' then m := '0';
     n := StrToInt(m);
     if ((n = 0) or (n > 12)) then begin
        Result := y;//new SimpleDateFormat("yyyy");
     end else begin
         Result := SMonth3[n] +' '+ y;//new SimpleDateFormat("MMM yyyy");
     end;
  end else
  if (nd = 3) then begin
     if Pos('d',fmt[0]) > 0 then begin
        d := dte[0];
     end else
     if Pos('M',fmt[0]) > 0 then begin
        m := dte[0];
     end else
     if Pos('y',fmt[0]) > 0 then begin
        y := dte[0];
     end;
     if Pos('d',fmt[1]) > 0 then begin
        d := dte[1];
     end else
     if Pos('M',fmt[1]) > 0 then begin
        m := dte[1];
     end else
     if Pos('y',fmt[1]) > 0 then begin
        y := dte[1];
     end;
     if Pos('d',fmt[2]) > 0 then begin
        d := dte[2];
     end else
     if Pos('M',fmt[2]) > 0 then begin
        m := dte[2];
     end else
     if Pos('y',fmt[2]) > 0 then begin
        y := dte[2];
     end;
     if m = '' then m := '0';
     n := StrToInt(m);
     if Pos('00',d) > 0 then begin
        if ((n = 0) or (n > 12)) then begin
	    Result := y;                  //new SimpleDateFormat("yyyy");
	end else begin
	    Result := SMonth3[n] +' '+ y; //new SimpleDateFormat("MMM yyyy");
	end;
     end else begin
         if ((n = 0) or (n > 12)) then begin
	    Result := d +' '+ y;                  //new SimpleDateFormat("dd yyyy");
	 end else begin
	     Result := d +' '+ SMonth3[n] +' '+ y; //new SimpleDateFormat("dd MMM yyyy");
	 end;
     end;
  end;
end;

function MultiFormatDatTim(str : String): String;
var
	ss, ss1, ss2 : String;
	n : Integer;
begin
	Result := '';
 	if Pos(pref_gedcom_before,str) > 0 then begin
		n := Pos(pref_gedcom_before,str);
		ss := Trim(Copy(str, n + Length(pref_gedcom_before), Length(str)));
		Result := 'BEF '+ FormatDatTim(ss);
 	end else
 	if Pos(pref_gedcom_after,str) > 0 then begin
		n := Pos(pref_gedcom_after,str);
		ss := Trim(Copy(str, n + Length(pref_gedcom_after), Length(str)));
		Result := 'AFT '+ FormatDatTim(ss);
  end else
  if Pos(pref_gedcom_between,str) > 0 then begin
		n := Pos(pref_gedcom_between,str);
		ss := Trim(Copy(str, n + Length(pref_gedcom_between), Length(str)));
	  if Pos(pref_gedcom_and,ss) > 0 then begin
 			n := Pos(pref_gedcom_and,ss);
 			ss1 := Trim(Copy(ss,0,n));
 			ss2 := Trim(Copy(ss, n+Length(pref_gedcom_and), Length(ss)));
 			Result := 'BET '+ FormatDatTim(ss1)+' AND '+FormatDatTim(ss2);
 		end else begin
 			Result := 'BET '+ FormatDatTim(ss);
		end;
  end else begin
   	Result := FormatDatTim(str);
  end;
end;

function DateDMY(D, M, Y, DateFormat : String): String;
var
	d_i, M_i, y_i : Integer;
begin
	Result := '';
	d_i := Pos('d',DateFormat);
	M_i := Pos('M',DateFormat);
	y_i := Pos('y',DateFormat);
	if ((d_i < M_i) and (M_i < y_i)) then begin//если ddMMyyyy
		Result := D +DateSeparate+ M +DateSeparate+ Y;
	end else
	if ((M_i < d_i) and (d_i < y_i)) then begin//если MMddyyyy
		Result := M +DateSeparate+ D +DateSeparate+ Y;
	end else
	if ((y_i < M_i) and (M_i < d_i)) then begin//если yyyyMMdd
    Result := Y +DateSeparate+ M +DateSeparate+ D;
	end else
	if ((y_i < d_i) and (d_i < M_i)) then begin//если yyyyddMM
    Result := Y +DateSeparate+ D +DateSeparate+ M;
	end;
end;

function DateFromStr(s : String): String;
var
  n, i, ii : Integer;
  ss : String;
  dmy : array[0..3] of ShortString;
begin
  Result := '';
  n := 0;
  ss := s;
  for i := 0 to 3 do begin
    ii := Pos(' ',ss);
    if (ii <= 0) then begin
      dmy[i] := ss;
      ss := '';
      inc(n);
      break;
    end else begin
      dmy[i] := Trim(Copy(ss,1,ii-1));
      ss := Trim(Copy(ss,ii+1, Length(ss)));
      inc(n);
    end;
  end;
  if (n = 1) then begin
    Result := dmy[0];
  end else
  if (n = 2) then begin
    ii := 0;
    for i := 1 to 12 do
      if Pos(dmy[0],SMonth3[i]) > 0 then
        ii := i;
      if (ii > 9) then begin
        dmy[0] := IntToStr(ii);
      end else begin
        dmy[0] := '0' + IntToStr(ii);
      end;
    Result := DateDMY('00',dmy[0],dmy[1],DateFormat);
  end else
  if (n = 3) then begin
    ii := 0;
    for i := 1 to 12 do
      if Pos(dmy[1],SMonth3[i]) > 0 then
        ii := i + 1;
      if (ii > 9) then begin
        dmy[1] := IntToStr(ii);
      end else begin
        dmy[1] := '0' + IntToStr(ii);
      end;
    Result := DateDMY(dmy[0],dmy[1],dmy[2],DateFormat);
  end else begin
    Result := dmy[0]+dmy[1]+dmy[2]+dmy[3];
  end;
end;

function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): Boolean;
var
  i: Integer;
  SRec: TSearchRec;
  FN: string;
begin
  Result := False;
  if not DirectoryExists(Dir) then
    exit;
  Result := True;
  Dir := IncludeTrailingBackslash(Dir);
  i := FindFirst(Dir + '*', faAnyFile, SRec);
  try
    while i = 0 do
    begin
      FN := Dir + SRec.Name;
      if SRec.Attr = faDirectory then
      begin
        if (SRec.Name <> '') and (SRec.Name <> '.') and (SRec.Name <> '..') then
        begin
          if DeleteAllFilesAndFolders then
            {$IFDEF WINDOWS}
            FileSetAttr(UTF8toANSI(FN), faArchive);
            {$ENDIF}
            {$IFDEF UNIX}
            FileSetAttr(FN, faArchive);
            {$ENDIF}
          Result := FullRemoveDir(FN, DeleteAllFilesAndFolders, StopIfNotAllDeleted, True);
          if not Result and StopIfNotAllDeleted then
            exit;
        end;
      end else begin
        if DeleteAllFilesAndFolders then
          {$IFDEF WINDOWS}
          FileSetAttr(UTF8toANSI(FN), faArchive);
          {$ENDIF}
          {$IFDEF UNIX}
          FileSetAttr(FN, faArchive);
          {$ENDIF}
        {$IFDEF WINDOWS}
        Result := SysUtils.DeleteFile(UTF8toANSI(FN));
        {$ENDIF}
        {$IFDEF UNIX}
        Result := SysUtils.DeleteFile(FN);
        {$ENDIF}
        if not Result and StopIfNotAllDeleted then
          exit;
      end;
      i := FindNext(SRec);
    end;
  finally
    FindClose(SRec);
  end;
  if not Result then
    exit;
  if RemoveRoot then
    {$IFDEF WINDOWS}
    if not RemoveDir(UTF8toANSI(Dir)) then
      Result := false;
    {$ENDIF}
    {$IFDEF UNIX}
    if not RemoveDir(Dir) then
      Result := false;
    {$ENDIF}
end;

function RenameDir(DirFrom, DirTo: string): Boolean;
begin
  Result := False;
  try
    if not DirectoryExists(DirTo) then
      {$IFDEF WINDOWS}
      MkDir(UTF8toANSI(DirTo));
      {$ENDIF}
      {$IFDEF UNIX}
      MkDir(DirTo);
      {$ENDIF}
    CopyFiles(DirFrom+dZd+'*.*', DirTo+dZd);
    //FullRemoveDir(DirFrom,True,True,True);
    Result:=DeleteDirectory(DirFrom,True);
    if Result then begin
      Result:=RemoveDir(DirFrom);
    end;
  except
  end;
end;

procedure CopyFiles(const FileName, DestName: string);
var
  SR : TSearchRec;
  sn, se, ss, sd : String;
  Found : Integer;
begin
  ss := ExtractFilePath(FileName);
  sd := ExtractFilePath(DestName);
  sn := ExtractFileName(DestName);
  Found := Pos( ExtractFileExt(sn), sn);
  sn := Copy(sn,1,Found-1);
  Found := FindFirst( FileName, faAnyFile, SR);
  while Found = 0 do begin
    if ((SR.Attr <> faDirectory) and (SR.Attr <> faVolumeID))
        and (SR.Name <> '.') and (SR.Name <> '..') then begin
      se := ExtractFileExt(SR.Name);
      FileUtil.CopyFile(ss+SR.Name,sd+SR.Name);
    end;
    Found := FindNext(SR)
  end;
  SysUtils.FindClose(SR);
end;

{
   WinAPI- GlobalMemoryStatus,    MEMORYSTATUS.
         ( dwTotalPhys),
    (dwAvailPhys),
      (dwTotalPageFile,dwAvailPageFile),
        (dwTotalVirtual,dwAvailVirtual),
      (dwMemoryLoad),    0  100
}
function MemAvail: Longint;
{$IFDEF MSWINDOWS}
var
  ms: TMemoryStatus;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  GlobalMemoryStatus(MS);
  MemAvail := MS.dwAvailPhys;
{$ENDIF}
{$IFDEF UNIX}
  Result := 500000000;//??
{$ENDIF}
end;

function GetEnvironmentVariableUtf8(const s: String): String;
begin
  {$ifdef GETEVNVAR_ANSI}
  Result:=SysToUtf8( SysUtils.GetEnvironmentVariable(s));
  {$else}
  //??Result:=ConsoleToUtf8( SysUtils.GetEnvironmentVariable(s));
  Result:=SysUtils.GetEnvironmentVariable(s);
  {$endif}
end;

end.

