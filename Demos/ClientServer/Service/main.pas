unit main;

{$I frx.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  frxServer, DB, ADODB, frxClass, frxADOComponents, frxDBSet, frxGZip,
  frxDCtrl, frxDMPExport, frxGradient, frxChBox, frxCross, frxRich,
  frxChart, frxBarcode, frxServerUtils, ActiveX, Registry, IniFiles, frxUtils,
  frxServerConfig;

type
  TFastReport = class(TService)
    ADOConnection: TADOConnection;
    Serv: TfrxReportServer;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxChartObject1: TfrxChartObject;
    frxRichObject1: TfrxRichObject;
    frxCrossObject1: TfrxCrossObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxGradientObject1: TfrxGradientObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxDialogControls1: TfrxDialogControls;
    frxGZipCompressor1: TfrxGZipCompressor;
    frxADOComponents1: TfrxADOComponents;
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  FastReport: TFastReport;
  dbMd: String;

implementation

uses ComObj;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  FastReport.Controller(CtrlCode);
end;

function TFastReport.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TFastReport.ServiceStart(Sender: TService; var Started: Boolean);
begin
  ADOConnection.ConnectionString := ServerConfig.GetValue('server.database.connectionstring');
  CoInitialize(nil);
  try
    ADOConnection.Open;
  except
    LogMessage('Database connection error');
  end;
  if ADOConnection.Connected then
  begin
    Serv.Open;
  end else
    LogMessage('Database not connected');
  Started := True;
end;

procedure TFastReport.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  if ADOConnection.Connected then
    ADOConnection.Close;
  Serv.Close;
  Stopped := True;
end;

procedure TFastReport.ServicePause(Sender: TService; var Paused: Boolean);
begin
  Serv.Close;
  Paused := True;
end;

procedure TFastReport.ServiceExecute(Sender: TService);
begin
  while not Terminated do
  begin
    ServiceThread.ProcessRequests(True);
    Sleep(100);
  end;
end;

procedure TFastReport.ServiceContinue(Sender: TService; var Continued: Boolean);
begin
  Serv.Open;
  Continued := True;
end;

procedure TFastReport.ServiceAfterInstall(Sender: TService);
var
  Registry: TRegistry;
  key: String;
begin
  Registry  := TRegistry.Create;
  try
{$IFNDEF Delphi4}
    Registry.Access := KEY_READ;
{$ENDIF}
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    key := 'System\CurrentControlSet\Services\' + Name;
    if Registry.KeyExists(key) then
    begin
{$IFNDEF Delphi4}
      Registry.Access := KEY_WRITE;
{$ENDIF}
      Registry.OpenKey(key, True);
      Registry.WriteString('Description', 'FastReport Server service. http://www.fast-report.com');
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

end.
