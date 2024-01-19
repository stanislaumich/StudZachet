program Zachetka;

uses
  Vcl.Forms,
  UMainWin in 'UMainWin.pas' {UMain} ,
  UAskreprint in 'UAskreprint.pas' {FAskreprint};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUMain, UMain);
  Application.CreateForm(TFAskreprint, FAskreprint);
  Application.Run;

end.
