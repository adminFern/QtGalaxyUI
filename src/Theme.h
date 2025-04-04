#pragma once
#include <QObject>
#include <QQmlEngine>
#include <QColor>
#include "stdafx.h"

class Theme : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(int, ThemeType)
    Q_PROPERTY_AUTO(bool, SystemTheme)
    Q_PROPERTY(bool dark READ dark NOTIFY darkChanged)
    Q_PROPERTY_AUTO(QColor, ItemTextColor)//文本颜色
    Q_PROPERTY_AUTO(QColor,ItemBackgroundColor)//文本颜色
    Q_PROPERTY_AUTO(QColor,ItemBordercolor)//项目边框颜色
    Q_PROPERTY_AUTO(QColor,ItemBorderHovercolor)//项目边框颜色
    Q_PROPERTY_AUTO(QColor,ItemrHovercolor)//项目边框颜色

    QML_NAMED_ELEMENT(Theme)
    QML_UNCREATABLE("")
    QML_SINGLETON
public:
    static Theme *create(QQmlEngine *, QJSEngine *) {return getInstance();}
    SINGLETON(Theme)
    //主题模式
    enum ModeType { Light = 0x0000, Dark = 0x0001, System = 0x0002 };
    Q_DECLARE_FLAGS(ThemeModes, ModeType)
    Q_FLAG(ThemeModes)


    bool dark() const;

private:
    explicit Theme(QObject *parent = nullptr);
    void refreshColors();
    bool getSystemThemeType();
    bool m_dark;

signals:
    void darkChanged();
};


