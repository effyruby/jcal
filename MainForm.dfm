object frmMain: TfrmMain
  Left = 47
  Top = 115
  BorderStyle = bsDialog
  Caption = 'frmMain'
  ClientHeight = 494
  ClientWidth = 1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 17
    Width = 62
    Height = 13
    Caption = 'Hebrew Year'
  end
  object Label2: TLabel
    Left = 176
    Top = 17
    Width = 75
    Height = 13
    Caption = 'Year Code Filter'
  end
  object edtHebYear: TEdit
    Left = 20
    Top = 33
    Width = 70
    Height = 27
    BiDiMode = bdLeftToRight
    Font.Charset = HEBREW_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    NumbersOnly = True
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
    Text = '0'
  end
  object Button2: TButton
    Left = 413
    Top = 47
    Width = 106
    Height = 25
    Caption = 'Molads this Yesr'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 415
    Top = 78
    Width = 106
    Height = 25
    Caption = 'New Year'
    TabOrder = 2
    OnClick = Button3Click
  end
  object edtYearCode: TEdit
    Left = 108
    Top = 33
    Width = 53
    Height = 27
    BiDiMode = bdRightToLeft
    Color = clSilver
    Font.Charset = HEBREW_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 3
    Text = '#1498'
    StyleElements = [seFont, seBorder]
  end
  object Button5: TButton
    Left = 417
    Top = 242
    Width = 106
    Height = 25
    Caption = 'Go back X years'
    Enabled = False
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 417
    Top = 273
    Width = 106
    Height = 25
    Caption = 'Go forwad  X years'
    Enabled = False
    TabOrder = 5
    OnClick = Button6Click
  end
  object seNoOfYears: TSpinEdit
    Left = 498
    Top = 168
    Width = 43
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 25
  end
  object TntPageControl1: TTntPageControl
    Left = 550
    Top = 17
    Width = 473
    Height = 420
    ActivePage = TntTabSheet2
    TabOrder = 7
    object TntTabSheet1: TTntTabSheet
      Caption = 'TntTabSheet1'
    end
    object TntTabSheet2: TTntTabSheet
      Caption = 'TntTabSheet2'
      object ListView1: TListView
        Left = 6
        Top = 20
        Width = 215
        Height = 359
        Columns = <
          item
          end
          item
            Width = 80
          end
          item
            Width = 80
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object ListView2: TListView
        Left = 230
        Top = 20
        Width = 220
        Height = 245
        Columns = <
          item
          end
          item
            Width = 80
          end
          item
            Width = 80
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
      end
      object ListView3: TListView
        Left = 230
        Top = 273
        Width = 220
        Height = 106
        Columns = <
          item
          end
          item
            Width = 80
          end
          item
            Width = 80
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
      end
    end
    object tsLogging: TTntTabSheet
      Caption = 'tsLogging'
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 465
        Height = 392
        Align = alClient
        Lines.Strings = (
          'Memo2')
        TabOrder = 0
      end
    end
  end
  object Button7: TButton
    Left = 417
    Top = 110
    Width = 106
    Height = 25
    Caption = 'Tekufah'
    TabOrder = 8
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 417
    Top = 166
    Width = 76
    Height = 25
    Caption = 'Next N Years'
    TabOrder = 9
    OnClick = Button8Click
  end
  object lvGeneral: TListView
    Left = 8
    Top = 66
    Width = 396
    Height = 420
    Columns = <
      item
        Width = 90
      end
      item
        Width = 80
      end
      item
        Width = 100
      end
      item
        Width = 80
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 10
    ViewStyle = vsReport
  end
  object Button4: TButton
    Left = 550
    Top = 461
    Width = 469
    Height = 25
    Caption = 'Calculate frequency of 14 types of year (over 6000 years)'
    TabOrder = 11
    OnClick = Button4Click
  end
  object pb: TProgressBar
    Left = 550
    Top = 440
    Width = 469
    Height = 17
    Max = 6000
    Step = 1
    TabOrder = 12
  end
  object cboYCFilter: TComboBox
    Left = 176
    Top = 39
    Width = 73
    Height = 21
    DropDownCount = 25
    TabOrder = 13
    Text = 'cboYCFilter'
  end
  object chkExcludeYC: TCheckBox
    Left = 279
    Top = 39
    Width = 84
    Height = 17
    Caption = 'Exclude Code'
    TabOrder = 14
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ConnectionDef=SQKite_JCal')
    Left = 32
    Top = 120
  end
end
