unit cnsts;

interface

uses
  Messages, SysUtils, Graphics, Variants, Classes, Controls, Forms,
  ExtCtrls, StdCtrls, Printers;

const
  cmsg1 = '';

var
  smsg1 : String;
  smsg2 : String;
  smsg3 : String;
  smsg4 : String;
  smsg5 : String;
  rkey1 : String;
  rkey2 : String;
  rkeyLogin : String;
  rkeyEmail : String;
  rkeyPswrd : String;

procedure InitCnsts;

implementation

//
procedure InitCnsts;
begin
  smsg1 := '������� ����� (E-Mail) � ������';
  smsg2 := '������� ����� (E-Mail) ���������';
  smsg3 := '��������� ����������������!';
  smsg4 := '    ������� �� �������!';
  smsg5 := '������� ����� ��� ������';
//
  smsg1 := ' Enter a login (E-Mail) and the password ';
  smsg2 := ' Enter a login (E-Mail) correctly ';
  smsg3 := ' The Program is registered! ';
  smsg4 := '     Thanks for purchase! ';
  smsg5 := ' The login or the password is incorrect';
//
  rkey1 := 'SOFTWARE';
  rkey2 := 'FamilyTree';
  rkeyLogin := 'Login';
  rkeyEmail := 'MyBoardsEmail';
  rkeyPswrd := 'MyBoardsPswrd';
end;

end.
