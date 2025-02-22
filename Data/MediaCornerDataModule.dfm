object dmMediaCorner: TdmMediaCorner
  Height = 480
  Width = 640
  object ibdbMediaCorner: TIBDatabase
    Connected = True
    DatabaseName = 'D:\Private\projekty\MediaCornerDelphi\Data\MEDIACORNERDB.GDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1250')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 48
    Top = 24
  end
  object itMediaCorner: TIBTransaction
    Active = True
    DefaultDatabase = ibdbMediaCorner
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 48
    Top = 112
  end
  object ibdsUsers: TIBDataSet
    Database = ibdbMediaCorner
    Transaction = itMediaCorner
    BufferChunks = 1000
    CachedUpdates = True
    DeleteSQL.Strings = (
      'delete from MC_USERS'
      'where'
      '  MCU_ID = :OLD_MCU_ID')
    InsertSQL.Strings = (
      'insert into MC_USERS'
      '  (MCU_ID, MCU_NAME, MCU_PASS)'
      'values'
      '  (:MCU_ID, :MCU_NAME, :MCU_PASS)')
    RefreshSQL.Strings = (
      'Select '
      '  MCU_ID,'
      '  MCU_NAME,'
      '  MCU_PASS'
      'from MC_USERS '
      'where'
      '  MCU_ID = :MCU_ID')
    SelectSQL.Strings = (
      'select * from MC_USERS')
    ModifySQL.Strings = (
      'update MC_USERS'
      'set'
      '  MCU_ID = :MCU_ID,'
      '  MCU_NAME = :MCU_NAME,'
      '  MCU_PASS = :MCU_PASS'
      'where'
      '  MCU_ID = :OLD_MCU_ID')
    ParamCheck = True
    UniDirectional = False
    GeneratorField.Field = 'MCU_ID'
    GeneratorField.Generator = 'GEN_MC_USERS_ID'
    GeneratorField.ApplyEvent = gamOnPost
    Left = 200
    Top = 24
    object ibdsUsersMCU_ID: TIntegerField
      FieldName = 'MCU_ID'
      Origin = 'MC_USERS.MCU_ID'
      Required = True
    end
    object ibdsUsersMCU_NAME: TIBStringField
      FieldName = 'MCU_NAME'
      Origin = 'MC_USERS.MCU_NAME'
      Required = True
      FixedChar = True
      Size = 16
    end
    object ibdsUsersMCU_PASS: TIBStringField
      FieldName = 'MCU_PASS'
      Origin = 'MC_USERS.MCU_PASS'
      Required = True
      FixedChar = True
      Size = 16
    end
  end
  object dsUsers: TDataSource
    AutoEdit = False
    DataSet = ibdsUsers
    Left = 200
    Top = 88
  end
  object IBSQL: TIBSQL
    Database = ibdbMediaCorner
    Transaction = itMediaCorner
    Left = 48
    Top = 184
  end
  object ibdsFriends: TIBDataSet
    Database = ibdbMediaCorner
    Transaction = itMediaCorner
    BufferChunks = 1000
    CachedUpdates = True
    DeleteSQL.Strings = (
      'delete from MC_FRIENDS'
      'where'
      '  MCF_USER = :OLD_MCF_USER and'
      '  MCF_FRIEND = :OLD_MCF_FRIEND')
    InsertSQL.Strings = (
      'insert into MC_FRIENDS'
      '  (MCF_ID, MCF_USER, MCF_FRIEND, CREATED_AT)'
      'values'
      '  (:MCF_ID, :MCF_USER, :MCF_FRIEND, :CREATED_AT)')
    RefreshSQL.Strings = (
      'Select '
      '  MCF_ID,'
      '  MCF_USER,'
      '  MCF_FRIEND,'
      '  CREATED_AT'
      'from MC_FRIENDS '
      'where'
      '  MCF_ID = :MCF_ID and'
      '  MCF_USER = :MCF_USER and'
      '  MCF_FRIEND = :MCF_FRIEND and'
      '  CREATED_AT = :CREATED_AT')
    SelectSQL.Strings = (
      'select * from MC_FRIENDS')
    ModifySQL.Strings = (
      'update MC_FRIENDS'
      'set'
      '  MCF_ID = :MCF_ID,'
      '  MCF_USER = :MCF_USER,'
      '  MCF_FRIEND = :MCF_FRIEND,'
      '  CREATED_AT = :CREATED_AT'
      'where'
      '  MCF_ID = :OLD_MCF_ID and'
      '  MCF_USER = :OLD_MCF_USER and'
      '  MCF_FRIEND = :OLD_MCF_FRIEND and'
      '  CREATED_AT = :OLD_CREATED_AT')
    ParamCheck = True
    UniDirectional = False
    GeneratorField.Field = 'MCF_ID'
    GeneratorField.Generator = 'GEN_MC_FRIENDS_ID'
    GeneratorField.ApplyEvent = gamOnPost
    Left = 272
    Top = 24
    object ibdsFriendsMCF_ID: TIntegerField
      FieldName = 'MCF_ID'
      Origin = 'MC_FRIENDS.MCF_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibdsFriendsMCF_USER: TIntegerField
      FieldName = 'MCF_USER'
      Origin = 'MC_FRIENDS.MCF_USER'
      Required = True
    end
    object ibdsFriendsMCF_FRIEND: TIntegerField
      FieldName = 'MCF_FRIEND'
      Origin = 'MC_FRIENDS.MCF_FRIEND'
      Required = True
    end
    object ibdsFriendsCREATED_AT: TDateTimeField
      FieldName = 'CREATED_AT'
      Origin = 'MC_FRIENDS.CREATED_AT'
    end
  end
  object dsFriends: TDataSource
    AutoEdit = False
    DataSet = ibdsFriendsTest
    Left = 272
    Top = 88
  end
  object IBQusers: TIBQuery
    Database = ibdbMediaCorner
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 200
    Top = 168
  end
  object dsqUsers: TDataSource
    DataSet = IBQusers
    Left = 200
    Top = 224
  end
  object ibdsWatchlist: TIBDataSet
    Database = ibdbMediaCorner
    Transaction = itMediaCorner
    BufferChunks = 1000
    CachedUpdates = True
    DeleteSQL.Strings = (
      'delete from MC_WATCHLIST'
      'where'
      '  MCW_USER = :OLD_MCW_USER and'
      '  MCW_MOVIE_TITLE = :OLD_MCW_MOVIE_TITLE')
    InsertSQL.Strings = (
      'insert into MC_WATCHLIST'
      '  (MCW_ID, MCW_USER, MCW_MOVIE_ID, MCW_MOVIE_TITLE)'
      'values'
      '  (:MCW_ID, :MCW_USER, :MCW_MOVIE_ID, :MCW_MOVIE_TITLE)')
    RefreshSQL.Strings = (
      'Select '
      '  MCW_ID,'
      '  MCW_USER,'
      '  MCW_MOVIE_ID,'
      '  MCW_MOVIE_TITLE,'
      '  MCW_CREATED_AT'
      'from MC_WATCHLIST '
      'where'
      '  MCW_ID = :MCW_ID and'
      '  MCW_USER = :MCW_USER and'
      '  MCW_MOVIE_ID = :MCW_MOVIE_ID and'
      '  MCW_MOVIE_TITLE = :MCW_MOVIE_TITLE and'
      '  MCW_CREATED_AT = :MCW_CREATED_AT')
    SelectSQL.Strings = (
      'select * from MC_WATCHLIST')
    ModifySQL.Strings = (
      'update MC_WATCHLIST'
      'set'
      '  MCW_ID = :MCW_ID,'
      '  MCW_USER = :MCW_USER,'
      '  MCW_MOVIE_ID = :MCW_MOVIE_ID,'
      '  MCW_MOVIE_TITLE = :MCW_MOVIE_TITLE,'
      '  MCW_CREATED_AT = :MCW_CREATED_AT'
      'where'
      '  MCW_ID = :OLD_MCW_ID and'
      '  MCW_USER = :OLD_MCW_USER and'
      '  MCW_MOVIE_ID = :OLD_MCW_MOVIE_ID and'
      '  MCW_MOVIE_TITLE = :OLD_MCW_MOVIE_TITLE and'
      '  MCW_CREATED_AT = :OLD_MCW_CREATED_AT')
    ParamCheck = True
    UniDirectional = False
    GeneratorField.Field = 'MCW_ID'
    GeneratorField.Generator = 'GEN_MC_WATCHLIST_ID'
    GeneratorField.ApplyEvent = gamOnPost
    Left = 344
    Top = 24
    object ibdsWatchlistMCW_ID: TIntegerField
      FieldName = 'MCW_ID'
      Origin = 'MC_WATCHLIST.MCW_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibdsWatchlistMCW_USER: TIntegerField
      FieldName = 'MCW_USER'
      Origin = 'MC_WATCHLIST.MCW_USER'
      Required = True
    end
    object ibdsWatchlistMCW_MOVIE_ID: TIntegerField
      FieldName = 'MCW_MOVIE_ID'
      Origin = 'MC_WATCHLIST.MCW_MOVIE_ID'
      Required = True
    end
    object ibdsWatchlistMCW_MOVIE_TITLE: TIBStringField
      FieldName = 'MCW_MOVIE_TITLE'
      Origin = 'MC_WATCHLIST.MCW_MOVIE_TITLE'
      Required = True
      Size = 255
    end
  end
  object dsWatchlist: TDataSource
    AutoEdit = False
    DataSet = ibdsWatchlist
    Left = 344
    Top = 88
  end
  object IBQwatchlist: TIBQuery
    Database = ibdbMediaCorner
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 272
    Top = 168
  end
  object ibdsFriendsTest: TIBDataSet
    Database = ibdbMediaCorner
    Transaction = itMediaCorner
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = False
    Left = 432
    Top = 24
  end
  object IBQFriends: TIBQuery
    Database = ibdbMediaCorner
    Transaction = itMediaCorner
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 344
    Top = 168
  end
end
