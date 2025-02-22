unit WatchlistFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids, MediaCornerDataModule;

type
  TWatchlist = class(TFrame)
    DBWatchlistGrid: TDBGrid;
    MovieSearchBox: TSearchBox;
    procedure DBWatchlistGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
    Column: TColumn; State: TGridDrawState);
    procedure DBWatchlistGridCellClick(Column: TColumn);
    procedure RefreshWatchlist;
    procedure FrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TWatchlist.DBWatchlistGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Text: string;
  TextWidth, TextHeight: Integer;
  X, Y: Integer;
begin
  if dmMediaCorner.dsWatchlist.DataSet.IsEmpty then
    Exit;

  if Column.FieldName = 'RemoveMovie' then
  begin
    Text := 'Remove from watchlist';

    // Get the width and height of the text
    TextWidth := DBWatchlistGrid.Canvas.TextWidth(Text);
    TextHeight := DBWatchlistGrid.Canvas.TextHeight(Text);

    // Calculate X and Y coordinates to center the text in the cell
    X := Rect.Left + (Rect.Width - TextWidth) div 2;
    Y := Rect.Top + (Rect.Height - TextHeight) div 2;

    // Fill the cell background and draw the centered text
    DBWatchlistGrid.Canvas.FillRect(Rect);
    DBWatchlistGrid.Canvas.TextOut(X, Y, Text);
  end;
end;

procedure TWatchlist.FrameCreate(Sender: TObject);
begin
  Self.ParentBackground := False;
  Self.Color := RGB(45, 51, 90);
end;

procedure TWatchlist.DBWatchlistGridCellClick(Column: TColumn);
var
  Movie: string;
begin
  if (dmMediaCorner.dsWatchlist.DataSet.IsEmpty) then
    Exit;

  if Column.FieldName = 'RemoveMovie' then
  begin
    Movie := dmMediaCorner.dsWatchlist.DataSet.FieldByName('MCW_MOVIE_TITLE').AsString;
    try
      dmMediaCorner.ibdsWatchlist.Delete;
      dmMediaCorner.ibdsWatchlist.ApplyUpdates;
      dmMediaCorner.itMediaCorner.CommitRetaining;
      ShowMessage(Trim(Movie) + ' removed from the watchlist')
    except
      MessageBox(Application.Handle, 'Couldnt remove user from the friendslist.', 'B³¹d', MB_ICONERROR);
    end;
  end;

  dmMediaCorner.FilterWatchlist(dmMediaCorner.CurrentUserID);
end;

procedure TWatchlist.RefreshWatchlist;
begin
  if dmMediaCorner.dsWatchlist.DataSet.Active then
  begin
    dmMediaCorner.dsWatchlist.DataSet.Close;
    dmMediaCorner.FilterWatchlist(dmMediaCorner.CurrentUserID);
  end;
end;

end.
