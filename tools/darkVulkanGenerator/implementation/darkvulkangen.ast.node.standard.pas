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
unit darkvulkangen.ast.node.standard;

interface
uses
  darkLog,
  darkCollections.types,
  darkIO.streams,
  darkvulkangen.ast;

type
  ENoChildren = class(ELogEntry);
  EUnsupportedChildType = class(ELogEntry);

const
  cIndentationStep = 2;

type
  TdvASTNode = class( TInterfacedObject, IdvASTNode )
  private
    fBeforeNode: IdvASTNode;
    fAfterNode: IdvASTNode;
    fChildren: ICollection;
    fLineBreaks: uint32;
  protected //- IdvASTNode -//
    function getBeforeNode: IdvASTNode;
    function getAfterNode: IdvASTNode;
    function getLineBreaks: uint32;
    procedure setLineBreaks( value: uint32 );
    function getChildCount: uint32;
    function getChild( idx: uint32 ): IdvASTNode;
    function LineBreaks: string;
    function WriteBeforeNode( Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32 ): boolean;
    function WriteAfterNode( Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32 ): boolean;
    function InsertChild( node: IdvASTNode ): IdvASTNode; virtual;
    function WriteToStream( Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32 ): boolean; virtual;
    function getIndentation( Indentation: uint32 ): string;
  public
    constructor Create( IsSpecialNode: boolean = False ); reintroduce;
    destructor Destroy; override;
  end;

implementation
uses
  darkCollections.list;

type
  IASTNodeList = {$ifdef fpc} specialize {$endif} IList<IdvASTNode>;
  TASTNodeList = {$ifdef fpc} specialize {$endif} TList<IdvASTNode>;

{ TdvASTNode }

constructor TdvASTNode.Create( IsSpecialNode: boolean );
begin
  inherited Create;
  if not IsSpecialNode then begin
    fBeforeNode := TdvASTNode.Create(True);
    fAfterNode := TdvASTNode.Create(True);
  end else begin
    fBeforeNode := nil;
    fAfterNode := nil;
  end;
  fLineBreaks := 1;
  fChildren := TASTNodeList.Create(128,True,False);
end;

destructor TdvASTNode.Destroy;
begin
  fBeforeNode := nil;
  fAfterNode := nil;
  fChildren := nil;
  inherited Destroy;
end;

function TdvASTNode.getAfterNode: IdvASTNode;
begin
  Result := fAfterNode;
end;

function TdvASTNode.getBeforeNode: IdvASTNode;
begin
  Result := fBeforeNode;
end;

function TdvASTNode.getChild(idx: uint32): IdvASTNode;
begin
  Result := IASTNodeList(fChildren).Items[idx];
end;

function TdvASTNode.getChildCount: uint32;
begin
  Result := IASTNodeList(fChildren).Count;
end;

function TdvASTNode.getIndentation(Indentation: uint32): string;
var
  idx: uint32;
begin
  Result := '';
  if Indentation=0 then begin
    exit;
  end;
  for idx := 0 to pred(Indentation) do begin
    Result := Result + ' ';
  end;
end;

function TdvASTNode.getLineBreaks: uint32;
begin
  Result := fLineBreaks;
end;

function TdvASTNode.InsertChild(node: IdvASTNode): IdvASTNode;
begin
  IASTNodeList(fChildren).Add(node);
  Result := node;
end;

procedure TdvASTNode.setLineBreaks(value: uint32);
begin
  fLineBreaks := value;
end;

function TdvASTNode.LineBreaks: string;
var
  idx: uint32;
begin
  Result := '';
  if fLineBreaks=0 then begin
    exit;
  end else begin
    for idx := 0 to pred(fLineBreaks) do begin
      Result := Result + sLineBreak;
    end;
  end;
end;

function TdvASTNode.WriteAfterNode(Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32): boolean;
begin
  Result := True;
  if assigned(fAfterNode) then begin
    Result := fAfterNode.WriteToStream(Stream,UnicodeFormat,Indentation);
  end;
end;

function TdvASTNode.WriteBeforeNode(Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32): boolean;
begin
  Result := True;
  if assigned(fBeforeNode) then begin
    Result := fBeforeNode.WriteToStream(Stream,UnicodeFormat,Indentation);
  end;
end;

function TdvASTNode.WriteToStream(Stream: IUnicodeStream; UnicodeFormat: TUnicodeFormat; Indentation: uint32): boolean;
var
  idx: uint32;
begin
  Result := False;
  if not WriteBeforeNode(Stream,UnicodeFormat,Indentation) then begin
    exit;
  end;
  if getChildCount=0 then begin
    Result := True;
    exit;
  end;
  for idx := 0 to pred(getChildCount) do begin
    if not getChild(idx).WriteToStream(Stream,UnicodeFormat,Indentation) then begin
      exit;
    end;
  end;
  if not WriteAfterNode(Stream,UnicodeFormat,Indentation) then begin
    exit;
  end;
  Result := True;
end;

initialization
  Log.Register( ENoChildren, 'Node does not support insertion of child nodes.' );
  Log.Register( EUnsupportedChildType, 'Node does not support this child type.' );

end.