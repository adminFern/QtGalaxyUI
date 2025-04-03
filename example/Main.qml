import QtQuick
import "../Controls"
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello ccc")
    Row{
        padding: 5
        spacing: 6
        QIcon{
            icosource: FluentIcons.q_VPN
        }
        QComboBox{
            id:bobox
        }

        Text {
            id: name
            text: qsTr("text")
        }
    }


}
