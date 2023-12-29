unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frxDBSet, Db, frxClass, ADODB,frxJSON, frxTransportHTTP,DateUtils;

type
  TReportData = class(TDataModule)
    Customers: TADOTable;
    CustomersCustNo: TFloatField;
    CustomersCompany: TStringField;
    CustomersAddr1: TStringField;
    CustomersAddr2: TStringField;
    CustomersCity: TStringField;
    CustomersState: TStringField;
    CustomersZip: TStringField;
    CustomersCountry: TStringField;
    CustomersPhone: TStringField;
    CustomersFAX: TStringField;
    CustomersTaxRate: TFloatField;
    CustomersContact: TStringField;
    CustomersLastInvoiceDate: TDateTimeField;
    Orders: TADOTable;
    OrdersOrderNo: TFloatField;
    OrdersCustNo: TFloatField;
    OrdersCustCompany: TStringField;
    OrdersSaleDate: TDateTimeField;
    OrdersShipDate: TDateTimeField;
    OrdersEmpNo: TIntegerField;
    OrdersShipToContact: TStringField;
    OrdersShipToAddr1: TStringField;
    OrdersShipToAddr2: TStringField;
    OrdersShipToCity: TStringField;
    OrdersShipToState: TStringField;
    OrdersShipToZip: TStringField;
    OrdersShipToCountry: TStringField;
    OrdersShipToPhone: TStringField;
    OrdersShipVIA: TStringField;
    OrdersPO: TStringField;
    OrdersTerms: TStringField;
    OrdersPaymentMethod: TStringField;
    OrdersItemsTotal: TCurrencyField;
    OrdersTaxRate: TFloatField;
    OrdersFreight: TCurrencyField;
    OrdersAmountPaid: TCurrencyField;
    OrderSource: TDataSource;
    OrdersDS: TfrxDBDataset;
    LineItems: TADOTable;
    LineItemsOrderNo: TFloatField;
    LineItemsItemNo: TFloatField;
    LineItemsPartNo: TFloatField;
    LineItemsPartName: TStringField;
    LineItemsQty: TIntegerField;
    LineItemsPrice: TCurrencyField;
    LineItemsDiscount: TFloatField;
    LineItemsTotal: TCurrencyField;
    LineItemsExtendedPrice: TCurrencyField;
    Parts: TADOTable;
    PartsPartNo: TFloatField;
    PartsVendorNo: TFloatField;
    PartsDescription: TStringField;
    PartsOnHand: TFloatField;
    PartsOnOrder: TFloatField;
    PartsCost: TCurrencyField;
    PartsListPrice: TCurrencyField;
    CustomerSource: TDataSource;
    LineItemSource: TDataSource;
    PartSource: TDataSource;
    RepQuery: TADOQuery;
    RepQuerySource: TDataSource;
    CustomersDS: TfrxDBDataset;
    ItemsDS: TfrxDBDataset;
    PartDS: TfrxDBDataset;
    QueryDS: TfrxDBDataset;
    Bio: TADOTable;
    BioSource: TDataSource;
    BioDS: TfrxDBDataset;
    Country: TADOTable;
    CountrySource: TDataSource;
    CountryDS: TfrxDBDataset;
    Cross: TADOTable;
    CrossSource: TDataSource;
    CrossDS: TfrxDBDataset;
    ADOConnection1: TADOConnection;
    RepQueryaCustNo: TFloatField;
    RepQueryCompany: TWideStringField;
    RepQueryAddr1: TWideStringField;
    RepQueryAddr2: TWideStringField;
    RepQueryCity: TWideStringField;
    RepQueryState: TWideStringField;
    RepQueryZip: TWideStringField;
    RepQueryCountry: TWideStringField;
    RepQueryPhone: TWideStringField;
    RepQueryFAX: TWideStringField;
    RepQueryaTaxRate: TFloatField;
    RepQueryContact: TWideStringField;
    RepQueryLastInvoiceDate: TDateTimeField;
    RepQuerybOrderNo: TFloatField;
    RepQuerybCustNo: TFloatField;
    RepQuerySaleDate: TDateTimeField;
    RepQueryShipDate: TDateTimeField;
    RepQueryEmpNo: TIntegerField;
    RepQueryShipToContact: TWideStringField;
    RepQueryShipToAddr1: TWideStringField;
    RepQueryShipToAddr2: TWideStringField;
    RepQueryShipToCity: TWideStringField;
    RepQueryShipToState: TWideStringField;
    RepQueryShipToZip: TWideStringField;
    RepQueryShipToCountry: TWideStringField;
    RepQueryShipToPhone: TWideStringField;
    RepQueryShipVIA: TWideStringField;
    RepQueryPO: TWideStringField;
    RepQueryTerms: TWideStringField;
    RepQueryPaymentMethod: TWideStringField;
    RepQueryItemsTotal: TFloatField;
    RepQuerybTaxRate: TFloatField;
    RepQueryFreight: TFloatField;
    RepQueryAmountPaid: TFloatField;
    RepQuerycOrderNo: TFloatField;
    RepQueryItemNo: TFloatField;
    RepQuerycPartNo: TFloatField;
    RepQueryQty: TIntegerField;
    RepQueryDiscount: TFloatField;
    RepQuerydPartNo: TFloatField;
    RepQueryVendorNo: TFloatField;
    RepQueryDescription: TWideStringField;
    RepQueryOnHand: TFloatField;
    RepQueryOnOrder: TFloatField;
    RepQueryCost: TFloatField;
    RepQueryListPrice: TFloatField;
    ADOConnection2: TADOConnection;
    MapOrders: TADOTable;
    MapOrderDetails: TADOTable;
    MapOrdersSource: TDataSource;
    MapOrderDetailsSource: TDataSource;
    MapOrdersDS: TfrxDBDataset;
    MapOrderDetailsDS: TfrxDBDataset;
    MapOrdersOrderID: TAutoIncField;
    MapOrdersCustomerID: TWideStringField;
    MapOrdersEmployeeID: TIntegerField;
    MapOrdersOrderDate: TDateTimeField;
    MapOrdersRequiredDate: TDateTimeField;
    MapOrdersShippedDate: TDateTimeField;
    MapOrdersShipVia: TIntegerField;
    MapOrdersFreight: TBCDField;
    MapOrdersShipName: TWideStringField;
    MapOrdersShipAddress: TWideStringField;
    MapOrdersShipCity: TWideStringField;
    MapOrdersShipRegion: TWideStringField;
    MapOrdersShipPostalCode: TWideStringField;
    MapOrdersShipCountry: TWideStringField;
    MapOrderDetailsOrderID: TIntegerField;
    MapOrderDetailsProductID: TIntegerField;
    MapOrderDetailsUnitPrice: TBCDField;
    MapOrderDetailsQuantity: TSmallintField;
    MapOrderDetailsDiscount: TFloatField;
    MapOrdersLatitude: TFloatField;
    MapOrdersLongitude: TFloatField;
    MapOrdersDS2: TfrxDBDataset;
    MapOrders2: TADOTable;
    AutoIncField1: TAutoIncField;
    WideStringField1: TWideStringField;
    IntegerField1: TIntegerField;
    DateTimeField1: TDateTimeField;
    DateTimeField2: TDateTimeField;
    DateTimeField3: TDateTimeField;
    IntegerField2: TIntegerField;
    BCDField1: TBCDField;
    MapOrdersSource2: TDataSource;
    MapOrderDetailsExtended: TADOTable;
    MapOrderDetailsExtendedSource: TDataSource;
    MapOrderDetailsExtendedDS: TfrxDBDataset;
    MapOrderDetailsExtendedProductName: TWideStringField;
    MapOrderDetailsExtendedExtendedPrice: TBCDField;
    NACities: TADOTable;
    NACitiesSource: TDataSource;
    NACitiesDS: TfrxDBDataset;
    NARivers: TADOTable;
    NARiversSource: TDataSource;
    LineStringDS: TfrxDBDataset;
    NAStates: TADOTable;
    NAStatesSource: TDataSource;
    NAStatesDS: TfrxDBDataset;
    ADOConnection3: TADOConnection;
    DatabaseOrg: TADOTable;
    OrgSource: TDataSource;
    OrgSourceDB: TfrxDBDataset;
    TreeMap: TADOTable;
    TeeMapSource: TDataSource;
    TeeMapDB: TfrxDBDataset;
    OHLC_Query: TADOQuery;
    OHLC_Source: TDataSource;
    OHLC_DB: TfrxDBDataset;
    JSON_DS: TfrxUserDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure JSON_DSGetValue(const VarName: string;
      var Value: Variant);
  private
    procedure ConnectToBase(ADOConnection: TADOConnection; FileName: String);
  public
    { Public declarations }
  end;

var
  ReportData: TReportData;

  tHTTP: TfrxTransportHTTP;
  frxJSON: TfrxJSON;
  Res: String;
  Symbol,Resolution,FromCandlesHistory,ToCandlesHistory : String;
  frxJSONArray: TfrxJSONArray ;
  S: TStringStream;
  NameCandles: String;

implementation

{$R *.DFM}

procedure TReportData.ConnectToBase(ADOConnection: TADOConnection; FileName: String);
begin
//  Cross.DatabaseName := ExtractFilePath(Application.ExeName);
  ADOConnection.Connected := False;
{$IFNDEF CPUX64}
  ADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + ExtractFilePath(Application.ExeName) + FileName;
{$ELSE}
  ADOConnection.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' + ExtractFilePath(Application.ExeName) + FileName;
{$ENDIF}
  ADOConnection.Open;
end;

procedure TReportData.DataModuleCreate(Sender: TObject);
var
  i:Integer;
begin
  ConnectToBase(ADOConnection1, 'demo.mdb');
  ConnectToBase(ADOConnection2, 'Northwind.MDB');
  NameCandles := 'GAS_USD';

    tHTTP := TfrxTransportHTTP.Create(nil);
    try

      {Res := tHTTP.Get('https://api.exmo.com/v1.1/candles_history?symbol='
      +Symbol+
      '&resolution='+Resolution +
      '&from='+ DateTimeToUnix(FromCandlesHistory)+
      '&to='+DateTimeToUnix(ToCandlesHistory));    }

      Res := tHTTP.Get('https://api.exmo.com/v1.1/candles_history?symbol='+NameCandles+'&resolution=D&from=1585555979&to=1588244027');
      if (Res = '') or (pos('error',Res) <> 0) then
      begin

        S := TStringStream.Create('', TEncoding.UTF8);
        try
          S.LoadFromFile('JSON/'+NameCandles+'.json');
        finally
          Res:= S.DataString;
          FreeAndNil(S);
        end;

      end;
      frxJSON := TfrxJSON.Create(Res);

      try
      if frxJSON.IsValid then
      begin
        if frxJSON.IsNameExists('candles') then
        frxJSONArray := TfrxJSONArray.Create(frxJSON.ObjectByName('candles'));

          JSON_DS.Fields.Clear;
          JSON_DS.Fields.Add('Ticker');
          JSON_DS.Fields.Add('Date');
          JSON_DS.Fields.Add('Time');
          JSON_DS.Fields.Add('Open');
          JSON_DS.Fields.Add('Close');
          JSON_DS.Fields.Add('High');
          JSON_DS.Fields.Add('Low');
          JSON_DS.Fields.Add('Vol');
          JSON_DS.RangeEndCount := frxJSONArray.Count;
        end;
       // frxJSONArray.Free;
      finally
        //frxJSON.Free;
      end;

    finally
      tHTTP.Free;
    end;

end;

procedure TReportData.JSON_DSGetValue(const VarName: string;
  var Value: Variant);
var
  Item: TfrxJSON;
  Time : string;
begin
   Item := frxJSONArray.Get(JSON_DS.RecNo);
   DateTimeToString(Time, 't', UnixToDateTime(StrToInt64(Copy(Item.ValueByName('t'),0,10))));

   if VarName = 'Ticker' then
    Value := NameCandles
  else if VarName = 'Date' then
    Value := DateToStr(UnixToDateTime(StrToInt64(Copy(Item.ValueByName('t'),0,10))))
  else if VarName = 'Time' then
    Value := Time
  else if VarName = 'Open' then
    Value := Item.ValueByName('o')
  else if VarName = 'Close' then
    Value := Item.ValueByName('c')
  else if VarName = 'High' then
    Value := Item.ValueByName('h')
  else if VarName = 'Low' then
    Value := Item.ValueByName('l')
  else if VarName = 'Vol' then
    Value := Item.ValueByName('v');
   Item.Free;
end;

end.
