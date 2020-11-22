# chess-image

## Overview

Simple command line tool that makes a picture of a chess position.

## Usage

    chess-image --position="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -" --size=320 --output=position.png
    chess-image --position="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -" --size=320 --output=position.png --font=adventurer
    chess-image --position="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -" --size=320 --output=position.png --font=adventurer --coordinates
    chess-image -p "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -" -s 320 -o position.png -f adventurer -c

## Compilation

*chess-image* is a Lazarus project, using the [BGRABitmap](https://github.com/bgrabitmap/bgrabitmap) library.

## Credit

*chess-image* uses *Chess Montreal* font by Gary Katch and *Chess Adventurer* font by Armando Hernandez Marroquin.

![alt text](position.png)
