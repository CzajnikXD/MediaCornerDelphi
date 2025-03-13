unit UsersFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, MediaCornerDataModule, Vcl.ExtCtrls, Vcl.WinXCtrls;

type
  TUsers = class(TFrame)
    DBUsersGrid: TDBGrid;
    UserSearchBox: TSearchBox;
    procedure DBUsersGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure DBUsersGridCellClick(Column: TColumn);
    procedure FrameCreate(Sender: TObject);
    procedure UserSearchBoxInvokeSearch(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TUsers.DBUsersGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Text: string;
  TextWidth, TextHeight: Integer;
  X, Y: Integer;
begin
  if dmMediaCorner.dsUsers.DataSet.IsEmpty then
    Exit;

  if Column.FieldName = 'AddUser' then
  begin
    Text := 'Add Friend';

    // Get the width and height of the text
    TextWidth := DBUsersGrid.Canvas.TextWidth(Text);
    TextHeight := DBUsersGrid.Canvas.TextHeight(Text);

    // Calculate X and Y coordinates to center the text in the cell
    X := Rect.Left + (Rect.Width - TextWidth) div 2;
    Y := Rect.Top + (Rect.Height - TextHeight) div 2;

    // Fill the cell background and draw the centered text
    DBUsersGrid.Canvas.FillRect(Rect);
    DBUsersGrid.Canvas.TextOut(X, Y, Text);
  end;
end;

procedure TUsers.FrameCreate(Sender: TObject);
begin
  Self.ParentBackground := False;
  Self.Color := RGB(45, 51, 90);

  dmMediaCorner.ibdsUsers.Close;
  dmMediaCorner.ibdsUsers.SelectSQL.Text := 'SELECT * FROM mc_users WHERE mcu_name <> ' + QuotedStr(dmMediaCorner.CurrentUsername);
  dmMediaCorner.ibdsUsers.Open;
end;

procedure TUsers.UserSearchBoxInvokeSearch(Sender: TObject);
var
  SearchText: string;
  CurrentUser: string;
begin
  SearchText := trim(UserSearchBox.Text);
  CurrentUser := dmMediaCorner.CurrentUsername;
  if SearchText = '' then
  begin
    dmMediaCorner.ibdsUsers.Close;
    dmMediaCorner.ibdsUsers.SelectSQL.Text := 'SELECT * FROM mc_users WHERE mcu_name <> ' + QuotedStr(CurrentUser);
    dmMediaCorner.ibdsUsers.Open;
  end
  else
  begin
    dmMediaCorner.ibdsUsers.Close;
    dmMediaCorner.ibdsUsers.SelectSQL.Text := 'SELECT * FROM mc_users WHERE mcu_name LIKE ' + QuotedStr('%'+SearchText+'%')
                                          + ' AND mcu_name <> ' + QuotedStr(CurrentUser);
    dmMediaCorner.ibdsUsers.Open;
  end;
end;

procedure TUsers.DBUsersGridCellClick(Column: TColumn);
var
  Username: string;
begin
  if Column.FieldName = 'AddUser' then
  begin
      Username := dmMediaCorner.dsUsers.DataSet.FieldByName('MCU_NAME').AsString;
      if dmMediaCorner.AddFriend(trim(Username)) then
        begin
          dmMediaCorner.ibdsUsers.open;
          dmMediaCorner.dsUsers.DataSet.Refresh;
          ShowMessage(trim(Username) + ' was successfully added to the friendslist');
        end
      else
        begin
        dmMediaCorner.ibdsUsers.open;
        dmMediaCorner.dsUsers.DataSet.Refresh;
        MessageBox(Application.Handle,'Selected user is already in the friendslist.','B³¹d',MB_ICONERROR);
        end;
  end;
end;

end.
