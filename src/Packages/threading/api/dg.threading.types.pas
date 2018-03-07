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
unit dg.threading.types;

interface

type
  ///  <summary>
  ///    Represents a connection to a message channel for sending
  ///    messages.
  ///  </summary>
  THChannelConnection = uint32;

  ///  <summary>
  ///     This record is returned from a call to SendMessage() to indicate
  ///     if the message was successfully sent, and to return any response
  ///     value.
  ///  </summary>
  TMessageResponse = record
    Sent: boolean;
    ParamA: NativeUInt;
    ParamB: NativeUInt;
  end;

  ///  <summary>
  ///    A record type representing a communication message between
  ///    subsystems.
  ///  </summary>
  PMessage = ^TMessage;
  TMessage = record
    MessageValue: uint32;
    ParamA: NativeUInt;
    ParamB: NativeUInt;
    Original: PMessage;
    Handled: Boolean;
    LockResponse: procedure of object;
    UnlockResponse: procedure of object;
  end;

implementation

end.
