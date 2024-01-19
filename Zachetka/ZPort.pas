unit ZPort;

interface

// (rom) this is the switch to change between static and dynamic linking.
// (rom) it is enabled by default here.
// (rom) To disable simply change the '$' to a '.'.
//{$DEFINE ZPORT_LINKONREQUEST}

{$IF CompilerVersion >= 17.0}
  {$DEFINE HAS_INLINE}
{$IFEND}

uses
  Windows;

{$IF not Declared(NativeInt)}
Type
  NativeInt = Integer;
{$IFEND}
{$IF not Declared(PPVoid)}
Type
  PPVoid = ^Pointer;
{$IFEND}
Const
  ZP_SDK_VER_MAJOR        = 1;
  ZP_SDK_VER_MINOR        = 20;
Const
  ZP_S_CANCELLED          = HResult($00040201); // Отменено пользователем
  ZP_S_NOTFOUND           = HResult($00040202); // Не найден (для функции ZP_FindSerialDevice)
  ZP_S_TIMEOUT            = HResult($00040203);
  ZP_E_OPENNOTEXIST       = HResult($80040203); // Порт не существует
  ZP_E_OPENPORT           = HResult($80040205); // Другая ошибка открытия порта
  ZP_E_PORTIO             = HResult($80040206); // Ошибка порта (Конвертор отключен от USB?)
  ZP_E_PORTSETUP          = HResult($80040207); // Ошибка настройки порта
  ZP_E_LOADFTD2XX         = HResult($80040208); // Неудалось загрузить FTD2XX.DLL
  ZP_E_SOCKET             = HResult($80040209); // Не удалось инициализировать сокеты
  ZP_E_SERVERCLOSE        = HResult($8004020A); // Дескриптор закрыт со стороны сервера
  ZP_E_NOTINITALIZED      = HResult($8004020B); // Не проинициализировано с помощью ZP_Initialize
  ZP_E_INSUFFICIENTBUFFER = HResult($8004020C); // Размер буфера слишком мал
  ZP_E_NOCONNECT          = HResult($8004020D);

Const
  ZP_MAX_PORT_NAME        = 31;
  ZP_MAX_REG_DEV          = 16;

Const // Флаги для ZP_Initialize
  ZP_IF_NO_MSG_LOOP       = $0001;  // Приложение не имеет цикла обработки сообщений
                                // (консольное приложение (console) или служба Windows (service))
  ZP_IF_LOG               = $0002;  // Писать лог

Const  // Параметры по умолчанию (тайм-ауты и периоды в миллисекундах)
  ZP_IP_CONNECTTIMEOUT    = 4000;  // Тайм-аут подключения по TCP для порта типа ZP_PORT_IP
  ZP_IP_RESTOREPERIOD     = 3000;  // Период восстановления утерянной TCP-связи (для порта типа ZP_PORT_IP)
  ZP_IPS_CONNECTTIMEOUT   = 10000; // Тайм-аут подключения по TCP для порта типа ZP_PORT_IPS
  ZP_USB_RESTOREPERIOD    = 3000;  // Период восстановления утерянной связи (для портов типов ZP_PORT_COM и ZP_PORT_FT)
  ZP_DTC_FINDUSBPERIOD    = 5000;  // Период поиска USB-устройств (только поиск com-портов) (для детектора устройств)
  ZP_DTC_FINDIPPERIOD     = 15000; // Период поиска IP-устройства по UDP (для детектора устройств)
  ZP_DTC_SCANDEVPERIOD    = INFINITE; // Период сканирования устройств, опросом портов (для детектора устройств)
  ZP_SCAN_RCVTIMEOUT0     = 500;   // Тайм-аут ожидания первого байта ответа на запрос при сканировании устройств
  ZP_SCAN_RCVTIMEOUT      = 3000;  // Тайм-аут ожидания ответа на запрос при сканировании устройств
  ZP_SCAN_MAXTRIES        = 2;     // Максимум попыток запроса при сканировании устройств
  ZP_SCAN_CHECKPERIOD     = INFINITE; // Период проверки входяших данных порта при сканировании портов
  ZP_FINDIP_RCVTIMEOUT    = 1000;  // Тайм-аут поиска ip-устройств по UDP
  ZP_FINDIP_MAXTRIES      = 1;     // Максимум попыток поиска ip-устройств по UDP

{$ALIGN 1}
{$MINENUMSIZE 4}
type
  TZP_PORT_TYPE = (
    ZP_PORT_UNDEF = 0,
    ZP_PORT_COM,	      // Com-порт
    ZP_PORT_FT,		      // FT-порт (через ftd2xx.dll по с/н USB, только для устройств, использующих этот драйвер)
    ZP_PORT_IP,		      // Ip-порт (TCP-клиент)
    ZP_PORT_IPS         // Ip-порт (TCP-сервер)
  );

  // Имя порта
  TZP_PORT_NAME = array[0..ZP_MAX_PORT_NAME] of WideChar;

type
  // Настройки ожидания исполнения функций
  TZP_WAIT_SETTINGS = record
    nReplyTimeout   : Cardinal;   // Тайм-аут ожидания ответа на запрос конвертеру
    nMaxTries         : Integer;    // Количество попыток отправить запрос
    hAbortEvent     : THandle;    // Дескриптор стандартного объекта Event для отмены функции
    nReplyTimeout0  : Cardinal;   // Тайм-аут ожидания первого символа ответа
    nCheckPeriod    : Cardinal;   // Период проверки порта в мс (если =0 или =INFINITE, то по RX-событию)
    nConnectTimeout : Cardinal;   // Тайм-аут подключения по TCP
    nRestorePeriod  : Cardinal;   // Период с которым будут осуществляться попытки восстановить утерянную TCP-связь
  end;
  PZP_WAIT_SETTINGS = ^TZP_WAIT_SETTINGS;

Const // Флаги для ZP_OPEN_PARAMS.nFlags
  ZP_POF_NO_WAIT_CONNECT = $0001;     // Не ждать завершения процедуры подключения
  ZP_POF_NO_CONNECT_ERR  = $0002;     // Не возвращать ошибку в случае когда нет связи
  ZP_POF_NO_DETECT_USB   = $0004;     // Не использовать детектор USB-устройств (для ZP_PORT_FT и ZP_PORT_COM)
type
  // Параметры открытия порта (для функции ZP_Open)
  TZP_PORT_OPEN_PARAMS = record
    szName          : PWideChar;      // Имя порта
    nType           : TZP_PORT_TYPE;  // Тип порта
    nBaud           : DWord;          // Скорость порта
    nEvChar         : AnsiChar;       // Сигнальный символ
    nStopBits       : Byte;           // Количество стоповых битов
    nConnectTimeout : Cardinal;       // Тайм-аут подключения по TCP
    nRestorePeriod  : Cardinal;       // Период с которым будут осуществляться попытки восстановить утерянную TCP-связь
    nFlags          : Cardinal;       // Флаги ZP_PF_...
  end;
  PZP_PORT_OPEN_PARAMS = ^TZP_PORT_OPEN_PARAMS;

Const // Флаги для функции ZP_Port_SetNotification
  ZP_PNF_RXEVENT    = $0001;  // Пришли новые данные от устройства
  ZP_PNF_STATUS     = $0002;  // Изменилось состояние подключения порта

Const // Флаги порта (для nFlags в структуре ZP_PORT_INFO)
  ZP_PIF_BUSY       = $0001;  // Порт занят
  ZP_PIF_USER       = $0002;  // Порт, указанный пользователем (массив _ZP_PORT_ADDR)
type
  // Информация о порте
  TZP_PORT_INFO = record
    nType           : TZP_PORT_TYPE;	          // Тип порта
    szName          : TZP_PORT_NAME;	          // Имя порта
    nFlags          : Cardinal;		              // Флаги порта (ZP_PF_...)
    szFriendly      : TZP_PORT_NAME;	          // Дружественное имя порта
    nDevTypes       : Cardinal;                 // Маска типов устройств
    szOwner         : array[0..63] of WideChar; // Владелец порта (для функции ZP_EnumIpDevices)
  end;
  PZP_PORT_INFO = ^TZP_PORT_INFO;

  TZP_DEVICE_INFO = record
    cbSize          : Cardinal;           // Размер структуры
    nTypeId         : Cardinal;
    nModel          : Cardinal;
    nSn        	    : Cardinal;
    nVersion        : Cardinal;
  end;
  PZP_DEVICE_INFO = ^TZP_DEVICE_INFO;

  // Состояние подключения
  TZP_CONNECTION_STATUS = (
    ZP_CS_DISCONNECTED = 0, // Отключен
    ZP_CS_CONNECTED,        // Подключен
    ZP_CS_CONNECTING,       // Идет подключение... (при первом подключении)
    ZP_CS_RESTORATION       // Восстанавление связи... (при следующих подключениях)
  );

Const // Флаги для ZP_N_CHANGE_INFO.nChangeMask и ZP_N_CHANGE_DEVINFO.nChangeMask
  ZP_CIF_BUSY       = $0004;  // Изменилось состояние "порт занят"
  ZP_CIF_FRIENDLY   = $0008;  // Изменилось дружественное имя порта
  ZP_CIF_OWNER      = $0020;  // Изменился владелец порта (только для IP устройств)
  ZP_CIF_MODEL      = $0080;  // Изменилась модель устройства
  ZP_CIF_SN         = $0100;  // Изменился серийный номер устройства
  ZP_CIF_VERSION    = $0200;  // Изменилась версия прошивки устройства
  ZP_CIF_DEVPARAMS  = $0400;  // Изменились расширенные параметры устройства
  ZP_CIF_LIST       = $0800;  // Изменился список портов (для _ZP_DDN_DEVICE_INFO) или устройств (для _ZP_DDN_PORT_INFO)
Type
  TZp_DevInfoPtr_Array = array[0..4095] of PZP_DEVICE_INFO;
  PZp_DevInfoPtr_Array = ^TZp_DevInfoPtr_Array;
  // Информация о порте
  TZP_DDN_PORT_INFO = record
    rPort           : TZP_PORT_INFO;
    aDevs           : PZp_DevInfoPtr_Array;
    nDevCount       : Integer;
    nChangeMask     : Cardinal;	// Маска изменений
  end;
  PZP_DDN_PORT_INFO = ^TZP_DDN_PORT_INFO;

  // Информация о устройстве
  TZP_DDN_DEVICE_INFO = record
    pInfo           : PZP_DEVICE_INFO;
    aPorts          : PZP_PORT_INFO;
    nPortCount      : Integer;
    nChangeMask     : Cardinal;
  end;
  PZP_DDN_DEVICE_INFO = ^TZP_DDN_DEVICE_INFO;

  TZP_DEVICEPARSEPROC = function(AReply: Pointer; ACount: Cardinal;
      var VPartially: LongBool; VInfo: PZP_DEVICE_INFO;
      VPortArr: PZP_PORT_INFO; AArrLen: Integer; var VPortCount: Integer): LongBool; stdcall;

Const // Флаги для TZP_NOTIFY_SETTINGS.nNMask
  ZP_NF_EXIST             = $0001;  // Уведомления о подключении/отключении порта (ZP_N_INSERT / ZP_N_REMOVE)
  ZP_NF_CHANGE            = $0002;  // Уведомление о изменении параметров порта (ZP_N_CHANGE)
  ZP_NF_ERROR             = $0008;  // Уведомление об ошибке в ните(thread), сканирующей порты (ZP_N_ERROR)
  ZP_NF_SDEVICE           = $0010;  // Информация о устройствах, подключенным к последовательным портам
  ZP_NF_IPDEVICE          = $0020;  // Информация о устройствах, подключенным к IP-портам
  ZP_NF_IPSDEVICE         = $0080;  // Опрашивать устройства через IPS-порты
  ZP_NF_COMPLETED         = $0040;  // Уведомления о завершении сканирования
  ZP_NF_DEVEXIST          = $0004;  // Уведомления о подключении/отключении устройства (ZP_N_DEVINSERT / ZP_N_DEVREMOVE)
  ZP_NF_DEVCHANGE         = $0100;  // Уведомления о изменении параметров устройства (ZP_N_DEVCHANGE)
  ZP_NF_UNIDCOM           = $1000;  // Искать неопознанные com-порты
  ZP_NF_USECOM            = $2000;  // По возможности использовать Com-порт

Const // Уведомления функции ZP_FindUsbNotification
  ZP_N_INSERT             = 1;	// Подключение порта (PZP_DDN_PORT_INFO(MsgParam) - инфо о порте)
  ZP_N_REMOVE             = 2;	// Отключение порта (PZP_DDN_PORT_INFO(MsgParam) - инфо о порте)
  ZP_N_CHANGE             = 3;	// Изменение состояния порта (PZP_DDN_PORT_INFO(MsgParam) - инфо об изменениях)
  ZP_N_ERROR              = 4;  // Произошла ошибка в ните (PHRESULT(MsgParam) - код ошибки)
  ZP_N_COMPLETED          = 5;  // Сканирование завершено (PINT(MsgParam) - маска: b0-список com-портов, b1-список ip-портов, b2-информация об устройствах, <0-ошибка)
  ZP_N_DEVINSERT          = 6;  // Подключение устройства (PZP_DDN_DEVICE_INFO(MsgParam) - инфо о устройстве)
  ZP_N_DEVREMOVE          = 7;  // Отключение устройства (PZP_DDN_DEVICE_INFO(MsgParam) - инфо о устройстве)
  ZP_N_DEVCHANGE          = 8;  // Изменение параметров устройства (PZP_DDN_DEVICE_INFO(MsgParam) - инфо об изменениях)

Type
  TZP_DD_NOTIFY_SETTINGS = record
    nNMask          : Cardinal;	      // Маска типов уведомлений ZP_NF_

    hEvent          : THandle;        // Событие (объект синхронизации)
    hWindow         : HWnd;           // Параметр для Callback-функции
    nWndMsgId       : Cardinal;       // Сообщение для отправки окну hWnd

    nSDevTypes      : Cardinal;	      // Маска тивов устройств, подключенных к последовательному порту
    nIpDevTypes     : Cardinal;	      // Маска тивов Ip-устройств

    aIps            : PWord;          // Массив TCP-портов для подключения конвертеров в режиме "CLIENT" (если NULL, то не используется)
    nIpsCount       : Integer;        // Количество TCP-портов
  end;
  PZP_DD_NOTIFY_SETTINGS = ^TZP_DD_NOTIFY_SETTINGS;

  TZP_DD_GLOBAL_SETTINGS = record
    nCheckUsbPeriod : Cardinal;	      // Период проверки состояния USB-портов (в миллисекундах) (=0 по умолчанию 5000)
    nCheckIpPeriod  : Cardinal;	      // Период проверки состояния IP-портов (в миллисекундах) (=0 по умолчанию 15000)
    nScanDevPeriod  : Cardinal;       // Период сканирования устройств на USB- и IP-портах (в миллисекундах) (=0 по умолчанию никогда=INFINITE)

    nIpReqTimeout   : Cardinal;       // Тайм-аут ожидания ответа от ip-устройства при опросе по UDP
    nIpReqMaxTries  : Integer;        // Количество попыток опроса ip-устройства по UDP
    rScanWS         : TZP_WAIT_SETTINGS; // Параметры ожидания при сканировании портов
  end;
  PZP_DD_GLOBAL_SETTINGS = ^TZP_DD_GLOBAL_SETTINGS;

  TZP_DEVICE = record
    nTypeId         : Cardinal;             // Тип устройства
    pReqData        : Pointer;              // Данные запроса (может быть NULL)
    nReqSize        : Cardinal;             // Количество байт в запросе
    pfnParse   	    : TZP_DEVICEPARSEPROC;  // Функция разбора ответа
    nDevInfoSize    : Cardinal;             // Размер структуры ZP_DEVICE_INFO
  end;
  PZP_DEVICE = ^TZP_DEVICE;

  TZP_IP_DEVICE = record
    rBase           : TZP_DEVICE;
    nReqPort        : Word;                 // UDP-порт для запроса
    nMaxPort        : Integer;              // Максимум портов у устройства (линий у конвертера)
  end;
  PZP_IP_DEVICE = ^TZP_IP_DEVICE;

  TZP_USB_DEVICE = record
    rBase           : TZP_DEVICE;
    pVidPids        : PDWord;               // Vid,Pid USB-устройств
    nVidPidCount    : Integer;              // Количество Vid,Pid
    nBaud           : Cardinal;             // Скорость порта
    chEvent         : AnsiChar;             // Символ-признак конца передачи (если =0, нет символа)
    nStopBits       : Byte;                 // Стоповые биты (ONESTOPBIT=0, ONE5STOPBITS=1, TWOSTOPBITS=2)
    pszBDesc        : PWideChar;            // Описание устройства, предоставленное шиной (DEVPKEY_Device_BusReportedDeviceDesc)
  end;
  PZP_USB_DEVICE = ^TZP_USB_DEVICE;

  TZP_PORT_ADDR = record
    nType           : TZP_PORT_TYPE;
    pName           : PWideChar;
    nDevTypes       : Cardinal;
  end;
  PZP_PORT_ADDR = ^TZP_PORT_ADDR;

Const // Флаги для параметра ZP_SEARCH_PARAMS.nFlags
  ZP_SF_USECOM      = $0001;  // Использовать COM-порт по возможности
  ZP_SF_DETECTOR    = $0002;  // Использовать уже готовый список найденных устройств Детектора (создается функцией ZP_FindNotification)
  ZP_SF_IPS         = $0004;  // Включить в список найденные IP-конвертеры в режиме CLIENT
  ZP_SF_UNID        = $0008;  // Включить в список неопознанные устройства
  ZP_SF_UNIDCOM     = $0010;  // Опрашивать неопознанные com-порты
Type
  // Параметры поиска устройств (для функции ZP_SearchDevices)
  TZP_SEARCH_PARAMS = record
    nDevMask        : Cardinal;             // Маска устройств для сканирования портов (=0 не искать, =0xffffffff искать всё)
    nIpDevMask      : Cardinal;             // Маска IP устройств, сканируемых с помощью UDP-запроса (=0 не искать, =0xffffffff искать всё)
    pPorts          : PZP_PORT_ADDR;        // Список портов
    nPCount         : Integer;              // Размер списка портов
    nFlags          : Cardinal;             // Флаги ZP_SF_...
    pWait           : PZP_WAIT_SETTINGS;    // Параметры ожидания для сканирования портов. Может быть =NULL.
    nIpReqTimeout   : Cardinal;             // Тайм-аут ожидания ответа от ip-устройства при опросе по UDP
    nIpReqMaxTries    : Integer;              // Количество попыток опроса ip-устройства по UDP
  end;
  PZP_SEARCH_PARAMS =^ TZP_SEARCH_PARAMS;


Type
  TZP_SetLog = function(ASvrAddr, AFileName: PWideChar; AFileTypeMask: Cardinal): HResult; stdcall;
  TZP_GetLog = function(VSvrAddrBuf: PWideChar; ASABufSize: Cardinal;
    VFileNameBuf: PWideChar; AFNBufSize: Cardinal; var VFileTypeMask: Cardinal): HResult; stdcall;
  TZP_AddLog = function(ASrc: WideChar; AMsgType: Integer; AText: PWideChar): HResult; stdcall;

{$MINENUMSIZE 1}
{$ALIGN ON}

{$IFNDEF ZPORT_LINKONREQUEST}

// Возвращает версию библиотеки
function ZP_GetVersion(): Cardinal; stdcall;

// Инициализация/финализация библиотеки
function ZP_Initialize(VObject: PPVoid; AFlags: Cardinal): HResult; stdcall;
function ZP_Finalyze(): HResult; stdcall;

function ZP_CloseHandle(AHandle: THandle): HResult; stdcall;
// Создает список подключенных портов
function ZP_GetPortInfoList(var VHandle: THandle; var VCount: Integer;
    ASerDevs: Cardinal=$ffffffff; AFlags: Cardinal=0): HResult; stdcall;
function ZP_GetPortInfo(AHandle: THandle; AIdx: Integer; var VInfo: TZP_PORT_INFO): HResult; stdcall;
// Ищет устройства, сканируя порты и(или) опрашивая ip-устройства по UDP
function ZP_SearchDevices(var VHandle: THandle; Const AParams: TZP_SEARCH_PARAMS): HResult; stdcall;
function ZP_FindNextDevice(AHandle: THandle; VInfo: PZP_DEVICE_INFO;
    VPortArr: PZP_PORT_INFO; AArrLen: Integer; var VPortCount: Integer;
    ATimeout: Cardinal=INFINITE): HResult; stdcall;

// Уведомления о событиях порта (подключении/отключении, заняли/освободился)
function ZP_DD_SetNotification(var VHandle: THandle; Const ASettings: TZP_DD_NOTIFY_SETTINGS): HResult; stdcall;
function ZP_DD_GetNextMessage(AHandle: THandle; var VMsg: Cardinal; var VMsgParam: NativeInt): HResult; stdcall;
function ZP_DD_SetGlobalSettings(ASettings: PZP_DD_GLOBAL_SETTINGS): HResult; stdcall;
function ZP_DD_GetGlobalSettings(var VSettings: TZP_DD_GLOBAL_SETTINGS): HResult; stdcall;
function ZP_DD_Refresh(AWaitMs: Cardinal=0): HResult; stdcall;

function ZP_SetServiceCtrlHandle(ASvc: THandle): HResult; stdcall;
procedure ZP_DeviceEventNotify(AEvType: Cardinal; AEvData: Pointer); stdcall;

// Разбота с портом
function ZP_Port_Open(var VHandle: THandle; AParams: PZP_PORT_OPEN_PARAMS): HResult; stdcall;
function ZP_Port_SetBaudAndEvChar(AHandle: THandle; ABaud: Cardinal; AEvChar: AnsiChar): HResult; stdcall;
function ZP_Port_GetBaudAndEvChar(AHandle: THandle; VBaud: PCardinal; VEvChar: PAnsiChar): HResult; stdcall;
function ZP_Port_GetConnectionStatus(AHandle: THandle; var VValue: TZP_CONNECTION_STATUS; var VSessionId: Cardinal): HResult; stdcall;
function ZP_Port_SetNotification(AHandle: THandle; AEvent: THandle; AWnd: HWnd;
    AWndMsgId: Cardinal; AMsgMask: Cardinal): HResult; stdcall;
function ZP_Port_EnumMessages(AHandle: THandle; var VMsgs: Cardinal): HResult; stdcall;
function ZP_Port_Clear(AHandle: THandle; AIn, AOut: LongBool): HResult; stdcall;
function ZP_Port_Write(AHandle: THandle; Const ABuf; ACount: Cardinal): HResult; stdcall;
function ZP_Port_Read(AHandle: THandle; var VBuf; ACount: Cardinal; var VRead: Cardinal): HResult; stdcall;
function ZP_Port_GetInCount(AHandle: THandle; var VCount: Cardinal): HResult; stdcall;
function ZP_Port_SetDtr(AHandle: THandle; AState: LongBool): HResult; stdcall;
function ZP_Port_SetRts(AHandle: THandle; AState: LongBool): HResult; stdcall;

// Работа с устройствами
function ZP_RegSerialDevice(Const AParams: TZP_USB_DEVICE): HResult; stdcall;
function ZP_RegIpDevice(Const AParams: TZP_IP_DEVICE): HResult; stdcall;

//{$IFDEF ZP_LOG}
//function ZP_SetLog(ASvrAddr, AFileName: PWideChar; AFileTypeMask: Cardinal): HResult; stdcall;
//function ZP_GetLog(VSvrAddrBuf: PWideChar; ASABufSize: Cardinal;
//    VFileNameBuf: PWideChar; AFNBufSize: Cardinal; var VFileTypeMask: Cardinal): HResult; stdcall;
//function ZP_AddLog(ASrc: WideChar; AMsgType: Integer; AText: PWideChar): HResult; stdcall;
//{$ENDIF !ZP_LOG}

{$ELSE}
type
  TZP_GetVersion = function(): Cardinal; stdcall;
  TZP_Initialize = function(VObject: PPVoid; AFlags: Cardinal): HResult; stdcall;
  TZP_Finalyze = function(): HResult; stdcall;
  TZP_CloseHandle = function(AHandle: THandle): HResult; stdcall;
  TZP_GetPortInfoList = function(var VHandle: THandle; var VCount: Integer;
      ASerDevs: Cardinal=$ffffffff; AFlags: Cardinal=0): HResult; stdcall;
  TZP_GetPortInfo = function(AHandle: THandle; AIdx: Integer; var VInfo: TZP_PORT_INFO): HResult; stdcall;
  TZP_SearchDevices = function(var VHandle: THandle; Const AParams: TZP_SEARCH_PARAMS): HResult; stdcall;
  TZP_FindNextDevice = function(AHandle: THandle; VInfo: PZP_DEVICE_INFO;
      VPortArr: PZP_PORT_INFO; AArrLen: Integer; var VPortCount: Integer;
      ATimeout: Cardinal=INFINITE): HResult; stdcall;
  TZP_DD_SetNotification = function(var VHandle: THandle; Const ASettings: TZP_DD_NOTIFY_SETTINGS): HResult; stdcall;
  TZP_DD_GetNextMessage = function(AHandle: THandle; var VMsg: Cardinal; var VMsgParam: NativeInt): HResult; stdcall;
  TZP_DD_SetGlobalSettings = function(ASettings: PZP_DD_GLOBAL_SETTINGS): HResult; stdcall;
  TZP_DD_GetGlobalSettings = function(var VSettings: TZP_DD_GLOBAL_SETTINGS): HResult; stdcall;
  TZP_DD_Refresh = function(AWaitMs: Cardinal=0): HResult; stdcall;
  TZP_SetServiceCtrlHandle = function(ASvc: THandle): HResult; stdcall;
  TZP_DeviceEventNotify = procedure(AEvType: Cardinal; AEvData: Pointer); stdcall;
  TZP_Port_Open = function(var VHandle: THandle; AParams: PZP_PORT_OPEN_PARAMS): HResult; stdcall;
  TZP_Port_SetBaudAndEvChar = function(AHandle: THandle; ABaud: Cardinal; AEvChar: AnsiChar): HResult; stdcall;
  TZP_Port_GetBaudAndEvChar = function(AHandle: THandle; VBaud: PCardinal; VEvChar: PAnsiChar): HResult; stdcall;
  TZP_Port_GetConnectionStatus = function(AHandle: THandle; var VValue: TZP_CONNECTION_STATUS; var VSessionId: Cardinal): HResult; stdcall;
  TZP_Port_SetNotification = function(AHandle: THandle; AEvent: THandle; AWnd: HWnd;
      AWndMsgId: Cardinal; AMsgMask: Cardinal): HResult; stdcall;
  TZP_Port_EnumMessages = function(AHandle: THandle; var VMsgs: Cardinal): HResult; stdcall;
  TZP_Port_Clear = function(AHandle: THandle; AIn, AOut: LongBool): HResult; stdcall;
  TZP_Port_Write = function(AHandle: THandle; Const ABuf; ACount: Cardinal): HResult; stdcall;
  TZP_Port_Read = function(AHandle: THandle; var VBuf; ACount: Cardinal; var VRead: Cardinal): HResult; stdcall;
  TZP_Port_GetInCount = function(AHandle: THandle; var VCount: Cardinal): HResult; stdcall;
  TZP_Port_SetDtr = function(AHandle: THandle; AState: LongBool): HResult; stdcall;
  TZP_Port_SetRts = function(AHandle: THandle; AState: LongBool): HResult; stdcall;
  TZP_RegSerialDevice = function(Const AParams: TZP_USB_DEVICE): HResult; stdcall;
  TZP_RegIpDevice = function(Const AParams: TZP_IP_DEVICE): HResult; stdcall;
var
  ZP_GetVersion: TZP_GetVersion;
  ZP_Initialize: TZP_Initialize;
  ZP_Finalyze: TZP_Finalyze;
  ZP_CloseHandle: TZP_CloseHandle;
  ZP_GetPortInfoList: TZP_GetPortInfoList;
  ZP_GetPortInfo: TZP_GetPortInfo;
  ZP_SearchDevices: TZP_SearchDevices;
  ZP_FindNextDevice: TZP_FindNextDevice;
  ZP_DD_SetNotification: TZP_DD_SetNotification;
  ZP_DD_GetNextMessage: TZP_DD_GetNextMessage;
  ZP_DD_SetGlobalSettings: TZP_DD_SetGlobalSettings;
  ZP_DD_GetGlobalSettings: TZP_DD_GetGlobalSettings;
  ZP_DD_Refresh: TZP_DD_Refresh;
  ZP_SetServiceCtrlHandle: TZP_SetServiceCtrlHandle;
  ZP_DeviceEventNotify: TZP_DeviceEventNotify;
  ZP_Port_Open: TZP_Port_Open;
  ZP_Port_SetBaudAndEvChar: TZP_Port_SetBaudAndEvChar;
  ZP_Port_GetBaudAndEvChar: TZP_Port_GetBaudAndEvChar;
  ZP_Port_GetConnectionStatus: TZP_Port_GetConnectionStatus;
  ZP_Port_SetNotification: TZP_Port_SetNotification;
  ZP_Port_EnumMessages: TZP_Port_EnumMessages;
  ZP_Port_Clear: TZP_Port_Clear;
  ZP_Port_Write: TZP_Port_Write;
  ZP_Port_Read: TZP_Port_Read;
  ZP_Port_GetInCount: TZP_Port_GetInCount;
  ZP_Port_SetDtr: TZP_Port_SetDtr;
  ZP_Port_SetRts: TZP_Port_SetRts;
  ZP_RegSerialDevice: TZP_RegSerialDevice;
  ZP_RegIpDevice: TZP_RegIpDevice;
{$ENDIF !ZPORT_LINKONREQUEST}
var
  ZP_SetLog: TZP_SetLog;
  ZP_GetLog: TZP_GetLog;
  ZP_AddLog: TZP_AddLog;

Const
//  ZP_DLL_Name = 'ZPort.dll';
//  ZP_DLL_Name = 'ZGuard.dll';
  ZP_DLL_Name = 'ZReader.dll';

function IsZPortLoaded(): Boolean;
function GetZPortModuleHandle(): THandle;
function LoadZPort(): HResult;
procedure UnloadZPort();

implementation

uses
  SysUtils {$IFDEF ZPORT_LINKONREQUEST}, SysConst {$ENDIF ZPORT_LINKONREQUEST};

{$IFDEF ZPORT_LINKONREQUEST}
var
  g_hLib: THandle = 0;
  g_nLoadCount: Integer = 0;
{$ENDIF ZPORT_LINKONREQUEST}

function IsZPortLoaded(): Boolean;
begin
{$IFDEF ZPORT_LINKONREQUEST}
  Result := g_hLib <> 0;
{$ELSE}
  Result := True;
{$ENDIF ZPORT_LINKONREQUEST}
end;

function GetZPortModuleHandle(): THandle;
begin
{$IFDEF ZPORT_LINKONREQUEST}
  Result := g_hLib;
{$ELSE}
  Result := 0;
{$ENDIF ZPORT_LINKONREQUEST}
end;

function LoadZPort(): HResult;
{$IFDEF ZPORT_LINKONREQUEST}
  function GetModuleSymbolEx(ASymbolName: LPCSTR; var VAccu: HResult): Pointer;
  begin
    Result := GetProcAddress(g_hLib, ASymbolName);
    if Result = nil then VAccu := E_NOINTERFACE;
  end;
{$ENDIF ZPORT_LINKONREQUEST}
  function CheckZpVersion(): Boolean;
  var
    nVersion: Cardinal;
  begin
    nVersion := ZP_GetVersion();
    Result := ((nVersion and $ff) = ZP_SDK_VER_MAJOR) and (((nVersion shr 8) and $ff) = ZP_SDK_VER_MINOR);
  end;
var
  hMod: THandle;
begin
{$IFDEF ZPORT_LINKONREQUEST}
  Result := S_OK;
  Inc(g_nLoadCount);
  if g_nLoadCount > 1 then
    Exit;
  g_hLib := LoadLibrary(PChar(ZP_DLL_Name));
  if g_hLib = 0 then
  begin
    Result := HResultFromWin32(GetLastError());
    exit;
  end;

  hMod := g_hLib;
  @ZP_GetVersion := GetModuleSymbolEx('ZP_GetVersion', Result);
  if Succeeded(Result) and CheckZpVersion() then
  begin
    @ZP_Initialize := GetModuleSymbolEx('ZP_Initialize', Result);
    @ZP_Finalyze := GetModuleSymbolEx('ZP_Finalyze', Result);
    @ZP_CloseHandle := GetModuleSymbolEx('ZP_CloseHandle', Result);
    @ZP_GetPortInfoList := GetModuleSymbolEx('ZP_GetPortInfoList', Result);
    @ZP_GetPortInfo := GetModuleSymbolEx('ZP_GetPortInfo', Result);
    @ZP_SearchDevices := GetModuleSymbolEx('ZP_SearchDevices', Result);
    @ZP_FindNextDevice := GetModuleSymbolEx('ZP_FindNextDevice', Result);
    @ZP_DD_SetNotification := GetModuleSymbolEx('ZP_DD_SetNotification', Result);
    @ZP_DD_GetNextMessage := GetModuleSymbolEx('ZP_DD_GetNextMessage', Result);
    @ZP_DD_SetGlobalSettings := GetModuleSymbolEx('ZP_DD_SetGlobalSettings', Result);
    @ZP_DD_GetGlobalSettings := GetModuleSymbolEx('ZP_DD_GetGlobalSettings', Result);
    @ZP_DD_Refresh := GetModuleSymbolEx('ZP_DD_Refresh', Result);
    @ZP_SetServiceCtrlHandle := GetModuleSymbolEx('ZP_SetServiceCtrlHandle', Result);
    @ZP_DeviceEventNotify := GetModuleSymbolEx('ZP_DeviceEventNotify', Result);
    @ZP_Port_Open := GetModuleSymbolEx('ZP_Port_Open', Result);
    @ZP_Port_SetBaudAndEvChar := GetModuleSymbolEx('ZP_Port_SetBaudAndEvChar', Result);
    @ZP_Port_GetBaudAndEvChar := GetModuleSymbolEx('ZP_Port_GetBaudAndEvChar', Result);
    @ZP_Port_GetConnectionStatus := GetModuleSymbolEx('ZP_Port_GetConnectionStatus', Result);
    @ZP_Port_SetNotification := GetModuleSymbolEx('ZP_Port_SetNotification', Result);
    @ZP_Port_EnumMessages := GetModuleSymbolEx('ZP_Port_EnumMessages', Result);
    @ZP_Port_Clear := GetModuleSymbolEx('ZP_Port_Clear', Result);
    @ZP_Port_Write := GetModuleSymbolEx('ZP_Port_Write', Result);
    @ZP_Port_Read := GetModuleSymbolEx('ZP_Port_Read', Result);
    @ZP_Port_GetInCount := GetModuleSymbolEx('ZP_Port_GetInCount', Result);
    @ZP_Port_SetDtr := GetModuleSymbolEx('ZP_Port_SetDtr', Result);
    @ZP_Port_SetRts := GetModuleSymbolEx('ZP_Port_SetRts', Result);
    @ZP_RegSerialDevice := GetModuleSymbolEx('ZP_RegSerialDevice', Result);
    @ZP_RegIpDevice := GetModuleSymbolEx('ZP_RegIpDevice', Result);
  end
  else
    Result := E_NOINTERFACE;

  if Failed(Result) then
    UnloadZPort();
{$ELSE}
  hMod := GetModuleHandle(ZP_DLL_Name);
  if CheckZpVersion() then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
{$ENDIF ZPORT_LINKONREQUEST}
  if Result = S_OK then
  begin
    @ZP_SetLog := GetProcAddress(hMod, 'ZP_SetLog');
    @ZP_GetLog := GetProcAddress(hMod, 'ZP_GetLog');
    @ZP_AddLog := GetProcAddress(hMod, 'ZP_AddLog');
  end;
end;

procedure UnloadZPort();
begin
{$IFDEF ZPORT_LINKONREQUEST}
  Dec(g_nLoadCount);
  if g_nLoadCount > 0 then
    exit;
  FreeLibrary(g_hLib);
  g_hLib := 0;
  ZP_GetVersion := nil;
  ZP_Initialize := nil;
  ZP_Finalyze := nil;
  ZP_CloseHandle := nil;
  ZP_GetPortInfoList := nil;
  ZP_GetPortInfo := nil;
  ZP_SearchDevices := nil;
  ZP_FindNextDevice := nil;
  ZP_DD_SetNotification := nil;
  ZP_DD_GetNextMessage := nil;
  ZP_DD_SetGlobalSettings := nil;
  ZP_DD_GetGlobalSettings := nil;
  ZP_DD_Refresh := nil;
  ZP_SetServiceCtrlHandle := nil;
  ZP_DeviceEventNotify := nil;

  ZP_Port_Open := nil;
  ZP_Port_SetBaudAndEvChar := nil;
  ZP_Port_GetBaudAndEvChar := nil;
  ZP_Port_GetConnectionStatus := nil;
  ZP_Port_SetNotification := nil;
  ZP_Port_EnumMessages := nil;
  ZP_Port_Clear := nil;
  ZP_Port_Write := nil;
  ZP_Port_Read := nil;
  ZP_Port_GetInCount := nil;
  ZP_Port_SetDtr := nil;
  ZP_Port_SetRts := nil;
  ZP_RegSerialDevice := nil;
  ZP_RegIpDevice := nil;
{$IFDEF ZP_LOG}
  ZP_SetLog := nil;
  ZP_GetLog := nil;
  ZP_AddLog := nil;
{$ENDIF !ZP_LOG}
{$ENDIF ZPORT_LINKONREQUEST}
end;

{$IFNDEF ZPORT_LINKONREQUEST}

function ZP_GetVersion(): Cardinal; stdcall;
        External ZP_DLL_Name name 'ZP_GetVersion';

function ZP_Initialize(VObject: PPVoid; AFlags: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Initialize';
function ZP_Finalyze(): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Finalyze';


function ZP_CloseHandle(AHandle: THandle): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_CloseHandle';
function ZP_GetPortInfoList(var VHandle: THandle; var VCount: Integer;
    ASerDevs: Cardinal; AFlags: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_GetPortInfoList';
function ZP_GetPortInfo(AHandle: THandle; AIdx: Integer; var VInfo: TZP_PORT_INFO): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_GetPortInfo';
function ZP_SearchDevices(var VHandle: THandle; Const AParams: TZP_SEARCH_PARAMS): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_SearchDevices';
function ZP_FindNextDevice(AHandle: THandle; VInfo: PZP_DEVICE_INFO;
    VPortArr: PZP_PORT_INFO; AArrLen: Integer; var VPortCount: Integer;
    ATimeout: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_FindNextDevice';

function ZP_DD_SetNotification(var VHandle: THandle; Const ASettings: TZP_DD_NOTIFY_SETTINGS): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_DD_SetNotification';
function ZP_DD_GetNextMessage(AHandle: THandle; var VMsg: Cardinal; var VMsgParam: NativeInt): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_DD_GetNextMessage';
function ZP_DD_SetGlobalSettings(ASettings: PZP_DD_GLOBAL_SETTINGS): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_DD_SetGlobalSettings';
function ZP_DD_GetGlobalSettings(var VSettings: TZP_DD_GLOBAL_SETTINGS): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_DD_GetGlobalSettings';
function ZP_DD_Refresh(AWaitMs: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_DD_Refresh';
function ZP_SetServiceCtrlHandle(ASvc: THandle): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_SetServiceCtrlHandle';
procedure ZP_DeviceEventNotify(AEvType: Cardinal; AEvData: Pointer); stdcall;
        External ZP_DLL_Name name 'ZP_DeviceEventNotify';

function ZP_Port_Open(var VHandle: THandle; AParams: PZP_PORT_OPEN_PARAMS): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_Open';
function ZP_Port_SetBaudAndEvChar(AHandle: THandle; ABaud: Cardinal; AEvChar: AnsiChar): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_SetBaudAndEvChar';
function ZP_Port_GetBaudAndEvChar(AHandle: THandle; VBaud: PCardinal; VEvChar: PAnsiChar): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_GetBaudAndEvChar';
function ZP_Port_GetConnectionStatus(AHandle: THandle; var VValue: TZP_CONNECTION_STATUS; var VSessionId: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_GetConnectionStatus';
function ZP_Port_SetNotification(AHandle: THandle; AEvent: THandle; AWnd: HWnd;
    AWndMsgId: Cardinal; AMsgMask: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_SetNotification';
function ZP_Port_EnumMessages(AHandle: THandle; var VMsgs: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_EnumMessages';

function ZP_Port_Clear(AHandle: THandle; AIn, AOut: LongBool): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_Clear';
function ZP_Port_Write(AHandle: THandle; Const ABuf; ACount: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_Write';
function ZP_Port_Read(AHandle: THandle; var VBuf; ACount: Cardinal; var VRead: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_Read';
function ZP_Port_GetInCount(AHandle: THandle; var VCount: Cardinal): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_GetInCount';
function ZP_Port_SetDtr(AHandle: THandle; AState: LongBool): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_SetDtr';
function ZP_Port_SetRts(AHandle: THandle; AState: LongBool): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_Port_SetRts';

function ZP_RegSerialDevice(Const AParams: TZP_USB_DEVICE): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_RegSerialDevice';
function ZP_RegIpDevice(Const AParams: TZP_IP_DEVICE): HResult; stdcall;
        External ZP_DLL_Name name 'ZP_RegIpDevice';
//{$IFDEF ZP_LOG}
//function ZP_SetLog(ASvrAddr, AFileName: PWideChar; AFileTypeMask: Cardinal): HResult; stdcall;
//        External ZP_DLL_Name name 'ZP_SetLog';
//function ZP_GetLog(VSvrAddrBuf: PWideChar; ASABufSize: Cardinal;
//    VFileNameBuf: PWideChar; AFNBufSize: Cardinal; var VFileTypeMask: Cardinal): HResult; stdcall;
//        External ZP_DLL_Name name 'ZP_GetLog';
//function ZP_AddLog(ASrc: WideChar; AMsgType: Integer; AText: PWideChar): HResult; stdcall;
//        External ZP_DLL_Name name 'ZP_AddLog';
//{$ENDIF !ZP_LOG}

{$ENDIF !ZPORT_LINKONREQUEST}


end.
