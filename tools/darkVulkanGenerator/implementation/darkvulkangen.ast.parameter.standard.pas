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
unit darkvulkangen.ast.parameter.standard;

interface
uses
  darkIO.streams,
  darkvulkangen.ast,
  darkvulkangen.ast.node.standard;

type
  TdvParameter = class( TdvASTNode, IdvParameter )
  private
    fProtection: TParameterProtection;
    fTypedSymbol: IdvTypedSymbol;
  private
    function getTypedSymbol: IdvTypedSymbol;
    function getProtection: TParameterProtection;
    procedure setProtection( value: TParameterProtection );
    function AsString: string;
  protected
    function InsertChild( node: IdvASTNode ): IdvASTNode; override;
    function WriteToStream( Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32 ): boolean; override;
  public
    constructor Create( name: string; datatype: string; Protection: TParameterProtection = TParameterProtection.ppNone ); reintroduce;
    destructor Destroy; override;
  end;

implementation
uses
  darkvulkangen.ast.typedsymbol.standard,
  darkLog;

{ TdvParameter }

function TdvParameter.AsString: string;
begin
  case fProtection of
    ppOut: Result := 'out ';
    ppIn: Result := 'const ';
    ppVar: Result := 'var ';
    else begin
      Result := '';
    end;
  end;
  Result := Result + fTypedSymbol.AsString;
end;

constructor TdvParameter.Create( Name: string; Datatype: string; Protection: TParameterProtection = TParameterProtection.ppNone );
begin
   inherited Create;
   fTypedSymbol := TdvTypedSymbol.Create( Name, Datatype );
   fProtection := Protection;
end;

destructor TdvParameter.Destroy;
begin
  fTypedSymbol := nil;
  inherited Destroy;
end;

function TdvParameter.getProtection: TParameterProtection;
begin
  Result := fProtection;
end;

function TdvParameter.getTypedSymbol: IdvTypedSymbol;
begin
  Result := fTypedSymbol;
end;

function TdvParameter.InsertChild(node: IdvASTNode): IdvASTNode;
begin
  Result := nil;
  Log.Insert(ENoChildren,TLogSeverity.lsError);
end;

procedure TdvParameter.setProtection(value: TParameterProtection);
begin
  fProtection := Value;
end;

function TdvParameter.WriteToStream(Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32): boolean;
begin
  Stream.WriteString(AsString,UnicodeFormat);
  Result := True;
end;

end.

