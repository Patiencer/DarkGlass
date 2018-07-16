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
unit darkplatform.mainloop.linux;

interface
{$ifdef LINUX}
uses
  darkthreading,
  darkplatform.displaymanager,
  darkplatform.windowmanager,
  darkplatform.window,
  darkplatform.mainloop.common;

type
  TMainLoop = class( TCommonMainLoop, IThreadSubSystem )
  protected //- Overrides of TCommonMainLoop -//
    procedure HandleOSMessages; override;
    function CreateDisplayManager: IDisplayManager; override;
    function CreateWindowManager: IWindowManager; override;
  end;

{$endif}
implementation
{$ifdef LINUX}
uses
  darkplatform.displaymanager.linux,
  darkplatform.windowmanager.linux,
  darkplatform.linux.binding.xlib;

function TMainLoop.CreateDisplayManager: IDisplayManager;
begin
  Result := TDisplayManager.Create;
end;

function TMainLoop.CreateWindowManager: IWindowManager;
begin
  Result := TWindowManager.Create;
end;

procedure TMainLoop.HandleOSMessages;
var
  Event: XEvent;
  _Display: Display;
  idx: uint32;
begin
  for idx := 0 to pred(fDisplayManager.Count) do begin
    _Display := fDisplayManager.Displays[idx].getOSHandle;
    while XPending(_Display)>0 do begin
      XNextEvent(_display,Event);
      TWindowManager( fWindowManager ).HandleWindowMessage( Event );
    end;
  end;
end;

{$endif}
end.
