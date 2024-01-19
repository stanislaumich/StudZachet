unit UAskreprint;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TFAskreprint = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAskreprint: TFAskreprint;

implementation

{$R *.dfm}

procedure TFAskreprint.BitBtn1Click(Sender: TObject);
begin
 Faskreprint.tag:=1;
 Faskreprint.Close;
end;

procedure TFAskreprint.BitBtn2Click(Sender: TObject);
begin
 Faskreprint.tag:=0;
 Faskreprint.Close;
end;

procedure TFAskreprint.BitBtn3Click(Sender: TObject);
begin
 Faskreprint.tag:=2;
 Faskreprint.Close;
end;

end.
