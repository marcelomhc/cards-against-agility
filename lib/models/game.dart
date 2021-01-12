import 'dart:math';

import 'package:cards_against_agility/models/player.dart';
import 'package:cards_against_agility/models/constants.dart';

class GameTable {

  GameTable(
      this.id,
      this.host,
      this.blackCard,
      this.playedCards,
      this.score,
      this.players,
      this.lastVoted,
      this.round,
      this.status
  );

  factory GameTable.fromScratch(String id, String host, List<int> blackCard) {
    return GameTable(
      id,
      host,
      blackCard,
      <String, String>{},
      <String, int>{},
      <String, String>{},
      <String, String>{},
      0,
      GameStatus.WAITING
    );
  }

  factory GameTable.fromMap(Map<String, dynamic> map) {
    return GameTable(
      map[ID_FIELD] as String,
      map[HOST_FIELD] as String,
      (map[BLACK_CARD] as List<dynamic>).cast<int>(),
      Map<String,String>.from(map[PLAYED_CARDS] as Map<String, dynamic>),
      Map<String,int>.from(map[SCORE_FIELD] as Map<String, dynamic>),
      Map<String,String>.from(map[PLAYERS_FIELD] as Map<String, dynamic>),
      Map<String,String>.from(map[LAST_VOTED] as Map<String, dynamic>),
      map[ROUND_FIELD] as int,
      GameStatus.values.firstWhere((GameStatus v) => v.toString() == (map[STATUS_FIELD] as String))
    );
  }

  String id;
  String host;
  List<int> blackCard;
  Map<String, String> playedCards;
  Map<String, int> score;
  Map<String, String> players;
  Map<String, String> lastVoted;
  int round;
  GameStatus status;

  static const String ID_FIELD = 'id';
  static const String HOST_FIELD = 'host';
  static const String BLACK_CARD = 'black_card';
  static const String PLAYED_CARDS = 'played_cards';
  static const String SCORE_FIELD = 'score';
  static const String PLAYERS_FIELD = 'players';
  static const String LAST_VOTED = 'last_voted';
  static const String ROUND_FIELD = 'round';
  static const String STATUS_FIELD = 'status';

    Map<String, dynamic> toMap() {
      final Map<String, dynamic> map = <String, dynamic>{};
      map[ID_FIELD] = id;
      map[HOST_FIELD] = host;
      map[BLACK_CARD] = blackCard;
      map[PLAYED_CARDS] = playedCards;
      map[SCORE_FIELD] = score;
      map[PLAYERS_FIELD] = players;
      map[LAST_VOTED] = lastVoted;
      map[ROUND_FIELD] = round;
      map[STATUS_FIELD] = status.toString();

      return map;
    }

  bool waitingPlayers() {
    return status == GameStatus.WAITING;
  }

  bool started() {
      return status == GameStatus.STARTED;
  }

  bool finished() {
    return status == GameStatus.FINISHED;
  }

  bool allCardsPlayed() {
      return playedCards.length == players.length - 1;
  }

  String blackCardText() {
      return blackCards[blackCard.last];
  }

  void newRound(String roundWinner, String cardText) {
    score[roundWinner] += 1;
    int nextBlack = blackCard.last;

    if(blackCard.length == blackCards.length) {
      blackCard.clear();
    }

    do {
      nextBlack = Random().nextInt(blackCards.length);
    } while(blackCard.contains(nextBlack));
    blackCard.add(nextBlack);

    lastVoted = <String, String>{roundWinner: cardText};
    playedCards.clear();
    final List<String> playerList = players.keys.toList();
    playerList.sort();
    host = playerList.elementAt((playerList.indexOf(host)+1) % playerList.length);
    round += 1;

    if(round > NUMBER_OF_ROUNDS) {
      status = GameStatus.FINISHED;
    }
  }

  void resetGame(String playerId) {
      blackCard = <int>[Random().nextInt(blackCards.length)];
      host = playerId;
      playedCards = <String, String>{};
      score = <String, int>{};
      players = <String, String>{};
      lastVoted = <String, String>{};
      round = 0;
      status = GameStatus.WAITING;
  }

  void startGame() {
      round = 1;
      status = GameStatus.STARTED;
  }

  void addPlayer(Player player) {
    if (!players.keys.contains(player.id)) {
      players.addAll(<String, String>{player.id: player.username});
      score[player.id] = 0;
    }
  }

  void removePlayer(String playerId) {
    final List<String> playerList = players.keys.toList();
    final int idx = playerList.indexOf(playerId);
    players.remove(playerId);
    score.remove(playerId);

    if (players.isEmpty) {
      deleteRoom();
    } else {
      if (host == playerId) {
        host = playerList.elementAt((idx+1) % players.length);
      }
    }
  }

  void deleteRoom() {
      return;
  }
}

enum GameStatus { WAITING, STARTED, FINISHED }
