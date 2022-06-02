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
    u64 gameID;
    address PlayerOne;
    address PlayerTwo;
    Winners winner;
    Players playerTurn;
    Players[u64;9] board;
}

u64 nbrOfGames;
u64 timeout = 300;

abi TicTacToe {
    fn save_player_position(player: u64, position: u64);
    fn get_player_position_filled(position: u64) -> u64;
    fn board_full() -> bool;
}

impl TicTacToe for Contract {
    
    fn test_function() -> bool {
        true
    }

    fn new_game() -> u256 gameId{
        Game memory game;
        game.playerTurn:: Players.PlayerOne;
        nrOfGames++;
        
    }

    // player 1 or 2, position is 1-9 (123/456/789)
    fn save_player_position(player: Player, position: u64) {
        store(sha256(("player_pos", position)), player);
    }

    // get the players position on the board, returns the player or empty
    // if the player returned value is None, that means it's empty
    fn get_player_position_filled(position: u64) -> player {
        get(sha256(("player_pos", position)));
    }
    
    fn calculate_winner() {


    }


    fn horizontal_alignement() -> Players winner {        
        if (
            (get_player_position_filled(1) == get_player_position_filled(2) && get_player_position_filled(2)  == get_player_position_filled(3) && get_player_position_filled(1) != Players.None)  
        ) {
            return get_player_position_filled(1);
        }
        elif (
            (get_player_position_filled(4) == get_player_position_filled(5) && get_player_position_filled(5)  == get_player_position_filled(6) && get_player_position_filled(4) != Players.None)
        ) {
            return get_player_position_filled(4);
        }
        elif (
            (get_player_position_filled(7) == get_player_position_filled(8) && get_player_position_filled(8)  == get_player_position_filled(9) && get_player_position_filled(7) != Players.None)
        ) {
            return get_player_position_filled(7);
        }
        return Players.None;
    }
    
    fn vertical_alignement() -> Players winner {
        if (
            (get_player_position_filled(1) == get_player_position_filled(4) && get_player_position_filled(4)  == get_player_position_filled(7) && get_player_position_filled(1) != Players.None)  
        ) {
            return get_player_position_filled(1);
        }
        elif (
            (get_player_position_filled(2) == get_player_position_filled(5) && get_player_position_filled(5)  == get_player_position_filled(8) && get_player_position_filled(2) != Players.None)
        ) {
            return get_player_position_filled(2);
        }
        elif (
            (get_player_position_filled(3) == get_player_position_filled(6) && get_player_position_filled(6)  == get_player_position_filled(9) && get_player_position_filled(3) != Players.None)
        ) {
            return get_player_position_filled(3);
        }
        return Players.None;
    }
    
    fn diagonal_alignement() -> Players winner {
        if (
            (get_player_position_filled(1) == get_player_position_filled(5) && get_player_position_filled(5)  == get_player_position_filled(9) && get_player_position_filled(1) != Players.None)  
        ) {
            return get_player_position_filled(1);
        }
        elif (
            (get_player_position_filled(3) == get_player_position_filled(5) && get_player_position_filled(5)  == get_player_position_filled(7) && get_player_position_filled(3) != Players.None)
        ) {
            return get_player_position_filled(2);
        }
        return Player.None;
    }

    fn board_full() -> bool{
        for (uint8 x = 0; x < 9; x++) {
            if (get_player_position_filled(x) == None) {
                return false;
            }
        }
        return true;
    }
}