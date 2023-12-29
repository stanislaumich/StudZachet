
{******************************************}
{                                          }
{             FastReport v4.0              }
{     FastReport User/Group editor demo    }
{         Copyright (c) 1998-2007          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit GroupEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TGroupEditorForm = class(TForm)
    Panel1: TPanel;
    UserEditForm: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EFullName: TEdit;
    ELogin: TEdit;
    CBActive: TCheckBox;
    EIndex: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GroupEditorForm: TGroupEditorForm;

implementation

{$R *.dfm}

end.
