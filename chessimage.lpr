
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

  procedure TChessImageApp.DoRun;
  type
    TCorner = (TopLeft, TopRight, BottomLeft, BottomRight);
    TBorder = (Top, Left, Right, Bottom);
    TPiece = (Pawn, Knight, Bishop, Rook, Queen, King);
    TColor = (White, Black);
  const
    CDefaultPos = '8/8/8/8/8/8/8/8 w - -';
    CDefaultSize = 400;
    CDefaultName = 'image.png';
    CMaxSize = 2000;
  var
    LErrorMessage, LPos: string;
    LSize: integer;
    LFilename: TFilename;
    LCornerIm: array[TCorner] of TBGRABitmap;
    LBorderIm: array[TBorder] of TBGRABitmap;
    LPieceIm: array[TColor, TPiece, TColor] of TBGRABitmap;
    LSquareIm: array[TColor] of TBGRABitmap;
    LResult: TBGRABitmap;
    LX, LY, LI, LW: integer;
    LC: char;
    LSquareColor, LColor: TColor;
    LCorner: TCorner;
    LBorder: TBorder;
    LPiece: TPiece;
  begin
    WriteLn('ChessImage 0.1');
    
    LErrorMessage := CheckOptions('hp:s:o:', 'help position: size: output:');
    if LErrorMessage <> '' then
    begin
      ShowException(Exception.Create(LErrorMessage));
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

    LCornerIm[TopLeft] := TBGRABitmap.Create;
    LCornerIm[TopLeft].LoadFromResource('tlc');
    LCornerIm[TopRight] := TBGRABitmap.Create;
    LCornerIm[TopRight].LoadFromResource('trc');
    LCornerIm[BottomLeft] := TBGRABitmap.Create;
    LCornerIm[BottomLeft].LoadFromResource('blc');
    LCornerIm[BottomRight] := TBGRABitmap.Create;
    LCornerIm[BottomRight].LoadFromResource('brc');

    LBorderIm[Top] := TBGRABitmap.Create;
    LBorderIm[Top].LoadFromResource('tb');
    LBorderIm[Left] := TBGRABitmap.Create;
    LBorderIm[Left].LoadFromResource('lb');
    LBorderIm[Right] := TBGRABitmap.Create;
    LBorderIm[Right].LoadFromResource('rb');
    LBorderIm[Bottom] := TBGRABitmap.Create;
    LBorderIm[Bottom].LoadFromResource('bb');

    LPieceIm[Black, Bishop, Black] := TBGRABitmap.Create;
    LPieceIm[Black, Bishop, Black].LoadFromResource('bbb');
    LPieceIm[Black, Bishop, White] := TBGRABitmap.Create;
    LPieceIm[Black, Bishop, White].LoadFromResource('bbw');
    LPieceIm[Black, King, Black] := TBGRABitmap.Create;
    LPieceIm[Black, King, Black].LoadFromResource('bkb');
    LPieceIm[Black, King, White] := TBGRABitmap.Create;
    LPieceIm[Black, King, White].LoadFromResource('bkw');
    LPieceIm[Black, Knight, Black] := TBGRABitmap.Create;
    LPieceIm[Black, Knight, Black].LoadFromResource('bnb');
    LPieceIm[Black, Knight, White] := TBGRABitmap.Create;
    LPieceIm[Black, Knight, White].LoadFromResource('bnw');
    LPieceIm[Black, Pawn, Black] := TBGRABitmap.Create;
    LPieceIm[Black, Pawn, Black].LoadFromResource('bpb');
    LPieceIm[Black, Pawn, White] := TBGRABitmap.Create;
    LPieceIm[Black, Pawn, White].LoadFromResource('bpw');
    LPieceIm[Black, Queen, Black] := TBGRABitmap.Create;
    LPieceIm[Black, Queen, Black].LoadFromResource('bqb');
    LPieceIm[Black, Queen, White] := TBGRABitmap.Create;
    LPieceIm[Black, Queen, White].LoadFromResource('bqw');
    LPieceIm[Black, Rook, Black] := TBGRABitmap.Create;
    LPieceIm[Black, Rook, Black].LoadFromResource('brb');
    LPieceIm[Black, Rook, White] := TBGRABitmap.Create;
    LPieceIm[Black, Rook, White].LoadFromResource('brw');

    LPieceIm[White, Bishop, Black] := TBGRABitmap.Create;
    LPieceIm[White, Bishop, Black].LoadFromResource('wbb');
    LPieceIm[White, Bishop, White] := TBGRABitmap.Create;
    LPieceIm[White, Bishop, White].LoadFromResource('wbw');
    LPieceIm[White, King, Black] := TBGRABitmap.Create;
    LPieceIm[White, King, Black].LoadFromResource('wkb');
    LPieceIm[White, King, White] := TBGRABitmap.Create;
    LPieceIm[White, King, White].LoadFromResource('wkw');
    LPieceIm[White, Knight, Black] := TBGRABitmap.Create;
    LPieceIm[White, Knight, Black].LoadFromResource('wnb');
    LPieceIm[White, Knight, White] := TBGRABitmap.Create;
    LPieceIm[White, Knight, White].LoadFromResource('wnw');
    LPieceIm[White, Pawn, Black] := TBGRABitmap.Create;
    LPieceIm[White, Pawn, Black].LoadFromResource('wpb');
    LPieceIm[White, Pawn, White] := TBGRABitmap.Create;
    LPieceIm[White, Pawn, White].LoadFromResource('wpw');
    LPieceIm[White, Queen, Black] := TBGRABitmap.Create;
    LPieceIm[White, Queen, Black].LoadFromResource('wqb');
    LPieceIm[White, Queen, White] := TBGRABitmap.Create;
    LPieceIm[White, Queen, White].LoadFromResource('wqw');
    LPieceIm[White, Rook, Black] := TBGRABitmap.Create;
    LPieceIm[White, Rook, Black].LoadFromResource('wrb');
    LPieceIm[White, Rook, White] := TBGRABitmap.Create;
    LPieceIm[White, Rook, White].LoadFromResource('wrw');

    LSquareIm[Black] := TBGRABitmap.Create;
    LSquareIm[Black].LoadFromResource('bs');
    LSquareIm[White] := TBGRABitmap.Create;
    LSquareIm[White].LoadFromResource('ws');

    LW := LSquareIm[White].Width;
    
    LResult := TBGRABitmap.Create(10 * LW, 10 * LW, BGRAWhite);

    LResult.PutImage(0, 0, LCornerIm[TopLeft], dmDrawWithTransparency);
    LResult.PutImage(LW * 9, 0, LCornerIm[TopRight], dmDrawWithTransparency);
    LResult.PutImage(0, LW * 9, LCornerIm[BottomLeft], dmDrawWithTransparency);
    LResult.PutImage(LW * 9, LW * 9, LCornerIm[BottomRight], dmDrawWithTransparency);

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
      LC := LPos[LI];
      if not (LC in ['/', '1'..'8', 'P', 'N', 'B', 'R', 'Q', 'K', 'p',
        'n', 'b', 'r', 'q', 'k']) then
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
              LSquareColor := White
            else
              LSquareColor := Black;
            LResult.PutImage(LW * LX, LW * (9 - LY), LSquareIm[LSquareColor],
              dmDrawWithTransparency);
            Inc(LX);
            Dec(LC);
          end;
        else
        begin
          if (LX + LY) mod 2 = 1 then
            LSquareColor := White
          else
            LSquareColor := Black;
          case LC of
            'P': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[White, Pawn, LSquareColor], dmDrawWithTransparency);
            'N': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[White, Knight, LSquareColor], dmDrawWithTransparency);
            'B': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[White, Bishop, LSquareColor], dmDrawWithTransparency);
            'R': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[White, Rook, LSquareColor], dmDrawWithTransparency);
            'Q': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[White, Queen, LSquareColor], dmDrawWithTransparency);
            'K': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[White, King, LSquareColor], dmDrawWithTransparency);
            'p': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[Black, Pawn, LSquareColor], dmDrawWithTransparency);
            'n': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[Black, Knight, LSquareColor], dmDrawWithTransparency);
            'b': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[Black, Bishop, LSquareColor], dmDrawWithTransparency);
            'r': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[Black, Rook, LSquareColor], dmDrawWithTransparency);
            'q': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[Black, Queen, LSquareColor], dmDrawWithTransparency);
            'k': LResult.PutImage(LW * LX, LW * (9 - LY),
                LPieceIm[Black, King, LSquareColor], dmDrawWithTransparency);
          end;
          Inc(LX);
        end;
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
        for LSquareColor := Low(TColor) to High(TColor) do
          LPieceIm[LColor, LPiece, LSquareColor].Free;

    LSquareIm[Black].Free;
    LSquareIm[White].Free;

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
    WriteLn('Usage: ', ExeName, ' -h');
    WriteLn('-p <fen> or --position=<fen>');
    WriteLn('-s <size> or --size=<size>');
    WriteLn('-o <file> or --output=<file>');
  end;

var
  Application: TChessImageApp;

begin
  Application := TChessImageApp.Create(nil);
  Application.Title:='ChessImage';
  Application.Run;
  Application.Free;
end.
