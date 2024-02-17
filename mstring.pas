unit mstring;

interface

Uses SysUtils;

function Empty(S: string): boolean;
function Replicate(c: char; nLen: integer): string;
function Space(nLen: integer): string;
function SpaceNBSP(nLen: integer): string;
function StrDeleteAll (S: string; DelChar: char): string;
function StrReplaceAll (S: string; OldChar, NewChar: char): string;
function StrDeleteStr (S: string; DelStr: string): string;
function StrReplaceStr (S: string; OldStr, NewStr: string): string;
function StrDelEoln (S: string): string;
function StrAddEoln (S: string): string;
function RightFileName(const FileName: string): boolean;
function StrNumChar( S: String): String;
function StrDelChars( S: String): String;
function StrReverse (S: string): string;
function APos(Substr: string; S: string): Integer;
function strBetween( s, c : String) : String;
function strNumBetween(s : String) : String;

implementation

{returns true if the string is empty of non-spaces, false otherwise}
function Empty(S: string): boolean;
begin
  if Trim(S) = '' then
    Result := true
  else
    Result := false;
end;

function Replicate(c: char; nLen: integer): string;
{return a string containing nLen times the character c}
var
  i: integer;
begin
  Result := '';
  for i := 1 to nLen do
    Result := Result + c;
end;

function Space(nLen: integer): string;
{return the number of spaces asked for}
begin
  Result := Replicate(' ', nLen);
end;

function SpaceNBSP(nLen: integer): string;
{return the number of spaces asked for}
var
  i : Integer;
begin
  Result := '';
  for i := 1 to nLen do
    Result := Result + '&nbsp;';
end;

function StrDeleteAll (S: string; DelChar: char): string;
var
  Temp: string;
  I: integer;
begin { Remove all occurences of the specified character from string }
  Temp := '';
  for I := 1 to Length (S) do begin
    if S[I] <> DelChar then Temp := Temp + S[I];
  end;
  StrDeleteAll := Temp;
end;

function StrReplaceAll (S: string; OldChar, NewChar: char): string;
var
  Temp: string;
  I: integer;
begin { Remove all occurences of OldChar with NewChar }
  Temp := '';
  for I := 1 to Length (S) do begin
    if S[I] <> OldChar then
      Temp := Temp + S[I]
    else
      Temp := Temp + NewChar;
  end;
  StrReplaceAll := Temp;
end;

function StrDeleteStr(S: string; DelStr: string): string;
var
  i : Integer;
begin
  i := Pos(DelStr, S);
  if i <> 0
   then StrDeleteStr := Copy(S,1,i-1)+Copy(S,i,Length(DelStr))+Copy(S, i+Length(DelStr), Length(S))
   else StrDeleteStr := S;
end;

function StrReplaceStr(S: string; OldStr, NewStr: string): string;
var
  i : Integer;
begin
  i := Pos(OldStr, S);
  if i <> 0
   then StrReplaceStr := Copy(S,1,i-1)+NewStr+Copy(S, i+Length(OldStr), Length(S))
   else StrReplaceStr := S;
end;

function StrDelEoln (S: string): string;
var
  Temp: string;
begin
  Temp := S;
  while Pos(Chr(10), Temp) <> 0 do
    Temp := StrReplaceStr( Temp, Chr(10), Chr(11));
  while Pos(Chr(13), Temp) <> 0 do
    Temp := StrReplaceStr( Temp, Chr(13), Chr(12));
  StrDelEoln := Temp;
end;

function StrAddEoln (S: string): string;
var
  Temp: string;
  I: integer;
begin
  Temp := S;
  while Pos(Chr(11), Temp) <> 0 do
    Temp := StrReplaceStr( Temp, Chr(11), Chr(10));
  while Pos(Chr(12), Temp) <> 0 do
    Temp := StrReplaceStr( Temp, Chr(12), Chr(13));
  StrAddEoln := Temp;
end;

// Проверка имени файла на наличие запрещённых символов (? * ...)
function RightFileName(const FileName: string): boolean;
const
  CHARS: array[1..9] of char =
  ('\', '/', ':', '*', '?', '"', '<', '>', '|');
var
  I: integer;
begin
  for I := 1 to 11 do
    if pos(CHARS[I], FileName) <> 0 then //Найден запрещённый символ
    begin
      Result := false;
      Exit;
    end;
  Result := true;
end;

function StrNumChar( S: String): String;
var
  i : Integer;
begin
  Result := '';
  for i:=1 to Length(S) do if ((S[i] >= '0') and (S[i] <= '9')) then Result := Result + S[i];
  if Result = '' then Result := '0';
end;

function StrDelChars( S: String): String;
var
  i : Integer;
begin
  Result := '';
  for i:=1 to Length(S) do if Pos(S[i], '/:*?"<>|') = 0 then Result := Result + S[i] else Result := Result + '_';
end;

function StrReverse (S: string): string;
var
  Temp: string;
  I: integer;
begin
  { Traverse string }
  Temp := '';
  for I := Length (S) downto 1 do
      Temp := Temp + S[I];
  StrReverse := Temp;
end;

function APos(Substr: string; S: string): Integer;
var
  Temp: string;
  I: integer;
begin
  Temp := StrReverse(S);
  I := Pos(Substr, Temp);
  if i > 0 then
    Result := Length(S)-I+1
  else
    Result := 0;
end;

function strBetween( s, c : String) : String;
var
  p1, p2 : Integer;
begin
  p1 := Pos(c, s);
  p2 := APos(c, s);
  if (p2 > p1 ) then Result := Copy(s, p1+1, p2-p1-1);
  Result := s;
end;

function strNumBetween(s : String) : String;
begin
  Result := StrNumChar(strBetween(s,'@'));
end;

end.

