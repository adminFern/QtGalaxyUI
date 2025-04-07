import QtQuick
import QtQuick.Controls
import GalaxyUI
Window {
    id: control
    property string initialItem //加载的布局内容
    property alias containerItem: layout_container
    property alias framelessHelper: frameless
    property bool fitsAppBarWindows: false
    property bool topmost: false
    property bool fixSize: false

    property AppBar appBar: AppBar{
        showMaximize: !control.fixSize
    }



    property int __margins: 0
    property Component background: comp_background
    property int windowEffect:EffectType.Normal
    color: "transparent"
    Component.onCompleted: {
        if(appBar && Number(appBar.width) === 0){
            appBar.width = Qt.binding(function(){ return control.width})
        }
    }
    Component.onDestruction: {
        frameless.onDestruction()
    }
    Component{
        id: comp_background
        Rectangle{
            color: {
                if(Qt.platform.os === "windows" && windowEffect !== EffectType.Normal && Tools.isWindows11OrGreater()){
                    return "transparent"
                }
                return Theme.isDark? "#FF202020":"#FFf3f3f3"
            }
        }
    }
    //加载
    AutoLoader{
        anchors.fill: parent
        sourceComponent: control.background
    }
    Frameless{
        id: frameless
        appbar: control.appBar
        topmost: control.topmost
        fixSize: control.fixSize
        buttonMaximized: control.appBar.buttonMaximized
        dark:Theme.isDark
        windowEffect: control.windowEffect


    }
    //内容
    Item{
        id: layout_container
        anchors.fill: parent
        anchors.margins: __margins
        AutoLoader{
            id: loader_container
            anchors{
                fill: parent
                topMargin: fitsAppBarWindows ? 0 : layout_appbar.height
            }
            source: {
                if(control.initialItem){
                    return control.initialItem
                }
                return ""
            }
        }
        Item{
            id: layout_appbar
            data: [appBar]
            width: parent.width
            height: childrenRect.height
            visible: !frameless.disabled
            y: control.visibility === Window.FullScreen ? -childrenRect.height : 0
            Behavior on y {
                NumberAnimation{
                    duration: 358
                    easing.type: Easing.InOutCubic
                }
            }
        }
    }
    function setHitTestVisible(id){
        frameless.setHitTestVisible(id)
    }
    function showMaximized(){
        frameless.showMaximized()
    }
    function showMinimized(){
        frameless.showMinimized()
    }
    function showNormal(){
        frameless.showNormal()
    }
    function showFullScreen(){
        frameless.showFullScreen()
    }
    function deleteLater(){
        Tools.deleteLater(control)
    }

}
