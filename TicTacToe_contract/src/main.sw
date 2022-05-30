contract;

use std::*;
use core::*;
use std::storage::StorageMap;

enum Players {
        None : (), 
        PlayerOne : address, 
        PlayerTwo : address
    }

enum Winners {
    None : Players,
    PlayerOne : Players,
    PlayerTwo : Players,
    Draw : ()
}

struct Game{
    address PlayerOne;
    address PlayerTwo;
    Winners winner;
    Players playerTurn;
    Players[u64;9] board;
}

storage {
    games: StorageMap<(u256,bool),u256>,
    store(sha3( ( Players, player_pos ) ), bool)
}

u64 nbrOfGames;
u64 timeout = 300;

abi TicTacToe {
    fn test_function() -> bool;
}

impl TicTacToe for Contract {
    
    fn test_function() -> bool {
        true
    }

    fn newGame() -> u256 gameId{
        Game memory game;
        game.playerTurn:: Players.PlayerOne;
        nrOfGames++;
        
    }


    
}
