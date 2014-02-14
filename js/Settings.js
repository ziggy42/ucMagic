// questa funzione serve per aiutarmi a connettermi al database senza dover scrivere staroba ogni fottuta volta
function getDatabase() {
     return LocalStorage.openDatabaseSync("Settings", "1.0", "StorageDatabase", 1000000);
}

// All'avvio dell'applicazione, possiamo inizializzare la tabella di cui abbiamo bisogno se gia non esiste
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            //tx.executeSql('DROP TABLE settings');
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
      });
}

// This function is used to write a setting into the database
function setSetting(setting, value) {
    // setting: string representing the setting name (eg: “username”)
    // value: string representing the value of the setting (eg: “myUsername”)
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
              //console.log(rs.rowsAffected)
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
// This function is used to retrieve a setting from the database
function getSetting(setting) {
   var db = getDatabase();
   var res="";

   try {
       db.transaction(function(tx) {
         var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
         if (rs.rows.length > 0) {
              res = rs.rows.item(0).value;
         } else {
             res = "Unknown";
         }
      })
   } catch(e) {
       //console.log("ERROREEEEE")
       return "";
   }

  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res
}

function resetSettings() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            tx.executeSql('DROP TABLE settings');
      });
}
