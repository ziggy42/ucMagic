/* file per tenere traccia dei giocatori */

// funzione per recuperare in fretta il mio fottuto database
function getPlayersDatabase() {
     return LocalStorage.openDatabaseSync("Players", "1.0", "StorageDatabase", 1000000);
}

// funzione per inizializzare il database, in particolare mi crea la tabella se gia non esiste :)
function initializePlayers() {
    var db = getPlayersDatabase();
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS players_storage(name TEXT, wins INT, loses INT)');
      });
}

//funzione per aggiornare le vittorie/sconfitte di un giocatore
function updatePlayer(name,wins,loses){
    var db = getPlayersDatabase();
    var res = "";
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('INSERT OR REPLACE INTO players_storage VALUES (?,?,?);', [name,wins,loses]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

function updateWinsLoses(name,wins,loses) {
    var db = getPlayersDatabase();
    var res = "";
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('UPDATE players_storage SET wins = (?),loses = (?) WHERE name = (?);', [wins,loses,name]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

// resetta
function reset() {
    var db = getPlayersDatabase();
    db.transaction(
        function(tx) {
            tx.executeSql('DROP TABLE players_storage');
      });
}

// recupera un player
function getPlayer(player_name){
    var db = getPlayersDatabase();
    var result

    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM players_storage WHERE name=?;', [player_name]);
            var dbItem = rs.rows.item(0);
            result = {
                'name': dbItem.name,
                'wins': dbItem.wins,
                'loses': dbItem.loses
            }
       })
    } catch(e) {
        return [];
    }
   return result
}

// recupera la lista dei player per riempire il listmodel
function getPlayerList(){
    var db = getPlayersDatabase();
    var result = new Array()

    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM players_storage');
            for(var i = 0; i < rs.rows.length; i++) {
                var dbItem = rs.rows.item(i);
                result[i] = {
                    'name': dbItem.name,
                    'wins': dbItem.wins,
                    'loses': dbItem.loses
                }
            }
        })
    } catch(e) {
        return []
    }
    return result;
}

// elimina un player
function removePlayer(player_name) {
    var db = getPlayersDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM players_storage WHERE name=?;', [player_name]);
              if (rs.rowsAffected > 0) {
                res = "OK";
              } else {
                res = "Error";
              }
        }
  );
  // The function returns “OK” if it was successful, or “Error” if it wasn't
  return res;
}
