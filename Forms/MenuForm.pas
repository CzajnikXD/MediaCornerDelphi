unit MenuForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, HomeFrame, WatchlistFrame, MoviesFrame,
  UsersFrame, FriendsFrame, SettingsFrame, IBX.IBSQL, IBX.IBQuery, FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;
type
  TFrameClass = class of TFrame;
  TfrMainMenu = class(TForm)
    ViewPanel: TPanel;
    AppTitle: TLabel;
    FriendsButton: TButton;
    HomeButton: TButton;
    MovieButton: TButton;
    SettingsButton: TButton;
    UsersButton: TButton;
    WatchlistButton: TButton;
    ViewDataPanel: TPanel;
    DataGridPanel: TPanel;
    ViewTitle: TLabel;
    MoviesMemTable: TFDMemTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SwitchFrame(FrameClass: TFrameClass);
    procedure HomeButtonClick(Sender: TObject);
    procedure WatchlistButtonClick(Sender: TObject);
    procedure MovieButtonClick(Sender: TObject);
    procedure UsersButtonClick(Sender: TObject);
    procedure FriendsButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TitleChange(const Title: WideString);
    procedure FormShow(Sender: TObject);
    procedure PreLoadMovies;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frMainMenu: TfrMainMenu;

implementation

{$R *.dfm}

uses MediaCornerDataModule, MediaCornerApiModule;

procedure TfrMainMenu.FormCreate(Sender: TObject);
begin
  MoviesMemTable := TFDMemTable.Create(Self);
  PreloadMovies;
  SwitchFrame(THome);
  TitleChange(#61461' Home');
end;

procedure TfrMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrMainMenu.FormDestroy(Sender: TObject);
begin
  frMainMenu := nil;
end;

procedure TfrMainMenu.FormShow(Sender: TObject);
begin
  dmMediaCorner.ibdsUsers.Open;
  dmMediaCorner.ibdsFriends.Open;
end;

procedure TfrMainMenu.SwitchFrame(FrameClass: TFrameClass);
var
  Frame: TFrame;
begin
  if DataGridPanel.ControlCount > 0 then
  begin
    DataGridPanel.Controls[0].Free;
  end;

  Frame := FrameClass.Create(Self);
  Frame.Parent := DataGridPanel;
  Frame.Align := alClient;
  Frame.Show;
end;

procedure TfrMainMenu.HomeButtonClick(Sender: TObject);
begin
  SwitchFrame(THome);
  TitleChange(#61461' Home');
end;

procedure TfrMainMenu.WatchlistButtonClick(Sender: TObject);
begin
  SwitchFrame(TWatchlist);
  dmMediaCorner.FilterWatchlist(dmMediaCorner.CurrentUserID);
  dmMediaCorner.ibdsWatchlist.Open;
  TitleChange(#61498' Watchlist');
end;

procedure TfrMainMenu.MovieButtonClick(Sender: TObject);
begin
  if MoviesMemTable.IsEmpty then
    PreloadMovies;

  SwitchFrame(TMovies);
  TitleChange(#61448' Movies');
end;

procedure TfrMainMenu.UsersButtonClick(Sender: TObject);
begin
  dmMediaCorner.ibdsUsers.Open;
  SwitchFrame(TUsers);
  TitleChange(#61632' Users');
end;

procedure TfrMainMenu.FriendsButtonClick(Sender: TObject);
begin
  SwitchFrame(TFriends);
  dmMediaCorner.LoadFriends(dmMediaCorner.CurrentUserID);
  TitleChange(#61447' Friends');
end;

procedure TfrMainMenu.SettingsButtonClick(Sender: TObject);
begin
  SwitchFrame(TSettings);
  TitleChange(#61459' Settings');
end;

procedure TfrMainMenu.TitleChange(const Title: WideString);
begin
  ViewTitle.Caption := Title;
end;

procedure TfrMainMenu.PreLoadMovies;
begin
  FetchPopularMoviesByPage(MoviesMemTable, 1);
end;

end.
