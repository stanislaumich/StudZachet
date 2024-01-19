unit ZRClasses;

interface

uses
  Windows, SysUtils, Classes, Messages,
{$IFNDEF CONSOLE}
  Forms,
{$ENDIF}
  ZBase, ZPort, ZReader, ZPClasses;

Type
  EZRError = class(EZPError)
  end;

  TCardInfoDynArray = array of TZr_Card_Info;

  TZRCardEvent = procedure(ASender: TObject; AInfo: PZR_Card_Info) of object;
  TZRCardUnknownEvent = procedure(ASender: TObject; Const AMsg: String) of object;
  TZRInputsChangeEvent = procedure(ASender: TObject; ANewState: Cardinal) of object;

  TZReader = class
  protected
    FPortName       : String;
    FPortType       : TZP_Port_Type;
    FStopBits       : Byte;
    FOpenFlags      : Cardinal;
    FSpeed          : Cardinal;
    FNotifications  : Boolean;
    FOnCardInsert   : TZRCardEvent;
    FOnCardRemove   : TZRCardEvent;
    FOnCardUnknown  : TZRCardUnknownEvent;
    FOnInputsChange : TZRInputsChangeEvent;
    FOnIndFlashEnd  : TNotifyEvent;
    FOnError        : TZpErrorEvent;
    FOnConnectChange: TNotifyEvent;
    m_hRd           : THandle;
    m_hWindow       : THandle;
    m_nRdType       : TZR_Rd_Type;
    m_nSn           : Integer;
    m_nVersion      : Cardinal;
    m_rWS           : TZP_Wait_Settings;
  public
    constructor Create(); overload;
    constructor Create(Const APortName: String; APortType: TZP_Port_Type); overload;
    destructor Destroy(); override;

    function GetConnectionStatus(var VSessionId: Cardinal): TZp_Connection_Status;{$IFDEF HAS_INLINE}inline;{$ENDIF}

    procedure SetWaitSettings(Const ASetting: TZP_Wait_Settings); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetWaitSettings(var VSetting: TZP_Wait_Settings); {$IFDEF HAS_INLINE}inline;{$ENDIF}

    procedure SetCapture(); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure ReleaseCapture(); {$IFDEF HAS_INLINE}inline;{$ENDIF}

    procedure GetInformation(var VInfo: TZR_Rd_Info); {$IFDEF HAS_INLINE}inline;{$ENDIF}

    function FindCard(var VType: TZr_Card_Type; var VNum: TZ_KeyNum): Boolean;
    procedure EnumCards(var VArr: TCardInfoDynArray; AMax: Integer=ZR_SEARCH_MAXCARD); overload;
    procedure EnumCards(AEnumProc: TZR_EnumCardsProc; AUserData: Pointer); overload; deprecated;

    procedure ReadULCard4Page(APageN: Integer; var VBuf16); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure WriteULCardPage(APageN: Integer; const AData4: Pointer); {$IFDEF HAS_INLINE}inline;{$ENDIF}

    function UpdateFirmware(AData: Pointer; ACount: Integer;
        ACallback: TZR_ProcessCallback; AUserData: Pointer): Boolean; {$IFDEF HAS_INLINE}inline;{$ENDIF}

    // Работа с картами T5557 (только считыватель Z2USB)
    function FindT57(var VNum: TZ_KeyNum; var VPar: Integer;
        APsw, AFlags: Cardinal): Boolean;
    procedure ReadT57Block(ABlockN: Integer; var VBuf4;
        APar: Integer; APsw, AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure WriteT57Block(ABlockN: Integer; const AData4: Pointer;
        APar: Integer; APsw, AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure ResetT57(); {$IFDEF HAS_INLINE}inline;{$ENDIF}

  protected
    procedure WindowMethod(var Message: TMessage);
    procedure CmZReader();

    procedure DoOnCardInsert(AInfo: PZR_Card_Info);
    procedure DoOnCardRemove(AInfo: PZR_Card_Info);
    procedure DoOnCardUnknown(Const AMsg: String);
    procedure DoOnInputsChange(ANewState: Cardinal);
    procedure DoOnIndFlashEnd();
    procedure DoOnError(AErrCode: HResult);
    procedure DoOnConnectionStatus();
    procedure EnableNotifications(AEnable: Boolean);

    procedure Close();
    procedure Open();

    function GetActive(): Boolean;
    procedure SetActive(AValue: Boolean);
    procedure SetNotifications(AValue: Boolean);

  public
    property Active: Boolean read GetActive write SetActive;
    property Handle: THandle read m_hRd;
    property Notifications: Boolean read FNotifications write SetNotifications;
    property OnCardInsert: TZRCardEvent read FOnCardInsert write FOnCardInsert;
    property OnCardRemove: TZRCardEvent read FOnCardRemove write FOnCardRemove;
    property OnCardUnknown: TZRCardUnknownEvent read FOnCardUnknown write FOnCardUnknown;
    property OnInputsChange: TZRInputsChangeEvent read FOnInputsChange write FOnInputsChange;
    property OnIndFlashEnd: TNotifyEvent read FOnIndFlashEnd write FOnIndFlashEnd;
    property OnError: TZpErrorEvent read FOnError write FOnError;
    property OnConnectionChange: TNotifyEvent read FOnConnectChange write FOnConnectChange;

    property PortName: String read FPortName write FPortName;
    property PortType: TZP_Port_Type read FPortType write FPortType;
    property Speed: Cardinal read FSpeed write FSpeed;
    property StopBits: Byte read FStopBits write FStopBits;
    property OpenFlags: Cardinal read FOpenFlags write FOpenFlags;
    property WaitSettings: TZP_Wait_Settings read m_rWS write SetWaitSettings;

    property RdType: TZR_Rd_Type read m_nRdType write m_nRdType;
    property Sn: Integer read m_nSn;
    property Version: Cardinal read m_nVersion;
  end;

  TMfReader = class(TZReader)
  public
    procedure SelectCard(const ANum: TZ_KeyNum; AType: TZr_Card_Type); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function AuthorizeSect(ABlockN: Integer; AKey: PZR_Mf_Auth_Key; AFlags: Cardinal): Boolean; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function AuthorizeSectByEKey(ABlockN: Integer;
        AKeyMask: Cardinal; VRKeyIdx: PInteger; AFlags: Cardinal): Boolean; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure ReadMfCardBlock(ABlockN: Integer; var VBuf16; AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure WriteMfCardBlock(ABlockN: Integer; const AData16: Pointer; AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}

    procedure GetIndicatorState(VRed: PCardinal; VGreen: PCardinal; VSound: PCardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetIndicatorState(ARed: TZR_Ind_State; AGreen: TZR_Ind_State; ASound: TZR_Ind_State); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function AddIndicatorFlash(ARecs: PZR_Ind_Flash; ACount: Integer; AReset: LongBool): Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure BreakIndicatorFlash(AAutoMode: LongBool); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetIndicatorFlashAvailable(): Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}

    procedure Reset1356(AWaitMs: Word); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure PowerOff(); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Request(AWakeUp: LongBool; VATQ: PWord); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Halt(); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure A_S(VNum: PZ_KeyNum; VSAQ: PByte); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure R_A_S(AWakeUp: LongBool;
        VNum: PZ_KeyNum; VSAQ: PByte; VATQ: PWord); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure R_R(const ANum: TZ_KeyNum; AWakeUp: LongBool); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function RATS(var VBuf; ABufSize: Integer): Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Auth(AAddr: Cardinal;
        AKey: PZR_MF_AUTH_KEY; AEKeyMask: Cardinal; VEKeyIdx: PInteger; AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Read16(AAddr: Cardinal; var VBuf16; AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Write16(AAddr: Cardinal; const AData16: Pointer; AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Write4(AAddr: Cardinal; const AData4: Pointer); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Increment(AAddr: Cardinal; AValue: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Decrement(AAddr: Cardinal; AValue: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Transfer(AAddr: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure Restore(AAddr: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}

    procedure WriteKeyToEEPROM(AAddr: Cardinal; AKeyB: LongBool;
        const AKey: TZR_Mf_Auth_Key); {$IFDEF HAS_INLINE}inline;{$ENDIF}
  end;

  // Matrix III Net
  TM3NReader = class(TMfReader)
  public
    procedure ActivatePowerKey(AForce: LongBool; ATimeMs: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetOutputs(AMask, AOutBits: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetInputs(var VFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetConfig(const AConfig: TZR_M3n_Config); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetConfig(var VConfig: TZR_M3n_Config); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetSecurity(ABlockN: Integer; AKeyMask: Cardinal; AKeyB: LongBool); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetSecurity(var VBlockN: Integer; var VKeyMask: Cardinal;
        var VKeyB: LongBool); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetClock(const ATime: TSystemTime); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetClock(var VTime: TSystemTime); {$IFDEF HAS_INLINE}inline;{$ENDIF}
  end;

  // Z-2 Base
  TZ2bReader = class(TZReader)
  public
    procedure SetFormat(AFmt: PWideChar; AArg: PWideChar;
        ANoCard: PWideChar; ASaveEE: LongBool); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetFormat(VFmtBuf: PWideChar; AFmtBufSize: Integer;
        VArgBuf: PWideChar; AArgBufSize: Integer;
        VNCBuf: PWideChar; ANCBufSize: Integer); overload; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure GetFormat(var VFmt, VArg, VNoCard: WideString); overload;

    procedure SetIndicatorState(ARed: TZR_Ind_State; AGreen: TZR_Ind_State; ASound: TZR_Ind_State); {$IFDEF HAS_INLINE}inline;{$ENDIF}
    procedure SetPowerState(AOn: Boolean); {$IFDEF HAS_INLINE}inline;{$ENDIF}
  end;

  TRdDetector = class(TZpDetector)
  public
    constructor Create();
  end;

function CheckZRVersion(): Boolean; {$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure CheckZRError(AErrCode: HResult);
function GetZRErrorText(AErrCode: HResult): String;

procedure ZRInitialize(AFlags: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure ZRFinalyze(); {$IFDEF HAS_INLINE}inline;{$ENDIF}

//procedure EnumSerialPorts(AEnumProc: TZP_EnumPortsProc; AUserData: Pointer); deprecated;
//procedure EnumReaders(AEnumProc: TZR_EnumRdsProc; AUserData: Pointer;
//    APorts: PZP_Port_Addr=nil; APCount: Integer=0;
//    AWait: PZP_Wait_Settings=nil; AFlags: Cardinal=1); deprecated;
//function FindReader(var VInfo: TZR_Rd_Info; var VPort: TZP_Port_Info;
//    APorts: PZP_Port_Addr=nil; APCount: Integer=0;
//    AWait: PZP_Wait_Settings=nil; AFlags: Cardinal=1): Boolean; deprecated;

procedure DecodeT57Config(var VConfig: TZR_T57_Config; const AData4: Pointer); {$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure EncodeT57Config(var VBuf4; const AConfig: TZR_T57_Config); {$IFDEF HAS_INLINE}inline;{$ENDIF}
function DecodeT57EmMarine(VBitOffs: PInteger; var VNum: TZ_KeyNum;
    const AData: Pointer; ACount: Integer): Boolean; {$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure EncodeT57EmMarine(var VBuf; VBufSize: Integer; ABitOffs: Integer;
    const ANum: TZ_KeyNum); {$IFDEF HAS_INLINE}inline;{$ENDIF}
function DecodeT57Hid(var VNum: TZ_KeyNum; const AData12: Pointer; var VWiegand: Integer): Boolean; {$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure EncodeT57Hid(var VBuf12; const ANum: TZ_KeyNum; AWiegand: Integer); {$IFDEF HAS_INLINE}inline;{$ENDIF}

procedure DecodeMfAccessBits(AAreaN: Integer; var VBits: Cardinal; const AData3: Pointer); {$IFDEF HAS_INLINE}inline;{$ENDIF}
procedure EncodeMfAccessBits(AAreaN: Integer; var VBuf3; ABits: Cardinal); {$IFDEF HAS_INLINE}inline;{$ENDIF}

implementation

Const
  CM_ZREADER  = (WM_USER + 1);


{ TZReader }

constructor TZReader.Create();
begin
  inherited Create();
  ZRInitialize(0);
  FStopBits := TWOSTOPBITS;
end;

constructor TZReader.Create(Const APortName: String; APortType: TZP_Port_Type);
begin
  inherited Create();
  FPortName := APortName;
  FPortType := APortType;
  ZRInitialize(0);
  FStopBits := TWOSTOPBITS;
end;

destructor TZReader.Destroy();
begin
  if m_hRd <> 0 then
    ZR_CloseHandle(m_hRd);
  ZRFinalyze();
  if m_hWindow <> 0 then
    DeallocateHWnd(m_hWindow);
  inherited Destroy();
end;

function TZReader.GetConnectionStatus(var VSessionId: Cardinal): TZp_Connection_Status;
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_GetConnectionStatus(m_hRd, Result, VSessionId));
end;

procedure TZReader.SetWaitSettings(Const ASetting: TZP_Wait_Settings);
begin
  if m_hRd <> 0 then
  CheckZRError(ZR_Rd_SetWaitSettings(m_hRd, ASetting));
  m_rWS := ASetting;
end;

procedure TZReader.GetWaitSettings(var VSetting: TZP_Wait_Settings);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_GetWaitSettings(m_hRd, VSetting));
end;

procedure TZReader.SetCapture();
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_SetCapture(m_hRd));
end;

procedure TZReader.ReleaseCapture();
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_ReleaseCapture(m_hRd));
end;

procedure TZReader.GetInformation(var VInfo: TZR_Rd_Info);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_GetInformation(m_hRd, VInfo));
end;

procedure TZReader.DoOnCardInsert(AInfo: PZR_Card_Info);
begin
  if Assigned(FOnCardInsert) then
    FOnCardInsert(Self, AInfo);
end;

procedure TZReader.DoOnCardRemove(AInfo: PZR_Card_Info);
begin
  if Assigned(FOnCardRemove) then
    FOnCardRemove(Self, AInfo);
end;

procedure TZReader.DoOnCardUnknown(Const AMsg: String);
begin
  if Assigned(FOnCardUnknown) then
    FOnCardUnknown(Self, AMsg);
end;

procedure TZReader.DoOnInputsChange(ANewState: Cardinal);
begin
  if Assigned(FOnInputsChange) then
    FOnInputsChange(Self, ANewState);
end;

procedure TZReader.DoOnIndFlashEnd();
begin
  if Assigned(FOnIndFlashEnd) then
    FOnIndFlashEnd(Self);
end;

procedure TZReader.DoOnError(AErrCode: HResult);
begin
  if Assigned(FOnError) then
    FOnError(Self, AErrCode);
end;

procedure TZReader.DoOnConnectionStatus();
begin
  if Assigned(FOnConnectChange) then
    FOnConnectChange(Self);
end;

procedure TZReader.CmZReader();
var
  hr: HResult;
  nMsg: Cardinal;
  nMsgParam: NativeInt;
begin
  repeat
    hr := ZR_Rd_GetNextMessage(m_hRd, nMsg, nMsgParam);
    if hr <> S_OK then
      break;
    case nMsg of
      ZR_RN_CARD_INSERT:        DoOnCardInsert(PZR_Card_Info(nMsgParam));
      ZR_RN_CARD_REMOVE:        DoOnCardRemove(PZR_Card_Info(nMsgParam));
      ZR_RN_CARD_UNKNOWN:       DoOnCardUnknown(WideCharToString(PWideChar(nMsgParam)));
      ZR_RN_INPUT_CHANGE:       DoOnInputsChange(nMsgParam);
      ZR_RN_IND_FLASH_END:      DoOnIndFlashEnd();
      ZR_RN_ERROR:              DoOnError(HResult(Pointer(nMsgParam)^));
      ZR_RDN_CONNECTION_CHANGE: DoOnConnectionStatus();
    end;
  until False;
end;

procedure TZReader.WindowMethod(var Message: TMessage);
begin
  with Message do
    if Msg = CM_ZREADER then
      try
        CmZReader();
      except
{$IFNDEF CONSOLE}
        Application.HandleException(Self);
{$ENDIF}
      end
    else
      Result := DefWindowProc(m_hWindow, Msg, wParam, lParam);
end;

procedure TZReader.EnableNotifications(AEnable: Boolean);
var
  rNS: TZR_Rd_Notify_Settings;
begin
  ASSERT(m_hRd <> 0);
  if AEnable then
  begin
    if m_hWindow = 0 then
      m_hWindow := AllocateHWnd(WindowMethod);
    FillChar(rNS, SizeOf(rNS), 0);
    rNS.nNMask := ZR_RNF_EXIST_CARD;
    if Assigned(FOnIndFlashEnd) then
      Inc(rNS.nNMask, ZR_RNF_IND_FLASH_END);
    if Assigned(FOnInputsChange) then
      Inc(rNS.nNMask, ZR_RNF_INPUT_CHANGE);
    if Assigned(FOnError) then
      Inc(rNS.nNMask, ZR_RNF_ERROR);
    if Assigned(FOnConnectChange) then
      Inc(rNS.nNMask, ZR_RDNF_CONNECTION_CHANGE);
    rNS.hWindow := m_hWindow;
    rNS.nWndMsgId := CM_ZREADER;
    rNS.nCheckInputPeriod := 300;
    CheckZRError(ZR_Rd_SetNotification(m_hRd, @rNS));
  end
  else
  begin
    CheckZRError(ZR_Rd_SetNotification(m_hRd, nil));
    if m_hWindow <> 0 then
    begin
      DeallocateHWnd(m_hWindow);
      m_hWindow := 0;
    end;
  end;
end;

function TZReader.FindCard(var VType: TZr_Card_Type; var VNum: TZ_KeyNum): Boolean;
var
  hr: HResult;
  rInfo: TZr_Card_Info;
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_SearchCards(m_hRd, 1));
  hr := ZR_Rd_FindNextCard(m_hRd, @rInfo);
  Result := (hr = S_OK);
  if Result then
  begin
    VType := rInfo.nType;
    VNum := rInfo.nNum;
  end;
  ZR_Rd_FindNextCard(m_hRd, nil);
  CheckZRError(hr);
end;

procedure TZReader.EnumCards(var VArr: TCardInfoDynArray; AMax: Integer);
var
  hr: HResult;
  rInfo: TZr_Card_Info;
  nIdx: Integer;
begin
  ASSERT(m_hRd <> 0);
  SetLength(VArr, 0);
  CheckZRError(ZR_Rd_SearchCards(m_hRd, AMax));
  repeat
    hr := ZR_Rd_FindNextCard(m_hRd, @rInfo);
    if hr <> S_OK then
      break;
    nIdx := Length(VArr);
    SetLength(VArr, nIdx + 1);
    VArr[nIdx] := rInfo;
  until False;
  CheckZRError(hr);
  ZR_Rd_FindNextCard(m_hRd, nil);
end;

procedure TZReader.EnumCards(AEnumProc: TZR_EnumCardsProc; AUserData: Pointer);
var
  rInfo: TZR_Card_Info;
  hr: HResult;
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_SearchCards(m_hRd, 1));
  repeat
    hr := ZR_Rd_FindNextCard(m_hRd, @rInfo);
    CheckZRError(hr);
    if hr <> S_OK then
      break;
    if not AEnumProc(@rInfo, AUserData) then
      break;
  until False;
  ZR_Rd_FindNextCard(m_hRd, nil); // освобождаем память
end;

procedure TZReader.ReadULCard4Page(APageN: Integer; var VBuf16);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_ReadULCard4Page(m_hRd, APageN, VBuf16));
end;

procedure TZReader.WriteULCardPage(APageN: Integer; const AData4: Pointer);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_WriteULCardPage(m_hRd, APageN, AData4));
end;

function TZReader.UpdateFirmware(AData: Pointer; ACount: Integer;
    ACallback: TZR_ProcessCallback; AUserData: Pointer): Boolean;
var
  nRet: HResult;
begin
  ASSERT(m_hRd <> 0);
  nRet := ZR_Rd_UpdateFirmware(m_hRd, AData, ACount, ACallback, AUserData);
  CheckZRError(nRet);
  Result := (nRet <> ZP_S_CANCELLED);
end;

function TZReader.FindT57(var VNum: TZ_KeyNum; var VPar: Integer;
    APsw, AFlags: Cardinal): Boolean;
var
  nRet: HResult;
begin
  ASSERT(m_hRd <> 0);
  nRet := ZR_Rd_FindT57(m_hRd, VNum, VPar, APsw, AFlags);
  Result := (nRet <> ZR_E_NOT57);
  if not Result then
    Exit;
  CheckZRError(nRet);
end;

procedure TZReader.ReadT57Block(ABlockN: Integer; var VBuf4;
    APar: Integer; APsw, AFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_ReadT57Block(m_hRd, ABlockN, VBuf4, APar, APsw, AFlags));
end;

procedure TZReader.WriteT57Block(ABlockN: Integer; const AData4: Pointer;
    APar: Integer; APsw, AFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_WriteT57Block(m_hRd, ABlockN, AData4, APar, APsw, AFlags));
end;

procedure TZReader.ResetT57();
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_ResetT57(m_hRd));
end;

function TZReader.GetActive(): Boolean;
begin
  Result := (m_hRd <> 0);
end;

procedure TZReader.Close();
begin
  if m_hRd = 0 then
    Exit;
  ZR_CloseHandle(m_hRd);
  m_hRd := 0;
  m_nRdType := ZR_RD_UNDEF;
  if m_hWindow <> 0 then
  begin
    DeallocateHWnd(m_hWindow);
    m_hWindow := 0;
  end;
end;

procedure TZReader.Open();
Const
  pMutexName: LPCTSTR = 'ZPortMutex';
var
  rOpen: TZR_Rd_Open_Params;
  rInfo: TZR_Rd_Info;
  szName: array[0..ZP_MAX_PORT_NAME] of WideChar;
  hMutex: THandle;
  fLock: Boolean;
begin
  ASSERT(m_hRd = 0);
  try
    fLock := False;
    hMutex := CreateMutex(nil, FALSE, pMutexName);
    if (hMutex = 0) and (GetLastError() = ERROR_ALREADY_EXISTS) then
      hMutex := OpenMutex(SYNCHRONIZE, FALSE, pMutexName);
    try
      fLock := (hMutex <> 0) and (WaitForSingleObject(hMutex, INFINITE) = WAIT_OBJECT_0);
    FillChar(rOpen, SizeOf(rOpen), 0);
    StringToWideChar(FPortName, szName, Length(szName));
    rOpen.pszName := szName;
    rOpen.nType := FPortType;
    rOpen.nStopBits := FStopBits;
    rOpen.nFlags := FOpenFlags;
//    FillChar(rWS, SizeOf(rWS), 0);
//    rWS.nCheckPeriod := 10;
    rOpen.pWait := @m_rWS;
    rOpen.nRdType := m_nRdType;
    rOpen.nSpeed := FSpeed;
    FillChar(rInfo, SizeOf(rInfo), 0);
    CheckZRError(ZR_Rd_Open(m_hRd, rOpen, @rInfo));
    finally
      if fLock then
         ReleaseMutex(hMutex);
      if hMutex <> 0 then
        CloseHandle(hMutex);
    end;
    m_nRdType := rInfo.nType;
    m_nSn := rInfo.rBase.nSn;
    m_nVersion := rInfo.rBase.nVersion;
    if FNotifications then
      EnableNotifications(True);
  except
    Close();
    raise;
  end;
end;

procedure TZReader.SetActive(AValue: Boolean);
begin
  if AValue = (m_hRd <> 0) then
    exit;
  if m_hRd <> 0 then
    Close()
  else
    Open();
end;

procedure TZReader.SetNotifications(AValue: Boolean);
begin
  if AValue = FNotifications then
    Exit;
  if m_hRd <> 0 then
    EnableNotifications(AValue);
  FNotifications := AValue;
end;


{ TMfReader }

procedure TMfReader.SelectCard(const ANum: TZ_KeyNum; AType: TZr_Card_Type);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_SelectCard(m_hRd, ANum, AType));
end;

function TMfReader.AuthorizeSect(ABlockN: Integer; AKey: PZR_Mf_Auth_Key; AFlags: Cardinal): Boolean;
var
  nRet: Integer;
begin
  ASSERT(m_hRd <> 0);
  nRet := ZR_Rd_AuthorizeSect(m_hRd, ABlockN, AKey, AFlags);
  if nRet = ZR_E_AUTHORIZE then
  begin
    Result := False;
    Exit;
  end;
  CheckZRError(nRet);
  Result := True;
end;

function TMfReader.AuthorizeSectByEKey(ABlockN: Integer;
    AKeyMask: Cardinal; VRKeyIdx: PInteger; AFlags: Cardinal): Boolean;
var
  nRet: Integer;
begin
  ASSERT(m_hRd <> 0);
  nRet := ZR_Rd_AuthorizeSectByEKey(m_hRd, ABlockN, AKeyMask, VRKeyIdx, AFlags);
  if nRet = ZR_E_AUTHORIZE then
  begin
    Result := False;
    Exit;
  end;
  CheckZRError(nRet);
  Result := True;
end;

procedure TMfReader.ReadMfCardBlock(ABlockN: Integer; var VBuf16; AFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_ReadMfCardBlock(m_hRd, ABlockN, VBuf16, AFlags));
end;

procedure TMfReader.WriteMfCardBlock(ABlockN: Integer; const AData16: Pointer; AFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_WriteMfCardBlock(m_hRd, ABlockN, AData16, AFlags));
end;

procedure TMfReader.GetIndicatorState(VRed: PCardinal; VGreen: PCardinal; VSound: PCardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_GetIndicatorState(m_hRd, VRed, VGreen, VSound));
end;

procedure TMfReader.SetIndicatorState(ARed: TZR_Ind_State; AGreen: TZR_Ind_State; ASound: TZR_Ind_State);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_SetIndicatorState(m_hRd, ARed, AGreen, ASound));
end;

function TMfReader.AddIndicatorFlash(ARecs: PZR_Ind_Flash; ACount: Integer; AReset: LongBool): Integer;
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_AddIndicatorFlash(m_hRd, ARecs, ACount, AReset, Result));
end;

procedure TMfReader.BreakIndicatorFlash(AAutoMode: LongBool);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_BreakIndicatorFlash(m_hRd, AAutoMode));
end;

function TMfReader.GetIndicatorFlashAvailable(): Integer;
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_GetIndicatorFlashAvailable(m_hRd, Result));
end;

procedure TMfReader.Reset1356(AWaitMs: Word);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Reset1356(m_hRd, AWaitMs));
end;

procedure TMfReader.PowerOff();
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_PowerOff(m_hRd));
end;

procedure TMfReader.Request(AWakeUp: LongBool; VATQ: PWord);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Request(m_hRd, AWakeUp, VATQ));
end;

procedure TMfReader.Halt();
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Halt(m_hRd));
end;

procedure TMfReader.A_S(VNum: PZ_KeyNum; VSAQ: PByte);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_A_S(m_hRd, VNum, VSAQ));
end;

procedure TMfReader.R_A_S(AWakeUp: LongBool;
    VNum: PZ_KeyNum; VSAQ: PByte; VATQ: PWord);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_R_A_S(m_hRd, AWakeUp, VNum, VSAQ, VATQ));
end;

procedure TMfReader.R_R(const ANum: TZ_KeyNum; AWakeUp: LongBool);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_R_R(m_hRd, ANum, AWakeUp));
end;

function TMfReader.RATS(var VBuf; ABufSize: Integer): Integer;
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_RATS(m_hRd, VBuf, ABufSize, Result));
end;

procedure TMfReader.Auth(AAddr: Cardinal;
    AKey: PZR_MF_AUTH_KEY; AEKeyMask: Cardinal; VEKeyIdx: PInteger; AFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Auth(m_hRd, AAddr, AKey, AEKeyMask, VEKeyIdx, AFlags));
end;

procedure TMfReader.Read16(AAddr: Cardinal; var VBuf16; AFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Read16(m_hRd, AAddr, VBuf16, AFlags));
end;

procedure TMfReader.Write16(AAddr: Cardinal; const AData16: Pointer; AFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Write16(m_hRd, AAddr, AData16, AFlags));
end;

procedure TMfReader.Write4(AAddr: Cardinal; const AData4: Pointer);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Write4(m_hRd, AAddr, AData4));
end;

procedure TMfReader.Increment(AAddr: Cardinal; AValue: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Increment(m_hRd, AAddr, AValue));
end;

procedure TMfReader.Decrement(AAddr: Cardinal; AValue: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Decrement(m_hRd, AAddr, AValue));
end;

procedure TMfReader.Transfer(AAddr: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Transfer(m_hRd, AAddr));
end;

procedure TMfReader.Restore(AAddr: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_Restore(m_hRd, AAddr));
end;

procedure TMfReader.WriteKeyToEEPROM(AAddr: Cardinal; AKeyB: LongBool;
    const AKey: TZR_Mf_Auth_Key);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_WriteKeyToEEPROM(m_hRd, AAddr, AKeyB, @AKey));
end;


{ TM3NReader }

procedure TM3NReader.ActivatePowerKey(AForce: LongBool; ATimeMs: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_ActivatePowerKey(m_hRd, AForce, ATimeMs));
end;

procedure TM3NReader.SetOutputs(AMask, AOutBits: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_SetOutputs(m_hRd, AMask, AOutBits));
end;

procedure TM3NReader.GetInputs(var VFlags: Cardinal);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_GetInputs(m_hRd, VFlags));
end;

procedure TM3NReader.SetConfig(const AConfig: TZR_M3n_Config);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_SetConfig(m_hRd, AConfig));
end;

procedure TM3NReader.GetConfig(var VConfig: TZR_M3n_Config);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_GetConfig(m_hRd, VConfig));
end;

procedure TM3NReader.SetSecurity(ABlockN: Integer; AKeyMask: Cardinal; AKeyB: LongBool);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_SetSecurity(m_hRd, ABlockN, AKeyMask, AKeyB));
end;

procedure TM3NReader.GetSecurity(var VBlockN: Integer; var VKeyMask: Cardinal;
    var VKeyB: LongBool);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_GetSecurity(m_hRd, VBlockN, VKeyMask, VKeyB));
end;

procedure TM3NReader.SetClock(const ATime: TSystemTime);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_SetClock(m_hRd, ATime));
end;

procedure TM3NReader.GetClock(var VTime: TSystemTime);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_M3n_GetClock(m_hRd, VTime));
end;


{ TZ2bReader }

procedure TZ2bReader.SetFormat(AFmt: PWideChar; AArg: PWideChar;
    ANoCard: PWideChar; ASaveEE: LongBool);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Z2b_SetFormat(m_hRd, AFmt, AArg, ANoCard, ASaveEE));
end;

procedure TZ2bReader.GetFormat(VFmtBuf: PWideChar; AFmtBufSize: Integer;
    VArgBuf: PWideChar; AArgBufSize: Integer;
    VNCBuf: PWideChar; ANCBufSize: Integer);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Z2b_GetFormat(m_hRd, VFmtBuf, AFmtBufSize,
      VArgBuf, AArgBufSize, VNCBuf, ANCBufSize));
end;

procedure TZ2bReader.GetFormat(var VFmt, VArg, VNoCard: WideString);
var
  szFmt, szArg, szNc: array[0..255] of WideChar;
begin
  GetFormat(szFmt, Length(szFmt), szArg, Length(szArg), szNc, Length(szNc));
  VFmt := WideCharToString(szFmt);
  VArg := WideCharToString(szArg);
  VNoCard := WideCharToString(szNc);
end;

procedure TZ2bReader.SetIndicatorState(ARed: TZR_Ind_State; AGreen: TZR_Ind_State; ASound: TZR_Ind_State);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Rd_SetIndicatorState(m_hRd, ARed, AGreen, ASound));
end;

procedure TZ2bReader.SetPowerState(AOn: Boolean);
begin
  ASSERT(m_hRd <> 0);
  CheckZRError(ZR_Z2b_SetPowerState(m_hRd, AOn));
end;


{ TRdDetector }

constructor TRdDetector.Create();
begin
  inherited Create();
  FSDevTypes := ZR_DEVTYPE_READERS;
  FIpDevTypes := ZR_IPDEVTYPE_CVTS;
end;

function CheckZRVersion(): Boolean;
var
  nVersion: Cardinal;
begin
  nVersion := ZR_GetVersion();
  Result := ((nVersion and $ff) = ZR_SDK_VER_MAJOR) and (((nVersion shr 8) and $ff) = ZR_SDK_VER_MINOR);
end;

function GetZRErrorText(AErrCode: HResult): String;
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
      Pointer(GetModuleHandle(ZR_DLL_Name)),
      Cardinal(AErrCode),
      MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
      @pBuffer, 0, nil);
  if pBuffer <> nil then
  begin
    SetString(Result, pBuffer, nLen);
    LocalFree(HLOCAL(pBuffer));
  end
  else
    Result := '';
end;

procedure CheckZRError(AErrCode: HResult);
begin
  if FAILED(AErrCode) then
    raise EZRError.Create(GetZRErrorText(AErrCode), AErrCode);
end;

procedure ZRInitialize(AFlags: Cardinal);
begin
  CheckZRError(ZR_Initialize(AFlags));
end;

procedure ZRFinalyze();
begin
  ZR_Finalyze();
end;

//procedure EnumSerialPorts(AEnumProc: TZP_EnumPortsProc; AUserData: Pointer);
//begin
//  ZPClasses.EnumSerialPorts(ZR_DEVTYPE_READERS, AEnumProc, AUserData);
//end;
//
//procedure EnumReaders(AEnumProc: TZR_EnumRdsProc; AUserData: Pointer;
//    APorts: PZP_Port_Addr; APCount: Integer;
//    AWait: PZP_Wait_Settings; AFlags: Cardinal);
//begin
//  CheckZRError(ZR_Initialize(0));
//  try
//    CheckZRError(ZR_EnumReaders(APorts, APCount, AEnumProc, AUserData, AWait, AFlags));
//  finally
//    ZR_Finalyze();
//  end;
//end;
//
//function FindReader(var VInfo: TZR_Rd_Info; var VPort: TZP_Port_Info;
//    APorts: PZP_Port_Addr; APCount: Integer;
//    AWait: PZP_Wait_Settings; AFlags: Cardinal): Boolean;
//var
//  nRet: HResult;
//begin
//  CheckZRError(ZR_Initialize(0));
//  try
//    nRet := ZR_FindReader(APorts, APCount, VInfo, VPort, AWait, AFlags);
//    CheckZRError(nRet);
//    Result := (nRet = S_OK);
//  finally
//    ZR_Finalyze();
//  end;
//end;

procedure DecodeT57Config(var VConfig: TZR_T57_Config; const AData4: Pointer);
begin
  CheckZRError(ZR_DecodeT57Config(VConfig, AData4));
end;

procedure EncodeT57Config(var VBuf4; const AConfig: TZR_T57_Config);
begin
  CheckZRError(ZR_EncodeT57Config(VBuf4, AConfig));
end;

function DecodeT57EmMarine(VBitOffs: PInteger; var VNum: TZ_KeyNum;
    const AData: Pointer; ACount: Integer): Boolean;
begin
  Result := (ZR_DecodeT57EmMarine(VBitOffs, VNum, AData, ACount) >= 0);
end;

procedure EncodeT57EmMarine(var VBuf; VBufSize: Integer; ABitOffs: Integer;
    const ANum: TZ_KeyNum);
begin
  CheckZRError(ZR_EncodeT57EmMarine(VBuf, VBufSize, ABitOffs, ANum));
end;

function DecodeT57Hid(var VNum: TZ_KeyNum; const AData12: Pointer; var VWiegand: Integer): Boolean;
begin
  Result := (ZR_DecodeT57Hid(VNum, AData12, VWiegand) >= 0);
end;

procedure EncodeT57Hid(var VBuf12; const ANum: TZ_KeyNum; AWiegand: Integer);
begin
  CheckZRError(ZR_EncodeT57Hid(VBuf12, ANum, AWiegand));
end;

procedure DecodeMfAccessBits(AAreaN: Integer; var VBits: Cardinal; const AData3: Pointer);
begin
  CheckZRError(ZR_DecodeMfAccessBits(AAreaN, VBits, AData3));
end;

procedure EncodeMfAccessBits(AAreaN: Integer; var VBuf3; ABits: Cardinal);
begin
  CheckZRError(ZR_EncodeMfAccessBits(AAreaN, VBuf3, ABits));
end;

end.
