unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls,
  frxClass, frxExportBaseDialog, frxExportZPL, IniFiles, frxPrinter, Printers, WinSpool;



const
  configFileName = 'config.ini';

type
  TForm1 = class(TForm)
    LSelect_Printer: TLabel;
    Printers: TComboBox;
    ShowZPL: TButton;
    Print: TButton;
    PageControl1: TPageControl;
    Reports: TTabSheet;
    ZPL_text: TTabSheet;
    DesignR: TButton;
    SelectR: TButton;
    ShowR: TButton;
    ZPS: TGroupBox;
    LDensity: TLabel;
    LPrinter_Init: TLabel;
    LPrinter_Finish: TLabel;
    LPage_Init: TLabel;
    LFont_Scale: TLabel;
    LFont: TLabel;
    LCode_Page: TLabel;
    Density: TComboBox;
    PrinterInit: TEdit;
    CodePage: TEdit;
    PrinterFinish: TEdit;
    PageInit: TEdit;
    FontScale: TEdit;
    Font: TEdit;
    PrintAB: TCheckBox;
    Memo1: TMemo;
    LoadFF: TButton;
    LRepName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SelectRClick(Sender: TObject);
    procedure DesignRClick(Sender: TObject);
    procedure ShowRClick(Sender: TObject);
    procedure ShowZPLClick(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure LoadFFClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Ini: Tinifile;
    isPreparedReport, preview: Boolean;
    reportFileName: String;
    procedure LoadIni();
    procedure SaveIni();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DesignRClick(Sender: TObject);
var
  report: TfrxReport;
begin
  if (not isPreparedReport) then
  begin
    report := TfrxReport.Create(Form1);
    report.LoadFromFile(reportFileName);
    report.DesignReport();
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveIni();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Inherited;
  Density.ItemIndex := 1;
  Printers.Items.Assign(frxPrinters.Printers);
  if Printers.Items.Count > 0 then
  begin
    Print.Enabled := True;
    Printers.ItemIndex := 0;
  end;
  isPreparedReport := false;
  preview := false;
  Ini := TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\' + configFileName);
  LoadIni();
end;

procedure TForm1.LoadFFClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Form1);
  OpenDialog.InitialDir := ExtractFileDir(ParamStr(0));
  openDialog.Filter := 'ZPL File (*.zpl)|*.zpl|Text File (*.txt)|*.txt;';
  if openDialog.Execute() then
    Memo1.Lines.LoadFromFile(openDialog.FileName)
end;

procedure TForm1.PrintClick(Sender: TObject);
var
  report: TfrxReport;
  zplexp: TfrxZPLExport;
  stream: TMemoryStream;
begin
  SaveIni();
  if(PageControl1.TabIndex = 0) then
  begin
    if (reportFileName = '') then
      SelectR.Click()
    else
    begin
      report := TfrxReport.Create(Form1);
      zplexp := TfrxZPLExport.Create(Form1);
      if not isPreparedReport then
      begin
        report.LoadFromFile(reportFileName);
        report.PrepareReport();
      end
      else
        report.PreviewPages.LoadFromFile(reportFileName);
      zplExp.ZplDensity := TZplDensity(Density.ItemIndex);
      zplExp.PrinterInit := PrinterInit.Text;
      zplExp.PrinterFinish := PrinterFinish.Text;
      zplExp.CodePage := CodePage.Text;
      zplExp.PageInit := PageInit.Text;
      zplExp.FontScale := StrToFloat(FontScale.Text);
      zplExp.PrinterFont := Font.Text;
      zplExp.PrintAsBitmap := PrintAB.Checked;
      stream := TMemoryStream.Create();
      zplExp.Stream := stream;
      report.Export(zplExp);
      stream.Position := 0;
      Memo1.Lines.LoadFromStream(stream);
      if not preview then
        WriteToPrinter(Printers.ItemIndex, Printers.Text, Memo1.Text);
    end;
  end
  else
  begin
  WriteToPrinter(Printers.ItemIndex, Printers.Text, Memo1.Text);
  end;
end;

procedure TForm1.SelectRClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Form1);
  OpenDialog.InitialDir := ExtractFileDir(ParamStr(0));
  openDialog.Filter := 'Report File (*.fr3)|*.fr3|Prepared Report File (*.fp3)|*.fp3;';
  if openDialog.Execute() then
  begin
    reportFileName := openDialog.FileName;
    LRepName.Caption := ExtractFileName(reportFileName);
    LRepName.Visible := True;
    isPreparedReport := (ExtractFileExt(reportFileName) = '.fp3');
    DesignR.Enabled := not isPreparedReport;
    ShowR.Enabled := true;
  end;
end;

procedure TForm1.ShowRClick(Sender: TObject);
var
  report: TfrxReport;
begin
  report := TfrxReport.Create(Form1);
  if not isPreparedReport then
  begin
    report.LoadFromFile(reportFileName);
    report.PrepareReport();
  end
  else
    report.PreviewPages.LoadFromFile(reportFileName);
  report.ShowPreparedReport;
end;

procedure TForm1.ShowZPLClick(Sender: TObject);
begin
  preview := True;
  Print.Click();
  preview := False;
  PageControl1.TabIndex := 1;

end;

procedure TForm1.LoadIni();
begin
  Density.ItemIndex := Ini.ReadInteger('Settings', 'Density', 1);
  PrinterInit.Text := Ini.ReadString('Settings', 'PrinterInit', '');
  CodePage.Text := Ini.ReadString('Settings', 'CodePage', '^PW464^LS0');
  PrinterFinish.Text := Ini.ReadString('Settings', 'PrinterFinish', '');
  PageInit.Text := Ini.ReadString('Settings', 'PageInit', '');
  FontScale.Text := Ini.ReadString('Settings', 'FontScale', '1,00');
  Font.Text := Ini.ReadString('Settings', 'Font', 'U');
  PrintAB.Checked := Ini.ReadBool('Settings', 'PrintAB', True);
end;

procedure TForm1.SaveIni();
begin
  Ini.WriteInteger('Settings', 'Density', Density.ItemIndex);
  Ini.WriteString ('Settings', 'PrinterInit', PrinterInit.Text);
  Ini.WriteString ('Settings', 'CodePage', CodePage.Text);
  Ini.WriteString ('Settings', 'PrinterFinish', PrinterFinish.Text);
  Ini.WriteString ('Settings', 'PageInit', PageInit.Text);
  Ini.WriteString ('Settings', 'FontScale', FontScale.Text);
  Ini.WriteString ('Settings', 'Font', Font.Text);
  Ini.WriteBool   ('Settings', 'PrintAB', PrintAB.Checked);
end;

end.
