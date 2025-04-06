#include "AppHelper.h"
#include <QGuiApplication>
#include <QPalette>
#include <QTimer>
#include <QDebug>
AppHelper::AppHelper(QObject *parent) : QObject(parent)
{
    // 安装事件过滤器到应用程序对象
    qApp->installEventFilter(this);

    // 延迟初始检查，确保信号连接完成
    QTimer::singleShot(0, this, [this](){
        emit themeChanged(isOSTheme());
    });
}
AppHelper::~AppHelper()
{
    // 移除事件过滤器
    if(qApp) {
        qApp->removeEventFilter(this);
    }
}
bool AppHelper::isOSTheme() const
{
    const QColor windowColor = QGuiApplication::palette().color(QPalette::Window);
    return windowColor.lightness() < 128;
}

QString AppHelper::resolvedUrl(const QString &path)
{
    if (m_engine == nullptr) {
        return path;
    }
    qDebug()<<"路径："<< m_baseUrl + path;
    return m_baseUrl + path;
}

bool AppHelper::eventFilter(QObject *watched, QEvent *event)
{
    if (event->type() == QEvent::ApplicationPaletteChange) {
        emit themeChanged(isOSTheme());
        return true;
    }
    return QObject::eventFilter(watched, event);
}
