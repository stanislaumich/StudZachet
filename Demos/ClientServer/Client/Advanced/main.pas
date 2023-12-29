
{******************************************}
{                                          }
{             FastReport v5.0              }
{          FastReport client demo          }
{         Copyright (c) 1998-2014          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit main;

{$I frx.inc}

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, frxClass, frxServerClient,
  frxGZip, frxDCtrl, frxChBox, frxCross, frxRich, frxChart,
  frxOLE, frxBarcode, ExtCtrls, frxExportPDF, frxExportImage,
  frxExportRTF, frxExportXML, frxExportXLS, frxExportHTML,
  {$IFNDEF Delphi12}frxExportTXT, {$ENDIF} frxGradient, Graphics, ComCtrls, Menus, ImgList
{$IFDEF Delphi6}
, Variants
{$ENDIF}
, frxExportMail, frxExportText, frxExportCSV;

type
  TMainForm = class(TForm)
    frxServerConnection1: TfrxServerConnection;
    TestBtn: TButton;
    Log: TMemo;
    Rep: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ShowBtn: TButton;
    CloseBtn: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Port: TEdit;
    Threads: TEdit;
    Label6: TLabel;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxOLEObject1: TfrxOLEObject;
    frxChartObject1: TfrxChartObject;
    frxRichObject1: TfrxRichObject;
    frxCrossObject1: TfrxCrossObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxDialogControls1: TfrxDialogControls;
    Label7: TLabel;
    Login: TEdit;
    Label8: TLabel;
    Password: TEdit;
    StopBtn: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Image1: TImage;
    frxGradientObject1: TfrxGradientObject;
    frxHTMLExport1: TfrxHTMLExport;
    frxXLSExport1: TfrxXLSExport;
    frxXMLExport1: TfrxXMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxBMPExport1: TfrxBMPExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxTIFFExport1: TfrxTIFFExport;
    frxPDFExport1: TfrxPDFExport;
    ProxyHost: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    ProxyPort: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Panel2: TPanel;
    Panel4: TPanel;
    Host: TEdit;
    ReportsTree: TTreeView;
    Description: TMemo;
    Label16: TLabel;
    Panel5: TPanel;
    ExportBtn: TButton;
    Label17: TLabel;
    Panel10: TPanel;
    ConnectBtn: TButton;
    Panel11: TPanel;
    Panel9: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Label18: TLabel;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    frxReportClient1: TfrxReportClient;
    ImageList1: TImageList;
    frxCSVExport1: TfrxCSVExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    frxMailExport1: TfrxMailExport;
    procedure TestBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StopBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label11Click(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure ReportsTreeChange(Sender: TObject; Node: TTreeNode);
    procedure ReportsTreeCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ExportBtnClick(Sender: TObject);
  private
    ThreadList: TList;
    ReportsList: TStringList;
    procedure ClearThreads;
  end;

  TfrxClientTestThread = class (TThread)
  protected
    procedure Execute; override;
  private
    CountRep: Integer;
    ErrorsCount: Integer;
    Log: TMemo;
    ThreadID: Integer;
    FConnection: TfrxServerConnection;
    FRepName: String;
    procedure AppendLog;
    procedure FinishLog;
  public
    Report: TfrxReportClient;
    Done: Boolean;
    constructor Create(C: TfrxServerConnection; RepName: String;
        Id: Integer; Rep: Integer; L: TMemo);
  end;

var
  MainForm: TMainForm;

implementation

{$IFDEF Delphi7}
uses  XPMan;
{$ENDIF}

{$R *.dfm}

procedure TMainForm.TestBtnClick(Sender: TObject);
var
  i, j, k: Integer;
  Thread: TfrxClientTestThread;
  s: String;
begin
  frxServerConnection1.Host := Host.Text;
  frxServerConnection1.Port := StrToInt(Port.Text);
  frxServerConnection1.Login := Login.Text;
  frxServerConnection1.Password := Password.Text;
  if (Length(ProxyHost.Text) > 0) then
  begin
    frxServerConnection1.ProxyHost := ProxyHost.Text;
    frxServerConnection1.ProxyPort := StrToInt(ProxyPort.Text);
  end;
  ClearThreads;
  j := StrToInt(Threads.Text);
  k := StrToInt(Rep.Text);
  i := Integer(ReportsTree.Selected.Data);
  if i <> -1 then
  begin
    Log.Lines.Add('Start test');
    s := ReportsList[i + 1];
    for i := 1 to j do
    begin
      Thread := TfrxClientTestThread.Create(frxServerConnection1, s, i, k, Log);
      ThreadList.Add(Thread);
    end;
  end;
end;

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ShowBtnClick(Sender: TObject);
var
  t: Cardinal;
  tf: Double;
  i: Integer;
begin
  frxServerConnection1.Host := Host.Text;
  frxServerConnection1.Port := StrToInt(Port.Text);
  frxServerConnection1.Login := Login.Text;
  frxServerConnection1.Password := Password.Text;
  if (Length(ProxyHost.Text) > 0) then
  begin
    frxServerConnection1.ProxyHost := ProxyHost.Text;
    frxServerConnection1.ProxyPort := StrToInt(ProxyPort.Text);
  end;
  i := Integer(ReportsTree.Selected.Data);
  if i <> -1 then
  begin
    frxReportClient1.LoadFromFile(ReportsList[i + 1]);
    t := GetTickCount;
    if frxReportClient1.PrepareReport then
    begin
      tf := (GetTickCount - t) / 1000;
      Log.Lines.Add(frxReportClient1.ReportName +
        ' Time=' + FloatToStr(tf) + ' Size=' + IntToStr(frxReportClient1.Client.StreamSize));
      frxReportClient1.ShowPreparedReport;
    end;
    Log.Lines.AddStrings(frxReportClient1.Errors);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Label14.Caption := #174;
  Label15.Caption := #169 + Label15.Caption;
  ThreadList := TList.Create;
  ReportsList := TStringList.Create;
end;

procedure TMainForm.ClearThreads;
var
  i: Integer;
begin
  for i := 0 to ThreadList.Count - 1 do
    if Assigned(TfrxClientTestThread(ThreadList[i])) then
    begin
      TfrxClientTestThread(ThreadList[i]).Terminate;
      TfrxClientTestThread(ThreadList[i]).Free;
    end;
  ThreadList.Clear;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ReportsList.Free;
  ClearThreads;
  ThreadList.Free;
end;

procedure TMainForm.StopBtnClick(Sender: TObject);
begin
  ClearThreads;
end;

procedure TMainForm.ListBox1DblClick(Sender: TObject);
begin
  ShowBtnClick(Sender);
end;

procedure TMainForm.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    ShowBtnClick(Sender);
end;

procedure TMainForm.Label11Click(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow, 'open', PChar(Label11.Caption), nil, nil, SW_SHOW);
end;

procedure TMainForm.ConnectBtnClick(Sender: TObject);
var
  t: Cardinal;
  tf: Double;
  s, s1: String;
  AccessFlag: Boolean;
  i: Integer;
  Node: TTreeNode;
  TopNode: TTreeNode;
  OldName: String;

begin
  ReportsTree.Items.Clear;
  ReportsList.Clear;
  Log.Clear;

  frxServerConnection1.Host := Host.Text;
  frxServerConnection1.Port := StrToInt(Port.Text);
  frxServerConnection1.Login := Login.Text;
  frxServerConnection1.Password := Password.Text;
  if (Length(ProxyHost.Text) > 0) then
  begin
    frxServerConnection1.ProxyHost := ProxyHost.Text;
    frxServerConnection1.ProxyPort := StrToInt(ProxyPort.Text);
  end;
  t := GetTickCount;
  Log.Lines.Text := Log.Lines.Text +
    frxReportClient1.GetServerVariable('SERVER_NAME');
  tf := (GetTickCount - t) / 1000;
  if frxReportClient1.Errors.Count = 0 then
  begin
    Log.Lines.Text := Log.Lines.Text +
      'Version: ' + frxReportClient1.GetServerVariable('SERVER_SOFTWARE');
    Log.Lines.Text := Log.Lines.Text +
      'From: ' + frxReportClient1.GetServerVariable('SERVER_LAST_UPDATE');
    Log.Lines.Text := Log.Lines.Text +
      'Uptime: ' + frxReportClient1.GetServerVariable('SERVER_UPTIME');
    Log.Lines.Add('Ping:' + FloatToStr(tf) + 'ms.');
  end;
  Log.Lines.AddStrings(frxReportClient1.Errors);

  AccessFlag :=  frxReportClient1.Errors.Count = 0;

  if AccessFlag then
  begin
    ReportsList.Text := frxReportClient1.GetServerVariable('SERVER_REPORTS_LIST');
    if ReportsList.Count > 0 then
    begin
      ReportsTree.Items.BeginUpdate;
      TopNode := nil;
      Oldname := '';
      for i := 0 to (ReportsList.Count div 3) - 1 do
      begin
        s := ReportsList[(i * 3) + 1];
        s := StringReplace(StringReplace(s, ExtractFileName(s), '', []), '\', ' ', [rfReplaceAll]);
        if s <> OldName then
        begin
          if s = '' then
            s1 := 'Reports'
          else
            s1 := s;
          Node := ReportsTree.Items.AddChild(nil, s1);
          Node.Data := Pointer(-1);
          Node.ImageIndex := 0;
          TopNode := Node;
          OldName := s;
        end;
        Node := ReportsTree.Items.AddChild(TopNode, ReportsList[i * 3]);
        Node.Data := Pointer((i * 3));
        Node.ImageIndex := 1;
      end;
      ReportsTree.Items.EndUpdate;
      ReportsTree.TopItem := ReportsTree.Items[0];
      ReportsTree.Selected := ReportsTree.Items[0];
      ReportsTree.SetFocus;
    end else
      Log.Lines.Add('Nothing reports is available or information restricted.');
  end;
end;

procedure TMainForm.Clear1Click(Sender: TObject);
begin
  Log.Clear;
end;

procedure TMainForm.ReportsTreeChange(Sender: TObject; Node: TTreeNode);
var
  i: Integer;
begin
  i := Integer(Node.Data);
  if i <> -1 then
    Description.Text := ReportsList[i + 2]
  else
    Description.Text := Node.Text;
  ShowBtn.Enabled := i <> -1;
  ExportBtn.Enabled := ShowBtn.Enabled;
  TestBtn.Enabled := ShowBtn.Enabled;
end;

procedure TMainForm.ReportsTreeCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.Count <> 0 then
    ReportsTree.Canvas.Font.Style := [fsBold];
end;

procedure TMainForm.ExportBtnClick(Sender: TObject);
var
  t: Cardinal;
  tf: Double;
  i: Integer;
begin
  frxServerConnection1.Host := Host.Text;
  frxServerConnection1.Port := StrToInt(Port.Text);
  frxServerConnection1.Login := Login.Text;
  frxServerConnection1.Password := Password.Text;
  if (Length(ProxyHost.Text) > 0) then
  begin
    frxServerConnection1.ProxyHost := ProxyHost.Text;
    frxServerConnection1.ProxyPort := StrToInt(ProxyPort.Text);
  end;
  i := Integer(ReportsTree.Selected.Data);
  if i <> -1 then
  begin
    frxReportClient1.LoadFromFile(ReportsList[i + 1]);
    t := GetTickCount;
    if frxReportClient1.PrepareReport then
    begin
      tf := (GetTickCount - t) / 1000;
      Log.Lines.Add(frxReportClient1.ReportName +
        ' Time=' + FloatToStr(tf) + ' Size=' + IntToStr(frxReportClient1.Client.StreamSize));
      frxReportClient1.Export(frxPDFExport1);
    end;
    Log.Lines.AddStrings(frxReportClient1.Errors);
  end;
end;

{ TfrxClientTestThread }

constructor TfrxClientTestThread.Create(C: TfrxServerConnection; RepName: String;
    Id: Integer; Rep: Integer; L: TMemo);
begin
  inherited Create(True);
  ErrorsCount := 0;
  ThreadId := Id;
  CountRep := Rep;
  FConnection := C;
  FRepName := RepName;
  Log := L;
  Done := False;
  Resume;
end;

procedure TfrxClientTestThread.Execute;
var
 i: Integer;
begin
  Done := False;
  Report := TfrxReportClient.Create(nil);
  Report.EngineOptions.EnableThreadSafe := True;
  Report.ShowProgress := False;
  Report.EngineOptions.SilentMode := True;
  Report.Connection := FConnection;
  Report.ReportName := FRepName;
  i := 0;
  while (i < CountRep) and (not Terminated) do
  begin
    Report.Clear;
    Report.PrepareReport;
    Synchronize(AppendLog);
    ErrorsCount := ErrorsCount + Report.Errors.Count;
    Inc(i);
  end;
  Synchronize(FinishLog);
  Report.Free;
  Done := True;
end;

procedure TfrxClientTestThread.AppendLog;
begin
  if Assigned(Log) and (Report.Errors.Count > 0) then
  begin
    Log.Lines.Add('Thread#' + IntToStr(ThreadID));
    Log.Lines.AddStrings(Report.Errors);
  end;
end;

procedure TfrxClientTestThread.FinishLog;
begin
  if Assigned(Log) and (not Terminated) then
    Log.Lines.Add('Thread#' + IntToStr(ThreadID) + ' finished. Errors:' + IntToStr(ErrorsCount));
end;

end.
