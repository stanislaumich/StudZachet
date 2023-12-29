object MainForm: TMainForm
  Left = 306
  Top = 257
  Width = 455
  Height = 359
  Caption = 'FastReport Server Users manager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 277
    Width = 447
    Height = 55
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object NewBtn: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'New'
      TabOrder = 0
      OnClick = NewBtnClick
    end
    object EditBtn: TButton
      Left = 108
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 1
      OnClick = EditBtnClick
    end
    object DeleteBtn: TButton
      Left = 197
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = DeleteBtnClick
    end
    object Panel3: TPanel
      Left = 352
      Top = 0
      Width = 95
      Height = 55
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 3
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 447
    Height = 277
    ActivePage = UserTab
    Align = alClient
    TabOrder = 1
    object UserTab: TTabSheet
      Caption = 'Users'
      object UserList: TListView
        Left = 0
        Top = 33
        Width = 439
        Height = 216
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'User name'
          end
          item
            AutoSize = True
            Caption = 'Full name'
          end
          item
            Caption = 'Group'
            Width = 95
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 439
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 10
          Width = 77
          Height = 13
          AutoSize = False
          Caption = 'Group name'
        end
        object CBox_Group: TComboBox
          Left = 89
          Top = 6
          Width = 284
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'All groups'
          OnChange = CBox_GroupChange
        end
      end
    end
    object GroupTab: TTabSheet
      Caption = 'Groups'
      ImageIndex = 1
      object GroupList: TListView
        Left = 0
        Top = 0
        Width = 439
        Height = 249
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'Group name'
          end
          item
            AutoSize = True
            Caption = 'Full name'
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
end
