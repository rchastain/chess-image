
program chessimage;

{$MODE OBJFPC}{$H+}
{$R images.res}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  CThreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, BGRABitmap, BGRABitmapTypes;

type
  TChessImage = (
    TopLeftCorner,
    TopBorder,
    TopRightCorner,
    LeftBorder,
    RightBorder,
    BottomLeftCorner,
    BottomBorder,
    BottomRightCorner,
    WhitePawnWhite,
    WhiteKnightWhite,
    WhiteBishopWhite,
    WhiteRookWhite,
    WhiteQueenWhite,
    WhiteKingWhite,
    WhitePawnBlack,
    WhiteKnightBlack,
    WhiteBishopBlack,
    WhiteRookBlack,
    WhiteQueenBlack,
    WhiteKingBlack,
    BlackPawnWhite,
    BlackKnightWhite,
    BlackBishopWhite,
    BlackRookWhite,
    BlackQueenWhite,
    BlackKingWhite,
    BlackPawnBlack,
    BlackKnightBlack,
    BlackBishopBlack,
    BlackRookBlack,
    BlackQueenBlack,
    BlackKingBlack,
    //WhiteSquare,
    BlackSquare
  );

type
  TChessImageMaker = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

procedure TChessImageMaker.DoRun;
const
  CDefaultPos = '8/8/8/8/8/8/8/8 w - -';
  CDefaultSize = 400;
  CDefaultName = 'image.png';
  CMaxSize = 2000;
var
  LErrMsg, LPos: string;
  LSize: integer;
  LFilename: TFilename;
  LImages: array[TChessImage] of TBGRABitmap;
  LResult: TBGRABitmap;
  LX, LY, LI, LW: integer;
  LC: char;
begin
  WriteLn('ChessImage 0.1');
  LErrMsg := CheckOptions('hp:s:o:', 'help position: size: output:');
  if LErrMsg <> '' then begin
    ShowException(Exception.Create(LErrMsg));
    Terminate;
    Exit;
  end;
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;
  
  if HasOption('p', 'position') then LPos := GetOptionValue('p', 'position') else LPos := CDefaultPos;
  if HasOption('s', 'size') then LSize := StrToInt(GetOptionValue('s', 'size')) else LSize := CDefaultSize;
  if HasOption('o', 'output') then LFilename := GetOptionValue('o', 'output') else LFilename := CDefaultName;

  if LSize > CMaxSize then
    LSize := CMaxSize;

  LImages[BottomBorder]      := TBGRABitmap.Create; LImages[BottomBorder].LoadFromResource('bb');
  LImages[BlackBishopBlack]  := TBGRABitmap.Create; LImages[BlackBishopBlack].LoadFromResource('bbb');
  LImages[BlackBishopWhite]  := TBGRABitmap.Create; LImages[BlackBishopWhite].LoadFromResource('bbw');
  LImages[BlackKingBlack]    := TBGRABitmap.Create; LImages[BlackKingBlack].LoadFromResource('bkb');
  LImages[BlackKingWhite]    := TBGRABitmap.Create; LImages[BlackKingWhite].LoadFromResource('bkw');
  LImages[BottomLeftCorner]  := TBGRABitmap.Create; LImages[BottomLeftCorner].LoadFromResource('blc');
  LImages[BlackKnightBlack]  := TBGRABitmap.Create; LImages[BlackKnightBlack].LoadFromResource('bnb');
  LImages[BlackKnightWhite]  := TBGRABitmap.Create; LImages[BlackKnightWhite].LoadFromResource('bnw');
  LImages[BlackPawnBlack]    := TBGRABitmap.Create; LImages[BlackPawnBlack].LoadFromResource('bpb');
  LImages[BlackPawnWhite]    := TBGRABitmap.Create; LImages[BlackPawnWhite].LoadFromResource('bpw');
  LImages[BlackQueenBlack]   := TBGRABitmap.Create; LImages[BlackQueenBlack].LoadFromResource('bqb');
  LImages[BlackQueenWhite]   := TBGRABitmap.Create; LImages[BlackQueenWhite].LoadFromResource('bqw');
  LImages[BlackRookBlack]    := TBGRABitmap.Create; LImages[BlackRookBlack].LoadFromResource('brb');
  LImages[BottomRightCorner] := TBGRABitmap.Create; LImages[BottomRightCorner].LoadFromResource('brc');
  LImages[BlackRookWhite]    := TBGRABitmap.Create; LImages[BlackRookWhite].LoadFromResource('brw');
  LImages[BlackSquare]       := TBGRABitmap.Create; LImages[BlackSquare].LoadFromResource('bs');
  LImages[LeftBorder]        := TBGRABitmap.Create; LImages[LeftBorder].LoadFromResource('lb');
  LImages[RightBorder]       := TBGRABitmap.Create; LImages[RightBorder].LoadFromResource('rb');
  LImages[TopBorder]         := TBGRABitmap.Create; LImages[TopBorder].LoadFromResource('tb');
  LImages[TopLeftCorner]     := TBGRABitmap.Create; LImages[TopLeftCorner].LoadFromResource('tlc');
  LImages[TopRightCorner]    := TBGRABitmap.Create; LImages[TopRightCorner].LoadFromResource('trc');
  LImages[WhiteBishopBlack]  := TBGRABitmap.Create; LImages[WhiteBishopBlack].LoadFromResource('wbb');
  LImages[WhiteBishopWhite]  := TBGRABitmap.Create; LImages[WhiteBishopWhite].LoadFromResource('wbw');
  LImages[WhiteKingBlack]    := TBGRABitmap.Create; LImages[WhiteKingBlack].LoadFromResource('wkb');
  LImages[WhiteKingWhite]    := TBGRABitmap.Create; LImages[WhiteKingWhite].LoadFromResource('wkw');
  LImages[WhiteKnightBlack]  := TBGRABitmap.Create; LImages[WhiteKnightBlack].LoadFromResource('wnb');
  LImages[WhiteKnightWhite]  := TBGRABitmap.Create; LImages[WhiteKnightWhite].LoadFromResource('wnw');
  LImages[WhitePawnBlack]    := TBGRABitmap.Create; LImages[WhitePawnBlack].LoadFromResource('wpb');
  LImages[WhitePawnWhite]    := TBGRABitmap.Create; LImages[WhitePawnWhite].LoadFromResource('wpw');
  LImages[WhiteQueenBlack]   := TBGRABitmap.Create; LImages[WhiteQueenBlack].LoadFromResource('wqb');
  LImages[WhiteQueenWhite]   := TBGRABitmap.Create; LImages[WhiteQueenWhite].LoadFromResource('wqw');
  LImages[WhiteRookBlack]    := TBGRABitmap.Create; LImages[WhiteRookBlack].LoadFromResource('wrb');
  LImages[WhiteRookWhite]    := TBGRABitmap.Create; LImages[WhiteRookWhite].LoadFromResource('wrw');
  //LImages[WhiteSquare]       := TBGRABitmap.Create; LImages[WhiteSquare].LoadFromResource('ws');
  
  LW := LImages[BottomBorder].Width;
  
  LResult := TBGRABitmap.Create(10 * LW, 10 * LW, BGRAWhite);
  LResult.PutImage(0, 0, LImages[TopLeftCorner], dmDrawWithTransparency);
  for LI := 1 to 8 do LResult.PutImage(LW * LI, 0, LImages[TopBorder], dmDrawWithTransparency);
  LResult.PutImage(LW * 9, 0, LImages[TopRightCorner], dmDrawWithTransparency);
  for LI := 1 to 8 do LResult.PutImage(0, LW * LI, LImages[LeftBorder], dmDrawWithTransparency);
  for LI := 1 to 8 do LResult.PutImage(LW * 9, LW * LI, LImages[RightBorder], dmDrawWithTransparency);
  LResult.PutImage(0, LW * 9, LImages[BottomLeftCorner], dmDrawWithTransparency);
  for LI := 1 to 8 do LResult.PutImage(LW * LI, LW * 9, LImages[BottomBorder], dmDrawWithTransparency);
  LResult.PutImage(LW * 9, LW * 9, LImages[BottomRightCorner], dmDrawWithTransparency);

  LX := 1;
  LY := 8;
  LI := 1;
  while LI <= Length(LPos) do
  begin
    LC := LPos[LI];
    if not (LC in ['/', '1'..'8', 'P', 'N', 'B', 'R', 'Q', 'K', 'p', 'n', 'b', 'r', 'q', 'k']) then
      Break;
    case LC of
      '/':
        begin
          LX := 1;
          Dec(LY);
        end;
      '1'..'8':
        while LC > '0' do
        begin
          if (LX + LY) mod 2 = 1 then
            //LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteSquare], dmDrawWithTransparency)
          else
            LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackSquare], dmDrawWithTransparency);
          Inc(LX);
          Dec(LC);
        end;
    else
      begin
        if (LX + LY) mod 2 = 1 then
          case LC of
            'P': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhitePawnWhite],   dmDrawWithTransparency);
            'N': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteKnightWhite], dmDrawWithTransparency);
            'B': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteBishopWhite], dmDrawWithTransparency);
            'R': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteRookWhite],   dmDrawWithTransparency);
            'Q': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteQueenWhite],  dmDrawWithTransparency);
            'K': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteKingWhite],   dmDrawWithTransparency);
            'p': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackPawnWhite],   dmDrawWithTransparency);
            'n': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackKnightWhite], dmDrawWithTransparency);
            'b': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackBishopWhite], dmDrawWithTransparency);
            'r': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackRookWhite],   dmDrawWithTransparency);
            'q': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackQueenWhite],  dmDrawWithTransparency);
            'k': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackKingWhite], dmDrawWithTransparency);
          end
        else
          case LC of
            'P': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhitePawnBlack],   dmDrawWithTransparency);
            'N': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteKnightBlack], dmDrawWithTransparency);
            'B': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteBishopBlack], dmDrawWithTransparency);
            'R': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteRookBlack],   dmDrawWithTransparency);
            'Q': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteQueenBlack],  dmDrawWithTransparency);
            'K': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[WhiteKingBlack],   dmDrawWithTransparency);
            'p': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackPawnBlack],   dmDrawWithTransparency);
            'n': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackKnightBlack], dmDrawWithTransparency);
            'b': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackBishopBlack], dmDrawWithTransparency);
            'r': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackRookBlack],   dmDrawWithTransparency);
            'q': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackQueenBlack],  dmDrawWithTransparency);
            'k': LResult.PutImage(LW * LX, LW * (9 - LY), LImages[BlackKingBlack], dmDrawWithTransparency);
          end;
        Inc(LX);
      end;
    end;
    Inc(LI);
  end;
  
  BGRAReplace(LResult, LResult.Resample(LSize, LSize, rmFineResample) as TBGRABitmap);
  
  LResult.SaveToFile(LFilename);
 
  LImages[BottomBorder].Free;
  LImages[BlackBishopBlack].Free;
  LImages[BlackBishopWhite].Free;
  LImages[BlackKingBlack].Free;
  LImages[BlackKingWhite].Free;
  LImages[BottomLeftCorner].Free;
  LImages[BlackKnightBlack].Free;
  LImages[BlackKnightWhite].Free;
  LImages[BlackPawnBlack].Free;
  LImages[BlackPawnWhite].Free;
  LImages[BlackQueenBlack].Free;
  LImages[BlackQueenWhite].Free;
  LImages[BlackRookBlack].Free;
  LImages[BottomRightCorner].Free;
  LImages[BlackRookWhite].Free;
  LImages[BlackSquare].Free;
  LImages[LeftBorder].Free;
  LImages[RightBorder].Free;
  LImages[TopBorder].Free;
  LImages[TopLeftCorner].Free;
  LImages[TopRightCorner].Free;
  LImages[WhiteBishopBlack].Free;
  LImages[WhiteBishopWhite].Free;
  LImages[WhiteKingBlack].Free;
  LImages[WhiteKingWhite].Free;
  LImages[WhiteKnightBlack].Free;
  LImages[WhiteKnightWhite].Free;
  LImages[WhitePawnBlack].Free;
  LImages[WhitePawnWhite].Free;
  LImages[WhiteQueenBlack].Free;
  LImages[WhiteQueenWhite].Free;
  LImages[WhiteRookBlack].Free;
  LImages[WhiteRookWhite].Free;
  //LImages[WhiteSquare].Free;
  LResult.Free;
  
  Terminate;
end;

constructor TChessImageMaker.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TChessImageMaker.Destroy;
begin
  inherited Destroy;
end;

procedure TChessImageMaker.WriteHelp;
begin
  WriteLn('Usage: ', ExeName, ' -h');
  WriteLn('-p <fen> or --position=<fen>');
  WriteLn('-s <size> or --size=<size>');
  WriteLn('-o <file> or --output=<file>');
end;

var
  Application: TChessImageMaker;
  
begin
  Application := TChessImageMaker.Create(nil);
  Application.Title:='ChessImage';
  Application.Run;
  Application.Free;
end.
