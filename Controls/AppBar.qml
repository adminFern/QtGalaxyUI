import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GalaxyUI
Rectangle {
    id: control
    property Component action
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property alias buttonClose: btn_close
    property alias buttonMaximized: btn_maximized
    property alias buttonMinimized: btn_minimized
    property string winTitle
    property string winIcon
    width: {
        if(parent){
            return parent.width
        }
        return 0
    }
    implicitHeight: 30
    color: "transparent"
    Item{
        id: d
        property var win: Window.window
        property int iconsize: 22
        property int buttonWidth : 46
        property bool isRestore: win && (Window.Maximized === win.visibility || Window.FullScreen === win.visibility)
        property bool resizable: Window.window && !(win.height === win.maximumHeight && win.height === win.minimumHeight && win.width === win.maximumWidth && win.width === win.minimumWidth)
        function setHitTestVisible(id){
            if(win && Window.window instanceof FramelessWindow){
                win.setHitTestVisible(id)
            }
        }

        property color itemHoverColor: Theme.isDark? Qt.rgba(1,1,1,0.08): Qt.rgba(0,0,0,0.08)
    }
    //图标个标题
    Item{
        width: parent.width
        height: 30
        Row{
            id: layout_title
            anchors{
                left: parent.left
                horizontalCenter: undefined
                top: parent.top
                bottom: parent.bottom
                leftMargin: 10
            }
            spacing: 6

            Image{
                id:icon
                width: d.iconsize
                height: d.iconsize
                source:control.winIcon
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted: {
                    if(control.winIcon===""){
                        visible=false
                    }
                }
            }
            Label{
                text: control.winTitle
                elide: Qt.ElideRight
                font: TextFont.body
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.isDark ? "white" :"black"
            }
        }
    }


    /////控制按钮
    RowLayout{
        id: layout_win_controls
        spacing: 0
        anchors.right: parent.right
        height: parent.height
        //加载外部
        AutoLoader{
            id: loader_action
            Layout.fillHeight: true
            sourceComponent: control.action
        }
        GaIconButton{
            id: btn_minimized
            implicitWidth: d.buttonWidth
            implicitHeight: parent.height
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            radius: 0
            iconSize:12
            iconSource: Icons.ChromeMinimize
            visible: control.showMinimize && Qt.platform.os !== "osx"
            //最小化
            onClicked: {
                Window.window.showMinimized()
            }

        }
        GaIconButton{
            id:btn_maximized
            property bool hover: hovered
            implicitWidth: d.buttonWidth
            implicitHeight: parent.height
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            radius: 0
            iconSize:12
            visible:d.resizable && control.showMaximize //control.showMaximize && Qt.platform.os !== "osx"
            iconSource: d.isRestore ? Icons.ChromeRestore : Icons.ChromeMaximize
            color: {
                if(down){
                    return Theme.isDark?Qt.rgba(1,1,1,0.1):Qt.rgba(0,0,0,0.1)
                }
                return btn_maximized.hover ? d.itemHoverColor:  "transparent"
            }
            onClicked: {
                if(d.isRestore){
                    Window.window.showNormal()
                }else{
                    Window.window.showMaximized()
                }
            }
        }
        GaIconButton{
            id: btn_close
            implicitWidth: d.buttonWidth
            implicitHeight: parent.height
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            radius: 0
            iconSize:12
            iconSource:Icons.ChromeClose
            visible: control.showClose && Qt.platform.os !== "osx"
            iconColor: hovered ? Qt.rgba(1,1,1,1) : Theme.textColor
            color: {
                if(pressed){
                    return Qt.rgba(185/255,13/255,28/255,1)
                }
                return hovered ? Qt.rgba(236/255,64/255,79/255,1) : Qt.rgba(0,0,0,0)
            }
            // Prompt{
            //     id:closeToolTip
            //     visible: btn_close.hovered
            //     text: qsTr("关闭")
            //     delay: 600
            //     PropertyAnimation {
            //         id: scaleInAnimation_close
            //         target: closeToolTip
            //         properties: "scale"
            //         from: 0 // 动画开始时的缩放比例，小于1表示小于原始大小
            //         to: 1 // 动画结束时的缩放比例，等于1表示原始大小
            //         duration: 300 // 动画持续时间，单位为毫秒
            //         easing.type: Easing.InQuad // 缓动类型，可以根据需要选择
            //     }
            //     onVisibleChanged:{
            //         if (visible) {
            //             scaleInAnimation_close.start()
            //         }
            //     }

            // }
            onClicked: {
                Window.window.close()
            }
        }
        Component.onCompleted: {
            d.setHitTestVisible(this)
        }
    }
}
