pragma Singleton
import QtQuick
import GalaxyUI
QtObject  {
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
    property int themeType: Theme.ModeType.Light


}
