unit Unit1;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
   ComCtrls, uPSComponent, IdHTTPServer, IdUDPClient, IdComponent, IdContext,
   IdCustomHTTPServer, IdSSLOpenSSL, IdHTTP, IdCustomTCPServer, IdGlobal;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    IdHTTPServer1: TIdHTTPServer;
    IdHTTPServer2: TIdHTTPServer;
    IdServerIOHandlerSSLOpenSSL1: TIdServerIOHandlerSSLOpenSSL;
    IdUDPClient1: TIdUDPClient;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Stop: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Label5Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  myText : String;
  lineCount : integer;
  fullOutput : String;
  temp: String;
  counter : integer;

implementation

{$R *.lfm}

{ TForm1 }

//bc sends 6 NEMA UDP datagrams every 250 ms
 //for linux must use 8080 as port as you must be root to assign ports under 1024, WTF!
// for linux: comment out:  {$IFDEF UseCThreads} and {$ENDIF}

procedure TForm1.Edit1Change(Sender: TObject);
begin
  Timer1.Interval :=  StrToInt( Edit1.Text);
end;

procedure TForm1.Edit4Change(Sender: TObject);
begin
IdUDPClient1.active := False;
IdUDPClient1.BoundPort :=  UpDown3.Position;
IdUDPClient1.active := True;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
IdUDPClient1.active := True;
Timer1.Enabled := True;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
IdHTTPServer2.Active := False;

    if ( CheckBox2.Checked = True) then
     begin
     IdHTTPServer2.Bindings.clear;
     IdHTTPServer2.DefaultPort:= 8080;
     end
  else
      begin
      IdHTTPServer2.Bindings.clear;
      IdHTTPServer2.DefaultPort:= 80;
      end;

  IdHTTPServer2.Active := True;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Timer1.Interval :=  StrToInt( Edit1.Text);
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
//CORS access
  //https://jonlennartaasenden.wordpress.com/2012/08/08/cors-for-indy/
  with aResponseInfo do CustomHeaders.AddValue('Access-Control-Allow-Origin','*');

   AResponseInfo.ContentText := '<html><head><title>My First Response</title></head>' +
  '<body>Command: ' + ARequestInfo.Command +
  '<br />Host: ' + ARequestInfo.Host +
  '<br />URI: ' + ARequestInfo.URI +
  '<br />UserAgent: ' + ARequestInfo.UserAgent +
  '<pre>' + fullOutput +
  '</pre></body></html>';

  AResponseInfo.ContentText := fullOutput;
end;

procedure TForm1.Label5Click(Sender: TObject);
begin

end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin

end;


procedure TForm1.StopClick(Sender: TObject);
begin
IdUDPClient1.active := False;
Timer1.Enabled := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  filename : String;
begin
   //http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html

if (lineCount = 0) then //allows last line to stay long enough to see
   begin
   Memo1.Lines.Clear;
   end;
myText := IdUDPClient1.ReceiveString(1);
  myText := Trim(myText);

   if (myText <> '') then
      begin
      Memo1.Lines.Add(myText);
      lineCount := lineCount + 1;
      end;
If ( lineCount >= UpDown2.Position ) then
     begin
      filename := Edit3.Text;
     if ( CheckBox1.Checked ) then
          begin
          filename := filename + counter.ToString;
          counter :=  counter + 1;
          end;
     filename := filename + '.txt';
     Memo1.Lines.SaveToFile( filename );
     fullOutput := Memo1.lines.Text;
     //Memo1.Lines.Clear;
     lineCount := 0;
     end;
     ;
     //IdUDPClient1.Disconnect;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin

end;





end.

