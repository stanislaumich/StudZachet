program Zachetka;

uses
  Vcl.Forms,
  UMainWin in 'UMainWin.pas' {UMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUMain, UMain);
  Application.Run;

end.
