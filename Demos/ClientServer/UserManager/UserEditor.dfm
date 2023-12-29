object EditUserForm: TEditUserForm
  Left = 311
  Top = 198
  BorderStyle = bsDialog
  Caption = 'Edit'
  ClientHeight = 310
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 269
    Width = 521
    Height = 41
    BevelOuter = bvNone
    TabOrder = 0
    object UserEditForm: TButton
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 436
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 4
    Top = 4
    Width = 513
    Height = 261
    TabOrder = 1
    object Label1: TLabel
      Left = 12
      Top = 12
      Width = 77
      Height = 13
      AutoSize = False
      Caption = 'Full name'
    end
    object Label2: TLabel
      Left = 12
      Top = 36
      Width = 77
      Height = 13
      AutoSize = False
      Caption = 'Login'
    end
    object Label3: TLabel
      Left = 252
      Top = 36
      Width = 77
      Height = 13
      AutoSize = False
      Caption = 'Password'
    end
    object Label4: TLabel
      Left = 12
      Top = 60
      Width = 77
      Height = 13
      AutoSize = False
      Caption = 'E-mail'
    end
    object Label5: TLabel
      Left = 300
      Top = 108
      Width = 181
      Height = 13
      AutoSize = False
      Caption = 'Member of groups'
    end
    object Label7: TLabel
      Left = 12
      Top = 108
      Width = 153
      Height = 13
      AutoSize = False
      Caption = 'Available groups'
    end
    object EFullName: TEdit
      Left = 92
      Top = 8
      Width = 409
      Height = 21
      TabOrder = 0
    end
    object CBActive: TCheckBox
      Left = 92
      Top = 82
      Width = 153
      Height = 17
      Caption = 'Enabled'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object ELogin: TEdit
      Left = 92
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 2
    end
    object EPassword: TEdit
      Left = 348
      Top = 32
      Width = 153
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object EEmail: TEdit
      Left = 92
      Top = 56
      Width = 409
      Height = 21
      TabOrder = 4
    end
    object MemberBox: TListBox
      Left = 288
      Top = 128
      Width = 212
      Height = 117
      DragMode = dmAutomatic
      ItemHeight = 13
      Sorted = True
      TabOrder = 5
      OnDragDrop = MemberBoxDragDrop
      OnDragOver = MemberBoxDragOver
    end
    object AvailBox: TListBox
      Left = 12
      Top = 128
      Width = 217
      Height = 117
      DragMode = dmAutomatic
      ItemHeight = 13
      Sorted = True
      TabOrder = 6
      OnDragOver = AvailBoxDragOver
    end
    object LeftBtn: TButton
      Left = 240
      Top = 156
      Width = 37
      Height = 25
      Caption = '>'
      TabOrder = 7
      OnClick = LeftBtnClick
    end
    object RightBtn: TButton
      Left = 240
      Top = 192
      Width = 37
      Height = 25
      Caption = '<'
      TabOrder = 8
      OnClick = RightBtnClick
    end
  end
end
