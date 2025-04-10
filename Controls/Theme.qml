pragma Singleton
import QtQuick
import GalaxyUI
QtObject  {

    // 字体加载器
      property FontLoader fontLoader: FontLoader {
           source: "Font/FluentIcons.ttf"// 或你的实际路径
      }

    // 枚举类型定义
    enum ModeType {
        Light = 0x0000,
        Dark = 0x0001,
        System = 0x0002
    }
    property bool isDark:{
        if(themeType===Theme.ModeType.Dark) return true
        if(themeType===Theme.ModeType.System) return AppHelper.isOSTheme
        return false
    }
    // 属性定义
    property int themeType: Theme.ModeType.System

    property color itemDisabledColor: isDark? Qt.rgba(1,1,1,0.5):Qt.rgba(0,0,0,0.5)

    property color itemPressColor: isDark? Qt.rgba(1, 1, 1, 0.08):Qt.rgba(0, 0, 0, 0.062)

    property color itemHoverColor: isDark? Qt.rgba(1, 1, 1, 0.05):Qt.rgba(0, 0, 0, 0.05)

    property color itemBackgroundColor: isDark? Qt.rgba(1, 1, 1, 0.01):Qt.rgba(0, 0, 0, 0.01)


      property color itemfocuscolor: isDark? Qt.darker("#E66495ED",1.1):"#E66495ED"

    //边框颜色
     property color borderNormalColor: isDark?  Qt.rgba(1, 1, 1, 0.15):Qt.rgba(0, 0, 0, 0.15)
     property color borderHoverlColor: isDark?  Qt.rgba(1, 1, 1, 0.2):Qt.rgba(0, 0, 0, 0.2)
     property color borderPresslColor: isDark? Qt.rgba(1, 1, 1, 0.3):Qt.rgba(0, 0, 0, 0.3)
    //文本颜色
    property color textColor:  isDark?"white":"black"


}
