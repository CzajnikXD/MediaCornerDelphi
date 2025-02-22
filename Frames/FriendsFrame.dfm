object Friends: TFriends
  Left = 0
  Top = 0
  Width = 1100
  Height = 600
  Color = clMediumpurple
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Montserrat Medium'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  OnResize = FrameCreate
  object DBFriendsGrid: TDBGrid
    Left = 80
    Top = 80
    Width = 940
    Height = 480
    DataSource = dmMediaCorner.dsFriends
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Montserrat Medium'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Montserrat Medium'
    TitleFont.Style = []
    OnCellClick = DBFriendsGridCellClick
    OnDrawColumnCell = DBFriendsGridDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'FRIEND_NAME'
        ReadOnly = True
        Title.Caption = 'USERNAME'
        Width = 450
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RemoveUser'
        ReadOnly = True
        Title.Caption = 'REMOVE USER FROM FRIENDSLIST'
        Width = 450
        Visible = True
      end>
  end
  object UserSearchBox: TSearchBox
    Left = 80
    Top = 30
    Width = 300
    Height = 35
    TabOrder = 1
    TextHint = 'Search a user'
  end
end
