unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, IdQOTDUDP, IdHTTP, IdHTTPServer, IdUDPClient, IdComponent, IdCustomHTTPServer, IdContext;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    IdHTTPServer1: TIdHTTPServer;
    Label1: TLabel;
    Label2: TLabel;
    Stop: TButton;
    IdUDPClient1: TIdUDPClient;
    Memo1: TMemo;
    Timer1: TTimer;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure IdQOTDUDP1Connected(Sender: TObject);
    procedure IdUDPClient1Connected(Sender: TObject);
    procedure IdUDPClient1Disconnected(Sender: TObject);
    procedure IdUDPClient1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure Memo1Change(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  myText : String;
  lineCount : integer;
  fullOutput : String;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.IdUDPClient1Connected(Sender: TObject);
begin

end;

procedure TForm1.IdQOTDUDP1Connected(Sender: TObject);
begin

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  Timer1.Interval :=  StrToInt( Edit1.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Timer1.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Clear;
  IdHTTPServer1.Active := True;
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := '<html><head><title>My First Response</title></head>' +
  '<body>Command: ' + ARequestInfo.Command +
  '<br />Host: ' + ARequestInfo.Host +
  '<br />URI: ' + ARequestInfo.URI +
  '<br />UserAgent: ' + ARequestInfo.UserAgent +
  '<pre>' + fullOutput +
  '</pre></body></html>';

  AResponseInfo.ContentText := fullOutput;

end;

procedure TForm1.IdUDPClient1Disconnected(Sender: TObject);
begin

end;

procedure TForm1.IdUDPClient1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin

Memo1.Lines.Add(AStatusText);

end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

end;

procedure TForm1.StopClick(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

  myText := IdUDPClient1.ReceiveString(100);
  myText := Trim(myText);

   if (myText <> '') then
      begin
      Memo1.Lines.Add(myText);
      lineCount := lineCount + 1;
      end;
If ( lineCount > 5 ) then
     begin
     Memo1.Lines.SaveToFile( Edit3.Text );
     fullOutput := Memo1.lines.Text;
     Memo1.Lines.Clear;
     lineCount := 0;
     end;

end;

end.

