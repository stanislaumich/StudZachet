object FastReport: TFastReport
  OldCreateOrder = False
  DisplayName = 'FastReport'
  Interactive = True
  AfterInstall = ServiceAfterInstall
  OnContinue = ServiceContinue
  OnExecute = ServiceExecute
  OnPause = ServicePause
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 542
  Top = 199
  Height = 379
  Width = 312
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Mode = cmRead
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 32
    Top = 12
  end
  object Serv: TfrxReportServer
    Active = False
    PrintPDF = True
    Print = True
    SocketOpen = True
    ConfigFileName = 'config.xml'
    Left = 124
    Top = 12
  end
  object frxBarCodeObject1: TfrxBarCodeObject
    Left = 36
    Top = 68
  end
  object frxChartObject1: TfrxChartObject
    Left = 128
    Top = 68
  end
  object frxRichObject1: TfrxRichObject
    Left = 32
    Top = 124
  end
  object frxCrossObject1: TfrxCrossObject
    Left = 128
    Top = 124
  end
  object frxCheckBoxObject1: TfrxCheckBoxObject
    Left = 36
    Top = 180
  end
  object frxGradientObject1: TfrxGradientObject
    Left = 132
    Top = 180
  end
  object frxDotMatrixExport1: TfrxDotMatrixExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    EscModel = 0
    GraphicFrames = False
    SaveToFile = False
    UseIniSettings = True
    Left = 36
    Top = 232
  end
  object frxDialogControls1: TfrxDialogControls
    Left = 132
    Top = 232
  end
  object frxGZipCompressor1: TfrxGZipCompressor
    Left = 220
    Top = 12
  end
  object frxADOComponents1: TfrxADOComponents
    DefaultDatabase = ADOConnection
    Left = 220
    Top = 68
  end
end
