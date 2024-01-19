unit ZReader;

interface

// (rom) this is the switch to change between static and dynamic linking.
// (rom) it is enabled by default here.
// (rom) To disable simply change the '$' to a '.'.
//{$DEFINE ZREADER_LINKONREQUEST}

{$IF CompilerVersion >= 17.0}
  {$DEFINE HAS_INLINE}
{$IFEND}

uses
  Windows, ZPort, ZBase;

Const
  ZR_SDK_VER_MAJOR          = 3;
  ZR_SDK_VER_MINOR          = 31;

Const
  ZR_E_NOANSWER             = HResult($80040302); // Нет ответа
  ZR_E_BADANSWER            = HResult($80040303); // Нераспознанный ответ
  ZR_E_CARDNOTSELECT        = HResult($80040304); // Карта не выбрана с помощью функции ZR_Rd_SelectCard
  ZR_E_NOCARD               = HResult($80040305); // Карта не обнаружена
  ZR_E_WRONGZPORT           = HResult($80040306); // Не правильная версия ZPort.dll
  ZR_E_RDERROR              = HResult($80040307); // Неизвестная ошибка считывателя
  ZR_E_CARDACCESS           = HResult($80040308); // Нет доступа к карте
  ZR_E_PAGELOCK             = HResult($80040309); // Страница заблокирована
  ZR_E_NOT57                = HResult($8004030A); // Карта не типа T57
  ZR_E_NOWRITET57           = HResult($8004030B); // Не удалось записать на T57
  ZR_E_INVMODEL             = HResult($8004030C); // Несоответствие модели (при прошивке)
  ZR_E_INVBOOTFILE          = HResult($8004030D); // Некорректные данные прошивки
  ZR_E_BUFFEROVERFLOWN      = HResult($8004030E); // Буфер переполнен
  ZR_E_KEYNOTFOUND          = HResult($8004030F); // Подходящий ключ не найден
  ZR_E_AUTHORIZE            = HResult($80040310); // Ошибка авторизации карты
  ZR_E_CARDNACK             = HResult($80040311); // Карта отказала в исполнении команды
  ZR_E_RESEXHAUSTED         = HResult($80040312); // Ресурсы устройства исчерпаны
  ZR_E_PREVNOTCOMLETED      = HResult($80040313); // Предыдущая команда не завершена

Const
  ZR_IF_LOG                 = $0100; // Записывать лог
Const
  ZR_DEVTYPE_CVT            = 0;
  ZR_DEVTYPE_Z2U            = 3;
  ZR_DEVTYPE_Z2M            = 4;
  ZR_DEVTYPE_Z2M2           = 8;
  ZR_DEVTYPE_Z2B            = 6;
  ZR_DEVTYPE_EHR            = 7;
  ZG_DEVTYPE_IPGUARD        = ZP_MAX_REG_DEV;
  ZR_DEVTYPE_READERS        = $3D9;
  ZR_IPDEVTYPE_CVTS         = 1;

// Значения по умолчанию
Const
  ZR_MIF_CHECKCARDPERIOD    = 300;  // Период сканирования карт в поле считывателей, работающий по протоколу "mif" (Z-2 USB MF, Matrix III Net и CP-Z-2MF)
  ZR_CHECKCARDPERIOD        = INFINITE; // Период сканирования карт в поле всех считывателей, кроме тех, которые работают по протоколу "mif"
  ZR_M3N_CHECKINPUTPERIOD   = INFINITE; // Период проверки состояния входов считывателя Matrix III Net
  ZR_SEARCH_MAXCARD         = 16;   // Предел найденных карт при поиске (значение по умолчанию для ZR_Rd_SearchCards)

Const // Флаги для TZR_RD_NOTIFY_SETTINGS.nNMask
  ZR_RNF_EXIST_CARD         = $0001;  // ZR_RN_CARD_INSERT / ZR_RN_CARD_REMOVE
  ZR_RNF_INPUT_CHANGE       = $0002;  // ZR_RN_INPUT_CHANGE
  ZR_RNF_IND_FLASH_END      = $0004;  // ZR_RN_IND_FLASH_END
  ZR_RNF_ERROR              = $0008;  // ZR_RN_ERROR
  ZR_RDNF_CONNECTION_CHANGE = $0010;  // ZR_RN_PORTSTATUS

Const // Уведомления функции ZR_Rd_SetNotification
  ZR_RN_CARD_INSERT         = 100;  // Карта поднесена ((PZR_CARD_INFO)lParam)
  ZR_RN_CARD_REMOVE         = 101;  // Карта удалена ((PZR_CARD_INFO)lParam, может быть = NULL)
  ZR_RN_CARD_UNKNOWN        = 102;  // Неизвестное сообщение от считывателя, (LPWCSTR)nMsgParam - текст сообщения
  ZR_RN_INPUT_CHANGE        = 103;  // Изменилось состояние входов Matrix III Net (nMsgParam - новое состояние входов)
  ZR_RN_IND_FLASH_END       = 104;  // Очередь индикации завершена (Z-2 USB MF, CPZ-2-MF, Matrix III Net), без параметра
  ZR_RN_ERROR               = 105;  // Произошла ошибка в ните (HRESULT*)nMsgParam - код ошибки
  ZR_RDN_CONNECTION_CHANGE  = 106;  // Изменилось состояние подключения

Const // Флаги для nFlags стуктуры ZR_RD_OPEN_PARAMS
  ZR_RD_WIEGAND             = $0002;  // Z-2 Base: подключение по Wiegand
{$ALIGN 1}
{$MINENUMSIZE 4}
type
  // Тип считывателя
  TZR_RD_TYPE = (
    ZR_RD_UNDEF = 0,
    ZR_RD_Z2U,			  // Z-2 USB
    ZR_RD_M3A,        // Matrix III Rd-All
    ZR_RD_Z2M,			  // Z-2 USB MF
    ZR_RD_M3N,        // Matrix III Net
    ZR_RD_CPZ2MF,     // CP-Z-2MF
    ZR_RD_Z2EHR,      // Z-2 EHR
    ZR_RD_Z2BASE,     // Z-2 Base
    ZR_RD_M5,         // Matrix V
    ZR_RD_Z2MFI,      // Z-2 USB MFI
    ZR_RD_M6          // Matrix VI NFC
  );

// Настройки уведомлений считывателя
  TZR_RD_NOTIFY_SETTINGS = packed record
    nNMask          : Cardinal;       // Маска типов уведомлений (ZR_RNF_..)

    hEvent          : THandle;        // Событие (объект синхронизации)
    hWindow         : HWnd;           // Параметр для Callback-функции
    nWndMsgId       : Cardinal;       // Сообщение для отправки окну hWnd

    nCheckCardPeriod: Cardinal;       // Период сканирования карт в поле считывателя Z2USB MF и считывателя Matrix III Net в мс (Если =0, используется значение по-умолчанию, 300)
    nCheckInputPeriod: Cardinal;      // Период проверки состояния входов для Matrix III Net (Если =0, используется значение по-умолчанию, никогда)
  end;
  PZR_RD_NOTIFY_SETTINGS = ^TZR_RD_NOTIFY_SETTINGS;

  TZR_RD_INFO = packed record
    rBase           : TZP_DEVICE_INFO;
    nType           : TZR_RD_TYPE;     // Тип считывателя

    pszLinesBuf     : PWideChar;      // Буфер для информационных строк
    nLinesBufMax    : Integer;        // Размер буфера в символах, включая завершающий #0
  end;
  PZR_RD_INFO = ^TZR_RD_INFO;

{$IFNDEF ZG_DEVTYPE_GUARD}
  // Модель конвертера
  TZG_CVT_TYPE = (
    ZG_CVT_UNDEF = 0,   // Не определено
	  ZG_CVT_Z397,			  // Z-397
	  ZG_CVT_Z397_GUARD,	// Z-397 Guard
	  ZG_CVT_Z397_IP,	    // Z-397 IP
    ZG_CVT_Z397_WEB,    // Z-397 Web
    ZG_CVT_Z5R_WEB,     // Z5R Web
    ZG_CVT_MATRIX2WIFI, // Matrix II Wi-Fi
    ZG_CVT_MATRIX6WIFI  // Matrix VI Wi-Fi
  );

  // Режим конвертера Guard
  TZG_GUARD_MODE = (
	  ZG_GUARD_UNDEF = 0,   // Не определено
	  ZG_GUARD_NORMAL,      // Режим "Normal" (эмуляция обычного конвертера Z397)
	  ZG_GUARD_ADVANCED,    // Режим "Advanced"
	  ZG_GUARD_TEST,        // Режим "Test" (для специалистов)
	  ZG_GUARD_ACCEPT       // Режим "Accept" (для специалистов)
  );
  PZG_GUARD_MODE = ^TZG_GUARD_MODE;

  // Информация о ip-конвертере, полученная опросом по Udp
  TZG_ENUM_IPCVT_INFO = packed record
    rBase           : TZP_DEVICE_INFO;
    nType           : TZG_CVT_TYPE;   // Тип конвертера
    nMode           : TZG_GUARD_MODE; // Режим работы конвертера Guard
    nFlags          : Cardinal;       // Флаги: бит 0 - "VCP", бит 1 - "WEB", 0xFF - "All"
  end;
  PZG_ENUM_IPCVT_INFO = ^TZG_ENUM_IPCVT_INFO;
{$ENDIF} // !ZG_DEVTYPE_GUARD

  TZR_RD_OPEN_PARAMS = packed record
    nType           : TZP_PORT_TYPE;    // Тип порта
    pszName         : PWideChar;        // Имя порта. Если =NULL, то используется hPort
    hPort           : THandle;          // Дескриптор порта, полученный функцией ZP_Open
    nRdType         : TZR_RD_TYPE;      // Тип считывателя. Если =ZR_RD_UNDEF, то автоопределение
    pWait           : PZP_WAIT_SETTINGS;// Параметры ожидания. Может быть =NULL.
    nStopBits       : Byte;
    nFlags          : Cardinal;
    nSpeed          : Cardinal;         // Скорость. Если =0, то автовыбор
  end;
  PZR_RD_OPEN_PARAMS = ^TZR_RD_OPEN_PARAMS;

  // Тип карты
  TZR_CARD_TYPE = (
    ZR_CD_UNDEF = 0,
    ZR_CD_EM,         // Em-Marine
    ZR_CD_HID,        // Hid
    ZR_CD_IC,         // iCode
    ZR_CD_UL,         // Mifare UltraLight
    ZR_CD_1K,         // Mifare Classic 1K
    ZR_CD_4K,         // Mifare Classic 4K
    ZR_CD_DF,         // Mifare DESFire
    ZR_CD_PX,         // Mifare ProX
    ZR_CD_COD433F,    // Cod433 Fix
    ZR_CD_COD433,     // Cod433
    ZR_CD_DALLAS,     // Dallas
    ZR_CD_CAME433,    // радиобрелок CAME
    ZR_CD_PLUS,       // Mifare Plus
    ZR_CD_PLUS1K,     // Mifare Plus 1K
    ZR_CD_PLUS2K,     // Mifare Plus 2K
    ZR_CD_PLUS4K,     // Mifare Plus 4K
    ZR_CD_MINI,       // Mifare Mini
    ZR_CD_TEMIC,      // Temic (T5557)
    ZR_CD_M2K,        // Mifare Classic 2K
    ZR_CD_SMXM1K,     // Smart MX with Mifare 1K
    ZR_CD_SMXM4K      // Smart MX with Mifare 4K
  );
  PZR_CARD_TYPE = ^TZR_CARD_TYPE;

Const
  ZR_CDO_MP      = $0001; // =1 это Mifare Plus
  ZR_CDO_MPTYPE  = $0002; // =1 определен тип Mifare Plus: S или X (актуально с ZG_CDO_MP)
  ZR_CDO_MPTYPEX = $0004; // =1 тип Mifare Plus = X, иначе S (актуально с ZG_CDO_MPTYPE)
  ZR_CDO_MPSL    = $0008; // =1 определен SL
  ZR_CDO_MPSL1   = $0010; // SL = SLFromCdOpts(opts): =0 SL0, =1 SL1, =2 SL2, =3 SL3
  ZR_CDO_MPSL2   = $0020;
Type
  TZRCDO = Cardinal;

Type
  TZR_CARD_INFO = packed record
    nType           : TZR_CARD_TYPE;  // Тип карты
    nNum            : TZ_KEYNUM;      // Номер карты
    nOpts           : TZRCDO;         // Флаги ключа
  end;
  PZR_CARD_INFO = ^TZR_CARD_INFO;

// Флаги для функции ZR_Rd_FindT57 \ ZR_Rd_ReadT57Block \ ZR_Rd_WriteT57Block
Const
  ZR_T57F_INIT      = 1;  // Разрешить инициализировать, если не удалось подобрать параметры (только в ZR_Rd_FindT57)
  ZR_T57F_PSW       = 2;  // Использовать пароль
  ZR_T57F_BLOCK     = 4;  // Блокировать дальнейшую перезапись блока (только в ZR_Rd_WriteT57Block)

Const // Modulation
  T57_MOD_DIRECT      = 0;    // 0 0 0 0 0
  T57_MOD_PSK1        = 2;    // 0 0 0 1 0
  T57_MOD_PSK2        = 4;    // 0 0 1 0 0
  T57_MOD_PSK3        = 6;    // 0 0 1 1 0
  T57_MOD_FSK1        = 8;    // 0 1 0 0 0
  T57_MOD_FSK2        = $A;   // 0 1 0 1 0
  T57_MOD_FSK1A       = $C;   // 0 1 1 0 0
  T57_MOD_FSK2A       = $E;   // 0 1 1 1 0
  T57_MOD_MANCHESTER  = $10;  // 1 0 0 0 0
  T57_MOD_BIPHASE50   = 1;    // 0 0 0 0 1
  T57_MOD_BIPHASE57   = $11;  // 1 0 0 0 1

Type
  // PSK CF
  TZR_T57_PSK = (
    T57_PSK_UNDEF = -1,
    T57_PSK_RF2, // 0 0
    T57_PSK_RF4, // 0 1
    T57_PSK_RF8, // 1 0
    T57_PSK_RES  // 1 1
  );

  TZR_T57_CONFIG = packed record
    fXMode          : LongBool;     // True, если X-Mode, иначе - e5550 compatible
    nMasterKey      : Cardinal;
    nDataRate       : Cardinal;
    nModulation     : Cardinal;
    nPSK_CF         : TZR_T57_PSK;
    fAOR            : LongBool;
    fOTP            : LongBool;     // (только в XMode)
    nMaxBlock       : Integer;
    fPsw            : LongBool;     // True, если пароль установлен
    fST_Seq_Ter     : LongBool;     // (только в e5550)
    fSST_Seq_StMrk  : LongBool;     // (только в XMode)
    fFastWrite      : LongBool;
    fInverseData    : LongBool;     // (только в XMode)
    fPOR_Delay      : LongBool;
  end;
  PZR_T57_CONFIG = ^TZR_T57_CONFIG;

  TZR_M3N_CONFIG = packed record
    nWorkMode       : Byte;
    nOutZumm        : Byte;
    nOutTM          : Byte;
    nOutExit        : Byte;
    nOutLock        : Byte;
    nOutDoor        : Byte;
    nProt           : Byte;
    nFlags          : Byte;       // 0 Impulse, 1 No card, 2 card num
    nCardFormat     : Byte;
    nSecurityMode   : Byte;
    Reserved1       : array[0..1] of Byte;
  end;
  PZR_M3N_CONFIG = ^TZR_M3N_CONFIG;

// Тип ключа авторизации Mifare
  TZR_MF_AUTH_KEY = array[0..19] of Byte; // [0] размер ключа (=6 для Classic или =16 для Plus)
  PZR_MF_AUTH_KEY = ^TZR_MF_AUTH_KEY;

  TZR_IND_STATE = (
    ZR_IND_NO_CHANGE = 0,
    ZR_IND_ON,
    ZR_IND_OFF,
    ZR_IND_AUTO
  );

// Флаги состояния индикатора
Const
  ZR_ISF_ON   = 1;
  ZR_ISF_AUTO = 2;

Const
  ZR_MAX_IND_FLASH  = 15;

Type
  TZR_IND_FLASH = packed record
    nRed            : TZR_IND_STATE;
    nGreen          : TZR_IND_STATE;
    nSound          : TZR_IND_STATE;
    nDuration       : Cardinal; // ms
  end;
  PZR_IND_FLASH = ^TZR_IND_FLASH;

Const // Общие флаги карт Mifare
  ZR_MFF_MP         = $0100; // карта - Mifare Plus (иначе - старый Mifare)
Const // Флаги авторизации карт Mifare
  ZR_MFAF_B         = $0001; // Авторизация по ключу B (иначе - по ключу A)
  ZR_MFAF_KEY       = $0002; // Авторизация по указанному ключу (иначе - по ключам в памяти считывателя)
  ZR_MFAF_FA        = $0010; // Following authenticate (для Mifare Plus)
  ZR_MFAF_RA        = $0030; // Reset authentication (для Mifare Plus)
Const // Флаги чтения/записи Mifare Plus
  ZR_MFRF_RESP      = $0001; // MAC on responce
  ZR_MFRF_OPEN      = $0002; // открытый текст (иначе - закрытый текст)
  ZR_MFRF_CMD       = $0004; // MAC on command

Const // Флаги для функции ZR_Rd_SearchCards
  ZR_RSCF_DETECTOR  = $0001; // Использовать уже готовый список найденных карт детектора

Type
  TZR_ENUMCARDSPROC = function(AInfo: PZR_CARD_INFO; AUserData: Pointer): LongBool; stdcall;
  TZR_PROCESSCALLBACK = function(APos: Integer; AMax: Integer; AUserData: Pointer): LongBool; stdcall;

// Устаревшие константы и типы
Type
  TZR_ENUMRDSPROC = function(AInfo: PZR_RD_INFO; Const APort: TZP_PORT_INFO; AUserData: Pointer): LongBool; stdcall;
  TZR_STATUS = HResult;
Const
  ZR_SUCCESS                = S_OK deprecated;
  ZR_E_CANCELLED            = ZP_S_CANCELLED deprecated;
  ZR_E_NOT_FOUND            = ZP_S_NOTFOUND deprecated;
  ZR_E_INVALID_PARAM        = E_INVALIDARG deprecated;
  ZR_E_OPEN_NOT_EXIST       = ZP_E_OPENNOTEXIST deprecated;
  ZR_E_OPEN_ACCESS          = E_ACCESSDENIED deprecated;
  ZR_E_OPEN_PORT            = ZP_E_OPENPORT deprecated;
  ZR_E_PORT_IO_ERROR        = ZP_E_PORTIO deprecated;
  ZR_E_PORT_SETUP           = ZP_E_PORTSETUP deprecated;
  ZR_E_LOAD_FTD2XX          = ZP_E_LOADFTD2XX deprecated;
  ZR_E_INIT_SOCKET          = ZP_E_SOCKET deprecated;
  ZR_E_SERVERCLOSE          = ZP_E_SERVERCLOSE deprecated;
  ZR_E_NOT_ENOUGH_MEMORY    = E_OUTOFMEMORY deprecated;
  ZR_E_UNSUPPORT            = E_NOINTERFACE deprecated;
  ZR_E_NOT_INITALIZED       = ZP_E_NOTINITALIZED deprecated;
  ZR_E_INSUFFICIENT_BUFFER  = ZP_E_INSUFFICIENTBUFFER deprecated;
  ZR_E_NO_ANSWER            = ZR_E_NOANSWER deprecated;
  ZR_E_BAD_ANSWER           = ZR_E_BADANSWER deprecated;
  ZR_E_CARD_NOT_SELECT      = ZR_E_CARDNOTSELECT deprecated;
  ZR_E_NO_CARD              = ZR_E_NOCARD deprecated;
  ZR_E_WRONG_ZPORT_VERSION  = ZR_E_WRONGZPORT deprecated;
  ZR_E_RD_OTHER             = ZR_E_RDERROR deprecated;
  ZR_E_CARD_ACCESS          = ZR_E_CARDACCESS deprecated;
  ZR_E_PAGE_LOCK            = ZR_E_PAGELOCK deprecated;
  ZR_E_NO_T57               = ZR_E_NOT57 deprecated;
  ZR_E_NO_WRITE_T57         = ZR_E_NOWRITET57 deprecated;
  ZR_E_INV_MODEL            = ZR_E_INVMODEL deprecated;
  ZR_E_INV_BOOTFILE         = ZR_E_INVBOOTFILE deprecated;
  ZR_E_BUFFER_OVERFLOWN     = ZR_E_BUFFEROVERFLOWN deprecated;
  ZR_E_KEY_NOT_FOUND        = ZR_E_KEYNOTFOUND deprecated;
  ZR_E_MIF_FCS              = ZR_E_RDERROR deprecated;
  ZR_E_MIF_INV_CMD          = ZR_E_RDERROR deprecated;
  ZR_E_MIF_INV_PAR          = ZR_E_RDERROR deprecated;
  ZR_E_MIF_RES              = ZR_E_RESEXHAUSTED deprecated;
  ZR_E_MIF_RD_DOWN          = ZR_E_RDERROR deprecated;
  ZR_E_MIF_NO_CARD          = ZR_E_NOCARD deprecated;
  ZR_E_MIF_CD_ANSWER        = ZR_E_RDERROR deprecated;
  ZR_E_MIF_AUTH             = ZR_E_AUTHORIZE deprecated;
  ZR_E_MIF_CD_NACK          = ZR_E_CARDNACK deprecated;
  ZR_E_MIF_PREV_CMD_NC      = ZR_E_PREVNOTCOMLETED deprecated;
  ZR_E_OTHER                = E_FAIL deprecated;

Const
  ZR_RNF_PLACE_CARD         = ZR_RNF_EXIST_CARD deprecated;
  ZR_RNF_WND_SYNC           = $4000 deprecated;
  ZR_RNF_ONLY_NOTIFY        = $8000 deprecated;
  ZR_IF_ERROR_LOG           = ZR_IF_LOG deprecated;
{$MINENUMSIZE 1}
{$ALIGN ON}


{$IFNDEF ZREADER_LINKONREQUEST}

// Возвращает версию библиотеки Z2Usb.dll
function ZR_GetVersion(): Cardinal; stdcall;

// Инициализация/финализация библиотеки
function ZR_Initialize(AFlags: Cardinal): HResult; stdcall;
function ZR_Finalyze(): HResult; stdcall;

// Загружает новую прошивку в считыватель
function ZR_UpdateRdFirmware(const AParams: TZR_RD_OPEN_PARAMS;
    AData: Pointer; ACount: Integer;
    ACallback: TZR_PROCESSCALLBACK; AUserData: Pointer): HResult; stdcall;

// Открывает/закрывает считыватель
function ZR_Rd_Open(var VHandle: THandle;
    const AParams: TZR_RD_OPEN_PARAMS; VInfo: PZR_RD_INFO=nil): HResult; stdcall;
// Отключается от считывателя, не закрывая порт, возвращает дескриптор порта, полученный функцией ZP_Open
function ZR_Rd_DettachPort(AHandle: THandle; var VPortHandle: THandle): HResult; stdcall;
// Возвращает состояние подключения
function ZR_Rd_GetConnectionStatus(AHandle: THandle; var VValue: TZP_CONNECTION_STATUS; var VSessionId: Cardinal): HResult; stdcall;

// Возвращает/устанавливает параметры ожидания исполнения функции
function ZR_Rd_GetWaitSettings(AHandle: THandle; var VSetting: TZP_WAIT_SETTINGS): HResult; stdcall;
function ZR_Rd_SetWaitSettings(AHandle: THandle; Const ASetting: TZP_WAIT_SETTINGS): HResult; stdcall;

// Захватить порт (приостанавливает фоновые операции с портом)
function ZR_Rd_SetCapture(AHandle: THandle): HResult; stdcall;
// Отпустить порт (возобновляет фоновые операции с портом)
function ZR_Rd_ReleaseCapture(AHandle: THandle): HResult; stdcall;

// Возвращает информацию о считывателе
function ZR_Rd_GetInformation(AHandle: THandle; var VInfo: TZR_RD_INFO): HResult; stdcall;

// Загружает в считыватель новую прошивку
function ZR_Rd_UpdateFirmware(AHandle: THandle; AData: Pointer; ACount: Integer;
    ACallback: TZR_PROCESSCALLBACK; AUserData: Pointer): HResult; stdcall;

// Настраивает уведомления считывателя
function ZR_Rd_SetNotification(AHandle: THandle; ASetting: PZR_RD_NOTIFY_SETTINGS): HResult; stdcall;
function ZR_Rd_GetNextMessage(AHandle: THandle; var VMsg: Cardinal;
    var VMsgParam: NativeInt): HResult; stdcall;

// Поиск карт в поле считывателя
function ZR_Rd_SearchCards(AHandle: THandle; AMaxCard: Integer=ZR_SEARCH_MAXCARD; AFlags:Cardinal=0): HResult; stdcall;
function ZR_Rd_FindNextCard(AHandle: THandle; VInfo: PZR_CARD_INFO): HResult; stdcall;

function ZR_Rd_SelectCard(AHandle: THandle; const ANum: TZ_KEYNUM; AType: TZR_CARD_TYPE): HResult; stdcall;

// Чтение/запись карты Mifare UL
function ZR_Rd_ReadULCard4Page(AHandle: THandle; APageN: Integer; var VBuf16): HResult; stdcall;
function ZR_Rd_WriteULCardPage(AHandle: THandle; APageN: Integer; AData4: Pointer): HResult; stdcall;

// Z2USB

function ZR_Rd_FindT57(AHandle: THandle; var VNum: TZ_KEYNUM;
    var VPar: Integer; APsw, AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_ReadT57Block(AHandle: THandle; ABlockN: Integer; var VBuf4;
    APar: Integer; APsw, AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_WriteT57Block(AHandle: THandle; ABlockN: Integer; AData4: Pointer;
    APar: Integer; APsw, AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_ResetT57(AHandle: THandle): HResult; stdcall;

function ZR_DecodeT57Config(var VConfig: TZR_T57_CONFIG; AData4: Pointer): HResult; stdcall;
function ZR_EncodeT57Config(var VBuf4; const AConfig: TZR_T57_CONFIG): HResult; stdcall;
function ZR_DecodeT57EmMarine(VBitOffs: PInteger; var VNum: TZ_KEYNUM;
    AData: Pointer; ACount: Integer): HResult; stdcall;
function ZR_EncodeT57EmMarine(var VBuf; VBufSize: Integer; ABitOffs: Integer;
    const ANum: TZ_KEYNUM): HResult; stdcall;
function ZR_DecodeT57Hid(var VNum: TZ_KEYNUM; AData12: Pointer; var VWiegand: Integer): HResult; stdcall;
function ZR_EncodeT57Hid(var VBuf12; const ANum: TZ_KEYNUM; AWiegand: Integer): HResult; stdcall;
function ZR_Rd_GetEncodedCardNumber(AHandle: THandle;
    var VType: TZR_CARD_TYPE; var VNum: TZ_KEYNUM;
    var VBuf; VBufSize: Integer; var VRCount: Integer): HResult; stdcall;

// Z2USB MF, Matrix-III Net

function ZR_Rd_AuthorizeSect(AHandle: THandle; ABlockN: Integer; AKey: PZR_MF_AUTH_KEY; AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_AuthorizeSectByEKey(AHandle: THandle; ABlockN: Integer; AKeyMask: Cardinal; VRKeyIdx: PInteger; AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_ReadMfCardBlock(AHandle: THandle; ABlockN: Integer; var VBuf16; AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_WriteMfCardBlock(AHandle: THandle; ABlockN: Integer; AData16: Pointer; AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_WriteMfCardBlock4(AHandle: THandle; ABlockN: Integer; AData4: Pointer): HResult; stdcall;

function ZR_Rd_GetIndicatorState(AHandle: THandle; VRed: PCardinal; VGreen: PCardinal; VSound: PCardinal): HResult; stdcall;
function ZR_Rd_SetIndicatorState(AHandle: THandle; ARed: TZR_IND_STATE; AGreen: TZR_IND_STATE; ASound: TZR_IND_STATE): HResult; stdcall;
function ZR_Rd_AddIndicatorFlash(AHandle: THandle; ARecs: PZR_IND_FLASH; ACount: Integer; AReset: LongBool; var VRCount: Integer): HResult; stdcall;
function ZR_Rd_BreakIndicatorFlash(AHandle: THandle; AAutoMode: LongBool): HResult; stdcall;
function ZR_Rd_GetIndicatorFlashAvailable(AHandle: THandle; var VCount: Integer): HResult; stdcall;

// Команды управления (состояние: считывателя, светодиодов)

function ZR_Rd_Reset1356(AHandle: THandle; AWaitMs: Word): HResult; stdcall;
function ZR_Rd_PowerOff(AHandle: THandle): HResult; stdcall;

// Команды ISO

function ZR_Rd_Request(AHandle: THandle; AWakeUp: LongBool; VATQ: PWord): HResult; stdcall;
function ZR_Rd_Halt(AHandle: THandle): HResult; stdcall;
function ZR_Rd_A_S(AHandle: THandle;
    VNum: PZ_KEYNUM; VSAQ: PByte): HResult; stdcall;
function ZR_Rd_R_A_S(AHandle: THandle; AWakeUp: LongBool;
    VNum: PZ_KEYNUM; VSAQ: PByte; VATQ: PWord): HResult; stdcall;
function ZR_Rd_R_R(AHandle: THandle; const ANum: TZ_KEYNUM; AWakeUp: LongBool): HResult; stdcall;
function ZR_Rd_RATS(AHandle: THandle; var VBuf; ABufSize: Integer; var VRCount: Integer): HResult; stdcall;
function ZR_Rd_Auth(AHandle: THandle; AAddr: Cardinal;
    AKey: PZR_MF_AUTH_KEY; AEKeyMask: Cardinal; VEKeyIdx: PInteger; AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_Read16(AHandle: THandle; AAddr: Cardinal; var VBuf16; AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_Write16(AHandle: THandle; AAddr: Cardinal; AData16: Pointer; AFlags: Cardinal): HResult; stdcall;
function ZR_Rd_Write4(AHandle: THandle; AAddr: Cardinal; AData4: Pointer): HResult; stdcall;
function ZR_Rd_Increment(AHandle: THandle; AAddr: Cardinal; AValue: Cardinal): HResult; stdcall;
function ZR_Rd_Decrement(AHandle: THandle; AAddr: Cardinal; AValue: Cardinal): HResult; stdcall;
function ZR_Rd_Transfer(AHandle: THandle; AAddr: Cardinal): HResult; stdcall;
function ZR_Rd_Restore(AHandle: THandle; AAddr: Cardinal): HResult; stdcall;
function ZR_Rd_ISO_MP_4(AHandle: THandle; AData: Pointer; ACount: Integer;
    var VBuf; ABufSize: Integer; var VRCount: Integer): HResult; stdcall;

function ZR_Rd_WriteKeyToEEPROM(AHandle: THandle; AAddr: Cardinal;
    AKeyB: LongBool; AKey: PZR_MF_AUTH_KEY): HResult; stdcall;

function ZR_DecodeMfAccessBits(AAreaN: Integer; var VBits: Cardinal; AData3: Pointer): HResult; stdcall;
function ZR_EncodeMfAccessBits(AAreaN: Integer; var VBuf3; ABits: Cardinal): HResult; stdcall;

// Matrix-III Net

function ZR_M3n_ActivatePowerKey(AHandle: THandle; AForce: LongBool; ATimeMs: Cardinal): HResult; stdcall;
function ZR_M3n_SetOutputs(AHandle: THandle; AMask, AOutBits: Cardinal): HResult; stdcall;
function ZR_M3n_GetInputs(AHandle: THandle; var VFlags: Cardinal): HResult; stdcall;
function ZR_M3n_SetConfig(AHandle: THandle; const AConfig: TZR_M3N_CONFIG): HResult; stdcall;
function ZR_M3n_GetConfig(AHandle: THandle; var VConfig: TZR_M3N_CONFIG): HResult; stdcall;
function ZR_M3n_SetSecurity(AHandle: THandle; ABlockN: Integer;
    AKeyMask: Cardinal; AKeyB: LongBool): HResult; stdcall;
function ZR_M3n_GetSecurity(AHandle: THandle; var VBlockN: Integer;
    var VKeyMask: Cardinal; var VKeyB: LongBool): HResult; stdcall;
function ZR_M3n_SetClock(AHandle: THandle; const ATime: TSystemTime): HResult; stdcall;
function ZR_M3n_GetClock(AHandle: THandle; var VTime: TSystemTime): HResult; stdcall;

// Z-2 Base
function ZR_Z2b_SetFormat(AHandle: THandle; AFmt: PWideChar; AArg: PWideChar;
    ANoCard: PWideChar; ASaveEE: LongBool): HResult; stdcall;
function ZR_Z2b_GetFormat(AHandle: THandle;
    VFmtBuf: PWideChar; AFmtBufSize: Integer;
    VArgBuf: PWideChar; AArgBufSize: Integer;
    VNCBuf: PWideChar; ANCBufSize: Integer): HResult; stdcall;
function ZR_Z2b_SetPowerState(AHandle: THandle;
    AOn: LongBool): HResult; stdcall;

{$ELSE}
type
  TZR_GetVersion = function(): Cardinal; stdcall;
  TZR_Initialize = function(AFlags: Cardinal): HResult; stdcall;
  TZR_Finalyze = function(): HResult; stdcall;
  TZR_UpdateRdFirmware = function(const AParams: TZR_RD_OPEN_PARAMS;
      AData: Pointer; ACount: Integer;
      ACallback: TZR_PROCESSCALLBACK; AUserData: Pointer): HResult; stdcall;
  TZR_Rd_Open = function(var VHandle: THandle;
      const AParams: TZR_RD_OPEN_PARAMS; VInfo: PZR_RD_INFO=nil): HResult; stdcall;
  TZR_Rd_DettachPort = function(AHandle: THandle; var VPortHandle: THandle): HResult; stdcall;
  TZR_Rd_GetConnectionStatus = function(AHandle: THandle; var VValue: TZP_CONNECTION_STATUS; var VSessionId: Cardinal): HResult; stdcall;
  TZR_Rd_GetWaitSettings = function(AHandle: THandle; var VSetting: TZP_WAIT_SETTINGS): HResult; stdcall;
  TZR_Rd_SetWaitSettings = function(AHandle: THandle; Const ASetting: TZP_WAIT_SETTINGS): HResult; stdcall;
  TZR_Rd_SetCapture = function(AHandle: THandle): HResult; stdcall;
  TZR_Rd_ReleaseCapture = function(AHandle: THandle): HResult; stdcall;
  TZR_Rd_GetInformation = function(AHandle: THandle; var VInfo: TZR_RD_INFO): HResult; stdcall;
  TZR_Rd_UpdateFirmware = function(AHandle: THandle; AData: Pointer; ACount: Integer;
      ACallback: TZR_PROCESSCALLBACK; AUserData: Pointer): HResult; stdcall;
  TZR_Rd_SetNotification = function(AHandle: THandle; ASetting: PZR_RD_NOTIFY_SETTINGS): HResult; stdcall;
  TZR_Rd_GetNextMessage = function(AHandle: THandle; var VMsg: Cardinal;
      var VMsgParam: NativeInt): HResult; stdcall;
  TZR_Rd_SearchCards = function(AHandle: THandle; AMaxCard: Integer=ZR_SEARCH_MAXCARD; AFlags:Cardinal=0): HResult; stdcall;
  TZR_Rd_FindNextCard = function(AHandle: THandle; VInfo: PZR_CARD_INFO): HResult; stdcall;
  TZR_Rd_SelectCard = function(AHandle: THandle; const ANum: TZ_KEYNUM; AType: TZR_CARD_TYPE): HResult; stdcall;
  TZR_Rd_ReadULCard4Page = function(AHandle: THandle; APageN: Integer; var VBuf16): HResult; stdcall;
  TZR_Rd_WriteULCardPage = function(AHandle: THandle; APageN: Integer; AData4: Pointer): HResult; stdcall;
  TZR_Rd_FindT57 = function(AHandle: THandle; var VNum: TZ_KEYNUM;
      var VPar: Integer; APsw, AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_ReadT57Block = function(AHandle: THandle; ABlockN: Integer; var VBuf4;
      APar: Integer; APsw, AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_WriteT57Block = function(AHandle: THandle; ABlockN: Integer; AData4: Pointer;
      APar: Integer; APsw, AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_ResetT57 = function(AHandle: THandle): HResult; stdcall;
  TZR_DecodeT57Config = function(var VConfig: TZR_T57_CONFIG; AData4: Pointer): HResult; stdcall;
  TZR_EncodeT57Config = function(var VBuf4; const AConfig: TZR_T57_CONFIG): HResult; stdcall;
  TZR_DecodeT57EmMarine = function(VBitOffs: PInteger; var VNum: TZ_KEYNUM;
      AData: Pointer; ACount: Integer): HResult; stdcall;
  TZR_EncodeT57EmMarine = function(var VBuf; VBufSize: Integer; ABitOffs: Integer;
      const ANum: TZ_KEYNUM): HResult; stdcall;
  TZR_DecodeT57Hid = function(var VNum: TZ_KEYNUM; AData12: Pointer; var VWiegand: Integer): HResult; stdcall;
  TZR_EncodeT57Hid = function(var VBuf12; const ANum: TZ_KEYNUM; AWiegand: Integer): HResult; stdcall;
  TZR_Rd_GetEncodedCardNumber = function(AHandle: THandle;
      var VType: TZR_CARD_TYPE; var VNum: TZ_KEYNUM;
      var VBuf; VBufSize: Integer; var VRCount: Integer): HResult; stdcall;
  TZR_Rd_AuthorizeSect = function(AHandle: THandle; ABlockN: Integer; AKey: PZR_MF_AUTH_KEY; AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_AuthorizeSectByEKey = function(AHandle: THandle; ABlockN: Integer; AKeyMask: Cardinal; VRKeyIdx: PInteger; AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_ReadMfCardBlock = function(AHandle: THandle; ABlockN: Integer; var VBuf16; AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_WriteMfCardBlock = function(AHandle: THandle; ABlockN: Integer; AData16: Pointer; AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_WriteMfCardBlock4 = function(AHandle: THandle; ABlockN: Integer; AData4: Pointer): HResult; stdcall;
  TZR_Rd_GetIndicatorState = function(AHandle: THandle; VRed: PCardinal; VGreen: PCardinal; VSound: PCardinal): HResult; stdcall;
  TZR_Rd_SetIndicatorState = function(AHandle: THandle; ARed: TZR_IND_STATE; AGreen: TZR_IND_STATE; ASound: TZR_IND_STATE): HResult; stdcall;
  TZR_Rd_AddIndicatorFlash = function(AHandle: THandle; ARecs: PZR_IND_FLASH; ACount: Integer; AReset: LongBool; var VRCount: Integer): HResult; stdcall;
  TZR_Rd_BreakIndicatorFlash = function(AHandle: THandle; AAutoMode: LongBool): HResult; stdcall;
  TZR_Rd_GetIndicatorFlashAvailable = function(AHandle: THandle; var VCount: Integer): HResult; stdcall;
  TZR_Rd_Reset1356 = function(AHandle: THandle; AWaitMs: Word): HResult; stdcall;
  TZR_Rd_PowerOff = function(AHandle: THandle): HResult; stdcall;
  TZR_Rd_Request = function(AHandle: THandle; AWakeUp: LongBool; VATQ: PWord): HResult; stdcall;
  TZR_Rd_Halt = function(AHandle: THandle): HResult; stdcall;
  TZR_Rd_A_S = function(AHandle: THandle;
      VNum: PZ_KEYNUM; VSAQ: PByte): HResult; stdcall;
  TZR_Rd_R_A_S = function(AHandle: THandle; AWakeUp: LongBool;
      VNum: PZ_KEYNUM; VSAQ: PByte; VATQ: PWord): HResult; stdcall;
  TZR_Rd_R_R = function(AHandle: THandle; const ANum: TZ_KEYNUM; AWakeUp: LongBool): HResult; stdcall;
  TZR_Rd_RATS = function(AHandle: THandle; var VBuf; ABufSize: Integer; var VRCount: Integer): HResult; stdcall;
  TZR_Rd_Auth = function(AHandle: THandle; AAddr: Cardinal;
      AKey: PZR_MF_AUTH_KEY; AEKeyMask: Cardinal; VEKeyIdx: PInteger; AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_Read16 = function(AHandle: THandle; AAddr: Cardinal; var VBuf16; AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_Write16 = function(AHandle: THandle; AAddr: Cardinal; AData16: Pointer; AFlags: Cardinal): HResult; stdcall;
  TZR_Rd_Write4 = function(AHandle: THandle; AAddr: Cardinal; AData4: Pointer): HResult; stdcall;
  TZR_Rd_Increment = function(AHandle: THandle; AAddr: Cardinal; AValue: Cardinal): HResult; stdcall;
  TZR_Rd_Decrement = function(AHandle: THandle; AAddr: Cardinal; AValue: Cardinal): HResult; stdcall;
  TZR_Rd_Transfer = function(AHandle: THandle; AAddr: Cardinal): HResult; stdcall;
  TZR_Rd_Restore = function(AHandle: THandle; AAddr: Cardinal): HResult; stdcall;
  TZR_Rd_ISO_MP_4 = function(AHandle: THandle; AData: Pointer; ACount: Integer;
      var VBuf; ABufSize: Integer; var VRCount: Integer): HResult; stdcall;
  TZR_Rd_WriteKeyToEEPROM = function(AHandle: THandle; AAddr: Cardinal;
      AKeyB: LongBool; AKey: PZR_MF_AUTH_KEY): HResult; stdcall;
  TZR_DecodeMfAccessBits = function(AAreaN: Integer; var VBits: Cardinal; AData3: Pointer): HResult; stdcall;
  TZR_EncodeMfAccessBits = function(AAreaN: Integer; var VBuf3; ABits: Cardinal): HResult; stdcall;
  TZR_M3n_ActivatePowerKey = function(AHandle: THandle; AForce: LongBool; ATimeMs: Cardinal): HResult; stdcall;
  TZR_M3n_SetOutputs = function(AHandle: THandle; AMask, AOutBits: Cardinal): HResult; stdcall;
  TZR_M3n_GetInputs = function(AHandle: THandle; var VFlags: Cardinal): HResult; stdcall;
  TZR_M3n_SetConfig = function(AHandle: THandle; const AConfig: TZR_M3N_CONFIG): HResult; stdcall;
  TZR_M3n_GetConfig = function(AHandle: THandle; var VConfig: TZR_M3N_CONFIG): HResult; stdcall;
  TZR_M3n_SetSecurity = function(AHandle: THandle; ABlockN: Integer;
      AKeyMask: Cardinal; AKeyB: LongBool): HResult; stdcall;
  TZR_M3n_GetSecurity = function(AHandle: THandle; var VBlockN: Integer;
      var VKeyMask: Cardinal; var VKeyB: LongBool): HResult; stdcall;
  TZR_M3n_SetClock = function(AHandle: THandle; const ATime: TSystemTime): HResult; stdcall;
  TZR_M3n_GetClock = function(AHandle: THandle; var VTime: TSystemTime): HResult; stdcall;
  TZR_Z2b_SetFormat = function(AHandle: THandle; AFmt: PWideChar; AArg: PWideChar;
      ANoCard: PWideChar; ASaveEE: LongBool): HResult; stdcall;
  TZR_Z2b_GetFormat = function(AHandle: THandle;
      VFmtBuf: PWideChar; AFmtBufSize: Integer;
      VArgBuf: PWideChar; AArgBufSize: Integer;
      VNCBuf: PWideChar; ANCBufSize: Integer): HResult; stdcall;
  TZR_Z2b_SetPowerState = function(AHandle: THandle;
      AOn: LongBool): HResult; stdcall;
var
  ZR_GetVersion: TZR_GetVersion;
  ZR_Initialize: TZR_Initialize;
  ZR_Finalyze: TZR_Finalyze;
  ZR_UpdateRdFirmware: TZR_UpdateRdFirmware;
  ZR_Rd_Open: TZR_Rd_Open;
  ZR_Rd_DettachPort: TZR_Rd_DettachPort;
  ZR_Rd_GetConnectionStatus: TZR_Rd_GetConnectionStatus;
  ZR_Rd_GetWaitSettings: TZR_Rd_GetWaitSettings;
  ZR_Rd_SetWaitSettings: TZR_Rd_SetWaitSettings;
  ZR_Rd_SetCapture: TZR_Rd_SetCapture;
  ZR_Rd_ReleaseCapture: TZR_Rd_ReleaseCapture;
  ZR_Rd_GetInformation: TZR_Rd_GetInformation;
  ZR_Rd_UpdateFirmware: TZR_Rd_UpdateFirmware;
  ZR_Rd_SetNotification: TZR_Rd_SetNotification;
  ZR_Rd_GetNextMessage: TZR_Rd_GetNextMessage;
  ZR_Rd_SearchCards: TZR_Rd_SearchCards;
  ZR_Rd_FindNextCard: TZR_Rd_FindNextCard;
  ZR_Rd_SelectCard: TZR_Rd_SelectCard;
  ZR_Rd_ReadULCard4Page: TZR_Rd_ReadULCard4Page;
  ZR_Rd_WriteULCardPage: TZR_Rd_WriteULCardPage;
  ZR_Rd_FindT57: TZR_Rd_FindT57;
  ZR_Rd_ReadT57Block: TZR_Rd_ReadT57Block;
  ZR_Rd_WriteT57Block: TZR_Rd_WriteT57Block;
  ZR_Rd_ResetT57: TZR_Rd_ResetT57;
  ZR_DecodeT57Config: TZR_DecodeT57Config;
  ZR_EncodeT57Config: TZR_EncodeT57Config;
  ZR_DecodeT57EmMarine: TZR_DecodeT57EmMarine;
  ZR_EncodeT57EmMarine: TZR_EncodeT57EmMarine;
  ZR_DecodeT57Hid: TZR_DecodeT57Hid;
  ZR_EncodeT57Hid: TZR_EncodeT57Hid;
  ZR_Rd_GetEncodedCardNumber: TZR_Rd_GetEncodedCardNumber;
  ZR_Rd_AuthorizeSect: TZR_Rd_AuthorizeSect;
  ZR_Rd_AuthorizeSectByEKey: TZR_Rd_AuthorizeSectByEKey;
  ZR_Rd_ReadMfCardBlock: TZR_Rd_ReadMfCardBlock;
  ZR_Rd_WriteMfCardBlock: TZR_Rd_WriteMfCardBlock;
  ZR_Rd_WriteMfCardBlock4: TZR_Rd_WriteMfCardBlock4;
  ZR_Rd_GetIndicatorState: TZR_Rd_GetIndicatorState;
  ZR_Rd_SetIndicatorState: TZR_Rd_SetIndicatorState;
  ZR_Rd_AddIndicatorFlash: TZR_Rd_AddIndicatorFlash;
  ZR_Rd_BreakIndicatorFlash: TZR_Rd_BreakIndicatorFlash;
  ZR_Rd_GetIndicatorFlashAvailable: TZR_Rd_GetIndicatorFlashAvailable;
  ZR_Rd_Reset1356: TZR_Rd_Reset1356;
  ZR_Rd_PowerOff: TZR_Rd_PowerOff;
  ZR_Rd_Request: TZR_Rd_Request;
  ZR_Rd_Halt: TZR_Rd_Halt;
  ZR_Rd_A_S: TZR_Rd_A_S;
  ZR_Rd_R_A_S: TZR_Rd_R_A_S;
  ZR_Rd_R_R: TZR_Rd_R_R;
  ZR_Rd_RATS: TZR_Rd_RATS;
  ZR_Rd_Auth: TZR_Rd_Auth;
  ZR_Rd_Read16: TZR_Rd_Read16;
  ZR_Rd_Write16: TZR_Rd_Write16;
  ZR_Rd_Write4: TZR_Rd_Write4;
  ZR_Rd_Increment: TZR_Rd_Increment;
  ZR_Rd_Decrement: TZR_Rd_Decrement;
  ZR_Rd_Transfer: TZR_Rd_Transfer;
  ZR_Rd_Restore: TZR_Rd_Restore;
  ZR_Rd_ISO_MP_4: TZR_Rd_ISO_MP_4;
  ZR_Rd_WriteKeyToEEPROM: TZR_Rd_WriteKeyToEEPROM;
  ZR_DecodeMfAccessBits: TZR_DecodeMfAccessBits;
  ZR_EncodeMfAccessBits: TZR_EncodeMfAccessBits;
  ZR_M3n_ActivatePowerKey: TZR_M3n_ActivatePowerKey;
  ZR_M3n_SetOutputs: TZR_M3n_SetOutputs;
  ZR_M3n_GetInputs: TZR_M3n_GetInputs;
  ZR_M3n_SetConfig: TZR_M3n_SetConfig;
  ZR_M3n_GetConfig: TZR_M3n_GetConfig;
  ZR_M3n_SetSecurity: TZR_M3n_SetSecurity;
  ZR_M3n_GetSecurity: TZR_M3n_GetSecurity;
  ZR_M3n_SetClock: TZR_M3n_SetClock;
  ZR_M3n_GetClock: TZR_M3n_GetClock;
  ZR_Z2b_SetFormat: TZR_Z2b_SetFormat;
  ZR_Z2b_GetFormat: TZR_Z2b_GetFormat;
  ZR_Z2b_SetPowerState: TZR_Z2b_SetPowerState;
{$ENDIF !ZREADER_LINKONREQUEST}

function ZR_CloseHandle(AHandle: THandle): HResult; {$IFDEF HAS_INLINE}inline;{$ENDIF}
// Перечислить все подключенные считыватели
function ZR_GetPortInfoList(var VHandle: THandle; var VCount: Integer): HResult; {$IFDEF HAS_INLINE}inline;{$ENDIF}
function ZR_SearchDevices(var VHandle: THandle; var AParams: TZP_SEARCH_PARAMS;
    ASerial: Boolean=True; AIP: Boolean=True): HResult; {$IFDEF HAS_INLINE}inline;{$ENDIF}
function ZR_FindNextDevice(AHandle: THandle; var VInfo: TZR_RD_INFO;
    VPortArr: PZP_PORT_INFO; AArrLen: Integer; var VPortCount: Integer;
    ATimeout: Cardinal=INFINITE): HResult; {$IFDEF HAS_INLINE}inline;{$ENDIF}
// Настраивает уведомления
function ZR_SetNotification(var VHandle: THandle; var ASettings: TZP_DD_NOTIFY_SETTINGS;
    ASerial: Boolean; AIp: Boolean): HResult;{$IFDEF HAS_INLINE}inline;{$ENDIF}
function ZR_GetNextMessage(AHandle: THandle; var VMsg: Cardinal;
    var VMsgParam: NativeInt): HResult;{$IFDEF HAS_INLINE}inline;{$ENDIF}

function SLFromCdOpts(Opts: TZRCDO): Integer;{$IFDEF HAS_INLINE}inline;{$ENDIF}

Const
  ZR_DLL_Name = 'ZReader.dll';

function IsZReaderLoaded(): Boolean;
function GetZReaderModuleHandle(): THandle;
function LoadZReader(): HResult;
procedure UnloadZReader();

implementation

uses
  SysUtils {$IFDEF ZREADER_LINKONREQUEST}, SysConst {$ENDIF ZREADER_LINKONREQUEST};

{$IFDEF ZREADER_LINKONREQUEST}
var
  g_hLib: THandle = 0;
  g_nLoadCount: Integer = 0;
{$ENDIF ZREADER_LINKONREQUEST}

function IsZReaderLoaded(): Boolean;
begin
{$IFDEF ZREADER_LINKONREQUEST}
  Result := g_hLib <> 0;
{$ELSE}
  Result := True;
{$ENDIF ZREADER_LINKONREQUEST}
end;

function GetZReaderModuleHandle(): THandle;
begin
{$IFDEF ZREADER_LINKONREQUEST}
  Result := g_hLib;
{$ELSE}
  Result := 0;
{$ENDIF ZREADER_LINKONREQUEST}
end;

function LoadZReader(): HResult;
{$IFDEF ZREADER_LINKONREQUEST}
  function GetModuleSymbolEx(ASymbolName: LPCSTR; var VAccu: HResult): Pointer;
  begin
    Result := GetProcAddress(g_hLib, ASymbolName);
    if Result = nil then VAccu := E_NOINTERFACE;
  end;
{$ENDIF ZREADER_LINKONREQUEST}
  function CheckZrVersion(): Boolean;
  var
    nVersion: Cardinal;
  begin
    nVersion := ZR_GetVersion();
    Result := ((nVersion and $ff) = ZR_SDK_VER_MAJOR) and (((nVersion shr 8) and $ff) = ZR_SDK_VER_MINOR);
  end;
begin
{$IFDEF ZREADER_LINKONREQUEST}
  Result := S_OK;
  Inc(g_nLoadCount);
  if g_nLoadCount > 1 then
    Exit;

  g_hLib := LoadLibrary(PChar(ZR_DLL_Name));
  if g_hLib = 0 then
  begin
    Result := HResultFromWin32(GetLastError());
    exit;
  end;
  Result := LoadZPort();
  if Succeeded(Result) then
  begin
    @ZR_GetVersion := GetModuleSymbolEx('ZR_GetVersion', Result);
    if Succeeded(Result) and CheckZrVersion() then
    begin
      @ZR_Initialize := GetModuleSymbolEx('ZR_Initialize', Result);
      @ZR_Finalyze := GetModuleSymbolEx('ZR_Finalyze', Result);
      @ZR_UpdateRdFirmware := GetModuleSymbolEx('ZR_UpdateRdFirmware', Result);
      @ZR_Rd_Open := GetModuleSymbolEx('ZR_Rd_Open', Result);
      @ZR_Rd_DettachPort := GetModuleSymbolEx('ZR_Rd_DettachPort', Result);
      @ZR_Rd_GetConnectionStatus := GetModuleSymbolEx('ZR_Rd_GetConnectionStatus', Result);
      @ZR_Rd_GetWaitSettings := GetModuleSymbolEx('ZR_Rd_GetWaitSettings', Result);
      @ZR_Rd_SetWaitSettings := GetModuleSymbolEx('ZR_Rd_SetWaitSettings', Result);
      @ZR_Rd_SetCapture := GetModuleSymbolEx('ZR_Rd_SetCapture', Result);
      @ZR_Rd_ReleaseCapture := GetModuleSymbolEx('ZR_Rd_ReleaseCapture', Result);
      @ZR_Rd_GetInformation := GetModuleSymbolEx('ZR_Rd_GetInformation', Result);
      @ZR_Rd_UpdateFirmware := GetModuleSymbolEx('ZR_Rd_UpdateFirmware', Result);
      @ZR_Rd_SetNotification := GetModuleSymbolEx('ZR_Rd_SetNotification', Result);
      @ZR_Rd_GetNextMessage := GetModuleSymbolEx('ZR_Rd_GetNextMessage', Result);
      @ZR_Rd_SearchCards := GetModuleSymbolEx('ZR_Rd_SearchCards', Result);
      @ZR_Rd_FindNextCard := GetModuleSymbolEx('ZR_Rd_FindNextCard', Result);
      @ZR_Rd_SelectCard := GetModuleSymbolEx('ZR_Rd_SelectCard', Result);
      @ZR_Rd_ReadULCard4Page := GetModuleSymbolEx('ZR_Rd_ReadULCard4Page', Result);
      @ZR_Rd_WriteULCardPage := GetModuleSymbolEx('ZR_Rd_WriteULCardPage', Result);
      @ZR_Rd_FindT57 := GetModuleSymbolEx('ZR_Rd_FindT57', Result);
      @ZR_Rd_ReadT57Block := GetModuleSymbolEx('ZR_Rd_ReadT57Block', Result);
      @ZR_Rd_WriteT57Block := GetModuleSymbolEx('ZR_Rd_WriteT57Block', Result);
      @ZR_Rd_ResetT57 := GetModuleSymbolEx('ZR_Rd_ResetT57', Result);
      @ZR_DecodeT57Config := GetModuleSymbolEx('ZR_DecodeT57Config', Result);
      @ZR_EncodeT57Config := GetModuleSymbolEx('ZR_EncodeT57Config', Result);
      @ZR_DecodeT57EmMarine := GetModuleSymbolEx('ZR_DecodeT57EmMarine', Result);
      @ZR_EncodeT57EmMarine := GetModuleSymbolEx('ZR_EncodeT57EmMarine', Result);
      @ZR_DecodeT57Hid := GetModuleSymbolEx('ZR_DecodeT57Hid', Result);
      @ZR_EncodeT57Hid := GetModuleSymbolEx('ZR_EncodeT57Hid', Result);
      @ZR_Rd_GetEncodedCardNumber := GetModuleSymbolEx('ZR_Rd_GetEncodedCardNumber', Result);
      @ZR_Rd_AuthorizeSect := GetModuleSymbolEx('ZR_Rd_AuthorizeSect', Result);
      @ZR_Rd_AuthorizeSectByEKey := GetModuleSymbolEx('ZR_Rd_AuthorizeSectByEKey', Result);
      @ZR_Rd_ReadMfCardBlock := GetModuleSymbolEx('ZR_Rd_ReadMfCardBlock', Result);
      @ZR_Rd_WriteMfCardBlock := GetModuleSymbolEx('ZR_Rd_WriteMfCardBlock', Result);
      @ZR_Rd_WriteMfCardBlock4 := GetModuleSymbolEx('ZR_Rd_WriteMfCardBlock4', Result);
      @ZR_Rd_GetIndicatorState := GetModuleSymbolEx('ZR_Rd_GetIndicatorState', Result);
      @ZR_Rd_SetIndicatorState := GetModuleSymbolEx('ZR_Rd_SetIndicatorState', Result);
      @ZR_Rd_AddIndicatorFlash := GetModuleSymbolEx('ZR_Rd_AddIndicatorFlash', Result);
      @ZR_Rd_BreakIndicatorFlash := GetModuleSymbolEx('ZR_Rd_BreakIndicatorFlash', Result);
      @ZR_Rd_GetIndicatorFlashAvailable := GetModuleSymbolEx('ZR_Rd_GetIndicatorFlashAvailable', Result);
      @ZR_Rd_Reset1356 := GetModuleSymbolEx('ZR_Rd_Reset1356', Result);
      @ZR_Rd_PowerOff := GetModuleSymbolEx('ZR_Rd_PowerOff', Result);
      @ZR_Rd_Request := GetModuleSymbolEx('ZR_Rd_Request', Result);
      @ZR_Rd_Halt := GetModuleSymbolEx('ZR_Rd_Halt', Result);
      @ZR_Rd_A_S := GetModuleSymbolEx('ZR_Rd_A_S', Result);
      @ZR_Rd_R_A_S := GetModuleSymbolEx('ZR_Rd_R_A_S', Result);
      @ZR_Rd_R_R := GetModuleSymbolEx('ZR_Rd_R_R', Result);
      @ZR_Rd_RATS := GetModuleSymbolEx('ZR_Rd_RATS', Result);
      @ZR_Rd_Auth := GetModuleSymbolEx('ZR_Rd_Auth', Result);
      @ZR_Rd_Read16 := GetModuleSymbolEx('ZR_Rd_Read16', Result);
      @ZR_Rd_Write16 := GetModuleSymbolEx('ZR_Rd_Write16', Result);
      @ZR_Rd_Write4 := GetModuleSymbolEx('ZR_Rd_Write4', Result);
      @ZR_Rd_Increment := GetModuleSymbolEx('ZR_Rd_Increment', Result);
      @ZR_Rd_Decrement := GetModuleSymbolEx('ZR_Rd_Decrement', Result);
      @ZR_Rd_Transfer := GetModuleSymbolEx('ZR_Rd_Transfer', Result);
      @ZR_Rd_Restore := GetModuleSymbolEx('ZR_Rd_Restore', Result);
      @ZR_Rd_ISO_MP_4 := GetModuleSymbolEx('ZR_Rd_ISO_MP_4', Result);
      @ZR_Rd_WriteKeyToEEPROM := GetModuleSymbolEx('ZR_Rd_WriteKeyToEEPROM', Result);
      @ZR_DecodeMfAccessBits := GetModuleSymbolEx('ZR_DecodeMfAccessBits', Result);
      @ZR_EncodeMfAccessBits := GetModuleSymbolEx('ZR_EncodeMfAccessBits', Result);
      @ZR_M3n_ActivatePowerKey := GetModuleSymbolEx('ZR_M3n_ActivatePowerKey', Result);
      @ZR_M3n_SetOutputs := GetModuleSymbolEx('ZR_M3n_SetOutputs', Result);
      @ZR_M3n_GetInputs := GetModuleSymbolEx('ZR_M3n_GetInputs', Result);
      @ZR_M3n_SetConfig := GetModuleSymbolEx('ZR_M3n_SetConfig', Result);
      @ZR_M3n_GetConfig := GetModuleSymbolEx('ZR_M3n_GetConfig', Result);
      @ZR_M3n_SetSecurity := GetModuleSymbolEx('ZR_M3n_SetSecurity', Result);
      @ZR_M3n_GetSecurity := GetModuleSymbolEx('ZR_M3n_GetSecurity', Result);
      @ZR_M3n_SetClock := GetModuleSymbolEx('ZR_M3n_SetClock', Result);
      @ZR_M3n_GetClock := GetModuleSymbolEx('ZR_M3n_GetClock', Result);
      @ZR_Z2b_SetFormat := GetModuleSymbolEx('ZR_Z2b_SetFormat', Result);
      @ZR_Z2b_GetFormat := GetModuleSymbolEx('ZR_Z2b_GetFormat', Result);
      @ZR_Z2b_SetPowerState := GetModuleSymbolEx('ZR_Z2b_SetPowerState', Result);
    end
    else
      Result := E_NOINTERFACE;
  end;

  if Failed(Result) then
    UnloadZReader();
{$ELSE}
  if CheckZrVersion() then
    Result := LoadZPort()
  else
    Result := E_NOINTERFACE;
{$ENDIF ZREADER_LINKONREQUEST}
end;

procedure UnloadZReader();
begin
{$IFDEF ZREADER_LINKONREQUEST}
  Dec(g_nLoadCount);
  if g_nLoadCount > 0 then
    exit;
  FreeLibrary(g_hLib);
  g_hLib := 0;
  UnloadZPort();
  ZR_GetVersion := nil;
  ZR_Initialize := nil;
  ZR_Finalyze := nil;
  ZR_UpdateRdFirmware := nil;
  ZR_Rd_Open := nil;
  ZR_Rd_DettachPort := nil;
  ZR_Rd_GetConnectionStatus := nil;
  ZR_Rd_GetWaitSettings := nil;
  ZR_Rd_SetWaitSettings := nil;
  ZR_Rd_SetCapture := nil;
  ZR_Rd_ReleaseCapture := nil;
  ZR_Rd_GetInformation := nil;
  ZR_Rd_UpdateFirmware := nil;
  ZR_Rd_SetNotification := nil;
  ZR_Rd_GetNextMessage := nil;
  ZR_Rd_SearchCards := nil;
  ZR_Rd_FindNextCard := nil;
  ZR_Rd_SelectCard := nil;
  ZR_Rd_ReadULCard4Page := nil;
  ZR_Rd_WriteULCardPage := nil;
  ZR_Rd_FindT57 := nil;
  ZR_Rd_ReadT57Block := nil;
  ZR_Rd_WriteT57Block := nil;
  ZR_Rd_ResetT57 := nil;
  ZR_DecodeT57Config := nil;
  ZR_EncodeT57Config := nil;
  ZR_DecodeT57EmMarine := nil;
  ZR_EncodeT57EmMarine := nil;
  ZR_DecodeT57Hid := nil;
  ZR_EncodeT57Hid := nil;
  ZR_Rd_GetEncodedCardNumber := nil;
  ZR_Rd_AuthorizeSect := nil;
  ZR_Rd_AuthorizeSectByEKey := nil;
  ZR_Rd_ReadMfCardBlock := nil;
  ZR_Rd_WriteMfCardBlock := nil;
  ZR_Rd_WriteMfCardBlock4 := nil;
  ZR_Rd_GetIndicatorState := nil;
  ZR_Rd_SetIndicatorState := nil;
  ZR_Rd_AddIndicatorFlash := nil;
  ZR_Rd_BreakIndicatorFlash := nil;
  ZR_Rd_GetIndicatorFlashAvailable := nil;
  ZR_Rd_Reset1356 := nil;
  ZR_Rd_PowerOff := nil;
  ZR_Rd_Request := nil;
  ZR_Rd_Halt := nil;
  ZR_Rd_A_S := nil;
  ZR_Rd_R_A_S := nil;
  ZR_Rd_R_R := nil;
  ZR_Rd_RATS := nil;
  ZR_Rd_Auth := nil;
  ZR_Rd_Read16 := nil;
  ZR_Rd_Write16 := nil;
  ZR_Rd_Write4 := nil;
  ZR_Rd_Increment := nil;
  ZR_Rd_Decrement := nil;
  ZR_Rd_Transfer := nil;
  ZR_Rd_Restore := nil;
  ZR_Rd_ISO_MP_4 := nil;
  ZR_Rd_WriteKeyToEEPROM := nil;
  ZR_DecodeMfAccessBits := nil;
  ZR_EncodeMfAccessBits := nil;
  ZR_M3n_ActivatePowerKey := nil;
  ZR_M3n_SetOutputs := nil;
  ZR_M3n_GetInputs := nil;
  ZR_M3n_SetConfig := nil;
  ZR_M3n_GetConfig := nil;
  ZR_M3n_SetSecurity := nil;
  ZR_M3n_GetSecurity := nil;
  ZR_M3n_SetClock := nil;
  ZR_M3n_GetClock := nil;
  ZR_Z2b_SetFormat := nil;
  ZR_Z2b_GetFormat := nil;
  ZR_Z2b_SetPowerState := nil;
{$ENDIF ZREADER_LINKONREQUEST}
end;


{$IFNDEF ZREADER_LINKONREQUEST}

function ZR_GetVersion(): Cardinal;
        External ZR_DLL_Name name 'ZR_GetVersion';

function ZR_Initialize(AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Initialize';
function ZR_Finalyze(): HResult;
        External ZR_DLL_Name name 'ZR_Finalyze';


function ZR_UpdateRdFirmware(const AParams: TZR_RD_OPEN_PARAMS;
    AData: Pointer; ACount: Integer;
    ACallback: TZR_PROCESSCALLBACK; AUserData: Pointer): HResult;
        External ZR_DLL_Name name 'ZR_UpdateRdFirmware';

function ZR_Rd_Open(var VHandle: THandle;
    const AParams: TZR_RD_OPEN_PARAMS; VInfo: PZR_RD_INFO): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Open';
function ZR_Rd_DettachPort(AHandle: THandle; var VPortHandle: THandle): HResult;
        External ZR_DLL_Name name 'ZR_Rd_DettachPort';
function ZR_Rd_GetConnectionStatus(AHandle: THandle; var VValue: TZP_CONNECTION_STATUS; var VSessionId: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_GetConnectionStatus';

function ZR_Rd_GetWaitSettings(AHandle: THandle; var VSetting: TZP_WAIT_SETTINGS): HResult;
        External ZR_DLL_Name name 'ZR_Rd_GetWaitSettings';
function ZR_Rd_SetWaitSettings(AHandle: THandle; Const ASetting: TZP_WAIT_SETTINGS): HResult;
        External ZR_DLL_Name name 'ZR_Rd_SetWaitSettings';

function ZR_Rd_SetCapture(AHandle: THandle): HResult;
        External ZR_DLL_Name name 'ZR_Rd_SetCapture';
function ZR_Rd_ReleaseCapture(AHandle: THandle): HResult;
        External ZR_DLL_Name name 'ZR_Rd_ReleaseCapture';

function ZR_Rd_GetInformation(AHandle: THandle; var VInfo: TZR_RD_INFO): HResult;
        External ZR_DLL_Name name 'ZR_Rd_GetInformation';

function ZR_Rd_UpdateFirmware(AHandle: THandle; AData: Pointer; ACount: Integer;
    ACallback: TZR_PROCESSCALLBACK; AUserData: Pointer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_UpdateFirmware';

function ZR_Rd_SetNotification(AHandle: THandle; ASetting: PZR_RD_NOTIFY_SETTINGS): HResult;
        External ZR_DLL_Name name 'ZR_Rd_SetNotification';
function ZR_Rd_GetNextMessage(AHandle: THandle; var VMsg: Cardinal;
    var VMsgParam: NativeInt): HResult;
        External ZR_DLL_Name name 'ZR_Rd_GetNextMessage';

function ZR_Rd_SearchCards(AHandle: THandle; AMaxCard: Integer; AFlags:Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_SearchCards';
function ZR_Rd_FindNextCard(AHandle: THandle; VInfo: PZR_CARD_INFO): HResult;
        External ZR_DLL_Name name 'ZR_Rd_FindNextCard';

function ZR_Rd_ReadULCard4Page(AHandle: THandle; APageN: Integer; var VBuf16): HResult;
        External ZR_DLL_Name name 'ZR_Rd_ReadULCard4Page';
function ZR_Rd_WriteULCardPage(AHandle: THandle; APageN: Integer; AData4: Pointer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_WriteULCardPage';

function ZR_Rd_FindT57(AHandle: THandle; var VNum: TZ_KEYNUM;
    var VPar: Integer; APsw, AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_FindT57';
function ZR_Rd_ReadT57Block(AHandle: THandle; ABlockN: Integer; var VBuf4;
    APar: Integer; APsw, AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_ReadT57Block';
function ZR_Rd_WriteT57Block(AHandle: THandle; ABlockN: Integer; AData4: Pointer;
    APar: Integer; APsw, AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_WriteT57Block';
function ZR_Rd_ResetT57(AHandle: THandle): HResult;
        External ZR_DLL_Name name 'ZR_Rd_ResetT57';

function ZR_DecodeT57Config(var VConfig: TZR_T57_CONFIG; AData4: Pointer): HResult;
        External ZR_DLL_Name name 'ZR_DecodeT57Config';
function ZR_EncodeT57Config(var VBuf4; const AConfig: TZR_T57_CONFIG): HResult;
        External ZR_DLL_Name name 'ZR_EncodeT57Config';
function ZR_DecodeT57EmMarine(VBitOffs: PInteger; var VNum: TZ_KEYNUM;
    AData: Pointer; ACount: Integer): HResult;
        External ZR_DLL_Name name 'ZR_DecodeT57EmMarine';
function ZR_EncodeT57EmMarine(var VBuf; VBufSize: Integer; ABitOffs: Integer;
    const ANum: TZ_KEYNUM): HResult;
        External ZR_DLL_Name name 'ZR_EncodeT57EmMarine';
function ZR_DecodeT57Hid(var VNum: TZ_KEYNUM; AData12: Pointer; var VWiegand: Integer): HResult;
        External ZR_DLL_Name name 'ZR_DecodeT57Hid';
function ZR_EncodeT57Hid(var VBuf12; const ANum: TZ_KEYNUM; AWiegand: Integer): HResult;
        External ZR_DLL_Name name 'ZR_EncodeT57Hid';
function ZR_Rd_GetEncodedCardNumber(AHandle: THandle;
    var VType: TZR_CARD_TYPE; var VNum: TZ_KEYNUM;
    var VBuf; VBufSize: Integer; var VRCount: Integer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_GetEncodedCardNumber';

function ZR_Rd_SelectCard(AHandle: THandle; const ANum: TZ_KEYNUM; AType: TZR_CARD_TYPE): HResult;
        External ZR_DLL_Name name 'ZR_Rd_SelectCard';
function ZR_Rd_AuthorizeSect(AHandle: THandle; ABlockN: Integer; AKey: PZR_MF_AUTH_KEY; AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_AuthorizeSect';
function ZR_Rd_AuthorizeSectByEKey(AHandle: THandle; ABlockN: Integer; AKeyMask: Cardinal; VRKeyIdx: PInteger; AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_AuthorizeSectByEKey';
function ZR_Rd_ReadMfCardBlock(AHandle: THandle; ABlockN: Integer; var VBuf16; AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_ReadMfCardBlock';
function ZR_Rd_WriteMfCardBlock(AHandle: THandle; ABlockN: Integer; AData16: Pointer; AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_WriteMfCardBlock';
function ZR_Rd_WriteMfCardBlock4(AHandle: THandle; ABlockN: Integer; AData4: Pointer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_WriteMfCardBlock4';

function ZR_Rd_GetIndicatorState(AHandle: THandle; VRed: PCardinal; VGreen: PCardinal; VSound: PCardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_GetIndicatorState';
function ZR_Rd_SetIndicatorState(AHandle: THandle; ARed: TZR_IND_STATE; AGreen: TZR_IND_STATE; ASound: TZR_IND_STATE): HResult;
        External ZR_DLL_Name name 'ZR_Rd_SetIndicatorState';
function ZR_Rd_AddIndicatorFlash(AHandle: THandle; ARecs: PZR_IND_FLASH; ACount: Integer; AReset: LongBool; var VRCount: Integer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_AddIndicatorFlash';
function ZR_Rd_BreakIndicatorFlash(AHandle: THandle; AAutoMode: LongBool): HResult;
        External ZR_DLL_Name name 'ZR_Rd_BreakIndicatorFlash';
function ZR_Rd_GetIndicatorFlashAvailable(AHandle: THandle; var VCount: Integer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_GetIndicatorFlashAvailable';

function ZR_Rd_Reset1356(AHandle: THandle; AWaitMs: Word): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Reset1356';
function ZR_Rd_PowerOff(AHandle: THandle): HResult;
        External ZR_DLL_Name name 'ZR_Rd_PowerOff';

function ZR_Rd_Request(AHandle: THandle; AWakeUp: LongBool; VATQ: PWord): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Request';
function ZR_Rd_Halt(AHandle: THandle): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Halt';
function ZR_Rd_A_S(AHandle: THandle;
    VNum: PZ_KEYNUM; VSAQ: PByte): HResult;
        External ZR_DLL_Name name 'ZR_Rd_A_S';
function ZR_Rd_R_A_S(AHandle: THandle; AWakeUp: LongBool;
    VNum: PZ_KEYNUM; VSAQ: PByte; VATQ: PWord): HResult;
        External ZR_DLL_Name name 'ZR_Rd_R_A_S';
function ZR_Rd_R_R(AHandle: THandle; const ANum: TZ_KEYNUM; AWakeUp: LongBool): HResult;
        External ZR_DLL_Name name 'ZR_Rd_R_R';
function ZR_Rd_RATS(AHandle: THandle; var VBuf; ABufSize: Integer; var VRCount: Integer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_RATS';
function ZR_Rd_Auth(AHandle: THandle; AAddr: Cardinal;
    AKey: PZR_MF_AUTH_KEY; AEKeyMask: Cardinal; VEKeyIdx: PInteger; AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Auth';
function ZR_Rd_Read16(AHandle: THandle; AAddr: Cardinal; var VBuf16; AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Read16';
function ZR_Rd_Write16(AHandle: THandle; AAddr: Cardinal; AData16: Pointer; AFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Write16';
function ZR_Rd_Write4(AHandle: THandle; AAddr: Cardinal; AData4: Pointer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Write4';
function ZR_Rd_Increment(AHandle: THandle; AAddr: Cardinal; AValue: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Increment';
function ZR_Rd_Decrement(AHandle: THandle; AAddr: Cardinal; AValue: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Decrement';
function ZR_Rd_Transfer(AHandle: THandle; AAddr: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Transfer';
function ZR_Rd_Restore(AHandle: THandle; AAddr: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_Rd_Restore';
function ZR_Rd_ISO_MP_4(AHandle: THandle; AData: Pointer; ACount: Integer;
    var VBuf; ABufSize: Integer; var VRCount: Integer): HResult;
        External ZR_DLL_Name name 'ZR_Rd_ISO_MP_4';

function ZR_Rd_WriteKeyToEEPROM(AHandle: THandle; AAddr: Cardinal;
    AKeyB: LongBool; AKey: PZR_MF_AUTH_KEY): HResult;
        External ZR_DLL_Name name 'ZR_Rd_WriteKeyToEEPROM';

function ZR_DecodeMfAccessBits(AAreaN: Integer; var VBits: Cardinal; AData3: Pointer): HResult;
        External ZR_DLL_Name name 'ZR_DecodeMfAccessBits';
function ZR_EncodeMfAccessBits(AAreaN: Integer; var VBuf3; ABits: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_EncodeMfAccessBits';

function ZR_M3n_ActivatePowerKey(AHandle: THandle; AForce: LongBool; ATimeMs: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_M3n_ActivatePowerKey';
function ZR_M3n_SetOutputs(AHandle: THandle; AMask, AOutBits: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_M3n_SetOutputs';
function ZR_M3n_GetInputs(AHandle: THandle; var VFlags: Cardinal): HResult;
        External ZR_DLL_Name name 'ZR_M3n_GetInputs';
function ZR_M3n_SetConfig(AHandle: THandle; const AConfig: TZR_M3N_CONFIG): HResult;
        External ZR_DLL_Name name 'ZR_M3n_SetConfig';
function ZR_M3n_GetConfig(AHandle: THandle; var VConfig: TZR_M3N_CONFIG): HResult;
        External ZR_DLL_Name name 'ZR_M3n_GetConfig';
function ZR_M3n_SetSecurity(AHandle: THandle; ABlockN: Integer;
    AKeyMask: Cardinal; AKeyB: LongBool): HResult;
        External ZR_DLL_Name name 'ZR_M3n_SetSecurity';
function ZR_M3n_GetSecurity(AHandle: THandle; var VBlockN: Integer;
    var VKeyMask: Cardinal; var VKeyB: LongBool): HResult;
        External ZR_DLL_Name name 'ZR_M3n_GetSecurity';
function ZR_M3n_SetClock(AHandle: THandle; const ATime: TSystemTime): HResult;
        External ZR_DLL_Name name 'ZR_M3n_SetClock';
function ZR_M3n_GetClock(AHandle: THandle; var VTime: TSystemTime): HResult;
        External ZR_DLL_Name name 'ZR_M3n_GetClock';

function ZR_Z2b_SetFormat(AHandle: THandle; AFmt: PWideChar; AArg: PWideChar;
    ANoCard: PWideChar; ASaveEE: LongBool): HResult;
        External ZR_DLL_Name name 'ZR_Z2b_SetFormat';
function ZR_Z2b_GetFormat(AHandle: THandle;
    VFmtBuf: PWideChar; AFmtBufSize: Integer;
    VArgBuf: PWideChar; AArgBufSize: Integer;
    VNCBuf: PWideChar; ANCBufSize: Integer): HResult;
        External ZR_DLL_Name name 'ZR_Z2b_GetFormat';
function ZR_Z2b_SetPowerState(AHandle: THandle; AOn: LongBool): HResult;
        External ZR_DLL_Name name 'ZR_Z2b_SetPowerState';

{$ENDIF !ZREADER_LINKONREQUEST}


function ZR_CloseHandle(AHandle: THandle): HResult;
begin
  Result := ZP_CloseHandle(AHandle);
end;
function ZR_GetPortInfoList(var VHandle: THandle; var VCount: Integer): HResult;
begin
  Result := ZP_GetPortInfoList(VHandle, VCount, ZR_DEVTYPE_READERS);
end;

function ZR_SearchDevices(var VHandle: THandle; var AParams: TZP_SEARCH_PARAMS;
    ASerial: Boolean; AIP: Boolean): HResult;
begin
  if ASerial then
    AParams.nDevMask := AParams.nDevMask or ZR_DEVTYPE_READERS;
  if AIP then
    AParams.nIpDevMask := AParams.nIpDevMask or ZR_IPDEVTYPE_CVTS;
  Result := ZP_SearchDevices(VHandle, AParams);
end;

function ZR_FindNextDevice(AHandle: THandle; var VInfo: TZR_RD_INFO;
    VPortArr: PZP_PORT_INFO; AArrLen: Integer; var VPortCount: Integer;
    ATimeout: Cardinal): HResult;
begin
  VInfo.rBase.cbSize := SizeOf(VInfo);
  Result := ZP_FindNextDevice(AHandle, @VInfo, VPortArr, AArrLen, VPortCount, ATimeout);
end;
function ZR_SetNotification(var VHandle: THandle; var ASettings: TZP_DD_NOTIFY_SETTINGS;
    ASerial, AIp: Boolean): HResult;
begin
  if ASerial then
    ASettings.nSDevTypes := ASettings.nSDevTypes or ZR_DEVTYPE_READERS;
  if AIp then
    ASettings.nIpDevTypes := ASettings.nSDevTypes or ZR_IPDEVTYPE_CVTS;
  Result := ZP_DD_SetNotification(VHandle, ASettings);
end;
function ZR_GetNextMessage(AHandle: THandle; var VMsg: Cardinal;
    var VMsgParam: NativeInt): HResult;
begin
  Result := ZP_DD_GetNextMessage(AHandle, VMsg, VMsgParam);
end;

function SLFromCdOpts(Opts: TZRCDO): Integer;
begin
  Result := ((Opts and (ZR_CDO_MPSL1 or ZR_CDO_MPSL2)) shr 4) and 3;
end;


end.
