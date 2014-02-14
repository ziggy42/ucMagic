import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import QtQuick.LocalStorage 2.0
import "../js/PlayersStorage.js" as PL
import "../js/Settings.js" as LS

Tab {
    id: mainTab
    title: i18n.tr("Players")

    property string sel

    Component {
        id: newDefaultPlayerComponent

        Dialog {
            id: newDefaultPlayerDialog

            title: i18n.tr("Add a default player!")
            text: i18n.tr("You need a new default player ;)")
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

                    PopupUtils.close(newDefaultPlayerDialog)
                }
            }
        }
    }

    Component {
        id: yesOrNo

        Dialog {
            id: yesOrNoDialog
            title: i18n.tr("Are you sure?")
            text: i18n.tr("All your players will be irreversibly deleted")

            Button {
                text: "Delete"
                color: "#FF0000"
                onClicked: {
                    PL.reset()
                    playersModel.clear()
                    PopupUtils.close(yesOrNoDialog)
                    PL.initializePlayers()

                    PopupUtils.open(newDefaultPlayerComponent)
                }
            }
            Button {
                text: "Cancel"
                color: "#0099CC"
                onClicked: {
                    PopupUtils.close(yesOrNoDialog)
                }
            }
        }
    }

    Component{
        id: newPlayerComponent

        Dialog {
            id: newPlayerDialog
            title: i18n.tr("Add a new Player?")
            text: i18n.tr("Choose the right name!")

            TextField {
                id: newPlayerName
                highlighted: true
            }

            Button {
                text: i18n.tr("Cancel")
                color: "#0099CC"
                onClicked: {
                    newPlayerName.remove(0,newPlayerName.text.length)
                    PopupUtils.close(newPlayerDialog)
                }
            }

            Button {
                text: i18n.tr("Done!")
                color: "#0099CC"
                onClicked: {
                    playersModel.append({"playername": newPlayerName.text , "wins": 0, "loses" : 0})
                    PL.updatePlayer(newPlayerName.text,0,0)
                    newPlayerName.remove(0,newPlayerName.text.length)
                    PopupUtils.close(newPlayerDialog)
                }
            }
        }
    }

    page: Page {
        id: mainPage

        Column {
            id: colonna
            y: units.gu(2)
            width: parent.width
            anchors { fill:parent }
            height: units.gu(50)//childrenRect.height

            ListItem.Header {
                Label {
                    text: i18n.tr("Players")
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(2) }
                    color: Theme.palette.normal.baseText
                    fontSize: "medium"
                }

                Label {
                    text: i18n.tr("W  -  L")
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: units.gu(2) }
                    color: Theme.palette.normal.baseText
                    fontSize: "medium"
                }
            }

            ListView {
                id: playersListView
                clip: true
                anchors { left: parent.left; right: parent.right; }
                height: parent.height
                width: parent.width
                model: playersModel

                delegate: ListItem.Standard {
                    id: delegato
                    removable: true

                    onItemRemoved: {
                        sel = la.text
                        PL.removePlayer(sel)

                        if(sel === LS.getSetting("defaultPlayer")) {
                            LS.setSetting("defaultPlayer","Player")
                            lifeTab.player1name = "Player"
                        }

                        if(lifeTab.player1name === sel) lifeTab.player1name = "Player"
                        if(lifeTab.player2name === sel) lifeTab.player2name = "Player"

                        updatePlayersModel()
                    }

                    Label {
                        id: la
                        text: playername
                        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(3) }
                        color: Theme.palette.normal.baseText
                        fontSize: "large"
                    }

                    Label {
                        text: wins + " - " + loses;
                        anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: units.gu(2) }
                        color: Theme.palette.normal.baseText
                        fontSize: "large"
                    }
                }
            }
        }

        tools: ToolbarItems {
            ToolbarButton {
                text: i18n.tr("Add Player")
                iconSource: "../graphics/add.svg"
                onTriggered: {
                    PopupUtils.open(newPlayerComponent)
                }
            }
            back: ToolbarButton {
                text: i18n.tr("Reset All")
                iconSource: "../graphics/erase.svg"
                onTriggered: {
                    PopupUtils.open(yesOrNo)
                }
            }
        }
    }
}
