; Скрипт создан: Мастер скриптов Inno Setup.

#define MyAppId "FamilyTree"
#define MyAppName "FamilyTree"
#define MyAppVersion "1"
#define MyAppVerName "The Family Tree of Family, Version 1.0.1"
#define MyAppPublisher "Perun, Ltd"
#define MyAppURL "http://www.familytree.ru"
#define MyAppIs "FamilyTree_is1"

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\FamilyTree
DefaultGroupName=The Family Tree
AllowNoIcons=yes
UninstallDisplayIcon=yes
LicenseFile=hlp\License.txt
InfoBeforeFile=hlp\ReadMe.txt
InfoAfterFile=hlp\FamilyTree.txt
; uncomment the following line if you want your installation to run on NT 3.51 too.
; MinVersion=4,3.51
ShowLanguageDialog=yes

;[LangOptions]
;LanguageCodePage=0

[Languages]
Name: en; MessagesFile: "compiler:Default.isl"
Name: rs; MessagesFile: "compiler:Languages\Russian.isl"
Name: de; MessagesFile: "compiler:Languages\German.isl"
Name: fr; MessagesFile: "compiler:Languages\French.isl"
Name: es; MessagesFile: "compiler:Languages\Spanish.isl"
Name: pr; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: ca; MessagesFile: "compiler:Languages\Catalan.isl"
Name: cz; MessagesFile: "compiler:Languages\Czech.isl"
Name: da; MessagesFile: "compiler:Languages\Danish.isl"
Name: du; MessagesFile: "compiler:Languages\Dutch.isl"
Name: fi; MessagesFile: "compiler:Languages\Finnish.isl"
Name: he; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: hu; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: it; MessagesFile: "compiler:Languages\Italian.isl"
Name: no; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: po; MessagesFile: "compiler:Languages\Polish.isl"
;Name: sk; MessagesFile: "compiler:Languages\Slovak.isl"
Name: sn; MessagesFile: "compiler:Languages\Slovenian.isl"

[Messages]
en.BeveledLabel=English
rs.BeveledLabel=Russian
de.BeveledLabel=Deutsch
fr.BeveledLabel=Francais
es.BeveledLabel=Spanish
pr.BeveledLabel=Poruguese
ca.BeveledLabel=Catalan.isl
cz.BeveledLabel=Czech.isl
da.BeveledLabel=Danish.isl
du.BeveledLabel=Dutch.isl
fi.BeveledLabel=Finnish.isl
he.BeveledLabel=Hebrew.isl
hu.BeveledLabel=Hungarian.isl
it.BeveledLabel=Italian.isl
no.BeveledLabel=Norwegian.isl
po.BeveledLabel=Polish.isl
;sk.BeveledLabel=Slovak.isl
sn.BeveledLabel=Slovenian.isl

[CustomMessages]
en.MyDescription=My description
en.MyAppName=The Family Tree of Family
en.MyAppVerName=The Family Tree of Family %1
rs.MyDescription=Мое описание
rs.MyAppName=Генеалогическое древо семьи
rs.MyAppVerName=Генеалогическое древо семьи %1
de.MyDescription=Meine Beschreibung
de.MyAppName=Genealogisch den Baum
de.MyAppVerName=Genealogisch den Baum %1
fr.MyDescription=Ma description
fr.MyAppName=L'arbre Genealogique de la famille
fr.MyAppVerName=L'arbre Genealogique de la famille %1
es.MyDescription=Mi descripción
es.MyAppName=Árbol genealógico de la familia de
es.MyAppVerName=Árbol genealógico de la familia de %1
pr.MyDescription=Minha descrição
pr.MyAppName=Família árvore da família
pr.MyAppVerName=Família árvore da família %1
ca.MyDescription=La meva descripció
ca.MyAppName=Arbre genealògic de la família de
ca.MyAppVerName=Arbre genealògic de la família de %1
cz.MyDescription=Můj popis
cz.MyAppName=Rodokmen rodiny
cz.MyAppVerName=Rodokmen rodiny %1
da.MyDescription=Min beskrivelse
da.MyAppName=Stamtræ for familien
da.MyAppVerName=Stamtræ for familien %1
du.MyDescription=Mijn beschrijving
du.MyAppName=Stamboom van de familie
du.MyAppVerName=Stamboom van de familie %1
fi.MyDescription=Oma kuvaus
fi.MyAppName=Sukupuu perhe
fi.MyAppVerName=Sukupuu perhe %1
he.MyDescription=תיאור שלי
he.MyAppName=אילן יוחסין של המשפחה
he.MyAppVerName=אילן יוחסין של המשפחה %1
hu.MyDescription=Моят описание
hu.MyAppName=Родословно дърво на семейството
hu.MyAppVerName=Родословно дърво на семейството %1
it.MyDescription=La mia descrizione
it.MyAppName=Albero genealogico della famiglia
it.MyAppVerName=Albero genealogico della famiglia %1
no.MyDescription=Min beskrivelse
no.MyAppName=Slektstre over familien
no.MyAppVerName=Slektstre over familien %1
po.MyDescription=Mój opis
po.MyAppName=Drzewo genealogiczne rodziny
po.MyAppVerName=Drzewo genealogiczne rodziny %1
;sk.MyDescription=Môj opis
;sk.MyAppName=Rodokmeň rodiny
;sk.MyAppVerName=Rodokmeň rodiny %1
sn.MyDescription=Moj opis
sn.MyAppName=Družinsko drevo družine
sn.MyAppVerName=Družinsko drevo družine %1

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; MinVersion: 4,4
Name: "quicklaunchicon"; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; MinVersion: 4,4; Flags: unchecked

[Dirs]
Name: "{app}\res"
Name: "{app}\res\values-bg"
Name: "{app}\res\values-by"
Name: "{app}\res\values-ca"
Name: "{app}\res\values-cn"
Name: "{app}\res\values-cz"
Name: "{app}\res\values-de"
Name: "{app}\res\values-dk"
Name: "{app}\res\values-en"
Name: "{app}\res\values-es"
Name: "{app}\res\values-fi"
Name: "{app}\res\values-fr"
Name: "{app}\res\values-gb"
Name: "{app}\res\values-ge"
Name: "{app}\res\values-gr"
Name: "{app}\res\values-hk"
Name: "{app}\res\values-hu"
Name: "{app}\res\values-id"
Name: "{app}\res\values-il"
Name: "{app}\res\values-ir"
Name: "{app}\res\values-it"
Name: "{app}\res\values-jp"
Name: "{app}\res\values-kr"
Name: "{app}\res\values-lt"
Name: "{app}\res\values-nl"
Name: "{app}\res\values-no"
Name: "{app}\res\values-pl"
Name: "{app}\res\values-pt"
Name: "{app}\res\values-ro"
Name: "{app}\res\values-ru"
Name: "{app}\res\values-se"
Name: "{app}\res\values-th"
Name: "{app}\res\values-tr"
Name: "{app}\res\values-tw"
Name: "{app}\res\values-ua"
Name: "{app}\res\values-us"
Name: "{app}\res\values-vn"

[Files]
Source: "FamilyTree.exe"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "FamilyTree.lng"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "empty.gif"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "res\values-bg\strings.xml"; DestDir: "{app}\res\values-bg"; CopyMode: alwaysoverwrite
Source: "res\values-by\strings.xml"; DestDir: "{app}\res\values-by"; CopyMode: alwaysoverwrite
Source: "res\values-ca\strings.xml"; DestDir: "{app}\res\values-ca"; CopyMode: alwaysoverwrite
Source: "res\values-cn\strings.xml"; DestDir: "{app}\res\values-cn"; CopyMode: alwaysoverwrite
Source: "res\values-cz\strings.xml"; DestDir: "{app}\res\values-cz"; CopyMode: alwaysoverwrite
Source: "res\values-de\strings.xml"; DestDir: "{app}\res\values-de"; CopyMode: alwaysoverwrite
Source: "res\values-dk\strings.xml"; DestDir: "{app}\res\values-dk"; CopyMode: alwaysoverwrite
Source: "res\values-en\strings.xml"; DestDir: "{app}\res\values-en"; CopyMode: alwaysoverwrite
Source: "res\values-es\strings.xml"; DestDir: "{app}\res\values-es"; CopyMode: alwaysoverwrite
Source: "res\values-fi\strings.xml"; DestDir: "{app}\res\values-fi"; CopyMode: alwaysoverwrite
Source: "res\values-fr\strings.xml"; DestDir: "{app}\res\values-fr"; CopyMode: alwaysoverwrite
Source: "res\values-gb\strings.xml"; DestDir: "{app}\res\values-gb"; CopyMode: alwaysoverwrite
Source: "res\values-ge\strings.xml"; DestDir: "{app}\res\values-ge"; CopyMode: alwaysoverwrite
Source: "res\values-gr\strings.xml"; DestDir: "{app}\res\values-gr"; CopyMode: alwaysoverwrite
Source: "res\values-hk\strings.xml"; DestDir: "{app}\res\values-hk"; CopyMode: alwaysoverwrite
Source: "res\values-hu\strings.xml"; DestDir: "{app}\res\values-hu"; CopyMode: alwaysoverwrite
Source: "res\values-id\strings.xml"; DestDir: "{app}\res\values-id"; CopyMode: alwaysoverwrite
Source: "res\values-il\strings.xml"; DestDir: "{app}\res\values-il"; CopyMode: alwaysoverwrite
Source: "res\values-ir\strings.xml"; DestDir: "{app}\res\values-ir"; CopyMode: alwaysoverwrite
Source: "res\values-it\strings.xml"; DestDir: "{app}\res\values-it"; CopyMode: alwaysoverwrite
Source: "res\values-jp\strings.xml"; DestDir: "{app}\res\values-jp"; CopyMode: alwaysoverwrite
Source: "res\values-kr\strings.xml"; DestDir: "{app}\res\values-kr"; CopyMode: alwaysoverwrite
Source: "res\values-lt\strings.xml"; DestDir: "{app}\res\values-lt"; CopyMode: alwaysoverwrite
Source: "res\values-nl\strings.xml"; DestDir: "{app}\res\values-nl"; CopyMode: alwaysoverwrite
Source: "res\values-no\strings.xml"; DestDir: "{app}\res\values-no"; CopyMode: alwaysoverwrite
Source: "res\values-pl\strings.xml"; DestDir: "{app}\res\values-pl"; CopyMode: alwaysoverwrite
Source: "res\values-pt\strings.xml"; DestDir: "{app}\res\values-pt"; CopyMode: alwaysoverwrite
Source: "res\values-ro\strings.xml"; DestDir: "{app}\res\values-ro"; CopyMode: alwaysoverwrite
Source: "res\values-ru\strings.xml"; DestDir: "{app}\res\values-ru"; CopyMode: alwaysoverwrite
Source: "res\values-se\strings.xml"; DestDir: "{app}\res\values-se"; CopyMode: alwaysoverwrite
Source: "res\values-th\strings.xml"; DestDir: "{app}\res\values-th"; CopyMode: alwaysoverwrite
Source: "res\values-tr\strings.xml"; DestDir: "{app}\res\values-tr"; CopyMode: alwaysoverwrite
Source: "res\values-tw\strings.xml"; DestDir: "{app}\res\values-tw"; CopyMode: alwaysoverwrite
Source: "res\values-ua\strings.xml"; DestDir: "{app}\res\values-ua"; CopyMode: alwaysoverwrite
Source: "res\values-us\strings.xml"; DestDir: "{app}\res\values-us"; CopyMode: alwaysoverwrite
Source: "res\values-vn\strings.xml"; DestDir: "{app}\res\values-vn"; CopyMode: alwaysoverwrite
;;;;
;Source: "Russian.chm"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;Source: "Deutsch.chm"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;Source: "English.chm"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;Source: "Francais.chm"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;Source: "Romana.chm"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;;;Source: "Notify.exe"; DestDir: "{app}"; CopyMode: alwaysoverwrite
;;;Source: "BirthDay.wav"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "hlp\ReadMe.txt"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "hlp\License.txt"; DestDir: "{app}"; CopyMode: alwaysoverwrite
Source: "hlp\English\FamilyTree.ini"; DestDir: "{app}"; Languages: en;
Source: "hlp\Russian\FamilyTree.ini"; DestDir: "{app}"; Languages: rs;
Source: "hlp\Deutsch\FamilyTree.ini"; DestDir: "{app}"; Languages: de;
Source: "hlp\Francais\FamilyTree.ini"; DestDir: "{app}"; Languages: fr;
Source: "hlp\Spanish\FamilyTree.ini"; DestDir: "{app}"; Languages: es;
Source: "hlp\Portuguese\FamilyTree.ini"; DestDir: "{app}"; Languages: pr;
Source: "hlp\Catalan\FamilyTree.ini"; DestDir: "{app}"; Languages: ca;
Source: "hlp\Czech\FamilyTree.ini"; DestDir: "{app}"; Languages: cz;
Source: "hlp\Danish\FamilyTree.ini"; DestDir: "{app}"; Languages: da;
Source: "hlp\Dutch\FamilyTree.ini"; DestDir: "{app}"; Languages: du;
Source: "hlp\Finnish\FamilyTree.ini"; DestDir: "{app}"; Languages: fi;
Source: "hlp\Hebrew\FamilyTree.ini"; DestDir: "{app}"; Languages: he;
Source: "hlp\Hungarian\FamilyTree.ini"; DestDir: "{app}"; Languages: hu;
Source: "hlp\Italian\FamilyTree.ini"; DestDir: "{app}"; Languages: it;
Source: "hlp\Norwegian\FamilyTree.ini"; DestDir: "{app}"; Languages: no;
Source: "hlp\Polish\FamilyTree.ini"; DestDir: "{app}"; Languages: po;
;Source: "hlp\Slovak\FamilyTree.ini"; DestDir: "{app}"; Languages: sk;
Source: "hlp\Slovenian\FamilyTree.ini"; DestDir: "{app}"; Languages: sn;

[INI]
Filename: "{app}\FamilyTree.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://www.familytree.ru"

[Icons]
Name: "{group}\{cm:MyAppName}"; Filename: "{app}\FamilyTree.exe"
Name: "{group}\FamilyTree on the Web"; Filename: "{app}\FamilyTree.url"
Name: "{group}\License"; Filename: "{app}\LICENSE.TXT"
Name: "{group}\{cm:UninstallProgram,}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\FamilyTree"; Filename: "{app}\FamilyTree.exe"; MinVersion: 4,4; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\FamilyTree"; Filename: "{app}\FamilyTree.exe"; MinVersion: 4,4; Tasks: quicklaunchicon

[Run]
Filename: "{app}\FamilyTree.exe"; Description: "Launch FamilyTree"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\FamilyTree.url"
Type: files; Name: "{app}\*.xml"
Type: files; Name: "{app}\*.chm"
Type: files; Name: "{app}\*.txt"

[Code]
var
  UserPage: TInputQueryWizardPage;
  UsagePage: TInputOptionWizardPage;
  LightMsgPage: TOutputMsgWizardPage;
  KeyPage: TInputQueryWizardPage;
  ProgressPage: TOutputProgressWizardPage;
  DataDirPage: TInputDirWizardPage;
  
procedure InitializeWizard;
begin
  { Create the pages }
  
  UserPage := CreateInputQueryPage(wpWelcome,
    'Personal Information', 'Who are you?',
    'Please specify your name and the company for whom you work, then click Next.');
  UserPage.Add('Name:', False);
  UserPage.Add('Company:', False);

  { Set default values, using settings that were stored last time if possible }

  UserPage.Values[0] := GetPreviousData('Name', ExpandConstant('{sysuserinfoname}'));
  UserPage.Values[1] := GetPreviousData('Company', ExpandConstant('{sysuserinfoorg}'));

end;

function GetUser(Param: String): String;
begin
  { Return a user value }
  { Could also be split into separate GetUserName and GetUserCompany functions }
  if Param = 'Name' then
    Result := UserPage.Values[0]
  else if Param = 'Company' then
    Result := UserPage.Values[1];
end;
