# chess-image

## Overview

Simple command line tool that makes a picture of a chess position.

## Usage

    chess-image -p "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -" -s 320 -o position.png
    chess-image --position="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -" --size=320 --output=position.png

## Compilation

chess-image is a Lazarus project, using the BGRABitmap library.

## Credit

chess-image uses the Montreal Chess font by Gary Katch.

![alt text](position.png)
