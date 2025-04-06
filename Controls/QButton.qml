import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T

T.Button{
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)




}







// Rectangle {
//     id: root
//     property string text: ""
//     property alias font: label.font
//     implicitWidth: Math.max(80, label.implicitWidth + 6)
//     implicitHeight: 35
//     radius: 4
//     property color highlightColor: "#00BFFF" // 默认天蓝色
//     property bool isHighlight: false

//     QtObject {
//         id: d
//         property real pressedScale: 0.96
//         property int animationDuration: 120

//         property color lightNormalColor: "#00ffffff"
//         property color lightHoverColor: "#EEEEEE"
//         property color lightPressedColor: "#E5E5E5"
//         property color lightBorderColor: "#DDDDDD"
//         property color lightTextColor: "#333333"

//         property color darkNormalColor: "#00ffffff"
//         property color darkHoverColor: "#505050"
//         property color darkPressedColor: "#404040"
//         property color darkBorderColor: "#707070"
//         property color darkTextColor: "#FFFFFF"

//         function adjustColor(color, factor) {
//             return Theme.isDark.dark ? Qt.darker(color, factor) : Qt.lighter(color, factor)
//         }
//         function getNormalColor() {
//             return root.isHighlight ? root.highlightColor : (Theme.isDark ? darkNormalColor : lightNormalColor)
//         }
//         function getHoverColor() {
//             return root.isHighlight ? adjustColor(root.highlightColor, 1.4) : (Theme.isDark ? darkHoverColor : lightHoverColor)
//         }
//         function getPressedColor() {
//             return root.isHighlight ? adjustColor(root.highlightColor, 1.2) : (Theme.isDark ? darkPressedColor : lightPressedColor)
//         }
//         function getBorderColor() {
//             return root.isHighlight ? "transparent" : (Theme.isDark ? darkBorderColor : lightBorderColor)
//         }
//         function getTextColor() {
//             if (!root.isHighlight) {
//                 return Theme.isDark.dark ? darkTextColor : lightTextColor
//             }
//             return mouseArea.pressed ? (Theme.isDark ? "black" : "white") : (Theme.isDark ? "white" : "black")
//         }
//     }
//     color: mouseArea.pressed ? d.getPressedColor() : (mouseArea.containsMouse ? d.getHoverColor() : d.getNormalColor())
//     border.color: d.getBorderColor()
//     border.width: root.isHighlight ? 0 : 1
//     scale: mouseArea.pressed ? d.pressedScale : 1.0

//     Behavior on color {
//         ColorAnimation { duration: 300; easing.type: Easing.InOutSine }
//     }
//     Behavior on border.color {
//         ColorAnimation { duration: 300; easing.type: Easing.InOutSine }
//     }
//     Behavior on scale {
//         NumberAnimation {
//             duration: d.animationDuration
//             easing.type: mouseArea.pressed ? Easing.InQuad : Easing.OutBack
//         }
//     }

//     Text {
//         id: label
//         padding: 3
//         anchors.centerIn: parent
//         verticalAlignment: Text.AlignVCenter // 垂直居中对齐
//         horizontalAlignment: Text.AlignRight // 水平靠右对齐
//         elide: Text.ElideRight
//         text: root.text
//         font.pixelSize: 14
//         color: d.getTextColor()
//     }

//     MouseArea {
//         id: mouseArea
//         anchors.fill: parent
//         hoverEnabled: true
//         cursorShape: Qt.PointingHandCursor
//         onPressed: root.pressed()
//         onReleased: root.released()
//         onClicked:root.clicked()
//         onCanceled: root.scale = 1.0
//     }
//     // 添加自定义信号
//     signal clicked()
//     signal pressed()
//     signal released()
//     // 外露方法
//     function setText(newText) {
//         label.text = newText
//     }
//     function setFontFamily(newFontFamily) {
//         label.font.family = newFontFamily
//     }

//     function setFontSize(newFontSize) {
//         label.font.pixelSize = newFontSize
//     }

//     function setHighlight(newIsHighlight) {
//         isHighlight = newIsHighlight
//     }

//     function setHighlightColor(newHighlightColor) {
//         highlightColor = newHighlightColor
//     }

//     function setLabelTextColor(newTextColor) {
//         label.color = newTextColor
//     }
// }
