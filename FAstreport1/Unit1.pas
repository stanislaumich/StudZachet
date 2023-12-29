unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.ExtCtrls, frxPreview;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Rep: TfrxReport;
    frxPreview1: TfrxPreview;
    OpenDialog1: TOpenDialog;
    Action1: TAction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetValue(name:string;val:string);
    procedure SetImage(name:string;val:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.SetValue(name:string;val:string);
var
 C:tfrxcomponent;
begin
 c:=rep.FindObject(name);
 tfrxmemoview(c).memo.text:=val;
end;

procedure TForm1.SetImage(name:string;val:string);
var
 C:tfrxcomponent;
begin
 c:=rep.FindObject(name);
 tfrxmemoview(c).memo.text:=val;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if opendialog1.execute then
 rep.LoadFromFile(opendialog1.filename);
 rep.PrepareReport();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

 SetValue('Memo15','2312323123');

 rep.PrepareReport();
 rep.ShowPreparedReport;
end;

end.
