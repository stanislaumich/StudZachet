
{******************************************}
{                                          }
{             FastReport v5.0              }
{      FastReport simple client demo       }
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
  {$IFNDEF Delphi12}frxExportTXT, {$ENDIF} frxGradient, Graphics
{$IFDEF Delphi6}
, Variants
{$ENDIF};

type
  TMainForm = class(TForm)
    frxServerConnection1: TfrxServerConnection;
    frxReportClient1: TfrxReportClient;
    Memo1: TMemo;
    Label3: TLabel;
    ShowBtn: TButton;
    CloseBtn: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Port: TEdit;
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
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    frxHTMLExport1: TfrxHTMLExport;
    frxXLSExport1: TfrxXLSExport;
    frxRTFExport1: TfrxRTFExport;
    frxPDFExport1: TfrxPDFExport;
    Label14: TLabel;
    Label15: TLabel;
    Panel2: TPanel;
    Host: TEdit;
    Label1: TLabel;
    RepName: TEdit;
    Label2: TLabel;
    Label6: TLabel;
    Param1: TEdit;
    Param1Value: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Param2: TEdit;
    Param2Value: TEdit;
    procedure CloseBtnClick(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{$IFDEF Delphi7}
uses  XPMan;
{$ENDIF}

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ShowBtnClick(Sender: TObject);
begin
  frxServerConnection1.Host := Host.Text;
  frxServerConnection1.Port := StrToInt(Port.Text);
  frxServerConnection1.Login := Login.Text;
  frxServerConnection1.Password := Password.Text;
  frxReportClient1.LoadFromFile(RepName.Text);
  frxReportClient1.Variables.Clear;
  if Length(Param1Value.Text) > 0 then
    frxReportClient1.Variables[Param1.Text] := Param1Value.Text;
  if Length(Param2Value.Text) > 0 then
    frxReportClient1.Variables[Param2.Text] := Param2Value.Text;
  if frxReportClient1.PrepareReport then
    frxReportClient1.ShowPreparedReport;
  Memo1.Lines.AddStrings(frxReportClient1.Errors);
end;

procedure TMainForm.Label11Click(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow, 'open', PChar(Label11.Caption), nil, nil, SW_SHOW);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Label14.Caption := #174;
  Label15.Caption := #169 + label15.Caption;
end;

end.
