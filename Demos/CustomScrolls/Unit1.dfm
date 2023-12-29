object Form1: TForm1
  Left = 192
  Top = 125
  Width = 876
  Height = 588
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object frxPreview: TfrxPreview
    Left = 40
    Top = 32
    Width = 609
    Height = 425
    OutlineVisible = True
    OutlineWidth = 121
    ThumbnailVisible = False
    UseReportHints = True
    HideScrolls = True
    OnScrollMaxChange = frxPreviewOnScrollMaxChange
    OnScrollPosChange = frxPreviewOnScrollPosChange
  end
  object HScroll: TScrollBar
    Left = 152
    Top = 488
    Width = 289
    Height = 17
    PageSize = 0
    TabOrder = 1
    OnScroll = HScrollScroll
  end
  object VScroll: TScrollBar
    Left = 704
    Top = 88
    Width = 17
    Height = 337
    Kind = sbVertical
    PageSize = 0
    TabOrder = 2
    OnScroll = VScrollScroll
  end
  object frxReport: TfrxReport
    Version = '6.5.0'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43821.455890636600000000
    ReportOptions.LastChange = 43821.459842037040000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 792
    Top = 104
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 136.063080000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        RowCount = 30
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Width = 718.110700000000000000
          Height = 136.063080000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -96
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8 = (
            '[time]')
          ParentFont = False
        end
      end
    end
  end
end
