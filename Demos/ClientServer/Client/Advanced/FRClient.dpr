program FRClient;

uses
  Forms,
  main in 'main.pas' {main};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FastReport Client Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
