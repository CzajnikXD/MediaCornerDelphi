unit MediaCornerDataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, IBX.IBDatabase,
  IBX.IBCustomDataSet, Winapi.Windows, Winapi.Messages, VCL.Dialogs, IBX.IBSQL,
  IBX.IBQuery;

type
  TdmMediaCorner = class(TDataModule)
    ibdbMediaCorner: TIBDatabase;
    itMediaCorner: TIBTransaction;
    ibdsUsers: TIBDataSet;
    ibdsUsersMCU_ID: TIntegerField;
    ibdsUsersMCU_NAME: TIBStringField;
    ibdsUsersMCU_PASS: TIBStringField;
    dsUsers: TDataSource;
    IBSQL: TIBSQL;
    ibdsFriends: TIBDataSet;
    dsFriends: TDataSource;
    ibdsFriendsMCF_USER: TIntegerField;
    ibdsFriendsMCF_FRIEND: TIntegerField;
    ibdsFriendsCREATED_AT: TDateTimeField;
    IBQusers: TIBQuery;
    dsqUsers: TDataSource;
    ibdsWatchlist: TIBDataSet;
    ibdsWatchlistMCW_ID: TIntegerField;
    ibdsWatchlistMCW_USER: TIntegerField;
    ibdsWatchlistMCW_MOVIE_ID: TIntegerField;
    ibdsWatchlistMCW_MOVIE_TITLE: TIBStringField;
    dsWatchlist: TDataSource;
    IBQwatchlist: TIBQuery;
    ibdsFriendsMCF_ID: TIntegerField;
    ibdsFriendsTest: TIBDataSet;
    IBQFriends: TIBQuery;
  private
    { Private declarations }
    FCurrentUserID: Integer;
    FCurrentUsername: string;
  public
    { Public declarations }
    property CurrentUserID: Integer read FCurrentUserID;
    property CurrentUsername: string read FCurrentUsername;

    procedure InitDB();
    function ValidateUser(const Username, Password: string): Boolean;
    function CreateUser(const Username, Password: string): Boolean;
    function CreateUser2(const Username, Password: string): Boolean;
    procedure LogoutUser();
    function AddFriend(const Username: string): Boolean;
    procedure FilterUsers(LoggedUserID: integer);
    function AddToWatchlist(const MovieTitle :string; MovieID: Integer): Boolean;
    procedure FilterWatchlist(LoggedUserID: integer);
    procedure LoadFriends(LoggedUserID: Integer);
    function RemoveFriend(const Username: string; LoggedUserID: Integer): Boolean;
  end;

var
  dmMediaCorner: TdmMediaCorner;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{
  Initializes the database connection.

  This procedure:
  - Checks if the database is already connected.
  - If not connected, it sets the connection parameters.
  - Attempts to establish a connection to the database.
  - Raises an exception if the connection attempt fails.

  Notes:
  - Uses hardcoded credentials (`SYSDBA` / `masterkey`), which is not recommended for production systems.
  - The database file path is dynamically constructed based on the application's directory.
}
procedure TdmMediaCorner.InitDB();
var
  ProjectDir: string;
begin
  if not ibdbMediaCorner.Connected then
  begin
  with dmMediaCorner.ibdbMediaCorner do
    begin
      Params.Clear;
      ProjectDir := ExtractFilePath(ParamStr(0));
      ProjectDir := ExpandFileName(ProjectDir + '..\..\');
      DatabaseName := IncludeTrailingPathDelimiter(ProjectDir + 'Data') + 'MEDIACORNERDB.GDB';
      Params.Add('user_name=SYSDBA');
      Params.Add('password=masterkey');
      Params.Add('lc_ctype=WIN1250');
      try
        Connected := True;
      except
        on e:Exception do
        begin
          raise Exception.Create('Failed to connect to the database: ' + E.Message);
        end;
      end;
    end;
  end;
end;

{
  Validates user credentials and logs in the user if authentication is successful.

  @param Username The username entered by the user.
  @param Password The password entered by the user.
  @return Boolean - Returns True if authentication is successful, False otherwise.

  This function:
  - Initializes the database connection.
  - Starts a transaction if one is not already active.
  - Queries the database for the provided username.
  - If the user exists, compares the stored password with the provided password.
  - If credentials match, sets the current user ID and username.
  - Calls `FilterUsers` to filter the user list.
  - Commits the transaction while retaining it for further operations.
  - Rolls back the transaction and raises an exception if an error occurs.

  Notes:
  - Uses plain-text password comparison, which is not secure. Hashing should be implemented.
  - Creates and destroys `TIBQuery` dynamically to prevent memory leaks.
  - Ensures the `ibdsUsers` dataset is closed at the end.
}
function TdmMediaCorner.ValidateUser(const Username: string; const Password: string): Boolean;
var
  DBPassword: string;
  ibqUsers  : TIBQuery;
begin
  InitDB();
  Result := False;

  try
    if not itMediaCorner.Active then
      itMediaCorner.StartTransaction;

    if not itMediaCorner.InTransaction then
      raise Exception.Create('Transaction was not started properly.');

    ibqUsers := TIBQuery.Create(nil);
    with ibqUsers do
    try
      database := dmMediaCorner.ibdbMediaCorner;
      transaction := dmMediaCorner.itMediaCorner;
      Close;
      SQL.Text := 'SELECT * FROM mc_users WHERE mcu_name = :Username';
      ParamByName('Username').AsString := Username;
      Open;

      if not IsEmpty then
      begin
        DBPassword := Trim(ibqUsers.FieldByName('MCU_PASS').AsString);
        if DBPassword = Password then
        begin
          FCurrentUserID := ibqUsers.FieldByName('MCU_ID').AsInteger;
          FCurrentUsername := ibqUsers.FieldByName('MCU_NAME').AsString;
          FilterUsers(FCurrentUserID);
          Result := True;
        end;
      end;
    finally
      FreeAndNil(ibqUsers)
    end;

    itMediaCorner.CommitRetaining;
  except
    on E: Exception do
    begin
      if itMediaCorner.InTransaction then
        itMediaCorner.Rollback;

      raise Exception.Create('Error during transaction: ' + E.Message);
    end;
  end;
  ibdsUsers.Close
end;

{
  Creates a new user account (Older Implementation).

  @param Username The desired username for the new account.
  @param Password The password for the new user.
  @return Boolean - Returns True if the user was successfully created, False otherwise.

  This function (older implementation):
  - Initializes the database connection.
  - Starts a transaction if one is not already active.
  - Checks if the username already exists in the database.
  - If the username is unique, generates a new user ID.
  - Inserts the new user into the database.
  - Commits the transaction upon success.
  - Rolls back the transaction if an error occurs.

  Note:
  - This function directly executes SQL queries via `IBSQL`, making it less efficient and more prone to SQL injection risks.
  - It was later reimplemented and optimized in `CreateUser2`.
}
function TdmMediaCorner.CreateUser(const Username: string; const Password: string): Boolean;
var
  NewUserID: Integer;
begin
  InitDB();
  Result := False;

  try
    if not itMediaCorner.Active then
      itMediaCorner.StartTransaction;

    if not itMediaCorner.InTransaction then
      raise Exception.Create('Transaction was not started properly.');

    IBSQL.SQL.Text := 'SELECT COUNT(*) FROM mc_users WHERE mcu_name = :Username';
    IBSQL.ParamByName('Username').AsString := Username;
    IBSQL.ExecQuery;

    if IBSQL.Fields[0].AsInteger > 0 then
    begin
      IBSQL.Close;
      itMediaCorner.Rollback;
      Exit;
    end;
    IBSQL.Close;

    IBSQL.SQL.Text := 'SELECT GEN_ID(gen_mc_users_id, 1) FROM RDB$DATABASE';
    IBSQL.ExecQuery;
    NewUserID := IBSQL.Fields[0].AsInteger;
    IBSQL.Close;

    IBSQL.SQL.Text := 'INSERT INTO mc_users (mcu_id, mcu_name, mcu_pass) VALUES (:ID, :Username, :Password)';
    IBSQL.ParamByName('ID').AsInteger := NewUserID;
    IBSQL.ParamByName('Username').AsString := Username;
    IBSQL.ParamByName('Password').AsString := Password;
    IBSQL.ExecQuery;
    IBSQL.Close;

    itMediaCorner.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      if itMediaCorner.InTransaction then
        itMediaCorner.Rollback;

      raise Exception.Create('Error during transaction: ' + E.Message);
    end;

  end;
end;

{
  Creates a new user account (Optimized Implementation).

  @param Username The desired username for the new account.
  @param Password The password for the new user.
  @return Boolean - Returns True if the user was successfully created, False otherwise.

  This function (improved version of `CreateUser`):
  - Initializes the database connection.
  - Starts a transaction if one is not already active.
  - Uses `ibdsUsers` instead of raw SQL queries for improved maintainability and efficiency.
  - Iterates through existing users to check for username availability.
  - If the username is unique, inserts a new user record into the dataset.
  - Commits the transaction upon success.
  - Rolls back the transaction if an error occurs.

  Improvements over `CreateUser`:
  - Uses dataset components (`ibdsUsers`) for better data handling.
  - Eliminates direct SQL execution via `IBSQL`, reducing potential SQL injection risks.
  - More structured and maintainable approach to database operations.
}
function TdmMediaCorner.CreateUser2(const Username: string; const Password: string): Boolean;
var
  NewUserID: Integer;
begin
  InitDB();
  Result := False;

  try
    if not itMediaCorner.Active then
      itMediaCorner.StartTransaction;

    if not itMediaCorner.InTransaction then
      raise Exception.Create('Transaction was not started properly.');

    if not ibdsUsers.Active then
      ibdsUsers.Open;

    ibdsUsers.First;
    while not ibdsUsers.Eof do
      begin
        if Trim(ibdsUsersMCU_NAME.AsString) = Trim(Username) then
          begin
            Result := False;
            Exit;
          end;
        ibdsUsers.Next;
      end;

    ibdsUsers.Insert;
    ibdsUsersMCU_NAME.AsString := Trim(Username);
    ibdsUsersMCU_PASS.AsString := Trim(Password);
    ibdsUsers.Post;
    ibdsUsers.ApplyUpdates;

    itMediaCorner.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      if itMediaCorner.InTransaction then
        itMediaCorner.Rollback;

      raise Exception.Create('Error during transaction: ' + E.Message);
    end;

  end;
end;

{
  Logs out the current user by clearing user-related session data.

  This procedure:
  - Resets the current user ID to 0.
  - Clears the current username.
}
procedure TdmMediaCorner.LogoutUser;
begin
   FCurrentUserID := 0;
   FCurrentUsername := '';
end;

{
  Adds a friend to the current user's friend list.

  @param Username The username of the friend to be added.
  @return Boolean - Returns True if the friend was successfully added, False otherwise.

  This function:
  - Initializes the database connection.
  - Starts a transaction if one is not already active.
  - Ensures the users and friends datasets are open.
  - Searches for the specified username in the user list.
  - Ensures the user is not adding themselves as a friend.
  - Inserts a new friend record and applies updates.
  - Commits the transaction upon success.
  - Rolls back the transaction if an error occurs.
}
function TdmMediaCorner.AddFriend(const Username: string): Boolean;
var
  FriendID : integer;
  FriendCheck : boolean;
begin
  InitDB();
  Result := false;

  try
    if not itMediaCorner.Active then
      itMediaCorner.StartTransaction;

    if not itMediaCorner.InTransaction then
      raise Exception.Create('Transaction was not started properly');

    if not ibdsFriends.Active then
      ibdsFriends.Open;

    if not ibdsUsers.Active then
      ibdsUsers.Open;

    ibdsUsers.First;
    while not ibdsUsers.Eof do
      begin
        if Trim(ibdsUsersMCU_NAME.AsString) = Trim(Username) then
          begin
            if Trim(Username) = Trim(FCurrentUsername) then
              begin
                Result := false;
                exit;
              end
            else
              begin
                FriendID := ibdsUsersMCU_ID.AsInteger;
                FriendCheck := true;
                break;
              end;
          end;
        ibdsUsers.Next;
      end;

    if not FriendCheck then
      begin
        Result := false;
        exit;
      end;

    ibdsUsers.Close;

    ibdsFriends.Insert;
    ibdsFriendsMCF_USER.AsInteger := FCurrentUserID;
    ibdsFriendsMCF_FRIEND.AsInteger := FriendID;
    ibdsFriends.Post;
    ibdsFriends.ApplyUpdates;

    itMediaCorner.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      if itMediaCorner.InTransaction then
        itMediaCorner.Rollback;

      if E.ClassName = 'EIBInterBaseError' then
      begin
        Result := false;
        exit;
      end
      else
      begin
        raise Exception.Create('Error during transaction: ' + E.Message);
      end;
    end;
  end;
end;

{
  Adds a movie to the current user's watchlist.

  @param MovieTitle The title of the movie to be added.
  @param MovieID The unique identifier of the movie.
  @return Boolean - Returns True if the movie was successfully added, False otherwise.

  This function:
  - Initializes the database connection.
  - Starts a transaction if one is not already active.
  - Ensures the watchlist dataset is open.
  - Inserts a new movie entry into the watchlist.
  - Applies updates and commits the transaction.
  - Rolls back the transaction if an error occurs.
}
function TdmMediaCorner.AddToWatchlist(Const MovieTitle: string; MovieID: Integer): Boolean;
begin
  InitDB();
  Result := false;

  try
    if not itMediaCorner.Active then
      itMediaCorner.StartTransaction;

    if not itMediaCorner.InTransaction then
      raise Exception.Create('Transaction was not started properly');

    if not ibdsWatchlist.Active then
      ibdsWatchlist.Open;

    ibdsWatchlist.Insert;
    ibdsWatchlistMCW_USER.AsInteger := FCurrentUserID;
    ibdsWatchlistMCW_MOVIE_TITLE.AsString := MovieTitle;
    ibdsWatchlistMCW_MOVIE_ID.AsInteger := MovieID;
    ibdsWatchlist.Post;
    ibdsWatchlist.ApplyUpdates;

    itMediaCorner.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      if itMediaCorner.InTransaction then
        itMediaCorner.Rollback;

      if E.ClassName = 'EIBInterBaseError' then
      begin
        Result := false;
        exit;
      end
      else
      begin
        raise Exception.Create('Error during transaction: ' + E.Message);
      end;
    end;
  end;
end;

{
  Filters the user list to exclude the currently logged-in user.

  @param LoggedUserID The ID of the currently logged-in user.

  This procedure:
  - Closes the existing user query.
  - Updates the SQL query to exclude the logged-in user.
  - Reopens the query with the new filter applied.
}
procedure TdmMediaCorner.FilterUsers(LoggedUserID: Integer);
begin
  IBQusers.Close;
  IBQusers.SQL.Text :=
    'SELECT * FROM MC_USERS WHERE MCU_ID <> :LoggedInUser';
  IBQusers.ParamByName('LoggedInUser').AsInteger := LoggedUserID;
  IBQusers.Open;
end;

{
  Filters the watchlist to show only items belonging to the logged-in user.

  @param LoggedUserID The ID of the currently logged-in user.

  This procedure:
  - Initializes the database connection.
  - Clears and updates the SQL query to fetch the user's watchlist.
  - Binds the user ID parameter.
  - Opens the dataset to reflect the filtered results.
}
procedure TdmMediaCorner.FilterWatchlist(LoggedUserID: Integer);
begin
  InitDB();

  ibdsWatchlist.SelectSQL.Clear;
  ibdsWatchlist.SelectSQL.Add('SELECT * FROM mc_watchlist WHERE mcw_user = :UserID');
  ibdsWatchlist.ParamByName('UserID').AsInteger := LoggedUserID;
  ibdsWatchlist.Open;
end;

{
  Loads the list of friends for the logged-in user.

  @param LoggedUserID The ID of the currently logged-in user.

  This procedure:
  - Creates a new dataset to store friends' information.
  - Queries the database to fetch the user's friends.
  - Binds the user ID parameter to retrieve only relevant records.
  - Opens the dataset and assigns it to the friends' data source.
  - Catches and raises an exception if an error occurs.
}
procedure TdmMediaCorner.LoadFriends(LoggedUserID: Integer);
begin
  ibdsFriendsTest := TIBDataSet.Create(nil);
  try
    ibdsFriendsTest.Database := dmMediaCorner.ibdbMediaCorner;
    ibdsFriendsTest.SelectSQL.Text :=
      'SELECT F.MCF_FRIEND, U.MCU_NAME AS FRIEND_NAME ' +
      'FROM MC_FRIENDS F ' +
      'JOIN MC_USERS U ON F.MCF_FRIEND = U.MCU_ID ' +
      'WHERE F.MCF_USER = :LoggedInUserID';
    ibdsFriendsTest.ParamByName('LoggedInUserID').AsInteger := LoggedUserID;
    ibdsFriendsTest.Open;

    dsFriends.DataSet := ibdsFriendsTest;
  except
    on E: Exception do
    begin
      raise Exception.Create('Error: ' + E.Message);
    end;
  end;
end;

{
  Removes a friend from the user's friend list.

  @param Username The username of the friend to be removed.
  @param LoggedUserID The ID of the currently logged-in user.
  @return Boolean - Returns True if the friend was successfully removed, False otherwise.

  This function:
  - Initializes the database connection.
  - Checks for an active transaction and starts one if needed.
  - Searches for the friend's user ID in the database.
  - Ensures the friendship exists before attempting removal.
  - Deletes the friend entry and commits the transaction.
  - Rolls back the transaction in case of errors.

  Exceptions:
  - Raises an exception if the transaction was not started properly.
  - Rolls back the transaction and rethrows an error if an unexpected exception occurs.
}
function TdmMediaCorner.RemoveFriend(const Username: string; LoggedUserID: Integer): Boolean;
var
  FriendID: Integer;
begin
  InitDB();
  Result := False;

  try
    if not itMediaCorner.Active then
      itMediaCorner.StartTransaction;

    if not itMediaCorner.InTransaction then
      raise Exception.Create('Transaction was not started properly');

    if not ibdsUsers.Active then
      ibdsUsers.Open;

    ibdsUsers.First;
    FriendID := -1;
    while not ibdsUsers.Eof do
    begin
      if Trim(ibdsUsersMCU_NAME.AsString) = Trim(Username) then
      begin
        FriendID := ibdsUsersMCU_ID.AsInteger;
        Break;
      end;
      ibdsUsers.Next;
    end;

    if FriendID = -1 then
    begin
      Result := False;
      Exit;
    end;

    ibdsFriends.Close;
    ibdsFriends.SelectSQL.Text :=
      'SELECT * FROM MC_FRIENDS WHERE MCF_USER = :CurrentUserID AND MCF_FRIEND = :FriendID';
    ibdsFriends.ParamByName('CurrentUserID').AsInteger := LoggedUserID;
    ibdsFriends.ParamByName('FriendID').AsInteger := FriendID;
    ibdsFriends.Open;

    if ibdsFriends.IsEmpty then
    begin
      Result := False;
      Exit;
    end;

    ibdsFriends.Delete;
    ibdsFriends.ApplyUpdates;

    itMediaCorner.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      if itMediaCorner.InTransaction then
        itMediaCorner.Rollback;

      if E.ClassName = 'EIBInterBaseError' then
      begin
        Result := False;
        Exit;
      end
      else
      begin
        raise Exception.Create('Error during transaction: ' + E.Message);
      end;
    end;
  end;
end;


end.
