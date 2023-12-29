program FRClientSimple;

uses
  Forms,
  main in 'main.pas' {main};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FastReport Simple Client Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
