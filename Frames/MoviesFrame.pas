unit MoviesFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.WinXCtrls, REST.Client, REST.Types, System.JSON, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TMovies = class(TFrame)
    DBMoviesGrid: TDBGrid;
    MovieSearchBox: TSearchBox;
    procedure FrameCreate(Sender: TObject);
    procedure DBMoviesGridCellClick(Column: TColumn);
    procedure DBMoviesGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
    Column: TColumn; State: TGridDrawState);
  private
    FDMemTable: TFDMemTable;
    DataSource: TDataSource;
    CurrentPage: Integer;
    procedure LoadMovies(PageNumber: Integer);
  public
  end;

implementation

{$R *.dfm}

uses
  MediaCornerApiModule, MediaCornerDataModule, MenuForm;

procedure TMovies.FrameCreate(Sender: TObject);
begin
  Self.ParentBackground := False;
  Self.Color := RGB(45, 51, 90);
  if Assigned(frMainMenu.MoviesMemTable) then
  begin
    FDMemTable := frMainMenu.MoviesMemTable;
  end
  else
  begin
    FDMemTable := TFDMemTable.Create(Self);
    LoadMovies(1);
  end;

  DataSource := TDataSource.Create(Self);
  DataSource.DataSet := FDMemTable;
  DBMoviesGrid.DataSource := DataSource;
end;

procedure TMovies.LoadMovies(PageNumber: Integer);
begin
  FDMemTable.Close;
  FetchPopularMoviesByPage(FDMemTable, PageNumber);
  FDMemTable.Open;
end;

procedure TMovies.DBMoviesGridCellClick(Column: TColumn);
var
  MovieID: Integer;
  MovieTitle: String;
begin
  if Column.FieldName = 'ADD MOVIE TO WATCHLIST' then
  begin
    MovieID := FDMemTable.FieldByName('id').AsInteger;
    MovieTitle := FDMemTable.FieldByName('title').AsString;

    if dmMediaCorner.AddToWatchlist(MovieTitle, MovieID) then
    begin
      MessageBox(Application.Handle,'Movie added successfully.','Info',MB_ICONINFORMATION);
    end
    else
    begin
      MessageBox(Application.Handle,'Movie is already on your watchlist.','Error',MB_ICONERROR)
    end;

  end;
end;

procedure TMovies.DBMoviesGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Text: string;
  TextWidth, TextHeight: Integer;
  X, Y: Integer;
begin
  if FDMemTable.IsEmpty then
    Exit;

  if Column.FieldName = 'ADD MOVIE TO WATCHLIST' then
  begin
    Text := 'Add to watchlist';

    // Get the width and height of the text
    TextWidth := DBMoviesGrid.Canvas.TextWidth(Text);
    TextHeight := DBMoviesGrid.Canvas.TextHeight(Text);

    // Calculate X and Y coordinates to center the text in the cell
    X := Rect.Left + (Rect.Width - TextWidth) div 2;
    Y := Rect.Top + (Rect.Height - TextHeight) div 2;

    // Fill the cell background and draw the centered text
    DBMoviesGrid.Canvas.FillRect(Rect);
    DBMoviesGrid.Canvas.TextOut(X, Y, Text);
  end;
end;

end.

