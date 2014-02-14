import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import QtQuick.LocalStorage 2.0
import "../js/Settings.js" as LS

Tab {
    id: mainTab
    title: i18n.tr("Settings")

    property alias playersSelector : defaultPlayerSelector.values

    function fromListModelToValue(){
         var valori = new Array();

         for(var i = 0; i < playersModel.count; i++)
             valori.push(playersModel.get(i).playername);

         return (valori.length !== 0) ? ((LS.getSetting("defaultPlayer") === "Player") ?  (new Array("Player")).concat(valori): valori ): ['Player']
    }

    page: Page {
        Column {
            id: column
            y: 30
            width: parent.width*3/4
            anchors {horizontalCenter: parent.horizontalCenter }
            spacing: units.gu(1)

            Label {
                text: i18n.tr("Round duration: %1 minutes").arg(parseInt(liveSlider.value))
                font.weight: Font.Light
                anchors {horizontalCenter: parent.horizontalCenter }
            }

            Slider {
                id: liveSlider
                objectName: "slider_live"
                live: true
                value: (LS.getSetting("firstTime") === "1") ? LS.getSetting("slider") : 45
                anchors {horizontalCenter: parent.horizontalCenter }

                onValueChanged: {
                    if(LS.getSetting("firstTime") === "1")
                        LS.setSetting("slider",value)

                    lifeTab.roundDuration = Math.floor(value)*60
                }
            }

            ListItem.ValueSelector {
                id: valueSelector
                text: "On Round Time Finished"
                selectedIndex: (parseInt(LS.getSetting("roundTimeFinished")) === 1) ? 1 : 0

                values: ["Timer flashes","Round ends"]

                onSelectedIndexChanged: {
                    if(selectedIndex === 0) {
                        LS.setSetting("roundTimeFinished",0)
                        lifeTab.roundFinish = false
                    }
                    else {
                        LS.setSetting("roundTimeFinished",1)
                        lifeTab.roundFinish = true
                    }
                }
            }

            ListItem.ValueSelector {
                id: colorSelector
                text: "pointsContainer color"
                selectedIndex: (parseInt(LS.getSetting("pointsContainerColor")) >= 0) ? parseInt(LS.getSetting("pointsContainerColor")) : 0

                values: ["default","orange","red","blue","green","gray","violet"]

                onSelectedIndexChanged: {
                    switch(selectedIndex) {
                        case 0:
                            lifeTab.colore = "#0066CC"
                            lifeTab.colore2 = "#0066CC"
                            LS.setSetting("pointsContainerColor",0)
                            break;
                        case 1:
                            lifeTab.colore = UbuntuColors.orange
                            lifeTab.colore2 = UbuntuColors.orange
                            LS.setSetting("pointsContainerColor",1)
                            break;
                        case 2:
                            lifeTab.colore = "red" //values[selectedIndex]
                            lifeTab.colore2 = "red" //values[selectedIndex]
                            LS.setSetting("pointsContainerColor",2)
                            break;
                        case 3:
                            lifeTab.colore = "blue" //values[selectedIndex]
                            lifeTab.colore2 = "blue" //values[selectedIndex]
                            LS.setSetting("pointsContainerColor",3)
                            break;
                        case 4:
                            lifeTab.colore = "green" //values[selectedIndex]
                            lifeTab.colore2 = "green" //values[selectedIndex]
                            LS.setSetting("pointsContainerColor",4)
                            break;
                        case 5:
                            lifeTab.colore = "gray" //values[selectedIndex]
                            lifeTab.colore2 = "gray" //values[selectedIndex]
                            LS.setSetting("pointsContainerColor",5)
                            break;
                        case 6:
                            lifeTab.colore = "#5E2750"
                            lifeTab.colore2 = "#5E2750"
                            LS.setSetting("pointsContainerColor",6)
                            break;
                    }
                }
            }

            ListItem.ValueSelector {
                id: defaultPlayerSelector
                text: "Default Player"
                values: (LS.getSetting("firstTime") === "1") ? fromListModelToValue() : ['Player 1']
                //selectedIndex: values.indexOf(LS.getSetting("defaultPlayer"))

                onSelectedIndexChanged: {
                    LS.setSetting("defaultPlayer",values[selectedIndex])
                    lifeTab.player1name = values[selectedIndex]
                }
            }

        }

        tools: ToolbarItems {
            ToolbarButton {
                text: i18n.tr("Default")
                iconSource: "../graphics/new_game_ubuntu.svg"
                onTriggered: {
                    liveSlider.value = 45
                    valueSelector.selectedIndex = 0
                    colorSelector.selectedIndex = 0
                }
            }
        }
    }
}
