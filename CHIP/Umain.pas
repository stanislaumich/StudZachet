unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ZBase, ZPort, ZReader,
  ZRClasses, Utils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public

  end;

  // +++++++++++++++++++++++++++++
const
  RdPortType = ZP_PORT_COM;
  RdPortName = 'COM3';
  //MfAuthKey: TZR_MF_AUTH_KEY = (6, $FF, $FF, $FF, $FF, $FF, $FF, 0, 0, 0, 0, 0,
  //  0, 0, 0, 0, 0, 0, 0, 0);

var
  g_hRd: THandle;

  // ++++++++++++++++++++++++++++++

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  rOpen: TZR_RD_Open_Params;
  rRdInf: TZR_Rd_Info;
  rInfo: TZR_Card_Info;
  s: String;
  hr: HResult;

begin
  CheckZRError(ZR_Initialize(ZP_IF_NO_MSG_LOOP));
  g_hRd := 0;

  try
    Memo1.Lines.Add(format('Open reader (%s)...', [RdPortName]));
    FillChar(rOpen, SizeOf(rOpen), 0);
    rOpen.pszName := PChar(RdPortName);
    rOpen.nType := RdPortType;
    FillChar(rRdInf, SizeOf(rRdInf), 0);
    CheckZRError(ZR_Rd_Open(g_hRd, rOpen, @rRdInf));
    if (rRdInf.nType <> ZR_RD_Z2M) and (rRdInf.nType <> ZR_RD_M3N) and
      (rRdInf.nType <> ZR_RD_CPZ2MF) and (rRdInf.nType <> ZR_RD_Z2MFI) then
    begin
      Memo1.Lines.Add('It is not Mifare Reader!');
      Readln;
      exit;
    end;

    CheckZRError(ZR_Rd_SearchCards(g_hRd, 1));
    hr := ZR_Rd_FindNextCard(g_hRd, @rInfo);
    CheckZRError(hr);

        Memo1.Lines.Add(format('%s %s', [
            CardTypeStrs[rInfo.nType], ZKeyNumToStr(rInfo.nNum, rInfo.nType)]));

  finally
    if g_hRd <> 0 then
      ZR_CloseHandle(g_hRd);
    ZR_Finalyze();

  end;
end;

end.
