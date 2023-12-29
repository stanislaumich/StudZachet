program frxserv;

uses
  SvcMgr,
  main in 'main.pas' {FastReport: TService};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFastReport, FastReport);
  Application.Run;
end.
