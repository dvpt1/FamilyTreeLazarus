unit genr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Ipfilebroker, PrintersDlgs, Forms,
  Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, StdCtrls;

type

  { TGenrForm }

  TGenrForm = class(TForm)
    BackButton: TToolButton;
    Gauge1: TProgressBar;
    HelpButton: TToolButton;
    IpFileDataProvider1: TIpFileDataProvider;
    Memo1: TMemo;
    Panel1: TPanel;
    PrintButton: TToolButton;
    PrintDialog1: TPrintDialog;
    SaveButton: TToolButton;
    SaveDialog1: TSaveDialog;
    ToolBar1: TToolBar;
    TuneButton: TToolButton;
    WebBrowser1: TIpHtmlPanel;
    procedure BackButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure GenerationAll;
    procedure GenerationPerson();
  end;

var
  GenrForm: TGenrForm;

implementation

uses main, tune, info, vars, mstring, utils;

{$R *.lfm}

procedure TGenrForm.TuneButtonClick(Sender: TObject);
begin
  TuneForm.ShowModal;
end;

procedure TGenrForm.GenerationAll;
var
  i, cnt, gnr : Integer;
  //заполн€ю координаты
  procedure ParentsAlls( Name: String; Index : Integer);
  var
    i : Integer;
    iRow : Integer;
    s : String;
  begin
    // отец или мать
    Inc(cnt);
    Inc(gnr);
    HTMLText := HTMLText + '<tr>';
    HTMLText := HTMLText + '<td align="center">' + IntToStr(cnt) + '</td>';
    HTMLText := HTMLText + '<td align="center"><b>' + LatToRim(gnr) + '</b></td>';
    HTMLText := HTMLText + '<td>';
    {
    s := '';
    if FileExistsUTF8(MainPathBMP+Name+'.jpg') then
      HTMLText := HTMLText + '<img src="'+MainPathBMP+Name+'.jpg" width="64" height="64" align=left alt="'+s+'">'
    else
      HTMLText := HTMLText + '<img src="'+MainPathEXE+'empty.gif" align=left alt="'+s+'">';
    }
    HTMLText := HTMLText + '<b>' + Name + '</b><br>';
    if (not Empty(listBirth.Strings[Index])) then
      HTMLText := HTMLText + field_birth +' '+ Trim(listBirth.Strings[Index]) + '<br>';
    if (not Empty(listPlaceb.Strings[Index])) then
      HTMLText := HTMLText + field_placeb +' '+ Trim(listPlaceb.Strings[Index]) + '<br>';
    if (not Empty(listDeath.Strings[Index])) then
      HTMLText := HTMLText + field_death +' '+ Trim(listDeath.Strings[Index]) + '<br>';
    if (not Empty(listPlaced.Strings[Index])) then
      HTMLText := HTMLText + field_placed +' '+ Trim(listPlaced.Strings[Index]) + '<br>';
    s := MainPathTXT+Trim(Name)+'.txt';
    if FileExists(s) then begin
      {$IFDEF WINDOWS}
      Memo1.Lines.LoadFromFile(UTF8toANSI(s));
      {$ENDIF}
      {$IFDEF UNIX}
      Memo1.Lines.LoadFromFile(s);
      {$ENDIF}
      HTMLText := HTMLText + '<i>';
      for i := 0 to Memo1.Lines.Count - 1 do begin
        if not Empty(Memo1.Lines.Strings[i]) then
        HTMLText := HTMLText + Memo1.Lines.Strings[i] + '<br>';
      end;
      HTMLText := HTMLText + '</i>';
    end;
    HTMLText := HTMLText + '</td></tr>';
    for iRow := 0 to listMans.Count - 1 do begin
      // ищу всех детей мужской линии
      if listGender.Strings[Index] = Man then begin
        if listFather.Strings[iRow] = Name then begin
          ParentsAlls(listMans.Strings[iRow], iRow);
        end;
      end;
      // ищу всех детей женской линии
      if listGender.Strings[Index] = Woman then begin
        if listMother.Strings[iRow] = Name then begin
          ParentsAlls(listMans.Strings[iRow], iRow);
        end;
      end;
    end;
    Dec(gnr);
  end;
begin
// рисую отчет
  WebBrowser1.Cursor := crHourGlass;
  HTMLText := '<html><head>';
  HTMLText := HTMLText + '<meta http-equiv="Content-Type" content="text/html; charset=UTF8-8">';
  HTMLText := HTMLText + '</head><body>';
//показываю процесс
  Gauge1.Visible := True;
  Gauge1.Max := listMans.Count;
//заполн€ю координаты
  for i := 0 to listMans.Count - 1 do begin
    Gauge1.Position := i;
    Application.ProcessMessages;
    cnt := 0;
    gnr := 0;
    if ((Empty(listFather.Strings[i]))
     and (Empty(listMother.Strings[i]))) then begin
      // сканирую только мужские линии
      if ((Empty(listFather.Strings[i])) and (Empty(listMother.Strings[i]))) then
      if listGender.Strings[i] = Man then begin//родоначальник
        HTMLText := HTMLText + '<h2>' + listMans.Strings[i] + '</h2>';
        HTMLText := HTMLText + '<table border="1" style="BORDER-TOP: 2pt solid; BORDER-BOTTOM: 2pt solid; BORDER-RIGHT: 2pt solid; BORDER-LEFT: 2pt solid" width="100%">';
        HTMLText := HTMLText + '<tr>';
        HTMLText := HTMLText + '<td width="5%" align="center">' + 'NN' + '</td>';
        HTMLText := HTMLText + '<td width="10%" align="center">' + CaptionGener + '</td>';
        HTMLText := HTMLText + '<td width="85%" align="center">' + field_name + '</td>';
        HTMLText := HTMLText + '</tr>';
        ParentsAlls(listMans.Strings[i], i);
        HTMLText := HTMLText + '</table>';
      end;
    end;
  end;
//
  HTMLText := HTMLText + '</body></html>';
  WebBrowser1.SetHtmlFromStr(HTMLText);
  Application.ProcessMessages;
  Gauge1.Visible := False;// закрытие окна процесса
  WebBrowser1.Cursor := crDefault;
end;

procedure TGenrForm.GenerationPerson();
var
  i,ii,iii : Integer;
  s,ss,sss : String;
  b : Boolean;
begin
// рисую отчет
  WebBrowser1.Cursor := crHourGlass;
  HTMLText := '<html><head>';
  HTMLText := HTMLText + '<meta http-equiv="Content-Type" content="text/html; charset=UTF8-8">';
  HTMLText := HTMLText + '</head><body>';
  HTMLText := HTMLText + '<table><tr><td><b>';
  HTMLText := HTMLText + '<H2>' + listMans.Strings[GridRow] + '</H2><hr>';
  {
  s := '';
  if FileExistsUTF8(MainPathBMP + listMans.Strings[GridRow] + '.jpg') then
    HTMLText := HTMLText + '<img src="'+MainPathBMP + listMans.Strings[GridRow] + '.jpg" width="64" height="64" align=left alt="'+s+'">'
  else
    HTMLText := HTMLText + '<img src="'+MainPathEXE+'empty.gif" align=left alt="'+s+'">';
  }
  if not Empty(listBirth.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_birth + ' ' + listBirth.Strings[GridRow] + '<br>';
  end;
  if not Empty(listPlaceb.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_placeb + ' '+ listPlaceb.Strings[GridRow] + '<br>';
  end;
  if not Empty(listFather.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_father + '<br>';
    HTMLText := HTMLText + listFather.Strings[GridRow] + '<br>';
  end;
  if not Empty(listMother.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_mother + '<br>';
    HTMLText := HTMLText + listMother.Strings[GridRow] + '<br>';
  end;
//показываю процесс
  Gauge1.Visible := True;
  Gauge1.Max := listMans.Count;
  b := False;
  if listGender.Strings[GridRow] = Man then begin
   for i := 0 to listMans.Count - 1 do begin
    Gauge1.Position := i;
    Application.ProcessMessages;
    if i <> GridRow then
    if listFather.Strings[ i] = listMans.Strings[GridRow] then begin
      if not b then begin
        HTMLText := HTMLText + '<br>';
        HTMLText := HTMLText + field_child + '<br>';
        b := True;
      end;
      if not Empty(listBirth.Strings[ i])
        then HTMLText := HTMLText + listMans.Strings[ i]+' ('+listBirth.Strings[ i]+')' + '<br>'
        else HTMLText := HTMLText + listMans.Strings[ i] + '<br>';
    end;
   end;
  end else begin
   for i := 0 to listMans.Count - 1 do begin
    Gauge1.Position := i;
    Application.ProcessMessages;
    if i <> GridRow then
    if listMother.Strings[ i] = listMans.Strings[GridRow] then begin
      if not b then begin
        HTMLText := HTMLText + '<br>';
        HTMLText := HTMLText + field_child + '' + '<br>';
        b := True;
      end;
      if not Empty(listBirth.Strings[ i])
        then HTMLText := HTMLText + listMans.Strings[ i]+' ('+listBirth.Strings[ i]+')' + '<br>'
        else HTMLText := HTMLText + listMans.Strings[ i] + '<br>';
    end;
   end;
  end;
  if not Empty(listDeath.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_death + ' ' + listDeath.Strings[GridRow] + '<br>';
  end;
  if not Empty(listPlaced.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_placed + ' ' + listPlaced.Strings[GridRow] + '<br>';
  end;
// муж-жена
  if not Empty(listSpouse.Strings[GridRow]) then begin
     HTMLText := HTMLText + '<br>';
     if listGender.Strings[GridRow] = Man then HTMLText := HTMLText + field_wife + '<br>';
     if listGender.Strings[GridRow] = Woman then HTMLText := HTMLText + field_husband + '<br>';
     ss := listSpouse.Strings[GridRow];
     repeat
        ii := Pos(rzd2, ss);
        if ii > 0 then begin
          s := Copy(ss,1,ii-1);
          ss := Copy(ss,ii+1,Length(ss));
        end else
          s := ss;
        if not Empty(s) then begin
          sss := s;
          iii := Pos(rzd3, sss);
          if iii > 0 then begin
            s := Copy(sss,1,iii-1);
            sss := Copy(sss,iii+1,Length(sss));
          end else
            s := sss;
          if not Empty(s) then begin
            HTMLText := HTMLText + '<li>' + s + '<br>';
            iii := Pos(rzd3, sss);
            if iii > 0 then begin
              if not Empty(Copy(sss,1,iii-1)) then
                HTMLText := HTMLText + field_wedding + ' ' + Copy(sss,1,iii-1) + '<br>';
              if not Empty(Copy(sss,iii+1,Length(sss))) then
                HTMLText := HTMLText + field_placew + ' ' + Copy(sss,iii+1,Length(sss)) + '<br>';
            end;
          end;
        end;
     until ii = 0;
     HTMLText := HTMLText + '<br>';
  end;
// национальность
  if not Empty(listNati.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_nati+' '+listNati.Strings[GridRow] + '<br>';
  end;
// де€тельность
  if not Empty(listOccu.Strings[GridRow]) then begin
    HTMLText := HTMLText + '<br>';
    HTMLText := HTMLText + field_occu+' '+listOccu.Strings[GridRow] + '<br>';
  end;
// биографи€
  s := MainPathTXT + listMans.Strings[GridRow] + '.txt';
  if FileExists(s) then begin
    {$IFDEF WINDOWS}
    Memo1.Lines.LoadFromFile(UTF8toANSI(s));
    {$ENDIF}
    {$IFDEF UNIX}
    Memo1.Lines.LoadFromFile(s);
    {$ENDIF}
    if (not empty(Memo1.Text)) then begin
      HTMLText := HTMLText + '<hr>';
      for i := 0 to Memo1.Lines.Count-1 do begin
        HTMLText := HTMLText + Memo1.Lines.Strings[i] + '<br>';
      end;
    end;
  end;
//
  HTMLText := HTMLText + '</b></td></tr></table>';
  HTMLText := HTMLText + '</body></html>';
//вывожу на экран
  WebBrowser1.SetHtmlFromStr(HTMLText);
  Application.ProcessMessages;
//
  Gauge1.Visible := False;// закрытие окна процесса
  WebBrowser1.Cursor := crDefault;
end;

procedure TGenrForm.HelpButtonClick(Sender: TObject);
begin
  InfoStart.ShowModal;
end;

procedure TGenrForm.BackButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TGenrForm.PrintButtonClick(Sender: TObject);
var
  vaIn, vaOut: OleVariant;
begin
  //if (PrintDialog1.Execute) then
  //??WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vaIn, vaOut);
end;

procedure TGenrForm.SaveButtonClick(Sender: TObject);
var
  FileHTML : TextFile;
  i : Integer;
  s : String;
begin
  SaveDialog1.DefaultExt := '*.html';
  SaveDialog1.Filter := '*.html|*.html;*.htm|*.htm';
  SaveDialog1.FileName := 'Generation.html';
  if SaveDialog1.Execute then begin
    AssignFile(FileHTML, SaveDialog1.FileName);
    {$I-}
    ReWrite(FileHTML);
    {$I+}
    Writeln(FileHTML, HTMLText);
    CloseFile(FileHTML);
  end;
end;

end.

