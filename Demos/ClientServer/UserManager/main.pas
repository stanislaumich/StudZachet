
{******************************************}
{                                          }
{             FastReport v4.0              }
{     FastReport User/Group editor demo    }
{         Copyright (c) 1998-2007          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit main;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, frxUsers;


type
  TMainForm = class(TForm)
    Panel1: TPanel;
    NewBtn: TButton;
    EditBtn: TButton;
    DeleteBtn: TButton;
    Panel3: TPanel;
    PageControl: TPageControl;
    UserTab: TTabSheet;
    UserList: TListView;
    Panel2: TPanel;
    Label1: TLabel;
    CBox_Group: TComboBox;
    GroupTab: TTabSheet;
    GroupList: TListView;
    procedure FormDestroy(Sender: TObject);
    procedure CBox_GroupChange(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ServerUsers: TfrxUsers;
    procedure Clear;
    procedure LoadLists;
    procedure LoadUserList(const Group: String);
    procedure LoadGroupList;
    procedure SaveUsers;
  end;

var
  MainForm: TMainForm;

implementation

uses Math, frxServerConfig, UserEditor, GroupEditor
{$IFDEF Delphi7}
,  XPMan
{$ENDIF};

{$R *.dfm}

procedure TMainForm.Clear;
begin
  UserList.Items.Clear;
  GroupList.Items.Clear;
  CBox_Group.Clear;
end;

procedure TMainForm.LoadGroupList;
var
  i: Integer;
  ListItem: TListItem;
  s: String;
begin
  GroupList.Items.BeginUpdate;
  GroupList.Items.Clear;
  for i := 0 to ServerUsers.GroupList.Count - 1 do
  begin
    ListItem := GroupList.Items.Add;
    ListItem.Caption := ServerUsers.GroupList[i];
    ListItem.Data := ServerUsers.GroupList.Objects[i];
    ListItem.SubItems.Add(TfrxUserGroupItem(ServerUsers.GroupList.Objects[i]).FullName);
  end;
  GroupList.Items.EndUpdate;
  s := CBox_Group.Text;
  CBox_Group.Clear;
  CBox_Group.Items.AddObject('All groups', nil);
  for i := 0 to ServerUsers.GroupList.Count - 1 do
    CBox_Group.Items.AddObject(ServerUsers.GroupList[i], ServerUsers.GroupList.Objects[i]);
  if CBox_Group.Items.Count > 0 then
  begin
    i := CBox_Group.Items.IndexOf(s);
    if i = -1 then
      CBox_Group.ItemIndex := 0
    else
      CBox_Group.ItemIndex := i;
  end;
end;

procedure TMainForm.LoadLists;
begin
  LoadUserList(CBox_Group.Text);
  LoadGroupList;
end;

procedure TMainForm.LoadUserList(const Group: String);
var
  i, j: Integer;
  s: String;
  ListItem: TListItem;
begin
  UserList.Items.BeginUpdate;
  UserList.Items.Clear;
  for i := 0 to ServerUsers.UserList.Count - 1 do
  begin
    if (Group = 'All groups') or ServerUsers.MemberOfGroup(ServerUsers.UserList[i], Group) then
    begin
      ListItem := UserList.Items.Add;
      ListItem.Caption := ServerUsers.UserList[i];
      ListItem.Data := ServerUsers.UserList.Objects[i];
      ListItem.SubItems.Add(TfrxUserGroupItem(ServerUsers.UserList.Objects[i]).FullName);
      s := '';
      for j := 0 to TfrxUserGroupItem(ServerUsers.UserList.Objects[i]).Members.Count - 1 do
        s := s + TfrxUserGroupItem(ServerUsers.UserList.Objects[i]).Members[j] + ',';
      if (Length(s) > 0) and (s[Length(s)] = ',') then
        SetLength(s, Length(s) - 1);
      ListItem.SubItems.Add(s);
    end;
  end;
  UserList.Items.EndUpdate;
end;

procedure TMainForm.SaveUsers;
begin
  ServerUsers.SaveToFile('users.xml');
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Clear;
  ServerUsers.Free;
end;

procedure TMainForm.CBox_GroupChange(Sender: TObject);
begin
  LoadUserList(CBox_Group.Text);
end;

procedure TMainForm.EditBtnClick(Sender: TObject);
var
  Item: TfrxUserGroupItem;
  i: Integer;
  FakePass: String;
begin
  if (PageControl.ActivePage = UserTab) and (UserList.Items.Count > 0)
    and (UserList.Selected <> nil) then
  begin
    EditUserForm := TEditUserForm.Create(Self);
    try
      Item := TfrxUserGroupItem(UserList.Selected.Data);
      EditUserForm.ELogin.Text := Item.Name;
      EditUserForm.ELogin.Enabled := False;
      EditUserForm.EFullName.Text := Item.FullName;
      EditUserForm.EEmail.Text := Item.Email;
      EditUserForm.CBActive.Checked := Item.Active;
      FakePass := '---------';
      EditUserForm.EPassword.Text := FakePass;
      for i := 0 to Item.Members.Count - 1 do
        EditUserForm.MemberBox.Items.Add(Item.Members[i]);
      for i := 0 to ServerUsers.GroupList.Count - 1 do
        if Item.Members.IndexOf(ServerUsers.GroupList[i]) = -1 then
          EditUserForm.AvailBox.Items.Add(ServerUsers.GroupList[i]);
      if EditUserForm.ShowModal = mrOk then
      begin
        if EditUserForm.EPassword.Text <> FakePass then
          ServerUsers.ChPasswd(Item.Name, EditUserForm.EPassword.Text);
        Item.Active := EditUserForm.CBActive.Checked;
        Item.FullName := EditUserForm.EFullName.Text;
        Item.Email := EditUserForm.EEmail.Text;

        for i := 0 to EditUserForm.AvailBox.Items.Count - 1 do
        begin
          ServerUsers.RemoveGroupFromUser(EditUserForm.AvailBox.Items[i], Item.Name);
          ServerUsers.RemoveUserFromGroup(Item.Name, EditUserForm.AvailBox.Items[i]);
        end;
        for i := 0 to EditUserForm.MemberBox.Items.Count - 1 do
          ServerUsers.AddUserToGroup(Item.Name, EditUserForm.MemberBox.Items[i]);
        SaveUsers;
        LoadLists;
      end;
    finally
      EditUserForm.Free;
    end;
  end else
  if (PageControl.ActivePage = GroupTab) and (GroupList.Items.Count > 0)
    and (GroupList.Selected <> nil) then
  begin
    GroupEditorForm := TGroupEditorForm.Create(Self);
    try
      Item := TfrxUserGroupItem(GroupList.Selected.Data);
      GroupEditorForm.ELogin.Text := Item.Name;
      GroupEditorForm.ELogin.Enabled := False;
      GroupEditorForm.EFullName.Text := Item.FullName;
      GroupEditorForm.CBActive.Checked := Item.Active;
      GroupEditorForm.EIndex.Text := Item.IndexFile;
      if GroupEditorForm.ShowModal = mrOk then
      begin
        Item.Active := GroupEditorForm.CBActive.Checked;
        Item.FullName := GroupEditorForm.EFullName.Text;
        Item.IndexFile := GroupEditorForm.EIndex.Text;
        SaveUsers;
        LoadLists;
      end;
    finally
      GroupEditorForm.Free;
    end;
  end;
end;

procedure TMainForm.NewBtnClick(Sender: TObject);
var
  Item: TfrxUserGroupItem;
  i: Integer;
begin
  if (PageControl.ActivePage = UserTab) then
  begin
    EditUserForm := TEditUserForm.Create(Self);
    try
      for i := 0 to ServerUsers.GroupList.Count - 1 do
        EditUserForm.AvailBox.Items.Add(ServerUsers.GroupList[i]);
      if EditUserForm.ShowModal = mrOk then
      begin
        Item := ServerUsers.AddUser(EditUserForm.ELogin.Text);
        if Item <> nil then
        begin
          ServerUsers.ChPasswd(Item.Name, EditUserForm.EPassword.Text);
          Item.Active := EditUserForm.CBActive.Checked;
          Item.FullName := EditUserForm.EFullName.Text;
          Item.Email := EditUserForm.EEmail.Text;
          for i := 0 to EditUserForm.MemberBox.Items.Count - 1 do
            ServerUsers.AddUserToGroup(Item.Name, EditUserForm.MemberBox.Items[i]);
          SaveUsers;
          LoadLists;
        end else
          MessageDlg('User name already exists!', mtError, [mbOk], 0);
      end;
    finally
      EditUserForm.Free;
    end;
  end else
  if PageControl.ActivePage = GroupTab then
  begin
    GroupEditorForm := TGroupEditorForm.Create(Self);
    try
      if GroupEditorForm.ShowModal = mrOk then
      begin
        Item := ServerUsers.AddGroup(GroupEditorForm.ELogin.Text);
        if Item <> nil then
        begin
          Item.Active := GroupEditorForm.CBActive.Checked;
          Item.FullName := GroupEditorForm.EFullName.Text;
          SaveUsers;
          LoadLists;
        end else
          MessageDlg('Group name already exists!', mtError, [mbOk], 0);
      end;
    finally
      GroupEditorForm.Free;
    end;
  end;
end;

procedure TMainForm.DeleteBtnClick(Sender: TObject);
var
  s: String;
begin
  if (PageControl.ActivePage = UserTab) and (UserList.Items.Count > 0)
    and (UserList.Selected <> nil) then
  begin
    s := TfrxUserGroupItem(UserList.Selected.Data).Name;
    if MessageDlg('Delete user "' + s + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ServerUsers.DeleteUser(s);
      SaveUsers;
      LoadLists;
    end;
  end else
  if (PageControl.ActivePage = GroupTab) and (GroupList.Items.Count > 0)
    and (GroupList.Selected <> nil) then
  begin
    s := TfrxUserGroupItem(GroupList.Selected.Data).Name;
    if MessageDlg('Delete group "' + s + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ServerUsers.DeleteGroup(s);
      SaveUsers;
      LoadLists;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ServerUsers := TfrxUsers.Create;
  ServerUsers.LoadFromFile('users.xml');
  LoadLists;
end;

end.
