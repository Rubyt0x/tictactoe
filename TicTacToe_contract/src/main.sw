contract;

use core::*;
use std::storage::StorageMap;
use std::{
    address::Address,
    assert::assert,
    chain::auth::{AuthError, msg_sender},
    identity::Identity,
    result::*,
    revert::revert,
};

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
    gameId: u64,
    PlayerOne: address,
    PlayerTwo: address,
    winner: Winners,
    playerTurn: Player
}

u64 nbrOfGames = 0;
u64 timeout = 300;

abi TicTacToe {
    fn new_game() -> u64 gameID;
    fn save_player_position(player: u64, position: u64);
    fn get_player_position_filled(gameID: u64, position: u64) -> u64;
    fn calculate_winner(Players[u64;9] memory board) -> (Winners winner);
    fn horizontal_alignement() -> Players winner;
    fn vertical_alignement() -> Players winner;
    fn diagonal_alignement() -> Players winner;
    fn board_full() -> bool;
}

impl TicTacToe for Contract {

    fn new_game() -> u64{
        Game game;
        game.playerTurn:: Players.PlayerOne;
        nrOfGames++;
        return nrOfGames;
    }

    fn make_move(u64 gameID, position)->(bool success, string reason){
        if (gameID > nrOfGames) {
            return (false, "No such game exists.");
        }

        // Any winner other than `None` means that no more moves are allowed.
        if (game.winner != Winners.None) {
            return (false, "The game has already ended.");
        }

        // Only the player whose turn it is may make a move.
        if (msg_sender != getCurrentPlayer(gameID)) {
            // TODO: what if the player is not present in the game at all?
            return (false, "It is not your turn.");
        }

        // Players can only make moves in cells on the board that have not been played before.
        if (get_player_position_filled(gameID, position) != Players.None) {
            return (false, "There is already a mark at the given coordinates.");
        }

        // Now the move is recorded and the according event emitted.
        position = game.playerTurn;
        emit PlayerMadeMove(_gameId, msg_sender, position);

        // Check if there is a winner now that we have a new move.
        Winners winner = calculateWinner(gameID);
        if (winner != Winners.None) {
            // If there is a winner (can be a `Draw`) it must be recorded in the game and
            // the corresponding event must be emitted.
            game.winner = winner;
            log GameOver(gameID, winner);

            return (true, "The game is over.");
        }

        // A move was made and there is no winner yet.
        // The next player should make her move.
        nextPlayer(game);

        return (true, "");
    }
    

    // player 1 or 2, position is 1-9 (123/456/789)
    fn save_player_position(player: Player, position: u64) {
        store(sha256(("player_pos", position)), player);
    }

    // get the players position on the board, returns the player or empty
    // if the player returned value is None, that means it's empty
    fn get_player_position_filled(gameID: u64, position: u64) -> player {
        get(sha256(("player_pos", gameID, position)));
    }

    fn save_winner(gameID: u64, winner: Winners){
        store(sha256(("winner", gameID)),winner);
    }

    fn get_winner(gameID: u64) -> winner {
        get(sha256(("winner", gameID, winner)));
    }

    fn calculate_winner(gameID) -> (Winners winner){
        Players player = winnerInRow();
        if (player == Players.PlayerOne) {
            save_winner(gameID, Winners.PlayerOne);
            return Winners.PlayerOne;
        }
        if (player == Players.PlayerTwo) {
            save_winner(gameID, Winners.PlayerTwo);
            return Winners.PlayerTwo;
        }

        player = winnerInColumn();
        if (player == Players.PlayerOne) {
            save_winner(gameID, Winners.PlayerOne);
            return Winners.PlayerOne;
        }
        if (player == Players.PlayerTwo) {
            save_winner(gameID, Winners.PlayerTwo);
            return Winners.PlayerTwo;
        }

        player = winnerInDiagonal();
        if (player == Players.PlayerOne) {
            save_winner(gameID, Winners.PlayerOne);
            return Winners.PlayerOne;
        }
        if (player == Players.PlayerTwo) {
            save_winner(gameID, Winners.PlayerTwo);
            return Winners.PlayerTwo;
        }

        // If there is no winner and no more space on the board,
        // then it is a draw.
        if (isBoardFull()) {
            save_winner(gameID, Winners.Draw);
            return Winners.Draw;
        }
        save_winner(gameID, Winners.None);
        return Winners.None;

    }


    fn horizontal_alignement(gameID) -> Players winner {        
        if (
            (get_player_position_filled(gameID, 1) == get_player_position_filled(gameID, 2) && get_player_position_filled(gameID, 2)  == get_player_position_filled(gameID, 3) && get_player_position_filled(gameID, 1) != Players.None)  
        ) {
            return get_player_position_filled(gameID, 1);
        }
        elif (
            (get_player_position_filled(gameID, 4) == get_player_position_filled(gameID, 5) && get_player_position_filled(gameID, 5)  == get_player_position_filled(6) && get_player_position_filled(4) != Players.None)
        ) {
            return get_player_position_filled(gameID, 4);
        }
        elif (
            (get_player_position_filled(gameID, 7) == get_player_position_filled(gameID, 8) && get_player_position_filled(gameID, 8)  == get_player_position_filled(gameID, 9) && get_player_position_filled(gameID, 7) != Players.None)
        ) {
            return get_player_position_filled(gameID, 7);
        }
        return Players.None;
    }
    
    fn vertical_alignement(gameID) -> Players winner {
        if (
            (get_player_position_filled(gameID, 1) == get_player_position_filled(gameID, 4) && get_player_position_filled(gameID, 4)  == get_player_position_filled(gameID, 7) && get_player_position_filled(gameID, 1) != Players.None)  
        ) {
            return get_player_position_filled(gameID, 1);
        }
        elif (
            (get_player_position_filled(gameID, 2) == get_player_position_filled(gameID, 5) && get_player_position_filled(gameID, 5)  == get_player_position_filled(gameID, 8) && get_player_position_filled(gameID, 2) != Players.None)
        ) {
            return get_player_position_filled(gameID, 2);
        }
        elif (
            (get_player_position_filled(gameID, 3) == get_player_position_filled(gameID, 6) && get_player_position_filled(gameID, 6)  == get_player_position_filled(gameID, 9) && get_player_position_filled(gameID, 3) != Players.None)
        ) {
            return get_player_position_filled(gameID, 3);
        }
        return Players.None;
    }
    
    fn diagonal_alignement(gameID) -> Players winner {
        if (
            (get_player_position_filled(gameID, 1) == get_player_position_filled(gameID, 5) && get_player_position_filled(gameID, 5)  == get_player_position_filled(gameID, 9) && get_player_position_filled(gameID, 1) != Players.None)  
        ) {
            return get_player_position_filled(gameID, 1);
        }
        elif (
            (get_player_position_filled(gameID, 3) == get_player_position_filled(gameID, 5) && get_player_position_filled(gameID, 5)  == get_player_position_filled(gameID, 7) && get_player_position_filled(gameID, 3) != Players.None)
        ) {
            return get_player_position_filled(gameID, 2);
        }
        return Player.None;
    }

    fn board_full(gameID) -> bool{
        for (u8 x = 0; x < 9; x++) {
            if (get_player_position_filled(gameID, x) == None) {
                return false;
            }
        }
        return true;
    }
}