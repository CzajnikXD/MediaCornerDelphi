program MediaCornerDelphi;

uses
  Vcl.Forms,
  LoginForm in 'Forms\LoginForm.pas' {frLogin},
  RegisterForm in 'Forms\RegisterForm.pas' {frRegister},
  Vcl.Themes,
  Vcl.Styles,
  MediaCornerDataModule in 'Data\MediaCornerDataModule.pas' {dmMediaCorner: TDataModule},
  MenuForm in 'Forms\MenuForm.pas' {frMainMenu},
  HomeFrame in 'Frames\HomeFrame.pas' {Home: TFrame},
  WatchlistFrame in 'Frames\WatchlistFrame.pas' {Watchlist: TFrame},
  MoviesFrame in 'Frames\MoviesFrame.pas' {Movies: TFrame},
  UsersFrame in 'Frames\UsersFrame.pas' {Users: TFrame},
  FriendsFrame in 'Frames\FriendsFrame.pas' {Friends: TFrame},
  SettingsFrame in 'Frames\SettingsFrame.pas' {Settings: TFrame},
  MediaCornerApiModule in 'Data\MediaCornerApiModule.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Amethyst Kamri');
  Application.CreateForm(TfrLogin, frLogin);
  Application.CreateForm(TdmMediaCorner, dmMediaCorner);
  Application.CreateForm(TfrMainMenu, frMainMenu);
  //  Application.CreateForm(TForm1, Form1);
  //  Application.CreateForm(TFRLoginForm, FRLoginForm);
//  Application.CreateForm(TFRRegisterForm, FRRegisterForm);
  Application.Run;
end.
