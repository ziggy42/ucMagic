import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import QtQuick.LocalStorage 2.0
import "../js/PlayersStorage.js" as PL
import "../js/Settings.js" as LS

Rectangle {
    id: questo
    property alias gwidth: questo.width
    property alias gheight:  questo.height
    property alias gx:  questo.x
    property alias gy:  questo.y
    property alias show:  questo.visible
    property alias gtext: selector.text

    property string firstOrSecond
    property alias playersSelector : selector.values

    radius: units.gu(5)
    color: "#0099CC"
    visible: false

    width: parent.width*2/3
    height: childrenRect.height + units.gu(4);

    anchors {centerIn: parent}

    Column{
        y: units.gu(2)
        spacing: units.gu(2)
        width: parent.width*2/3
        anchors {horizontalCenter: parent.horizontalCenter}

        ListItem.ValueSelector {
            id: selector
            text: i18n.tr("First Player")
            values: (LS.getSetting("firstTime") === "1") ? fromListModelToValue() : ['Player 1']

            onSelectedIndexChanged: {
                if(firstOrSecond === "lc1")
                    lifeTab.player1name = values[selectedIndex]
                else
                    lifeTab.player2name = values[selectedIndex]
            }
        }

        Label {
            text: i18n.tr("Add a New Player")
            fontSize: "large"
            anchors {horizontalCenter: parent.horizontalCenter}
        }

        TextField {
            id: newPlayerName
            anchors {horizontalCenter:  parent.horizontalCenter; }
            highlighted: true
        }

        Row {
            anchors {horizontalCenter:  parent.horizontalCenter; }
            spacing: units.gu(2)

            Button {
                text: i18n.tr("Add")

                onClicked: {
                    playersModel.append({"playername": newPlayerName.text , "wins": 0})
                    PL.updatePlayer(newPlayerName.text,0,0)

                    settingsTab.playersSelector = settingsTab.fromListModelToValue()
                    lifeTab.cp.playersSelector = settingsTab.fromListModelToValue()

                    if(firstOrSecond === "lc1")
                        lifeTab.player1name = newPlayerName.text
                    else
                        lifeTab.player2name = newPlayerName.text
                    show =  false
                }
            }
            Button {
                text: i18n.tr("Exit")

                onClicked: {
                    show =  false
                }
            }
        }
    }
}
