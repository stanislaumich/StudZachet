unit ZBase;

interface

Type
  // Номер ключа контроллера ([0] - размер ключа)
  TZ_KEYNUM = array[0..15] of Byte;
  PZ_KEYNUM = ^TZ_KEYNUM;

function CompareZKeyNums(Const _Left, _Right: TZ_KEYNUM): Integer;

implementation

uses
  Math;

function CompareZKeyNums(Const _Left, _Right: TZ_KEYNUM): Integer;
var
  i: Integer;
begin
  for i := min(_Left[0], _Right[0]) downto 1 do
  begin
    if _Left[i] <> _Right[i] then
    begin
      if _Left[i] > _Right[i] then
        Result := +1
      else
        Result := -1;
      exit;
    end;
  end;
  if _Left[0] <> _Right[0] then
  begin
    if _Left[0] > _Right[0] then
      Result := +1
    else
      Result := -1;
    exit;
  end;
  Result := 0;
end;

end.
