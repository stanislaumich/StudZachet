unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frxClass, frxPreview;

type
  TForm1 = class(TForm)
    frxPreview: TfrxPreview;
    frxReport: TfrxReport;
    HScroll: TScrollBar;
    VScroll: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure HScrollScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure VScrollScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure frxPreviewOnScrollPosChange(Sender: TObject; Orientation: TfrxScrollerOrientation; var Value: Integer);
    procedure frxPreviewOnScrollMaxChange(Sender: TObject; Orientation: TfrxScrollerOrientation; Value: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  frxReport.Preview := frxPreview;
  frxReport.PrepareReport();
end;

procedure TForm1.HScrollScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  frxPreview.Workspace.HorzPosition := ScrollPos;
end;

procedure TForm1.VScrollScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  frxPreview.Workspace.VertPosition := ScrollPos;
end;

procedure TForm1.frxPreviewOnScrollMaxChange(Sender: TObject; Orientation: TfrxScrollerOrientation; Value: Integer);
begin
  if (Orientation = frsVertical) then
  begin
    if (VScroll <> nil) then //not needed under Lazarus
      VScroll.Max := Value;
  end
  else
    if (HScroll <> nil) then //not needed under Lazarus
      HScroll.Max := Value;
end;

procedure TForm1.frxPreviewOnScrollPosChange(Sender: TObject; Orientation: TfrxScrollerOrientation; var Value: Integer);
begin
  if (Orientation = frsVertical) then
  begin
    if (VScroll <> nil) then //not needed under Lazarus
      VScroll.Position := Value;
  end
  else
    if (HScroll <> nil) then //not needed under Lazarus
      HScroll.Position := Value;
end;

end.
