//------------------------------------------------------------------------------
// This file is part of the DarkGlass game engine project.
// More information can be found here: http://chapmanworld.com/darkglass
//
// DarkGlass is licensed under the MIT License:
//
// Copyright 2018 Craig Chapman
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the �Software�),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED �AS IS�, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.
//------------------------------------------------------------------------------
unit darkplatform.mainloop.android;

interface
{$ifdef ANDROID}
uses
  AndroidAPI.Input,
  darkplatform.appglue.android,
  darkplatform.mainloop.common,
  darkplatform.window,
  darkthreading,
  darkplatform.displaymanager,
  darkplatform.windowmanager;

type
  TMainLoop = class( TCommonMainLoop, IThreadSubSystem )
  private
    fApp: pandroid_app;
  protected
    procedure DoApplicationCommand(app: pandroid_app; cmd: int32);
    function DoInputEvent(app: pandroid_app; Event: PAInputEvent ): int32;
  protected //- Override me -//
    procedure HandleOSMessages; override;
    function CreateDisplayManager: IDisplayManager; override;
    function CreateWindowManager: IWindowManager; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

{$endif}
implementation
{$ifdef ANDROID}
uses
  sysutils,
  AndroidAPI.Looper,
  AndroidAPI.NativeActivity,
  darkplatform.displaymanager.android,
  darkplatform.windowmanager.android;

var
  MainLoop: TMainLoop = nil;

procedure onAppCmd(app: pandroid_app; cmd: Integer); cdecl;
begin
  MainLoop.DoApplicationCommand(app,cmd);
end;

function onInputEvent(App: PAndroid_app; Event: PAInputEvent): Int32; cdecl;
begin
  Result := MainLoop.DoInputEvent(app,event);
end;

constructor TMainLoop.Create;
begin
  inherited Create;
  if assigned(MainLoop) then begin
    raise
      Exception.Create('TMainLoop is a singleton class.');
    exit;
  end;
  MainLoop := Self;
  fApp := PANativeActivity(System.DelphiActivity)^.instance;
  fApp.userData := Self;
  fApp.onAppCmd := OnAppCmd;
  fApp.onInputEvent := onInputEvent;
end;

function TMainLoop.CreateDisplayManager: IDisplayManager;
begin
  Result := TDisplayManager.Create;
end;

function TMainLoop.CreateWindowManager: IWindowManager;
begin
  Result := TWindowManager.Create;
end;

destructor TMainLoop.Destroy;
begin
  MainLoop := nil;
  inherited Destroy;
end;

procedure TMainLoop.DoApplicationCommand(app: pandroid_app; cmd: int32);
begin
  if cmd=APP_CMD_INIT_WINDOW then begin
  end;
  if cmd=APP_CMD_WINDOW_REDRAW_NEEDED then begin
  end;
end;

function TMainLoop.DoInputEvent(app: pandroid_app; Event: PAInputEvent): int32;
begin
  exit;
end;

procedure TMainLoop.HandleOSMessages;
var
  ident : Integer;
  events: Integer;
  source: pandroid_poll_source;
begin
  ident := ALooper_pollAll(1, nil, @events, @source);
  if (ident >= 0) and (source <> nil) then begin
    source.process(fApp, source);
  end;
  doApplicationCommand( fApp, APP_CMD_WINDOW_REDRAW_NEEDED );
end;

{$endif}
end.
