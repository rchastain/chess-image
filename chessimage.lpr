
program chessimage;

{$MODE OBJFPC}{$H+}
{$R images.res}

uses
{$IFDEF UNIX}{$IFDEF USECTHREADS}
  CThreads,
{$ENDIF}{$ENDIF}
  Classes,
  SysUtils,
  CustApp,
  BGRABitmap,
  BGRABitmapTypes;

type
  TChessImageApp = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

const
  CDefaultPos         = '8/8/8/8/8/8/8/8 w - -';
  CDefaultSize        = 400;
  CMaxSize            = 2000;
  CDefaultName        = 'image.png';
  CDefaultFont        = 'montreal';
  CDefaultCoordinates = FALSE;

procedure TChessImageApp.DoRun;
type
  TCorner = (TopLeft, TopRight, BottomLeft, BottomRight);
  TBorder = (Top, Left, Right, Bottom);
  TPiece  = (Pawn, Knight, Bishop, Rook, Queen, King);
  TColor  = (White, Black);
var
  LCornerIm       : array[TCorner] of TBGRABitmap;
  LBorderIm       : array[TBorder] of TBGRABitmap;
  LPieceIm        : array[TColor, TPiece, TColor] of TBGRABitmap;
  LSquareIm       : array[TColor] of TBGRABitmap;
  LLeftCoordIm    : array[1..8] of TBGRABitmap;
  LBottomCoordIm  : array[1..8] of TBGRABitmap;
  LResult         : TBGRABitmap;
  LSqColor, LColor: TColor;
  LCorner         : TCorner;
  LBorder         : TBorder;
  LPiece          : TPiece;
  LErrMsg, LPos   : string;
  LFilename       : TFilename;
  LSize           : integer;
  LFont           : string;
  LCoordinates    : boolean;
  LX, LY, LI, LW  : integer;
  LChar           : char;
function FSquareColor: TColor;
begin
  if (LX + LY) mod 2 = 1 then result := White else result := Black;
end;
begin
  WriteLn('ChessImage 0.2.1');
  
  LErrMsg := CheckOptions('hp:s:o:f:c', 'help position: size: output: font: coordinates');
  if (LErrMsg <> '') or (ParamCount = 0) then
  begin
    if LErrMsg <> '' then
      WriteLn(LErrMsg);
    WriteHelp;
    Terminate;
    Exit;
  end;
  
  if HasOption('h', 'help') then
  begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if HasOption('p', 'position') then
    LPos := GetOptionValue('p', 'position')
  else
    LPos := CDefaultPos;
  
  if HasOption('s', 'size') then
    LSize := StrToInt(GetOptionValue('s', 'size'))
  else
    LSize := CDefaultSize;
  if LSize > CMaxSize then
    LSize := CMaxSize;
    
  if HasOption('o', 'output') then
    LFilename := GetOptionValue('o', 'output')
  else
    LFilename := CDefaultName;

  if HasOption('f', 'font') then
    LFont := GetOptionValue('f', 'font')
  else
    LFont := CDefaultFont;
  if  (LFont <> 'adventurer')
  and (LFont <> 'montreal') then
  begin
    WriteLn('Possible values for the font parameter: adventurer, montreal');
    LFont := CDefaultFont;
  end;

  LCoordinates := HasOption('c', 'coordinates') or CDefaultCoordinates;

  LCornerIm[TopLeft]     := TBGRABitmap.Create; LCornerIm[TopLeft].LoadFromResource(LFont + '_tlc');
  LCornerIm[TopRight]    := TBGRABitmap.Create; LCornerIm[TopRight].LoadFromResource(LFont + '_trc');
  LCornerIm[BottomLeft]  := TBGRABitmap.Create; LCornerIm[BottomLeft].LoadFromResource(LFont + '_blc');
  LCornerIm[BottomRight] := TBGRABitmap.Create; LCornerIm[BottomRight].LoadFromResource(LFont + '_brc');

  LBorderIm[Top]    := TBGRABitmap.Create; LBorderIm[Top].LoadFromResource(LFont + '_tb');
  LBorderIm[Left]   := TBGRABitmap.Create; LBorderIm[Left].LoadFromResource(LFont + '_lb');
  LBorderIm[Right]  := TBGRABitmap.Create; LBorderIm[Right].LoadFromResource(LFont + '_rb');
  LBorderIm[Bottom] := TBGRABitmap.Create; LBorderIm[Bottom].LoadFromResource(LFont + '_bb');

  LPieceIm[Black, Bishop, Black] := TBGRABitmap.Create; LPieceIm[Black, Bishop, Black].LoadFromResource(LFont + '_bbb');
  LPieceIm[Black, Bishop, White] := TBGRABitmap.Create; LPieceIm[Black, Bishop, White].LoadFromResource(LFont + '_bbw');
  LPieceIm[Black, King, Black]   := TBGRABitmap.Create; LPieceIm[Black, King, Black].LoadFromResource(LFont + '_bkb');
  LPieceIm[Black, King, White]   := TBGRABitmap.Create; LPieceIm[Black, King, White].LoadFromResource(LFont + '_bkw');
  LPieceIm[Black, Knight, Black] := TBGRABitmap.Create; LPieceIm[Black, Knight, Black].LoadFromResource(LFont + '_bnb');
  LPieceIm[Black, Knight, White] := TBGRABitmap.Create; LPieceIm[Black, Knight, White].LoadFromResource(LFont + '_bnw');
  LPieceIm[Black, Pawn, Black]   := TBGRABitmap.Create; LPieceIm[Black, Pawn, Black].LoadFromResource(LFont + '_bpb');
  LPieceIm[Black, Pawn, White]   := TBGRABitmap.Create; LPieceIm[Black, Pawn, White].LoadFromResource(LFont + '_bpw');
  LPieceIm[Black, Queen, Black]  := TBGRABitmap.Create; LPieceIm[Black, Queen, Black].LoadFromResource(LFont + '_bqb');
  LPieceIm[Black, Queen, White]  := TBGRABitmap.Create; LPieceIm[Black, Queen, White].LoadFromResource(LFont + '_bqw');
  LPieceIm[Black, Rook, Black]   := TBGRABitmap.Create; LPieceIm[Black, Rook, Black].LoadFromResource(LFont + '_brb');
  LPieceIm[Black, Rook, White]   := TBGRABitmap.Create; LPieceIm[Black, Rook, White].LoadFromResource(LFont + '_brw');

  LPieceIm[White, Bishop, Black] := TBGRABitmap.Create; LPieceIm[White, Bishop, Black].LoadFromResource(LFont + '_wbb');
  LPieceIm[White, Bishop, White] := TBGRABitmap.Create; LPieceIm[White, Bishop, White].LoadFromResource(LFont + '_wbw');
  LPieceIm[White, King, Black]   := TBGRABitmap.Create; LPieceIm[White, King, Black].LoadFromResource(LFont + '_wkb');
  LPieceIm[White, King, White]   := TBGRABitmap.Create; LPieceIm[White, King, White].LoadFromResource(LFont + '_wkw');
  LPieceIm[White, Knight, Black] := TBGRABitmap.Create; LPieceIm[White, Knight, Black].LoadFromResource(LFont + '_wnb');
  LPieceIm[White, Knight, White] := TBGRABitmap.Create; LPieceIm[White, Knight, White].LoadFromResource(LFont + '_wnw');
  LPieceIm[White, Pawn, Black]   := TBGRABitmap.Create; LPieceIm[White, Pawn, Black].LoadFromResource(LFont + '_wpb');
  LPieceIm[White, Pawn, White]   := TBGRABitmap.Create; LPieceIm[White, Pawn, White].LoadFromResource(LFont + '_wpw');
  LPieceIm[White, Queen, Black]  := TBGRABitmap.Create; LPieceIm[White, Queen, Black].LoadFromResource(LFont + '_wqb');
  LPieceIm[White, Queen, White]  := TBGRABitmap.Create; LPieceIm[White, Queen, White].LoadFromResource(LFont + '_wqw');
  LPieceIm[White, Rook, Black]   := TBGRABitmap.Create; LPieceIm[White, Rook, Black].LoadFromResource(LFont + '_wrb');
  LPieceIm[White, Rook, White]   := TBGRABitmap.Create; LPieceIm[White, Rook, White].LoadFromResource(LFont + '_wrw');

  LSquareIm[Black] := TBGRABitmap.Create;
  LSquareIm[Black].LoadFromResource(LFont + '_bs');
  LSquareIm[White] := TBGRABitmap.Create;
  LSquareIm[White].LoadFromResource(LFont + '_ws');

  LW := LSquareIm[White].Width;

  for LI := 1 to 8 do
  begin
    LLeftCoordIm[LI]   := TBGRABitmap.Create; LLeftCoordIm[LI].LoadFromResource(LFont + '_lb_' + IntToStr(LI));
    LBottomCoordIm[LI] := TBGRABitmap.Create; LBottomCoordIm[LI].LoadFromResource(LFont + '_bb_' + Chr(LI + Ord('a') - 1));
  end;

  LResult := TBGRABitmap.Create(10 * LW, 10 * LW, BGRAWhite);

  LResult.PutImage(0, 0, LCornerIm[TopLeft], dmDrawWithTransparency);
  LResult.PutImage(LW * 9, 0, LCornerIm[TopRight], dmDrawWithTransparency);
  LResult.PutImage(0, LW * 9, LCornerIm[BottomLeft], dmDrawWithTransparency);
  LResult.PutImage(LW * 9, LW * 9, LCornerIm[BottomRight], dmDrawWithTransparency);

  if LCoordinates then
    for LI := 1 to 8 do
    begin
      LResult.PutImage(LW * LI, 0, LBorderIm[Top], dmDrawWithTransparency);
      LResult.PutImage(0, LW * LI, LLeftCoordIm[9 - LI], dmDrawWithTransparency);
      LResult.PutImage(LW * 9, LW * LI, LBorderIm[Right], dmDrawWithTransparency);
      LResult.PutImage(LW * LI, LW * 9, LBottomCoordIm[LI], dmDrawWithTransparency);
    end else
      for LI := 1 to 8 do
      begin
        LResult.PutImage(LW * LI, 0, LBorderIm[Top], dmDrawWithTransparency);
        LResult.PutImage(0, LW * LI, LBorderIm[Left], dmDrawWithTransparency);
        LResult.PutImage(LW * 9, LW * LI, LBorderIm[Right], dmDrawWithTransparency);
        LResult.PutImage(LW * LI, LW * 9, LBorderIm[Bottom], dmDrawWithTransparency);
      end;

  LX := 1;
  LY := 8;
  LI := 1;
  while LI <= Length(LPos) do
  begin
    LChar := LPos[LI];
    case LChar of
      '/':
        begin
          LX := 1;
          Dec(LY);
        end;
      '1'..'8':
        while LChar > '0' do
        begin
          LResult.PutImage(LW * LX, LW * (9 - LY), LSquareIm[FSquareColor], dmDrawWithTransparency);
          Inc(LX);
          Dec(LChar);
        end;
      'P': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[White, Pawn,   FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'N': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[White, Knight, FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'B': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[White, Bishop, FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'R': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[White, Rook,   FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'Q': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[White, Queen,  FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'K': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[White, King,   FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'p': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[Black, Pawn,   FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'n': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[Black, Knight, FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'b': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[Black, Bishop, FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'r': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[Black, Rook,   FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'q': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[Black, Queen,  FSquareColor], dmDrawWithTransparency); Inc(LX); end;
      'k': begin LResult.PutImage(LW * LX, LW * (9 - LY), LPieceIm[Black, King,   FSquareColor], dmDrawWithTransparency); Inc(LX); end;
    else
      Break;
    end;
    Inc(LI);
  end;

  BGRAReplace(LResult, LResult.Resample(LSize, LSize, rmFineResample) as TBGRABitmap);

  LResult.SaveToFile(LFilename);

  for LCorner := Low(TCorner) to High(TCorner) do
    LCornerIm[LCorner].Free;

  for LBorder := Low(TBorder) to High(TBorder) do
    LBorderIm[LBorder].Free;

  for LColor := Low(TColor) to High(TColor) do
    for LPiece := Low(TPiece) to High(TPiece) do
      for LSqColor := Low(TColor) to High(TColor) do
        LPieceIm[LColor, LPiece, LSqColor].Free;

  LSquareIm[White].Free;
  LSquareIm[Black].Free;

  for LI := 1 to 8 do
  begin
    LLeftCoordIm[LI].Free;
    LBottomCoordIm[LI].Free;
  end;

  LResult.Free;
  Terminate;
end;

constructor TChessImageApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException := True;
end;

destructor TChessImageApp.Destroy;
begin
  inherited Destroy;
end;

procedure TChessImageApp.WriteHelp;
begin
  WriteLn('Usage: chess-image [options]');
  WriteLn('Options:');
  WriteLn('  -h        or --help          : Show help');
  WriteLn('  -p <fen>  or --position=<fen>: The position you want an image of (mandatory)');
  WriteLn('  -s <size> or --size=<size>   : The size of the image (default: ', CDefaultSize, ')');
  WriteLn('  -o <file> or --output=<file> : The name to give to the file (default: ', CDefaultName, ')');
  WriteLn('  -f <file> or --font=<font>   : The font to use (available: adventurer, montreal; default: ', CDefaultFont, ')');
  WriteLn('  -c        or --coordinates   : Append coordinates around the board (default: ', CDefaultCoordinates, ')');
  WriteLn('Example:');
{$IFDEF UNIX}
  WriteLn('  ./chess-image -p "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR" -s 200');
{$ELSE}
  WriteLn('  chess-image -p "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR" -s 200');
{$ENDIF}
end;

var
  Application: TChessImageApp;

begin
  Application := TChessImageApp.Create(nil);
  Application.Title:='ChessImage';
  Application.Run;
  Application.Free;
end.

