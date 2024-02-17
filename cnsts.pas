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
  smsg1 := 'Введите логин (E-Mail) и пароль';
  smsg2 := 'Введите логин (E-Mail) правильно';
  smsg3 := 'Программа зарегистрирована!';
  smsg4 := '    Спасибо за покупку!';
  smsg5 := 'Неверен логин или пароль';
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
