object AddTodoEntryForm: TAddTodoEntryForm
  Left = 0
  Top = 0
  Caption = 'Add Entry'
  ClientHeight = 239
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object EditPriority: TLabeledEdit
    Left = 8
    Top = 32
    Width = 33
    Height = 21
    EditLabel.Width = 34
    EditLabel.Height = 13
    EditLabel.Caption = 'Priority'
    MaxLength = 1
    TabOrder = 0
    OnKeyPress = EditPriorityKeyPress
  end
  object EditContent: TLabeledEdit
    Left = 56
    Top = 32
    Width = 353
    Height = 21
    EditLabel.Width = 39
    EditLabel.Height = 13
    EditLabel.Caption = 'Content'
    TabOrder = 1
  end
  object EditDateCreate: TLabeledEdit
    Left = 288
    Top = 72
    Width = 121
    Height = 21
    EditLabel.Width = 56
    EditLabel.Height = 13
    EditLabel.Caption = 'DateCreate'
    TabOrder = 2
  end
  object EditAddContext: TLabeledEdit
    Left = 8
    Top = 72
    Width = 121
    Height = 21
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'Add Context'
    TabOrder = 3
    OnKeyPress = EditAddContextKeyPress
  end
  object ListContexts: TListBox
    Left = 8
    Top = 99
    Width = 121
    Height = 118
    ItemHeight = 13
    TabOrder = 4
  end
  object EditAddProject: TLabeledEdit
    Left = 145
    Top = 72
    Width = 121
    Height = 21
    EditLabel.Width = 56
    EditLabel.Height = 13
    EditLabel.Caption = 'Add Project'
    TabOrder = 5
    OnKeyPress = EditAddProjectKeyPress
  end
  object ListProjects: TListBox
    Left = 144
    Top = 99
    Width = 122
    Height = 118
    ItemHeight = 13
    TabOrder = 6
  end
  object BtnAddEntry: TButton
    Left = 334
    Top = 161
    Width = 75
    Height = 25
    Caption = 'Add entry'
    TabOrder = 7
    OnClick = BtnAddEntryClick
  end
  object btnSaveEntry: TButton
    Left = 334
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Save Entry'
    Enabled = False
    TabOrder = 8
    OnClick = btnSaveEntryClick
  end
end
