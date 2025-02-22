unit RegisterForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrRegister = class(TForm)
    TitlePanel: TPanel;
    Title: TLabel;
    Subtitle: TLabel;
    RegisterPanel: TPanel;
    UsernameEdit: TEdit;
    PasswordEdit: TEdit;
    RegisterButton: TButton;
    BackLoginLabel: TLabel;
    RegisterLabel: TLabel;
    procedure BackLoginLabelClick(Sender: TObject);
    procedure BackLoginLabelMouseEnter(Sender: TObject);
    procedure BackLoginLabelMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure RegisterButtonClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frRegister: TfrRegister;

implementation

{$R *.dfm}
uses
  LoginForm, MediaCornerDataModule;

procedure TfrRegister.BackLoginLabelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrRegister.BackLoginLabelMouseEnter(Sender: TObject);
begin
  BackLoginLabel.Cursor := crHandPoint;
end;

procedure TfrRegister.BackLoginLabelMouseLeave(Sender: TObject);
begin
  BackLoginLabel.Cursor := crDefault;
end;

procedure TfrRegister.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrRegister.FormDestroy(Sender: TObject);
begin
  frRegister := nil;
end;

procedure TfrRegister.RegisterButtonClick(Sender: TObject);
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
    if dmMediaCorner.CreateUser2(Username, Password) then
      begin
        MessageBox(Application.Handle,'User created successfully.','Info',MB_ICONINFORMATION);
        Close;
      end
    else
      begin
        MessageBox(Application.Handle,'Couldnt create a user, please try again.','B³¹d',MB_ICONERROR);
      end;
  end;
end;

end.
