import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components/" as Components

Tab {
    id: mainTab
    title: i18n.tr("About")

    page: Page {
        Rectangle {
            id: container
            y: units.gu(6)
            //color: "#2C001E"
            color: "#000066"
            height: parent.height/5
            width: parent.width * (2/3)
            radius: units.gu(2)
            anchors {horizontalCenter: parent.horizontalCenter}
            opacity: 0.5

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter;
                spacing: units.gu(1.5)

                Row {
                    Label { font.bold: true; text: i18n.tr("Author: ") }
                    Label { text: i18n.tr("Andrea Pivetta")}
                }

                Row{
                    Label { font.bold: true; text: i18n.tr("HomePage: ")}
                    Label { text: "<a href=\"http://andreapivetta.altervista.org/\">blog</a>"; onLinkActivated: Qt.openUrlExternally(link)}
                }

                Row {
                    Label { font.bold: true; text: i18n.tr("Mail: ")}
                    Label { text: "vanpivix@gmail.com"}
                }
            }
        }
    }
}

