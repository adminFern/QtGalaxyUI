import QtQuick
import QtQuick.Controls
import GalaxyUI
import "../Controls"
import QtQuick.Layouts
Window {
  id: window
  width: 1000
  height: 700
  visible: true
  //initialItem:"../example/T_Content.qml"


GaIconLabel{

text: "中国广告广告"
iconSource:"qrc:/logo.png"
mirrored:true
}

  // Component {
  //   id: comp_reveal
  //   CircularReveal {
  //     id: reveal
  //     target: window.contentItem
  //     anchors.fill: parent
  //     onAnimationFinished: {
  //       loader_reveal.sourceComponent = undefined
  //     }
  //     onImageChanged: {
  //       changeDark()
  //     }
  //   }
  // }
  // AutoLoader {
  //   id: loader_reveal
  //   anchors.fill: parent
  //   z: 65535
  // }


  // Row{
  //   anchors.centerIn: parent
  //   spacing: 3
  //   GaIconButton{
  //     iconSource:Icons.Light
  //     iconSize: 22
  //     text: "正常"
  //     display: Button.TextBesideIcon
  //     onClicked: {
  //       window.windowEffect=EffectType.Normal
  //     }
  //   }
  //   GaIconButton{
  //     iconSource:Icons.MapLayers
  //     display: Button.TextBesideIcon
  //     iconSize: 22
  //     text: "云母"
  //     onClicked: {
  //       window.windowEffect=EffectType.Mica
  //     }
  //   }
  //   GaIconButton{
  //     iconSource:Icons.Shuffle
  //     display: Button.TextBesideIcon
  //     iconSize: 22
  //     text: "深度云母"
  //     onClicked: {
  //       window.windowEffect=EffectType.Mica_alt
  //     }
  //   }
  //   GaIconButton{
  //     iconSource:Icons.NetworkTower
  //     display: Button.TextBesideIcon
  //     iconSize: 22
  //     text: "亚克力"
  //     onClicked: {
  //       window.windowEffect=EffectType.Acrylic
  //     }
  //   }

  // }



  // // ScrollBar.vertical: GaScrollBar{
  // //     id: scrollbar_header
  // // }
  // // ScrollBar.horizontal: GaScrollBar{
  // //     id: scrollbar_header
  // // }



  // appBar: AppBar{

  //   winTitle:"中华人民共和国"
  //   winIcon: "../favicon.ico"
  //   action: RowLayout{
  //     GaIconButton{
  //       id: btn_dark
  //       implicitWidth: 42
  //       padding: 0
  //       radius: 0
  //       iconSource:Theme.isDark?Icons.Brightness:Icons.QuietHours
  //       iconSize: 18
  //       onClicked: (mouse) =>{

  //        handleDarkChanged(this)

  //       }
  //     }
  //   }
  // }

  // function handleDarkChanged(button) {
  //   if (loader_reveal.sourceComponent) {
  //     return
  //   }
  //   loader_reveal.sourceComponent = comp_reveal
  //   var target = window.contentItem
  //   var pos = button.mapToItem(target, 0, 0)
  //   var centerX = pos.x + button.width / 2
  //   var centerY = pos.y + button.height / 2
  //   var radius = Math.max(distance(centerX, centerY, 0,
  //                                  0), distance(centerX, centerY,
  //                                               target.width, 0),
  //                         distance(centerX, centerY, 0,
  //                                  target.height), distance(
  //                           centerX, centerY,
  //                           target.width, target.height))
  //   var reveal = loader_reveal.item
  //   reveal.start(reveal.width * Screen.devicePixelRatio,
  //                reveal.height * Screen.devicePixelRatio,
  //                Qt.point(centerX, centerY), radius, Theme.isDark)
  // }
  // function distance(x1, y1, x2, y2) {
  //   return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
  // }
  // function changeDark() {
  //   if (Theme.isDark) {
  //     Theme.themeType = Theme.ModeType.Light
  //   } else {
  //     Theme.themeType = Theme.ModeType.Dark
  //   }
  // }
}
