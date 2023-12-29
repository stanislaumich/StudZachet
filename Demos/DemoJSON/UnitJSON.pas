unit UnitJSON;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, Vcl.StdCtrls, frxJSON, frxTransportHTTP,DateUtils,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage, frxDesgn, frxChart,
  frxExportBaseDialog, frxExportPDF;

type
  TFormJSON = class(TForm)
    frxReport1: TfrxReport;
    JSON_DS: TfrxUserDataSet;
    ButtonConnectToJSON: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBoxName: TComboBox;
    ComboBoxResolution: TComboBox;
    DateTimePickerFrom: TDateTimePicker;
    Label4: TLabel;
    DateTimePickerTo: TDateTimePicker;
    ButtonShowReport: TButton;
    Image1: TImage;
    Label5: TLabel;
    StatusBar1: TStatusBar;
    Button1: TButton;
    frxDesigner1: TfrxDesigner;
    frxChartObject1: TfrxChartObject;
    frxPDFExport1: TfrxPDFExport;
    procedure ButtonConnectToJSONClick(Sender: TObject);
    procedure ButtonShowReportClick(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure JSON_DSGetValue(const VarName: string; var Value: Variant);
    procedure Button1Click(Sender: TObject);
    procedure DateTimePickerFromChange(Sender: TObject);
    procedure DateTimePickerToChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormJSON: TFormJSON;
  tHTTP: TfrxTransportHTTP;
  frxJSON: TfrxJSON;
  Res: String;
  Symbol,Resolution,FromCandlesHistory,ToCandlesHistory : String;
  frxJSONArrayT,frxJSONArrayC,frxJSONArrayO,
  frxJSONArrayH,frxJSONArrayL,frxJSONArrayV: TfrxJSONArray;
  S: TStringStream;

implementation

{$R *.dfm}

procedure TFormJSON.Button1Click(Sender: TObject);
begin
  if (Res = '') then ButtonConnectToJSON.Click;
  frxReport1.DesignReport();
end;

procedure TFormJSON.ButtonConnectToJSONClick(Sender: TObject);
begin
  frxReport1.LoadFromFile('ChartJSON.fr3');
  JSON_DS.RangeEnd := reCount;
  Symbol := ComboBoxName.Items[ComboBoxName.ItemIndex];
  Resolution := ComboBoxResolution.Items[ComboBoxResolution.ItemIndex];
  FromCandlesHistory := DateTimeToUnix(DateTimePickerFrom.DateTime).ToString;
  ToCandlesHistory := DateTimeToUnix(DateTimePickerTo.DateTime).ToString;

    tHTTP := TfrxTransportHTTP.Create(nil);
    try
      Res := tHTTP.Get('https://api.bcs.ru/udfdatafeed/v1/history?symbol='
      +Symbol+
      '&resolution='+Resolution +
      '&from='+ FromCandlesHistory+
      '&to='+ToCandlesHistory);

      if (Res = '') or (pos('"s":"ok"',Res) = 0) then
      begin
        StatusBar1.Font.Color := clRed;
        StatusBar1.SimpleText := 'Error loading JSON';
        S := TStringStream.Create('', TEncoding.UTF8);
        try
          S.LoadFromFile('JSON/'+Symbol+'.json');
        finally
          Res:= S.DataString;
          FreeAndNil(S);
        end;
        StatusBar1.SimpleText := 'Successful JSON loading from file '+Symbol+'.json';
      end
      else
      begin
        StatusBar1.Font.Color := clGreen;
        StatusBar1.SimpleText := 'Successful JSON('+Symbol+') loading';
      end;

      frxJSON := TfrxJSON.Create(Res);

      try
      if frxJSON.IsValid then
      begin
        StatusBar1.SimpleText :=StatusBar1.SimpleText +' /JSON is Valid';
        if frxJSON.IsNameExists('t') then
          frxJSONArrayT := TfrxJSONArray.Create(frxJSON.ObjectByName('t'));
          frxJSONArrayC := TfrxJSONArray.Create(frxJSON.ObjectByName('c'));
          frxJSONArrayO := TfrxJSONArray.Create(frxJSON.ObjectByName('o'));
          frxJSONArrayH := TfrxJSONArray.Create(frxJSON.ObjectByName('h'));
          frxJSONArrayL := TfrxJSONArray.Create(frxJSON.ObjectByName('l'));
          frxJSONArrayV := TfrxJSONArray.Create(frxJSON.ObjectByName('v'));

          JSON_DS.Fields.Clear;
          JSON_DS.Fields.Add('Ticker');
          JSON_DS.Fields.Add('Date');
          JSON_DS.Fields.Add('Time');
          JSON_DS.Fields.Add('Open');
          JSON_DS.Fields.Add('Close');
          JSON_DS.Fields.Add('High');
          JSON_DS.Fields.Add('Low');
          JSON_DS.Fields.Add('Vol');
          JSON_DS.RangeEndCount := frxJSONArrayT.Count;
      end
      else StatusBar1.SimpleText :=StatusBar1.SimpleText +' /JSON is Invalid';
      finally
      end;

    finally
    end;

end;

procedure TFormJSON.ButtonShowReportClick(Sender: TObject);
begin
if (Res = '') then ButtonConnectToJSON.Click;

 frxReport1.ShowReport();
end;

procedure TFormJSON.ComboBoxNameChange(Sender: TObject);
begin
  ButtonConnectToJSON.Click;
end;

procedure TFormJSON.DateTimePickerFromChange(Sender: TObject);
begin
  ButtonConnectToJSON.Click;
end;

procedure TFormJSON.DateTimePickerToChange(Sender: TObject);
begin
  ButtonConnectToJSON.Click;
end;

procedure TFormJSON.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     tHTTP.Free;
     frxJSON.Free;
     frxJSONArrayT.Free;
     frxJSONArrayC.Free;
     frxJSONArrayO.Free;
     frxJSONArrayH.Free;
     frxJSONArrayL.Free;
     frxJSONArrayV.Free;
end;

procedure TFormJSON.JSON_DSGetValue(const VarName: string; var Value: Variant);
var
  Item: string;
  Time : string;
begin
   Item := frxJSONArrayT.GetString(JSON_DS.RecNo);
   DateTimeToString(Time, 't', UnixToDateTime(StrToInt64(Item)));

  if VarName = 'Ticker' then
  begin
     Value := Symbol;
     exit;
  end
  else if VarName = 'Date' then
  begin
    Value := DateToStr(UnixToDateTime(StrToInt64(Item)))+' '+Time;
     exit;
  end
  else if VarName = 'Time' then
  begin
    Value := Time;
    exit;
  end
  else if VarName = 'Open' then
    Item := frxJSONArrayO.GetString(JSON_DS.RecNo)
  else if VarName = 'Close' then
    Item := frxJSONArrayC.GetString(JSON_DS.RecNo)
  else if VarName = 'High' then
    Item := frxJSONArrayH.GetString(JSON_DS.RecNo)
  else if VarName = 'Low' then
    Item := frxJSONArrayL.GetString(JSON_DS.RecNo)
  else if VarName = 'Vol' then
    Item := frxJSONArrayV.GetString(JSON_DS.RecNo);

    Value := Item;
end;

procedure TFormJSON.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
    if Panel = StatusBar.Panels[0] then
    begin
      StatusBar.Canvas.Font.Color := clRed;
      StatusBar.Canvas.TextOut(Rect.left, Rect.Top, StatusBar.Panels[0].Text);
    end;
end;

end.
