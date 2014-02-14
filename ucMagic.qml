import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "ui"
import QtQuick.LocalStorage 2.0
import "js/Settings.js" as LS
import "js/PlayersStorage.js" as PL

/*!
    \brief MainView with Tabs element.
           First Tab has a single Label and
           second Tab has a single ToolbarAction.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.andreap.ucmagic"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    headerColor: "#000066"
    backgroundColor: "#0099CC"
    footerColor: "#00CCCC"

    width: units.gu(100)
    height: units.gu(75)

    function updatePlayersModel(){
        playersModel.clear()

        var players = PL.getPlayerList()
        for(var i = 0; i < players.length; i++){
            playersModel.append({"playername": players[i].name, "wins": players[i].wins, "loses" :players[i].loses});
        }
    }

    Component {
        id: welcomeScreenComponent

        Dialog {
            id: welcomeScreenDialog

            title: i18n.tr("Welcome to MagicCounter!")
            text: i18n.tr("This is your first visit, so you have to add a default player!")
            TextField {
                id: newPlayerName
                highlighted: true
            }

            Button {
                text: i18n.tr("Done!")
                color: "#0099CC"
                onClicked: {
                    playersModel.append({"playername": newPlayerName.text , "wins": 0, "loses" : 0})
                    PL.updatePlayer(newPlayerName.text,0,0)
                    LS.setSetting("defaultPlayer",newPlayerName.text)
                    lifeTab.player1name = newPlayerName.text
                    LS.setSetting("firstTime","1")

                    PopupUtils.close(welcomeScreenDialog)
                }
            }
        }
    }

    Component.onCompleted: {
        LS.initialize();
        PL.initializePlayers()

        if(LS.getSetting("firstTime") !== "1") {
            PopupUtils.open(welcomeScreenComponent)
            LS.setSetting("slider",45)
        }

        updatePlayersModel()
    }

    ListModel {
        id: playersModel;

        //spostato su updatePlayersModel()
        onCountChanged: {
            settingsTab.playersSelector = settingsTab.fromListModelToValue()
            lifeTab.cp.playersSelector = settingsTab.fromListModelToValue()
        }
    }


    Tabs {
        id: tabs

        LifeTab { id: lifeTab }
        PlayersTab { id: playersTab }
        SettingsTab { id: settingsTab }
        AboutTab {}
    }
}
