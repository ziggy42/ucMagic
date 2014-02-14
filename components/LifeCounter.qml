import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

AbstractButton {
    id: lifeCounterAB

    property alias playerName: playerLabel.text
    property alias points: points.text
    property alias pointsColor: pointsContainer.color

    property string idnumb

    width: childrenRect.width; height: childrenRect.height;

    Column{
        spacing: 10

        AbstractButton {
            id: thisbutton
            width: row.width
            height: units.gu(4)

            Label{
                id: playerLabel
                anchors.centerIn: parent
                fontSize: "large"
                //color: "#2C001E"
            }

            onClicked: {
                chooseplayer.gtext=i18n.tr("Select Player")
                chooseplayer.show = true
                chooseplayer.firstOrSecond = idnumb
            }
        }

        ListItem.ThinDivider{}
        

        Row {
            id: row
            spacing: units.gu(1);

            ImageButton {
                id: addButton
                buttonImage: "../graphics/add.svg"
                height: units.gu(4)
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    console.log(playerLabel.text + " +1")
                    points.text = parseInt(points.text)+ 1
                }
            }

            Rectangle {
                id: pointsContainer
                width: units.gu(8);
                height: units.gu(8);
                radius: units.gu(2);
                antialiasing: true
                color: "#000066"

                Label {
                    id: points
                    text: "20"
                    anchors.centerIn: parent
                    fontSize: "large"
                }
            }

            ImageButton {
                id: removeButton
                buttonImage: "../graphics/-.svg"
                height: units.gu(4)
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    console.log(playerLabel.text + " -1")
                    points.text = parseInt(points.text) - 1
                }
            }
        }
    }
}
