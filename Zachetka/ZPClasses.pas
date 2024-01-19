unit ZPClasses;

interface

uses
  Windows, SysUtils, Messages, Classes, Types,
{$IFNDEF CONSOLE}
  Forms,
{$ENDIF}
  ZPort;

Type
  EZPError = class(Exception)
  public
    m_nErrCode      : HResult;

    constructor Create(const Msg: string; AErrCode: HResult);
  end;

  TZPort = class
  protected
    FPortName       : String;
    FPortType       : TZP_Port_Type;
    FBaud           : Cardinal;
    FEvChar         : AnsiChar;
    FStopBits       : Byte;
    FTag            : NativeInt;
    m_hHandle       : THandle;
    m_hWindow       : THandle;
    FOnRxChar       : TNotifyEvent;
    FOnStatusChange : TNotifyEvent;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Clear(AIn: Boolean=True; AOut: Boolean=True);{$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Write(Const ABuf; ACount: Cardinal);{$IFDEF HAS_INLINE}inline;{$ENDIF}
    function Read(var VBuf; ACount: Cardinal): Cardinal;{$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetInCount(): Cardinal;{$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetConnectionStatus(var VSettionId: Cardinal): TZp_Connection_Status;{$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetDtr(AState: Boolean);{$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetRts(AState: Boolean);{$IFDEF HAS_INLINE}inline;{$ENDIF}
  protected
    procedure WindowMethod(var Message: TMessage);
    procedure DoOnRxEvent();
    procedure DoOnStatusChange();
    procedure SetNotifications();
    procedure Open();
    procedure Close();

    function GetOpened(): Boolean;
    procedure SetOpened(AValue: Boolean);
    procedure SetBaud(AValue: Cardinal);
    procedure SetEvChar(AValue: AnsiChar);
    procedure SetOnRxChar(AValue: TNotifyEvent);
    procedure SetOnStatusChange(AValue: TNotifyEvent);
 public
    property Opened: Boolean read GetOpened write SetOpened;
    property Handle: THandle read m_hHandle;

    property PortName: String read FPortName write FPortName;
    property PortType: TZP_Port_Type read FPortType write FPortType;
    property Baud: Cardinal read FBaud write SetBaud;
    property EvChar: AnsiChar read FEvChar write SetEvChar;
    property StopBits: Byte read FStopBits write FStopBits;
    property Tag: NativeInt read FTag write FTag;
    property OnRxChar: TNotifyEvent read FOnRxChar write SetOnRxChar;
    property OnStatusChange: TNotifyEvent read FOnStatusChange write SetOnStatusChange;
  end;

  TZDevTypes = set of (devSerial, devIP);
  TZpDDPortEvent = procedure(ASender: TObject; Const AInfo: TZp_DDN_Port_Info) of object;
  TZpErrorEvent = procedure(ASender: TObject; AErrCode: HResult) of object;
  TZpDDDeviceEvent = procedure(ASender: TObject; Const AInfo: TZp_DDN_Device_Info) of object;
  TZpDDScanComplite = procedure(ASender: TObject; AStatus: Integer) of object;

  TZPDetector = class
  protected
    FEnabled        : Boolean;
    FDevTypes       : TZDevTypes;
    FOnPortInsert   : TZpDDPortEvent;
    FOnPortRemove   : TZpDDPortEvent;
    FOnPortChange   : TZpDDPortEvent;
    FOnError        : TZpErrorEvent;
    FOnDeviceInsert : TZpDDDeviceEvent;
    FOnDeviceRemove : TZpDDDeviceEvent;
    FOnDeviceChange : TZpDDDeviceEvent;
    FOnScanComplite : TZpDDScanComplite;
    FSDevTypes      : Cardinal;	// Маска тивов устройств, подключенных к последовательному порту
    FIpDevTypes     : Cardinal;	// Маска тивов Ip-устройств
    FIpsPorts       : TWordDynArray;

    m_hHandle       : THandle;
    m_hWindow       : THandle;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Refresh(ATimeOut: Cardinal=0);{$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetSettings(var VSettings: TZp_DD_Global_Settings);{$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetSettings(ASettings: PZp_DD_Global_Settings);{$IFDEF HAS_INLINE}inline;{$ENDIF}
  protected
    procedure WindowMethod(var Message: TMessage);
    procedure CmZPort();
    procedure SetNotifications();
    procedure Open();
    procedure Close();

    procedure DoOnPortInsert(Const AInfo: TZp_DDN_Port_Info);
    procedure DoOnPortRemove(Const AInfo: TZp_DDN_Port_Info);
    procedure DoOnPortChange(Const AInfo: TZp_DDN_Port_Info);
    procedure DoOnError(AErrCode: HResult);
    procedure DoOnDevInsert(Const AInfo: TZp_DDN_Device_Info);
    procedure DoOnDevRemove(Const AInfo: TZp_DDN_Device_Info);
    procedure DoOnDevChange(Const AInfo: TZp_DDN_Device_Info);
    procedure DoOnScanComplite(AStatus: Integer);
    procedure SetEnabled(AEnable: Boolean);
    procedure SetDevTypes(AValue: TZDevTypes);
    procedure SetIpsPorts(Const AValue: TWordDynArray);
    procedure SetOnDeviceInsert(Const AValue: TZpDDDeviceEvent);
    procedure SetOnDeviceRemove(Const AValue: TZpDDDeviceEvent);
    procedure SetOnDeviceChange(Const AValue: TZpDDDeviceEvent);
  public
    property OnPortInsert: TZpDDPortEvent read FOnPortInsert write FOnPortInsert;
    property OnPortRemove: TZpDDPortEvent read FOnPortRemove write FOnPortRemove;
    property OnPortChange: TZpDDPortEvent read FOnPortChange write FOnPortChange;
    property OnError: TZpErrorEvent read FOnError write FOnError;
    property OnDeviceInsert: TZpDDDeviceEvent read FOnDeviceInsert write SetOnDeviceInsert;
    property OnDeviceRemove: TZpDDDeviceEvent read FOnDeviceRemove write SetOnDeviceRemove;
    property OnDeviceChange: TZpDDDeviceEvent read FOnDeviceChange write SetOnDeviceChange;
    property OnScanComplite: TZpDDScanComplite read FOnScanComplite write FOnScanComplite;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property DevTypes: TZDevTypes read FDevTypes write SetDevTypes;
    property IpsPorts: TWordDynArray read FIpsPorts write SetIpsPorts;
  end;
  // Список портов
  TZPortList = class
  protected
    m_hHandle       : THandle;
    m_nCount        : Integer;
  public
    constructor Create();
    destructor Destroy(); override;
  protected
    function GetCount(): Integer;
    function GetPortInfo(AIdx: Integer): TZp_Port_Info;
  public
    property Count: Integer read GetCount;
    property PortInfos[Idx: Integer]: TZp_Port_Info read GetPortInfo;
  end;

procedure ZPInitialize(AFlags: Cardinal=ZP_IF_LOG);{$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure ZPFinalyze();{$IFDEF HAS_INLINE}inline;{$ENDIF}

procedure GetPortInfoList(var VHandle: THandle; var VCount: Integer;
    ASerDevs: Cardinal=$ffffffff; AFlags: Cardinal=0);{$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure GetPortInfo(AHandle: THandle; AIdx: Integer; var VInfo: TZp_Port_Info);{$IFDEF HAS_INLINE}inline;{$ENDIF}

procedure SearchDevices(var VHandle: THandle; var AParams: TZP_Search_Params); {$IFDEF HAS_INLINE}inline;{$ENDIF}
function FindNextDevice(AHandle: THandle; VInfo: PZp_Device_Info;
    VPortArr: PZP_Port_Info; AArrLen: Integer; var VPortCount: Integer;
    ATimeout: Cardinal=INFINITE): Boolean; {$IFDEF HAS_INLINE}inline;{$ENDIF}

//procedure EnumSerialPorts(ADevTypes: Cardinal; AEnumProc: TZP_ENUMPORTSPROC;
//    AUserData: Pointer); deprecated;
//procedure EnumSerialDevices(ADevTypes: Cardinal; APorts: PZP_Port_Addr; APCount: Integer;
//    AEnumProc: TZP_ENUMDEVICEPROC; AUserData: Pointer; AWait: PZP_WAIT_SETTINGS=nil;
//    AFlags: Cardinal=1); deprecated;
//function FindSerialDevice(ADevTypes: Cardinal; APorts: PZP_Port_Addr; APCount: Integer;
//    VInfo: PZP_DEVICE_INFO; AInfoSize: Integer; var VPort: TZP_PORT_INFO;
//    AWait: PZP_WAIT_SETTINGS=nil; AFlags: Cardinal=1
//    ): Boolean; deprecated;
//procedure EnumIpDevices(ADevTypes: Cardinal; AEnumProc: TZP_ENUMDEVICEPROC;
//    AUserData: Pointer; AWait: PZP_WAIT_SETTINGS=nil;
//    AFlags: Cardinal=1); deprecated;

procedure RegSerialDevice(Const AParams: TZP_USB_DEVICE);{$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure RegIpDevice(Const AParams: TZP_IP_DEVICE);{$IFDEF HAS_INLINE}inline;{$ENDIF}

function CheckZPVersion(): Boolean;{$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure CheckZPError(AErrCode: HResult);
function GetZPErrorText(AErrCode: HResult): String;
{$IF not Declared(MAKELANGID)}
{$DEFINE MAKELANGID}
function MAKELANGID(p, s: WORD): WORD;
{$IFEND}

implementation

Const
  CM_ZPORT  = (WM_USER + 1);


constructor EZPError.Create(const Msg: string; AErrCode: HResult);
begin
  inherited Create(Msg);
  m_nErrCode := AErrCode;
end;

{ TZPort }

constructor TZPort.Create();
begin
  inherited Create();
  FBaud := 9600;
end;

destructor TZPort.Destroy();
begin
  if Opened then
    Close();
  inherited Destroy();
end;

procedure TZPort.Clear(AIn, AOut: Boolean);
begin
  ASSERT(Opened);
  CheckZPError(ZP_Port_Clear(m_hHandle, AIn, AOut));
end;

procedure TZPort.Write(Const ABuf; ACount: Cardinal);
begin
  ASSERT(Opened);
  CheckZPError(ZP_Port_Write(m_hHandle, ABuf, ACount));
end;

function TZPort.Read(var VBuf; ACount: Cardinal): Cardinal;
begin
  ASSERT(Opened);
  CheckZPError(ZP_Port_Read(m_hHandle, VBuf, ACount, Result));
end;

function TZPort.GetInCount(): Cardinal;
begin
  ASSERT(Opened);
  CheckZPError(ZP_Port_GetInCount(m_hHandle, Result));
end;

function TZPort.GetConnectionStatus(var VSettionId: Cardinal): TZp_Connection_Status;
begin
  ASSERT(Opened);
  CheckZPError(ZP_Port_GetConnectionStatus(m_hHandle, Result, VSettionId));
end;

procedure TZPort.SetDtr(AState: Boolean);
begin
  ASSERT(Opened);
  CheckZPError(ZP_Port_SetDtr(m_hHandle, AState));
end;

procedure TZPort.SetRts(AState: Boolean);
begin
  ASSERT(Opened);
  CheckZPError(ZP_Port_SetRts(m_hHandle, AState));
end;

procedure TZPort.SetBaud(AValue: Cardinal);
begin
  if Opened then
    CheckZPError(ZP_Port_SetBaudAndEvChar(m_hHandle, AValue, FEvChar));
  FBaud := AValue;
end;

procedure TZPort.SetEvChar(AValue: AnsiChar);
begin
  if Opened then
    CheckZPError(ZP_Port_SetBaudAndEvChar(m_hHandle, FBaud, AValue));
  FEvChar := AValue;
end;

procedure TZPort.SetOnRxChar(AValue: TNotifyEvent);
begin
  FOnRxChar := AValue;
  if Opened then
    SetNotifications();
end;

procedure TZPort.SetOnStatusChange(AValue: TNotifyEvent);
begin
  FOnStatusChange := AValue;
  if Opened then
    SetNotifications();
end;

procedure TZPort.DoOnRxEvent();
begin
  if Assigned(FOnRxChar) then
    FOnRxChar(Self);
end;

procedure TZPort.DoOnStatusChange();
begin
  if Assigned(FOnStatusChange) then
    FOnStatusChange(Self);
end;

procedure TZPort.WindowMethod(var Message: TMessage);
var
  nMsgs: Cardinal;
begin
  with Message do
    if Msg = CM_ZPORT then
      try
        CheckZPError(ZP_Port_EnumMessages(m_hHandle, nMsgs));
        if (nMsgs and ZP_PNF_RXEVENT) <> 0 then
          DoOnRxEvent();
        if (nMsgs and ZP_PNF_STATUS) <> 0 then
          DoOnStatusChange();
      except
{$IFNDEF CONSOLE}
        Application.HandleException(Self);
{$ENDIF}
      end
    else
      Result := DefWindowProc(m_hWindow, Msg, wParam, lParam);
end;

procedure TZPort.SetNotifications();
var
  nMask: Cardinal;
begin
  nMask := 0;
  if Assigned(FOnRxChar) then
    Inc(nMask, ZP_PNF_RXEVENT);
  if Assigned(FOnStatusChange) then
    Inc(nMask, ZP_PNF_STATUS);
  if (nMask <> 0) <> (m_hWindow <> 0) then
  begin
    if m_hWindow = 0 then
      m_hWindow := AllocateHWnd(WindowMethod)
    else
    begin
      DeallocateHWnd(m_hWindow);
      m_hWindow := 0;
    end;
  end;
  CheckZPError(ZP_Port_SetNotification(m_hHandle, 0, m_hWindow, CM_ZPORT, nMask));
end;

procedure TZPort.Open();
var
  szName: array[0..ZP_MAX_PORT_NAME] of WideChar;
  rOpen: TZp_Port_Open_Params;
begin
  try
    StringToWideChar(FPortName, szName, Length(szName));
    FillChar(rOpen, SizeOf(rOpen), 0);
    rOpen.szName := szName;
    rOpen.nType := FPortType;
    rOpen.nBaud := FBaud;
    rOpen.nEvChar := FEvChar;
    rOpen.nStopBits := FStopBits;
    CheckZPError(ZP_Port_Open(m_hHandle, @rOpen));
    SetNotifications();
  except
    Close();
    raise;
  end;
end;

procedure TZPort.Close();
begin
  if m_hHandle <> 0 then
  begin
    ZP_CloseHandle(m_hHandle);
    m_hHandle := 0;
  end;
  if m_hWindow <> 0 then
  begin
    DeallocateHWnd(m_hWindow);
    m_hWindow := 0;
  end;
end;

function TZPort.GetOpened(): Boolean;
begin
  Result := (m_hHandle <> 0);
end;

procedure TZPort.SetOpened(AValue: Boolean);
begin
  if AValue = Opened then
    exit;
  if AValue then Open() else Close();
end;



{ TZPDetector }

constructor TZPDetector.Create();
begin
  inherited Create();
  FDevTypes := [devSerial, devIP];
  FSDevTypes := $ffffffff;
  FIpDevTypes := $ffffffff;
  SetLength(FIpsPorts, 1);
  FIpsPorts[0] := 25000;
end;

destructor TZPDetector.Destroy();
begin
  if FEnabled then
    Close();
  Inherited Destroy();
end;

procedure TZPDetector.Refresh(ATimeOut: Cardinal);
begin
  CheckZPError(ZP_DD_Refresh(ATimeOut));
end;

procedure TZPDetector.GetSettings(var VSettings: TZp_DD_Global_Settings);
begin
  CheckZPError(ZP_DD_GetGlobalSettings(VSettings));
end;

procedure TZPDetector.SetSettings(ASettings: PZp_DD_Global_Settings);
begin
  CheckZPError(ZP_DD_SetGlobalSettings(ASettings));
end;

procedure TZPDetector.DoOnPortInsert(Const AInfo: TZp_DDN_Port_Info);
begin
  if Assigned(FOnPortInsert) then
    FOnPortInsert(Self, AInfo);
end;

procedure TZPDetector.DoOnPortRemove(Const AInfo: TZp_DDN_Port_Info);
begin
  if Assigned(FOnPortRemove) then
    FOnPortRemove(Self, AInfo);
end;

procedure TZPDetector.DoOnPortChange(Const AInfo: TZp_DDN_Port_Info);
begin
  if Assigned(FOnPortChange) then
    FOnPortChange(Self, AInfo);
end;

procedure TZPDetector.DoOnError(AErrCode: HResult);
begin
  if Assigned(FOnError) then
    FOnError(Self, AErrCode);
end;

procedure TZPDetector.DoOnDevInsert(Const AInfo: TZp_DDN_Device_Info);
begin
  if Assigned(FOnDeviceInsert) then
    FOnDeviceInsert(Self, AInfo);
end;

procedure TZPDetector.DoOnDevRemove(Const AInfo: TZp_DDN_Device_Info);
begin
  if Assigned(FOnDeviceRemove) then
    FOnDeviceRemove(Self, AInfo);
end;

procedure TZPDetector.DoOnDevChange(Const AInfo: TZp_DDN_Device_Info);
begin
  if Assigned(FOnDeviceChange) then
    FOnDeviceChange(Self, AInfo);
end;

procedure TZPDetector.DoOnScanComplite(AStatus: Integer);
begin
  if Assigned(FOnScanComplite) then
    FOnScanComplite(Self, AStatus);
end;

procedure TZPDetector.CmZPort();
var
  hr: HResult;
  nMsg: Cardinal;
  nMsgParam: NativeInt;
begin
  repeat
    hr := Zp_DD_GetNextMessage(m_hHandle, nMsg, nMsgParam);
    if hr <> S_OK then
      break;
    case nMsg of
      ZP_N_INSERT:        DoOnPortInsert(PZp_DDN_Port_Info(nMsgParam)^);
      ZP_N_REMOVE:        DoOnPortRemove(PZp_DDN_Port_Info(nMsgParam)^);
      ZP_N_CHANGE:        DoOnPortChange(PZp_DDN_Port_Info(nMsgParam)^);
      ZP_N_ERROR:         DoOnError(HResult(Pointer(nMsgParam)^));
      ZP_N_DEVINSERT:     DoOnDevInsert(PZp_DDN_Device_Info(nMsgParam)^);
      ZP_N_DEVREMOVE:     DoOnDevRemove(PZp_DDN_Device_Info(nMsgParam)^);
      ZP_N_DEVCHANGE:     DoOnDevChange(PZp_DDN_Device_Info(nMsgParam)^);
      ZP_N_COMPLETED:     DoOnScanComplite(PInteger(nMsgParam)^);
    end;
  until False;
end;

procedure TZPDetector.WindowMethod(var Message: TMessage);
begin
  with Message do
    if Msg = CM_ZPORT then
      CmZPort()
    else
      Result := DefWindowProc(m_hWindow, Msg, wParam, lParam);
end;

procedure TZPDetector.SetNotifications();
var
  rNS: TZP_DD_Notify_Settings;
  h: THandle;
begin
  h := 0;
  FillChar(rNS, SizeOf(rNS), 0);
  rNS.nNMask := ZP_NF_USECOM or ZP_NF_UNIDCOM;
  if Assigned(FOnPortInsert) or Assigned(FOnPortRemove) then
    Inc(rNS.nNMask, ZP_NF_EXIST);
  if Assigned(FOnPortChange) then
    Inc(rNS.nNMask, ZP_NF_CHANGE);
  if Assigned(FOnError) then
    Inc(rNS.nNMask, ZP_NF_ERROR);
  if Assigned(FOnDeviceInsert) or Assigned(FOnDeviceRemove) then
    Inc(rNS.nNMask, ZP_NF_DEVEXIST);
  if Assigned(FOnDeviceChange) then
    Inc(rNS.nNMask, ZP_NF_DEVCHANGE);
  if Assigned(FOnScanComplite) then
    Inc(rNS.nNMask, ZP_NF_COMPLETED);
  if rNS.nNMask <> 0 then
  begin
    rNS.hWindow := m_hWindow;
    rNS.nWndMsgId := CM_ZPORT;
    if devSerial in FDevTypes then
    begin
      rNS.nSDevTypes := $ffffffff;
      if (rNS.nNMask and (ZP_NF_DEVEXIST or ZP_NF_DEVCHANGE)) <> 0 then
        Inc(rNS.nNMask, ZP_NF_SDEVICE);
    end;
    if devIP in FDevTypes then
    begin
      rNS.nIpDevTypes := $ffffffff;
      if Length(FIpsPorts) > 0 then
      begin
        rNS.aIps := @FIpsPorts[0];
        rNS.nIpsCount := Length(FIpsPorts);
      end;
      if (rNS.nNMask and (ZP_NF_DEVEXIST or ZP_NF_DEVCHANGE)) <> 0 then
        Inc(rNS.nNMask, ZP_NF_IPDEVICE);
    end;
    CheckZPError(ZP_DD_SetNotification(h, rNS));
  end;
  if m_hHandle <> 0 then
    ZP_CloseHandle(m_hHandle);
  m_hHandle := h;
end;

procedure TZPDetector.Open();
begin
  try
    m_hWindow := AllocateHWnd(WindowMethod);
    SetNotifications();
  except
    Close();
    raise;
  end;
end;

procedure TZPDetector.Close();
begin
  if m_hHandle <> 0 then
  begin
    ZP_CloseHandle(m_hHandle);
    m_hHandle := 0;
  end;
  if m_hWindow <> 0 then
  begin
    DeallocateHWnd(m_hWindow);
    m_hWindow := 0;
  end;
end;

procedure TZPDetector.SetDevTypes(AValue: TZDevTypes);
begin
  FDevTypes := AValue;
  if FEnabled then
    SetNotifications();
end;

procedure TZPDetector.SetIpsPorts(Const AValue: TWordDynArray);
begin
  FIpsPorts := AValue;
  if FEnabled then
    SetNotifications();
end;

procedure TZPDetector.SetOnDeviceInsert(Const AValue: TZpDDDeviceEvent);
begin
  FOnDeviceInsert := AValue;
  if FEnabled then
    SetNotifications();
end;

procedure TZPDetector.SetOnDeviceRemove(Const AValue: TZpDDDeviceEvent);
begin
  FOnDeviceRemove := AValue;
  if FEnabled then
    SetNotifications();
end;

procedure TZPDetector.SetOnDeviceChange(Const AValue: TZpDDDeviceEvent);
begin
  FOnDeviceChange := AValue;
  if FEnabled then
    SetNotifications();
end;

procedure TZPDetector.SetEnabled(AEnable: Boolean);
begin
  if FEnabled = AEnable then
    exit;
  if AEnable then Open() else Close();
  FEnabled := AEnable;
end;


{ TZPortList }

constructor TZPortList.Create();
begin
  inherited Create();
  CheckZPError(ZP_GetPortInfoList(m_hHandle, m_nCount));
end;

destructor TZPortList.Destroy();
begin
  if m_hHandle <> 0 then
    ZP_CloseHandle(m_hHandle);
  Inherited Destroy();
end;

function TZPortList.GetCount(): Integer;
begin
  Result := m_nCount;
end;

function TZPortList.GetPortInfo(AIdx: Integer): TZp_Port_Info;
begin
  CheckZPError(ZP_GetPortInfo(m_hHandle, AIdx, Result));
end;


procedure ZPInitialize(AFlags: Cardinal);
begin
{$IFDEF DEBUG}
  if not CheckZPVersion() then
    raise Exception.Create(format('Wrong version "%s".', [ZP_DLL_Name]));
{$ENDIF}
  CheckZPError(ZP_Initialize(nil, AFlags));
end;

procedure ZPFinalyze();
begin
  ZP_Finalyze();
end;

procedure GetPortInfoList(var VHandle: THandle; var VCount: Integer;
    ASerDevs: Cardinal; AFlags: Cardinal);
begin
  CheckZPError(ZP_GetPortInfoList(VHandle, VCount, ASerDevs, AFlags));
end;

procedure GetPortInfo(AHandle: THandle; AIdx: Integer; var VInfo: TZp_Port_Info);
begin
  CheckZPError(ZP_GetPortInfo(AHandle, AIdx, VInfo));
end;

procedure SearchDevices(var VHandle: THandle; var AParams: TZP_Search_Params);
begin
  CheckZPError(ZP_SearchDevices(VHandle, AParams));
end;

function FindNextDevice(AHandle: THandle; VInfo: PZp_Device_Info;
    VPortArr: PZP_Port_Info; AArrLen: Integer; var VPortCount: Integer;
    ATimeout: Cardinal): Boolean;
var
  hr: HResult;
begin
  hr := ZP_FindNextDevice(AHandle, VInfo, VPortArr, AArrLen, VPortCount, ATimeout);
  CheckZPError(hr);
  Result := (hr = S_OK);
end;

//procedure EnumSerialPorts(ADevTypes: Cardinal; AEnumProc: TZP_ENUMPORTSPROC; AUserData: Pointer);
//begin
//  CheckZPError(ZP_EnumSerialPorts(ADevTypes, AEnumProc, AUserData));
//end;
//
//procedure EnumSerialDevices(ADevTypes: Cardinal; APorts: PZP_Port_Addr; APCount: Integer;
//    AEnumProc: TZP_ENUMDEVICEPROC; AUserData: Pointer; AWait: PZP_WAIT_SETTINGS;
//    AFlags: Cardinal);
//begin
//  CheckZPError(ZP_EnumSerialDevices(ADevTypes, APorts, APCount, AEnumProc, AUserData, AWait, AFlags));
//end;
//
//function FindSerialDevice(ADevTypes: Cardinal; APorts: PZP_Port_Addr; APCount: Integer;
//    VInfo: PZP_DEVICE_INFO; AInfoSize: Integer; var VPort: TZP_PORT_INFO;
//    AWait: PZP_WAIT_SETTINGS; AFlags: Cardinal): Boolean;
//var
//  nRet: HResult;
//begin
//  nRet := ZP_FindSerialDevice(ADevTypes, APorts, APCount, VInfo, AInfoSize, VPort, AWait, AFlags);
//  CheckZPError(nRet);
//  Result := (nRet = S_OK);
//end;
//
//procedure EnumIpDevices(ADevTypes: Cardinal; AEnumProc: TZP_ENUMDEVICEPROC;
//    AUserData: Pointer; AWait: PZP_WAIT_SETTINGS; AFlags: Cardinal);
//begin
//  CheckZPError(ZP_EnumIpDevices(ADevTypes, AEnumProc, AUserData, AWait, AFlags));
//end;

procedure RegSerialDevice(Const AParams: TZP_USB_DEVICE);
begin
  CheckZPError(ZP_RegSerialDevice(AParams));
end;

procedure RegIpDevice(Const AParams: TZP_IP_DEVICE);
begin
  CheckZPError(ZP_RegIpDevice(AParams));
end;

function CheckZPVersion(): Boolean;
var
  nVersion: Cardinal;
begin
  nVersion := ZP_GetVersion();
  Result := ((nVersion and $ff) = ZP_SDK_VER_MAJOR) and (((nVersion shr 8) and $ff) = ZP_SDK_VER_MINOR);
end;

function GetZPErrorText(AErrCode: HResult): String;
var
  pBuffer: PChar;
  nLen, nFlags: Integer;
begin
  pBuffer := nil;
  if HResultFacility(AErrCode) = $4 then
    nFlags := FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_HMODULE
  else
    nFlags := FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM;
  nLen := FormatMessage(nFlags,
      Pointer(GetModuleHandle(ZP_DLL_Name)),
      Cardinal(AErrCode),
      MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
      PChar(@pBuffer), 0, nil);
  if pBuffer <> nil then
  begin
    SetString(Result, pBuffer, nLen);
    LocalFree(HLOCAL(pBuffer));
  end
  else
    Result := '';
end;

procedure CheckZPError(AErrCode: HResult);
begin
  if FAILED(AErrCode) then
    raise EZPError.Create(GetZPErrorText(AErrCode), AErrCode);
end;

{$IFDEF MAKELANGID}
function MAKELANGID(p, s: WORD): WORD;
begin
  Result := WORD(s shl 10) or p;
end;
{$ENDIF}

end.
