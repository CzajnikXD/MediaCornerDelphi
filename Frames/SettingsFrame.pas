unit SettingsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TSettings = class(TFrame)
    Label1: TLabel;
    procedure FrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TSettings.FrameCreate(Sender: TObject);
begin
  Self.ParentBackground := False;
  Self.Color := RGB(45, 51, 90);
end;

end.
