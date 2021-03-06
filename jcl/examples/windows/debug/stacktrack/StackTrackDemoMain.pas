unit StackTrackDemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AppEvnts, ActnList;

type
  TMainForm = class(TForm)
    ExceptionLogMemo: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Button4: TButton;
    ApplicationEvents: TApplicationEvents;
    Label1: TLabel;
    ActionList1: TActionList;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses
  JclDebug;

{ TMainForm }

//--------------------------------------------------------------------------------------------------
// Simulation of various unhandled exceptions
//--------------------------------------------------------------------------------------------------

procedure TMainForm.Button1Click(Sender: TObject);
begin
  PInteger(nil)^ := 0;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  ListBox1.Items[1] := 'a';
end;

procedure AAA;
begin
  PInteger(nil)^ := 0;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  AAA;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  ActionList1.Actions[0].Execute;
end;

//--------------------------------------------------------------------------------------------------
// Simple VCL application unhandled exception handler using JclDebug
//--------------------------------------------------------------------------------------------------

procedure TMainForm.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  // Log time stamp
  ExceptionLogMemo.Lines.Add(DateTimeToStr(Now));

  // Log unhandled exception stack info to ExceptionLogMemo
  JclLastExceptStackListToStrings(ExceptionLogMemo.Lines, False, True, True, False);

  // Insert empty line
  ExceptionLogMemo.Lines.Add('');

  // Display default VCL unhandled exception dialog
  Application.ShowException(E);
end;

//--------------------------------------------------------------------------------------------------
// JclDebug initialization and finalization for VCL application
//--------------------------------------------------------------------------------------------------

initialization

  // Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
  Include(JclStackTrackingOptions, stRawMode);
  // Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
  Include(JclStackTrackingOptions, stStaticModuleList);

  // Initialize Exception tracking
  JclStartExceptionTracking;

finalization

  // Uninitialize Exception tracking
  JclStopExceptionTracking;

end.
