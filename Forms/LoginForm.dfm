object frLogin: TfrLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Login'
  ClientHeight = 550
  ClientWidth = 800
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  TextHeight = 15
  object TitlePanel: TPanel
    Left = 250
    Top = 75
    Width = 300
    Height = 180
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Title: TLabel
      Left = 49
      Top = 100
      Width = 201
      Height = 40
      Alignment = taCenter
      Caption = 'Media Corner'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Montserrat SemiBold'
      Font.Style = []
      ParentFont = False
    end
    object Subtitle: TLabel
      Left = 49
      Top = 140
      Width = 203
      Height = 16
      Alignment = taCenter
      Caption = 'Your best media activity database'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Montserrat Medium'
      Font.Style = []
      ParentFont = False
    end
  end
  object LoginPanel: TPanel
    Left = 250
    Top = 253
    Width = 300
    Height = 225
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      300
      225)
    object NewAccLabel: TLabel
      Left = 80
      Top = 140
      Width = 132
      Height = 16
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Create a new account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Montserrat'
      Font.Style = []
      ParentFont = False
      OnClick = NewAccLabelClick
      OnMouseEnter = NewAccLabelMouseEnter
      OnMouseLeave = NewAccLabelMouseLeave
    end
    object UsernameEdit: TEdit
      Left = 50
      Top = 25
      Width = 200
      Height = 23
      MaxLength = 25
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextHint = 'Username'
    end
    object PasswordEdit: TEdit
      Left = 50
      Top = 60
      Width = 200
      Height = 23
      MaxLength = 25
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 1
      TextHint = 'Password'
    end
    object LoginButton: TButton
      Left = 90
      Top = 105
      Width = 120
      Height = 25
      Caption = 'Login'
      TabOrder = 2
      OnClick = LoginButtonClick
    end
  end
end
