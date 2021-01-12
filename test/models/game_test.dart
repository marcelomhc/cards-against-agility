import 'package:cards_against_agility/models/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game table', ()
  {
    test('Create from Scratch', () {
      const String id = 'id';
      const String host = 'host';
      const List<int> blackCard = <int>[0];
      final GameTable table = GameTable.fromScratch(id, host, blackCard);

      expect(table.id, id);
      expect(table.host, host);
      expect(table.blackCard, blackCard);
      expect(table.playedCards, <String, String>{});
      expect(table.score, <String, int>{});
      expect(table.players, <String, String>{});
      expect(table.lastVoted, <String, String>{});
      expect(table.round, 0);
      expect(table.status, GameStatus.WAITING);
    });
    test('Create from Map', () {
      const String id = 'id';
      const String host = 'host';
      const List<int> blackCard = <int>[2];
      final Map<String, String> playedCards = <String, String>{'Player1': 'Card1', 'Player2': 'Card2'};
      final Map<String, String> lastVoted = <String, String>{'Player1': 'Card1'};
      final Map<String, int> score = <String, int>{'Player1': 3, 'Player2': 4};
      final Map<String, String> players = <String, String>{'Player1': 'Name1', 'Player2': 'Name2'};
      const int round = 10;
      const GameStatus status = GameStatus.WAITING;

      final Map<String, dynamic> map = <String, dynamic>{};
      map[GameTable.ID_FIELD] = id;
      map[GameTable.HOST_FIELD] = host;
      map[GameTable.BLACK_CARD] = blackCard;
      map[GameTable.PLAYED_CARDS] = playedCards;
      map[GameTable.SCORE_FIELD] = score;
      map[GameTable.PLAYERS_FIELD] = players;
      map[GameTable.LAST_VOTED] = lastVoted;
      map[GameTable.ROUND_FIELD] = round;
      map[GameTable.STATUS_FIELD] = status.toString();
      final GameTable table = GameTable.fromMap(map);

      expect(table.id, id);
      expect(table.host, host);
      expect(table.blackCard, blackCard);
      expect(table.playedCards, playedCards);
      expect(table.score, score);
      expect(table.players, players);
      expect(table.lastVoted, lastVoted);
      expect(table.round, round);
      expect(table.status, status);
    });
    test('Game table to map', () {
      const String id = 'id';
      const String host = 'host';
      const List<int> blackCard = <int>[2];
      final Map<String, String> playedCards = <String, String>{'Player1': 'Card1', 'Player2': 'Card2'};
      final Map<String, String> lastVoted = <String, String>{'Player1': 'Card1'};
      final Map<String, int> score = <String, int>{'Player1': 3, 'Player2': 4};
      final Map<String, String> players = <String, String>{'Player1': 'Name1', 'Player2': 'Name2'};
      const int round = 10;
      const GameStatus status = GameStatus.STARTED;

      final Map<String, dynamic> map = GameTable(id, host, blackCard, playedCards, score, players, lastVoted, round, status).toMap();

      expect(map[GameTable.ID_FIELD], id);
      expect(map[GameTable.HOST_FIELD], host);
      expect(map[GameTable.BLACK_CARD], blackCard);
      expect(map[GameTable.PLAYED_CARDS], playedCards);
      expect(map[GameTable.SCORE_FIELD], score);
      expect(map[GameTable.PLAYERS_FIELD], players);
      expect(map[GameTable.ROUND_FIELD], round);
      expect(map[GameTable.STATUS_FIELD], status.toString());
    });
  });
}
