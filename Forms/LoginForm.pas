unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrLogin = class(TForm)
    TitlePanel: TPanel;
    Title: TLabel;
    Subtitle: TLabel;
    LoginPanel: TPanel;
    UsernameEdit: TEdit;
    PasswordEdit: TEdit;
    LoginButton: TButton;
    NewAccLabel: TLabel;
    procedure NewAccLabelClick(Sender: TObject);
    procedure NewAccLabelMouseEnter(Sender: TObject);
    procedure NewAccLabelMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frLogin: TfrLogin;

implementation

{$R *.dfm}

uses
  RegisterForm, MediaCornerDataModule, MenuForm;

procedure TfrLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrLogin.FormDestroy(Sender: TObject);
begin
  frLogin := nil;
end;

procedure TfrLogin.NewAccLabelClick(Sender: TObject);
begin
  if frRegister = nil then
    frRegister := TfrRegister.Create(Self);
  Self.Visible := False;
  with frRegister do
  try
    Visible := False;
    ShowModal;
  finally
    FreeAndNil(frRegister)
  end;
  Self.Visible := True;
end;

procedure TfrLogin.NewAccLabelMouseEnter(Sender: TObject);
begin
  NewAccLabel.Cursor := crHandPoint;
end;

procedure TfrLogin.NewAccLabelMouseLeave(Sender: TObject);
begin
  NewAccLabel.Cursor := crDefault;
end;

procedure TfrLogin.LoginButtonClick(Sender: TObject);
var
  Username, Password: string;
begin
  Username := Trim(UsernameEdit.Text);
  Password := Trim(PasswordEdit.Text);

  if (Username='') or (Password='') then
  begin
     MessageBox(Application.Handle,'Input fields cant be empty.','B³¹d',MB_ICONERROR);
     if UsernameEdit.CanFocus then
       UsernameEdit.SetFocus;
  end
  else
  begin
    if dmMediaCorner.ValidateUser(Username, Password) then
      begin
        MessageBox(Application.Handle,'Logged in successfully.','Info',MB_ICONINFORMATION);
        Hide;

        if frMainMenu = nil then
          frMainMenu := TfrMainMenu.Create(Self);
        with frMainMenu do
        try
          Visible := False;
          ShowModal;
        finally
          FreeAndNil(frMainMenu);
        end;
        Close;
      end
    else
      begin
        MessageBox(Application.Handle,'Incorrect login credentials.','B³¹d',MB_ICONERROR);
      end;
  end;
end;


end.
