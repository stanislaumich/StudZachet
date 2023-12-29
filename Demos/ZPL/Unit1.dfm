object Form1: TForm1
  Left = 0
  Top = 0
  Width = 696
  Height = 629
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LSelect_Printer: TLabel
    Left = 57
    Top = 544
    Width = 64
    Height = 13
    Caption = 'Select Printer'
  end
  object Printers: TComboBox
    Left = 152
    Top = 541
    Width = 273
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'Printers'
  end
  object ShowZPL: TButton
    Left = 431
    Top = 530
    Width = 106
    Height = 44
    Caption = 'Show ZPL'
    TabOrder = 1
    OnClick = ShowZPLClick
  end
  object Print: TButton
    Left = 543
    Top = 530
    Width = 106
    Height = 44
    Caption = 'Print'
    TabOrder = 2
    OnClick = PrintClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 643
    Height = 505
    ActivePage = Reports
    TabOrder = 3
    object Reports: TTabSheet
      Caption = 'Reports'
      object LRepName: TLabel
        Left = 140
        Top = 21
        Width = 51
        Height = 13
        Caption = 'LRepName'
        Visible = False
      end
      object DesignR: TButton
        Left = 24
        Top = 56
        Width = 92
        Height = 25
        Caption = 'Design Report'
        Enabled = False
        TabOrder = 0
        OnClick = DesignRClick
      end
      object SelectR: TButton
        Left = 24
        Top = 16
        Width = 92
        Height = 25
        Caption = 'Select Report'
        TabOrder = 1
        OnClick = SelectRClick
      end
      object ShowR: TButton
        Left = 24
        Top = 96
        Width = 92
        Height = 25
        Caption = 'Show Report'
        Enabled = False
        TabOrder = 2
        OnClick = ShowRClick
      end
      object ZPS: TGroupBox
        Left = 24
        Top = 140
        Width = 593
        Height = 289
        Caption = 'Zebra Printer Setting'
        TabOrder = 3
        object LDensity: TLabel
          Left = 56
          Top = 48
          Width = 36
          Height = 13
          Caption = 'Density'
        end
        object LPrinter_Init: TLabel
          Left = 57
          Top = 78
          Width = 51
          Height = 13
          Caption = 'Printer Init'
        end
        object LPrinter_Finish: TLabel
          Left = 56
          Top = 138
          Width = 62
          Height = 13
          Caption = 'Printer Finish'
        end
        object LPage_Init: TLabel
          Left = 56
          Top = 168
          Width = 43
          Height = 13
          Caption = 'Page Init'
        end
        object LFont_Scale: TLabel
          Left = 57
          Top = 198
          Width = 50
          Height = 13
          Caption = 'Font Scale'
        end
        object LFont: TLabel
          Left = 57
          Top = 228
          Width = 22
          Height = 13
          Caption = 'Font'
        end
        object LCode_Page: TLabel
          Left = 56
          Top = 108
          Width = 52
          Height = 13
          Caption = 'Code Page'
        end
        object Density: TComboBox
          Left = 216
          Top = 45
          Width = 145
          Height = 21
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 0
          Text = '8 dpmm(203 dpi)'
          Items.Strings = (
            '6 dpmm(152 dpi)'
            '8 dpmm(203 dpi)'
            '12 dpmm(300 dpi)'
            '24 dpmm(600 dpi)')
        end
        object PrinterInit: TEdit
          Left = 216
          Top = 75
          Width = 345
          Height = 21
          TabOrder = 1
        end
        object CodePage: TEdit
          Left = 216
          Top = 105
          Width = 345
          Height = 21
          TabOrder = 2
          Text = '^CI28'
        end
        object PrinterFinish: TEdit
          Left = 216
          Top = 135
          Width = 345
          Height = 21
          TabOrder = 3
        end
        object PageInit: TEdit
          Left = 216
          Top = 165
          Width = 345
          Height = 21
          TabOrder = 4
        end
        object FontScale: TEdit
          Left = 216
          Top = 195
          Width = 345
          Height = 21
          TabOrder = 5
        end
        object Font: TEdit
          Left = 216
          Top = 225
          Width = 345
          Height = 21
          TabOrder = 6
        end
        object PrintAB: TCheckBox
          Left = 216
          Top = 255
          Width = 97
          Height = 17
          Caption = 'Print As Bitmap'
          Checked = True
          State = cbChecked
          TabOrder = 7
        end
      end
    end
    object ZPL_text: TTabSheet
      Caption = 'ZPL text'
      ImageIndex = 1
      object Memo1: TMemo
        Left = 0
        Top = 3
        Width = 632
        Height = 438
        TabOrder = 0
      end
      object LoadFF: TButton
        Left = 496
        Top = 447
        Width = 136
        Height = 25
        Caption = 'Load From File'
        TabOrder = 1
        OnClick = LoadFFClick
      end
    end
  end
end
