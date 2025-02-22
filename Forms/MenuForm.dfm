object frMainMenu: TfrMainMenu
  Left = 0
  Top = 0
  Caption = 'Media Corner'
  ClientHeight = 700
  ClientWidth = 1400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object ViewPanel: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 700
    Align = alLeft
    TabOrder = 0
    object AppTitle: TLabel
      Left = 31
      Top = 37
      Width = 188
      Height = 25
      Alignment = taCenter
      Caption = #62060' MEDIA CORNER'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object HomeButton: TButton
      Left = 25
      Top = 100
      Width = 200
      Height = 50
      Caption = #61461' Home'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = HomeButtonClick
    end
    object WatchlistButton: TButton
      Left = 25
      Top = 160
      Width = 200
      Height = 50
      Caption = #61498' Watchlist'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = WatchlistButtonClick
    end
    object MovieButton: TButton
      Left = 25
      Top = 220
      Width = 200
      Height = 50
      Caption = #61448' Movies'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = MovieButtonClick
    end
    object UsersButton: TButton
      Left = 25
      Top = 280
      Width = 200
      Height = 50
      Caption = #61632' Users'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = UsersButtonClick
    end
    object FriendsButton: TButton
      Left = 25
      Top = 339
      Width = 200
      Height = 50
      Caption = #61447' Friends'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = FriendsButtonClick
    end
    object SettingsButton: TButton
      Left = 25
      Top = 400
      Width = 200
      Height = 50
      Caption = #61459' Settings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = SettingsButtonClick
    end
  end
  object ViewDataPanel: TPanel
    Left = 250
    Top = 0
    Width = 1150
    Height = 700
    Align = alClient
    TabOrder = 1
    object ViewTitle: TLabel
      Left = 45
      Top = 35
      Width = 58
      Height = 20
      Caption = 'ViewTitle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'FontAwesome'
      Font.Style = []
      ParentFont = False
    end
    object DataGridPanel: TPanel
      Left = 25
      Top = 75
      Width = 1100
      Height = 600
      TabOrder = 0
    end
  end
end
