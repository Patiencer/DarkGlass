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
unit darkplatform.windowmanager.android;

interface
{$ifdef ANDROID}
uses
  darkplatform.window,
  darkplatform.display,
  darkplatform.windowmanager,
  darkplatform.windowmanager.common;

type
  TWindowManager = class( TCommonWindowManager )
  private //- IWindowManager -//
    function CreateWindow( Display: IDisplay ): IWindow; override;
  end;

{$endif}
implementation
{$ifdef ANDROID}
uses
  darkplatform.window.android;

{ TWindowManager }

function TWindowManager.CreateWindow(Display: IDisplay): IWindow;
begin
  if Self.getCount>=1 then begin
    Result := Self.getItem(0);
  end else begin
    Result := Self.AddWindow( TWindow.Create(Display) );
  end;
end;

{$endif}
end.
