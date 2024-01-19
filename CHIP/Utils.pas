unit Utils;

interface

uses
  SysUtils, Character, Math,
  ZBase, ZPort, ZReader;

Const
  PortTypeStrs: array[TZP_PORT_TYPE] of String = (
      'Unknown', 'COM', 'FT', 'IP', 'IPS');
  BusyStrs: array[Boolean] of String = ('', 'Busy');
  ReaderTypeStrs: array[TZR_RD_TYPE] of String = (
      'Unknown', 'Z-2 USB', 'Matrix III Rd-All', 'Z-2 USB MF', 'Matrix III Net',
      'CP-Z-2MF', 'Z-2 EHR', 'Z-2 Base', 'Matrix V', 'Z-2 USB MFI',
      'Matrix VI NFC');
  CardTypeStrs: array[TZR_CARD_TYPE] of String = (
      'Unknown', 'EM', 'HID', 'IC', 'UL', '1K', '4K', 'DF', 'PX',
      'Cod433 Fix', 'Cod433', 'Dallas', 'CAME',
    'Plus', 'Plus 1K', 'Plus 2K', 'Plus 4K', 'Mini',
    'Temic', 'M2K', 'SMXM1K', 'SMXM4K');

function ZKeyNumToStr(const ANum: TZ_KEYNUM; AType: TZR_Card_Type): String;

function GetBit(AVal: Cardinal; AIdx: Integer): Boolean;{$IFDEF HAS_INLINE}inline;{$ENDIF}
function Sscanf(const s: string; const fmt: string;
  const Args: array of Pointer): Integer;
function GetTickSpan(AOld, ANew: Cardinal): Cardinal; {$IFDEF HAS_INLINE}inline;{$ENDIF}

implementation

function ZKeyNumToStr(const ANum: TZ_KEYNUM; AType: TZR_Card_Type): String;
var
  i: Integer;
  nFacility: Cardinal;
begin
  case AType of
    ZR_CD_EM: Result := format('%d,%.5d', [ANum[3], PWord(@ANum[1])^]);
    ZR_CD_HID:
    begin
      nFacility := 0;
      i := min(ANum[0] - 2, 4);
      if i > 0 then
        Move(ANum[3], nFacility, i);
      Result := format('[%.*X] %.5d', [i * 2, nFacility, PWord(@ANum[1])^]);
    end
    else
    begin
      Result := '';
      for i := ANum[0] downto 1 do
        Result := Result + IntToHex(ANum[i], 2);
    end;
  end;
end;

function GetBit(AVal: Cardinal; AIdx: Integer): Boolean;
begin
  Result := ((AVal shr AIdx) and 1) <> 0;
end;

//{ Sscanf выполняет синтаксический разбор входной строки. Параметры...
//
//s - входная строка для разбора
//fmt - 'C' scanf-форматоподобная строка для управления разбором
//%d - преобразование в Long Integer
//%f - преобразование в Extended Float
//%s - преобразование в строку (ограничено пробелами)
//другой символ - приращение позиции s на "другой символ"
//пробел - ничего не делает
//Pointers - массив указателей на присваиваемые переменные
//
//результат - количество действительно присвоенных переменных
//
//Например, ...
//Sscanf('Name. Bill   Time. 7:32.77   Age. 8',
//'. %s . %d:%f . %d', [@Name, @hrs, @min, @age]);
//
//возвратит ...
//Name = Bill  hrs = 7  min = 32.77  age = 8 }
//
function Sscanf(const s: string; const fmt: string;
  const Args: array of Pointer): Integer;
Type
  TFmtType = (ftNone,
      ftChar, ftInteger, ftHex, ftExtended, ftString);
var
  i, n, m: integer;
  nFmt: TFmtType;
  s1: string;
  L: Integer;
  X: Extended;

  function GetInt: Integer;
  begin
    s1 := '';
    while (Length(s) > n) and (s[n] = ' ') do
      inc(n);
    while (Length(s) >= n) and CharInSet(s[n], ['0'..'9', '+', '-']) do
    begin
      s1 := s1 + s[n];
      Inc(n);
    end;
    Result := Length(s1);
  end;
  function GetHex: Integer;
  begin
    s1 := '';
    while (Length(s) > n) and (s[n] = ' ') do
      inc(n);
    while (Length(s) >= n) and CharInSet(s[n], ['0'..'9','a'..'f','A'..'F']) do
    begin
      s1 := s1 + s[n];
      Inc(n);
    end;
    Result := Length(s1);
  end;

  function GetFloat: Integer;
  begin
    s1 := '';
    while (Length(s) > n) and (s[n] = ' ') do
      Inc(n);
    if (Length(s) >= n) and CharInSet(s[n], ['+', '-']) then
    begin
      s1 := s1 + s[n];
      Inc(n);
    end;

    while (Length(s) >= n) and CharInSet(s[n], ['0'..'9', {$IF CompilerVersion >= 22.0}FormatSettings.{$IFEND}DecimalSeparator, 'e', 'E']) do
    begin
      s1 := s1 + s[n];
      Inc(n);
    end;
    Result := Length(s1);
  end;

  function GetString: Integer;
  begin
    s1 := '';
    while (Length(s) > n) and (s[n] = ' ') do
      Inc(n);
    if m<=Length(fmt) then
    begin
      while (Length(s) >= n) and (s[n] <> ' ') and (s[n] <> fmt[m]) do
      begin
        s1 := s1 + s[n];
        Inc(n);
      end;
    end
    else
    begin
      while (Length(s) >= n) and (s[n] <> ' ') do
      begin
        s1 := s1 + s[n];
        Inc(n);
      end;
    end;
    Result := Length(s1);
  end;

  function ScanStr(c: Char): Boolean;
  begin
    while (Length(s) > n) and (s[n] <> c) do
      inc(n);
    Result := (n <= Length(s));
    inc(n);
  end;

  function GetFmt: TFmtType;
  begin
    Result := ftNone;
    while (TRUE) do
    begin
      while (Length(fmt) > m) and (fmt[m] = ' ') do
        inc(m);
      if (m >= Length(fmt)) then
        break;
      if (fmt[m] = '%') then
      begin
        inc(m);
        case ToLower(fmt[m]) of
          'd': Result := ftInteger;
          'x': Result := ftHex;
          'f': Result := ftExtended;
          's': Result := ftString;
          '%': break;
        end;
        inc(m);
        break;
      end;
      if (ScanStr(fmt[m]) = False) then
        break;
      inc(m);
    end;
  end;

begin
  n := 1;
  m := 1;
  Result := 0;
  for i := 0 to High(Args) do
  begin
    nFmt := GetFmt;
    case nFmt of
      ftInteger:
        begin
          if GetInt > 0 then
          begin
            L := StrToInt(s1);
            PInteger(Args[i])^ := L;
            inc(Result);
          end
          else
            break;
        end;
      ftHex:
        begin
          if GetHex > 0 then
          begin
            L := StrToInt('$' + s1);
            PInteger(Args[i])^ := L;
            inc(Result);
          end
          else
            break;
        end;
      ftExtended:
        begin
          if GetFloat > 0 then
          begin
            X := StrToFloat(s1);
            PExtended(Args[i])^ := X;
            inc(Result);
          end
          else
            break;
        end;
      ftString:
        begin
          GetString();
          PString(Args[i])^ := s1;
          inc(Result);
        end;
    else
      break;
    end;
  end;
end;

function GetTickSpan(AOld, ANew: Cardinal): Cardinal;
begin
  {This is just in case the TickCount rolled back to zero}
  if ANew >= AOld then
    Result := (ANew - AOld)
  else
    Result := (High(LongWord) - AOld + ANew);
end;

end.
