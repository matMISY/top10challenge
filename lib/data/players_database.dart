import '../models/player.dart';

class PlayersDatabase {
  static final PlayersDatabase _instance = PlayersDatabase._internal();
  factory PlayersDatabase() => _instance;
  PlayersDatabase._internal();

  final Map<String, Player> _players = {
    "Kylian Mbappé": Player(
      name: "Kylian Mbappé",
      nationality: "🇫🇷",
      club: "PSG",
      position: "Attaquant",
      aliases: ["Mbappe", "Kylian", "Mbappé", "Donatello"],
    ),
    "Edinson Cavani": Player(
      name: "Edinson Cavani",
      nationality: "🇺🇾",
      club: "PSG",
      position: "Attaquant",
      aliases: ["Cavani", "El Matador", "Edi"],
    ),
    "Zlatan Ibrahimović": Player(
      name: "Zlatan Ibrahimović",
      nationality: "🇸🇪",
      club: "PSG",
      position: "Attaquant",
      aliases: ["Zlatan", "Ibra", "Ibrahimovic", "Ibrahimović"],
    ),
    "Neymar": Player(
      name: "Neymar",
      nationality: "🇧🇷",
      club: "PSG",
      position: "Ailier",
      aliases: ["Neymar Jr", "Ney", "Neymar da Silva Santos Júnior"],
    ),
    "Pauleta": Player(
      name: "Pauleta",
      nationality: "🇵🇹",
      club: "PSG",
      position: "Attaquant",
      aliases: ["Pedro Miguel Carreiro Resendes", "Pedro Pauleta"],
    ),
    "Safet Sušić": Player(
      name: "Safet Sušić",
      nationality: "🇧🇦",
      club: "PSG",
      position: "Milieu",
      aliases: ["Susic", "Sušić", "Safet"],
    ),
    "Carlos Bianchi": Player(
      name: "Carlos Bianchi",
      nationality: "🇦🇷",
      club: "PSG",
      position: "Attaquant",
      aliases: ["Bianchi", "Carlos"],
    ),
    "Mustapha Dahleb": Player(
      name: "Mustapha Dahleb",
      nationality: "🇩🇿",
      club: "PSG",
      position: "Milieu",
      aliases: ["Dahleb", "Mustapha"],
    ),
    "Ronaldinho": Player(
      name: "Ronaldinho",
      nationality: "🇧🇷",
      club: "PSG",
      position: "Milieu offensif",
      aliases: ["Ronaldinho Gaúcho", "Ronaldo de Assis Moreira"],
    ),
    "Dominique Rocheteau": Player(
      name: "Dominique Rocheteau",
      nationality: "🇫🇷",
      club: "PSG",
      position: "Ailier",
      aliases: ["Rocheteau", "Dominique", "L'Ange Vert"],
    ),
    "Cristiano Ronaldo": Player(
      name: "Cristiano Ronaldo",
      nationality: "🇵🇹",
      club: "Real Madrid",
      position: "Ailier",
      aliases: ["CR7", "Cristiano", "Ronaldo", "Cristiano Ronaldo dos Santos Aveiro"],
    ),
    "Raúl": Player(
      name: "Raúl",
      nationality: "🇪🇸",
      club: "Real Madrid",
      position: "Attaquant",
      aliases: ["Raúl González", "Raul", "El Angel de Madrid"],
    ),
    "Karim Benzema": Player(
      name: "Karim Benzema",
      nationality: "🇫🇷",
      club: "Real Madrid",
      position: "Attaquant",
      aliases: ["Benzema", "Karim", "KB9", "Big Benz"],
    ),
    "Alfredo Di Stéfano": Player(
      name: "Alfredo Di Stéfano",
      nationality: "🇪🇸",
      club: "Real Madrid",
      position: "Attaquant",
      aliases: ["Di Stefano", "La Saeta Rubia", "Alfredo"],
    ),
    "Carlos Santillana": Player(
      name: "Carlos Santillana",
      nationality: "🇪🇸",
      club: "Real Madrid",
      position: "Attaquant",
      aliases: ["Santillana", "Carlos"],
    ),
    "Ferenc Puskás": Player(
      name: "Ferenc Puskás",
      nationality: "🇭🇺",
      club: "Real Madrid",
      position: "Attaquant",
      aliases: ["Puskas", "Ferenc", "The Galloping Major"],
    ),
    "Hugo Sánchez": Player(
      name: "Hugo Sánchez",
      nationality: "🇲🇽",
      club: "Real Madrid",
      position: "Attaquant",
      aliases: ["Sanchez", "Hugo", "Hugol"],
    ),
    "Francisco Gento": Player(
      name: "Francisco Gento",
      nationality: "🇪🇸",
      club: "Real Madrid",
      position: "Ailier",
      aliases: ["Gento", "Paco Gento", "La Galerna del Cantábrico"],
    ),
    "Emilio Butragueño": Player(
      name: "Emilio Butragueño",
      nationality: "🇪🇸",
      club: "Real Madrid",
      position: "Attaquant",
      aliases: ["Butragueno", "El Buitre", "Emilio"],
    ),
    "Gareth Bale": Player(
      name: "Gareth Bale",
      nationality: "🏴󠁧󠁢󠁷󠁬󠁳󠁿",
      club: "Real Madrid",
      position: "Ailier",
      aliases: ["Bale", "Gareth"],
    ),
  };

  Player? getPlayer(String name) {
    return _players[name];
  }

  List<Player> getAllPlayers() {
    return _players.values.toList();
  }

  List<Player> searchPlayers(String query) {
    final normalizedQuery = query.toLowerCase();
    return _players.values
        .where((player) => player.matches(normalizedQuery))
        .toList();
  }
}