object Movies: TMovies
  Left = 0
  Top = 0
  Width = 1100
  Height = 600
  Color = clAqua
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  OnResize = FrameCreate
  object DBMoviesGrid: TDBGrid
    Left = 80
    Top = 80
    Width = 940
    Height = 480
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
    OnCellClick = DBMoviesGridCellClick
    OnDrawColumnCell = DBMoviesGridDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'title'
        ReadOnly = True
        Title.Caption = 'TITLE'
        Width = 400
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'release_date'
        ReadOnly = True
        Title.Caption = 'RELEASE DATE'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADD MOVIE TO WATCHLIST'
        ReadOnly = True
        Width = 300
        Visible = True
      end>
  end
  object MovieSearchBox: TSearchBox
    Left = 80
    Top = 30
    Width = 300
    Height = 36
    TabOrder = 1
    TextHint = 'Search a movie'
  end
end
