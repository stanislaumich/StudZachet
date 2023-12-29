
{******************************************}
{                                          }
{             FastReport v4.0              }
{     FastReport User/Group editor demo    }
{         Copyright (c) 1998-2007          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit UserEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TEditUserForm = class(TForm)
    Panel1: TPanel;
    UserEditForm: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    EFullName: TEdit;
    CBActive: TCheckBox;
    ELogin: TEdit;
    EPassword: TEdit;
    EEmail: TEdit;
    MemberBox: TListBox;
    AvailBox: TListBox;
    LeftBtn: TButton;
    RightBtn: TButton;
    procedure MemberBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AvailBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure MemberBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LeftBtnClick(Sender: TObject);
    procedure RightBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditUserForm: TEditUserForm;

implementation

{$R *.dfm}

procedure TEditUserForm.MemberBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = AvailBox;
end;

procedure TEditUserForm.AvailBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = MemberBox;
end;

procedure TEditUserForm.MemberBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  s: String;
  i: Integer;
begin
  i := (Source as TListBox).ItemIndex;
  s := (Source as TListBox).Items[i];
  (Sender as TListBox).Items.Add(s);
  (Source as TListBox).Items.Delete(i);
end;

procedure TEditUserForm.LeftBtnClick(Sender: TObject);
var
  i: Integer;
begin
  i := AvailBox.ItemIndex;
  if i <> -1 then
  begin
    MemberBox.Items.Add(AvailBox.Items[i]);
    AvailBox.Items.Delete(i);
  end;
end;

procedure TEditUserForm.RightBtnClick(Sender: TObject);
var
  i: Integer;
begin
  i := AvailBox.ItemIndex;
  if i <> -1 then
  begin
    MemberBox.Items.Add(AvailBox.Items[i]);
    AvailBox.Items.Delete(i);
  end;
end;

end.
