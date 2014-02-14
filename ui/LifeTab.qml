import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "../components/" as Components
import QtQuick.LocalStorage 2.0
import "../js/PlayersStorage.js" as PL
import "../js/Settings.js" as LS

Tab {
    id: mainTab
    title: i18n.tr("Life Counter")

    property alias cp: chooseplayer

    property string winner: ""
    property int seconds: 0
    property int roundDuration: 2700
    property bool roundFinish: false

    property alias colore: lc1.pointsColor
    property alias colore2: lc2.pointsColor

    property alias player1name: lc1.playerName
    property alias player2name: lc2.playerName


    function fromSecondsToString(n){
        var hours, minutes, seconds;

        seconds = (n%60 < 10) ? "0" + n%60 : n%60
        n = (n - seconds)/60
        minutes = (n%60 < 10) ? "0" + n%60 : n%60
        hours = ((n - minutes)/60 < 10) ? "0" + (n - minutes)/60 : (n - minutes)/60

        return hours + ":" + minutes + ":" + seconds
    }

    function findWinner(){
        var lc1_wins = 0, lc2_wins = 0;
        for(var i = 0; i < historyModel.count; i++){
            if(historyModel.get(i).winner === lc1.playerName) lc1_wins++;
            else lc2_wins++;
        }

        if(lc1_wins > lc2_wins) {
            PL.updateWinsLoses(lc1.playerName, PL.getPlayer(lc1.playerName).wins + 1, PL.getPlayer(lc1.playerName).loses);
            PL.updateWinsLoses(lc2.playerName, PL.getPlayer(lc2.playerName).wins, PL.getPlayer(lc2.playerName).loses+1);
            updatePlayersModel()
        }
        else {
            if(lc1_wins < lc2_wins) {
                PL.updateWinsLoses(lc2.playerName, PL.getPlayer(lc2.playerName).wins + 1, PL.getPlayer(lc2.playerName).loses);
                PL.updateWinsLoses(lc1.playerName, PL.getPlayer(lc1.playerName).wins, PL.getPlayer(lc1.playerName).loses+1);
                updatePlayersModel()
            }
        }
    }

    function resetTimer(){
        timerLabel.text = "00:00:00"
        seconds = 0
    }

    Component {
        id: dialog

        Dialog {
            id: dialogue

            onVisibleChanged: roundTimer.running = false

            title: winner + i18n.tr(" wins!")
            text: i18n.tr("What do you want to do?")
            Button {
                text: i18n.tr("New Round")
                color: "#0099CC"
                onClicked: {
                    lc2.points = 20
                    lc1.points = 20
                    roundTimer.running = false
                    timerLabel.text = "00:00:00"
                    colorAnimation.running = false
                    seconds = 0
                    PopupUtils.close(dialogue)
                }
            }
            Button {
                text: i18n.tr("New Game")
                color: "#0099CC"
                onClicked: {
                    findWinner()
                    lc2.points = 20
                    lc1.points = 20
                    historyModel.clear()
                    roundTimer.running = false
                    timerLabel.text = "00:00:00"
                    colorAnimation.running = false
                    seconds = 0
                    PopupUtils.close(dialogue)
                }
            }
            Button {
                text: i18n.tr("Close")
                color: "#0099CC"
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }

    Components.ChoosePlayer {
        id: chooseplayer
    }

    page: Page {
        Row {
            id: row
            y: 30
            spacing: units.gu(5)
            //spacing: 40
            anchors.horizontalCenter: parent.horizontalCenter

            Components.LifeCounter {
                id: lc1
                playerName: LS.getSetting("defaultPlayer")
                points: "20"
                //
                idnumb: "lc1"

                onPointsChanged: {
                    if(parseInt(points) === 0) {
                        console.log(lc2.playerName + " wins")
                        winner = lc2.playerName
                        PopupUtils.open(dialog)
                        historyModel.append({"winner": lc2.playerName, "score" : (lc2.points + "/" + lc1.points)})
                    }
                }
            }

            Components.LifeCounter {
                id: lc2
                playerName: "Player 2"
                points: "20"
                //
                idnumb: "lc2"

                onPointsChanged: {
                    if(parseInt(points) === 0) {
                        console.log(lc1.playerName + " wins")
                        winner = lc1.playerName
                        PopupUtils.open(dialog)
                        historyModel.append({"winner": lc1.playerName, "score" : (lc1.points + "/" + lc2.points)})
                    }
                }
            }
        }

        Timer {
            id: roundTimer

            interval: 1000
            repeat: true
            running: false
            onTriggered: {
                seconds += 1
                timerLabel.text = fromSecondsToString(seconds)
                if(roundFinish) {
                    if(seconds === roundDuration) {
                        if(lc1.points !== lc2.points){
                            winner = (lc1.points > lc2.points) ? lc1.playerName : lc2.playerName
                            PopupUtils.open(dialog)
                            historyModel.append({"winner": winner, "score" : (lc1.points + "/" + lc2.points)})
                            running = false
                        }
                        else{
                            winner = "Nobody"
                            PopupUtils.open(dialog)
                            historyModel.append({"winner": "DRAW", "score" : (lc1.points + "/" + lc2.points)})
                            running = false
                        }
                    }
                }
                else{
                    if(seconds === roundDuration) colorAnimation.running = true//timerLabel.color = "#2C001E"
                }
            }

            onRunningChanged: {
                 if(roundTimer.running){
                     pausePlayTimer.buttonImage = "../graphics/pause.svg"
                 }
                 else{
                     pausePlayTimer.buttonImage = "../graphics/start.svg"
                 }
            }
        }

        Row{
            id: timerRow
            anchors {top: row.bottom; horizontalCenter: parent.horizontalCenter; topMargin: units.gu(3)}
            spacing: units.gu(1)

            Components.ImageButton {
                id: pausePlayTimer
                anchors.verticalCenter: parent.verticalCenter
                height: units.gu(4)

                buttonImage: "../graphics/start.svg"
                onClicked: {
                    if(roundTimer.running){
                        roundTimer.running = false
                    }
                    else{
                        roundTimer.running = true
                    }
                }
            }

            Label {
                id: timerLabel
                color: Theme.palette.normal.baseText

                fontSize: "x-large"
                text: "00:00:00"

                SequentialAnimation on color {
                    id: colorAnimation
                    running: false

                    loops: Animation.Infinite
                    ColorAnimation {
                        from: Theme.palette.normal.baseText
                        to: "red"//"#dd4814"
                        duration: UbuntuAnimation.SnapDuration
                    }
                    PauseAnimation {
                        duration: 100
                    }
                    ColorAnimation {
                        from: "red"//"#dd4814"
                        to: Theme.palette.normal.baseText
                        duration: UbuntuAnimation.SnapDuration
                    }
                    PauseAnimation {
                        duration: 100
                    }

                    onRunningChanged: {
                        timerLabel.color = Theme.palette.normal.baseText
                    }
                }
            }

            Components.ImageButton {
                id: resetTimer
                anchors.verticalCenter: parent.verticalCenter
                height: units.gu(4)

                buttonImage: "../graphics/back.svg"
                onClicked: {
                    roundTimer.running = false
                    timerLabel.text = "00:00:00"
                    colorAnimation.running = false
                    seconds = 0
                    pausePlayTimer.buttonImage = "../graphics/start.svg"
                }
            }
        }

        Column {
            // TODO
            /*
              l'altezza di sta cosa va modificata
              */


            id: listLap

            height: childrenRect.height
            //aggiunto
            y: 270
            anchors { left: parent.left; right: parent.right; /*top: timerRow.bottom; topMargin: units.gu(5) */}
            ListItem.ThinDivider {}

            ListItem.Header {
                Label {
                    text: i18n.tr("History of the game")
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(2) }
                    color: Theme.palette.normal.baseText
                    fontSize: "medium"
                }
            }

            ListModel { id: historyModel; }
            ListView {
                id: listViewHistory

                clip: true
                anchors { left: parent.left; right: parent.right; }
                height: units.gu(40)
                model: historyModel

                delegate: ListItem.Standard {
                    Label {
                        text: winner
                        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(3) }
                        color: Theme.palette.normal.baseText
                        fontSize: "large"
                    }

                    Label {
                        text: score;
                        anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: units.gu(2) }
                        color: Theme.palette.normal.baseText
                        fontSize: "large"
                    }
                }
            }
        }

        tools: ToolbarItems {
            ToolbarButton {
                text: i18n.tr("New Round")
                iconSource: "../graphics/new_round.svg"
                onTriggered: {
                    if(lc1.points > lc2.points){
                        winner = lc1.playerName
                        historyModel.append({"winner": lc1.playerName, "score" : (lc1.points + "/" + lc2.points)})
                    } else {
                        if(lc1.points < lc2.points){
                            winner = lc2.playerName
                            historyModel.append({"winner": lc2.playerName, "score" : (lc1.points + "/" + lc2.points)})
                        }
                        else {
                            winner = "Nobody"
                            historyModel.append({"winner": "DRAW", "score" : (lc1.points + "/" + lc2.points)})
                        }
                    }

                    lc2.points = 20
                    lc1.points = 20
                    roundTimer.running = false
                    timerLabel.text = "00:00:00"
                    colorAnimation.running = false
                    seconds = 0
                }
            }
            back: ToolbarButton {
                text: i18n.tr("New Game")
                iconSource: "../graphics/new_game.svg"
                onTriggered: {
                    findWinner()
                    lc2.points = 20
                    lc1.points = 20
                    roundTimer.running = false
                    timerLabel.text = "00:00:00"
                    colorAnimation.running = false
                    seconds = 0
                    historyModel.clear()
                }
            }
        }
    }
}
