unit FriendsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids, MediaCornerDataModule;

type
  TFriends = class(TFrame)
    DBFriendsGrid: TDBGrid;
    UserSearchBox: TSearchBox;
    procedure DBFriendsGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure DBFriendsGridCellClick(Column: TColumn);
    procedure FrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFriends.DBFriendsGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Text: string;
  TextWidth, TextHeight: Integer;
  X, Y: Integer;
begin
  if (dmMediaCorner.dsFriends.DataSet.IsEmpty) then
    Exit;

  if Column.FieldName = 'RemoveUser' then
  begin
    Text := 'Remove from friendslist';

    // Get the width and height of the text
    TextWidth := DBFriendsGrid.Canvas.TextWidth(Text);
    TextHeight := DBFriendsGrid.Canvas.TextHeight(Text);

    // Calculate X and Y coordinates to center the text in the cell
    X := Rect.Left + (Rect.Width - TextWidth) div 2;
    Y := Rect.Top + (Rect.Height - TextHeight) div 2;

    // Fill the cell background and draw the centered text
    DBFriendsGrid.Canvas.FillRect(Rect);
    DBFriendsGrid.Canvas.TextOut(X, Y, Text);
  end;
end;

procedure TFriends.FrameCreate(Sender: TObject);
begin
  Self.ParentBackground := False;
  Self.Color := RGB(45, 51, 90);
end;

procedure TFriends.DBFriendsGridCellClick(Column: TColumn);
var
  Username: string;
begin
  if (dmMediaCorner.dsFriends.DataSet.IsEmpty) then
    Exit;

  if Column.FieldName = 'RemoveUser' then
  begin
    Username := dmMediaCorner.dsFriends.DataSet.FieldByName('FRIEND_NAME').AsString;

    if dmMediaCorner.RemoveFriend(Username, dmMediaCorner.CurrentUserID) then
    begin
      ShowMessage(Trim(Username) + ' removed from the friendslist');
    end
    else
    begin
      MessageBox(Application.Handle, 'Couldnt remove user from the friendslist.', 'B³¹d', MB_ICONERROR);
    end;
  end;

  dmMediaCorner.LoadFriends(dmMediaCorner.CurrentUserID);
end;

end.
