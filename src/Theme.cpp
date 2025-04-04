#include "Theme.h"
#include <QGuiApplication>
#include <QPalette>
Theme::Theme(QObject *parent)
    : QObject{parent}
{
    m_ThemeType=Theme::ModeType::Light;
    m_dark=false;

    this->refreshColors();
    //连接信号槽
    connect(this, &Theme::darkChanged, this, [=] { refreshColors(); });
    connect(this, &Theme::ThemeTypeChanged, this, [=] { Q_EMIT darkChanged();});
    connect(this, &Theme::SystemThemeChanged, this, [=] { refreshColors(); });
}

void Theme::refreshColors()
{
    m_SystemTheme=this->getSystemThemeType();
    auto isDark = dark();
    ItemTextColor(isDark?QColor(255, 255, 255) : QColor(0, 0, 0));
    ItemBackgroundColor(isDark?QColor(255, 255, 255, qRound(255 * 0.02)):QColor(0, 0, 0,qRound(255 * 0.02)));
    ItemBordercolor(isDark?QColor(255, 255, 255, qRound(255 * 0.3)):QColor(0, 0, 0,qRound(255 * 0.3)));
    ItemBorderHovercolor(isDark?QColor(255, 255, 255, qRound(255 * 0.4)):QColor(0, 0, 0,qRound(255 * 0.4)));
    ItemrHovercolor(isDark?QColor(255, 255, 255, qRound(255 * 0.08)):QColor(0, 0, 0,qRound(255 * 0.08)));

}

bool Theme::getSystemThemeType()
{
    QPalette palette = QGuiApplication::palette();
    QColor color = palette.color(QPalette::Window).rgb();
    return color.red() * 0.2126 + color.green() * 0.7152 + color.blue() * 0.0722 <= 255.0f / 2;
}

bool Theme::dark() const
{
    if (m_ThemeType == Theme::ModeType::Dark) {
        return true;
    } else if (m_ThemeType == Theme::ModeType::System) {
        return m_SystemTheme;
    } else {
        return false;
    }
}
