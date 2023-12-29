program FRServer;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {main};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'FastReport Server Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
