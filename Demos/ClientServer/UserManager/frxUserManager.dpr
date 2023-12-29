
{******************************************}
{                                          }
{             FastReport v4.0              }
{     FastReport User/Group editor demo    }
{         Copyright (c) 1998-2006          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

program frxUserManager;

uses
  Forms,
  main in 'main.pas' {MainForm},
  UserEditor in 'UserEditor.pas' {EditUserForm},
  GroupEditor in 'GroupEditor.pas' {GroupEditorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
