object TodoForm: TTodoForm
  Left = 0
  Top = 0
  Caption = 'Todo'
  ClientHeight = 328
  ClientWidth = 832
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
  object BtnAddEntry: TButton
    Left = 8
    Top = 8
    Width = 113
    Height = 25
    Caption = 'Add new entry'
    TabOrder = 0
    OnClick = BtnAddEntryClick
  end
  object TodoGrid: TStringGrid
    Left = 0
    Top = 80
    Width = 832
    Height = 248
    Align = alBottom
    ColCount = 7
    Ctl3D = False
    RowCount = 2
    ParentCtl3D = False
    TabOrder = 1
    OnMouseUp = TodoGridMouseUp
    ColWidths = (
      64
      30
      232
      91
      93
      116
      139)
    RowHeights = (
      24
      24)
  end
end
