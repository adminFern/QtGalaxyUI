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

    property color itemDisabledColor: isDark? Qt.rgba(0.98,0.98,0.98,0.5):Qt.rgba(0.3,0.3,0.3,0.5)
    property color itemPressColor: isDark? Qt.rgba(0.98,0.98,0.98,0.9):Qt.rgba(0.3,0.3,0.3,0.9)
    property color itemHoverColor: isDark? Qt.rgba(0.98,0.98,0.98,0.6):Qt.rgba(0.3,0.3,0.3,0.6)
    property color itemNormalColor: isDark? Qt.rgba(0.98,0.98,0.98,0.6):Qt.rgba(0.3,0.3,0.3,0.6)
    property color textColor:  isDark?"white":"black"


}
