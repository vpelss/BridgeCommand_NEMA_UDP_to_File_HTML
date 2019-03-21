unit Unit1;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls,  IdHTTPServer, IdUDPClient, IdComponent, IdContext, IdCustomHTTPServer;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    IdHTTPServer1: TIdHTTPServer;
    IdUDPClient1: TIdUDPClient;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Stop: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Clear;
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



procedure TForm1.StopClick(Sender: TObject);
begin
IdUDPClient1.active := False;
Timer1.Enabled := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

  //http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html

myText := IdUDPClient1.ReceiveString(1);
  myText := Trim(myText);

   if (myText <> '') then
      begin
      Memo1.Lines.Add(myText);
      lineCount := lineCount + 1;
      end;
If ( lineCount > UpDown2.Position ) then
     begin
     Memo1.Lines.SaveToFile( Edit3.Text );
     fullOutput := Memo1.lines.Text;
     Memo1.Lines.Clear;
     lineCount := 0;
     end;
     ;
     //IdUDPClient1.Disconnect;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin

end;





end.

