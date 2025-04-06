#pragma once

#include <QObject>
#include <QQuickItem>
#include <QAbstractNativeEventFilter>
#include <QQmlProperty>
#include "stdafx.h"
#include <QQuickWindow>


class Frameless : public QQuickItem, QAbstractNativeEventFilter {
    Q_OBJECT
    Q_PROPERTY_AUTO_P(QQuickItem *, appbar)
    Q_PROPERTY_AUTO_P(QQuickItem *, buttonMaximized)
    Q_PROPERTY_AUTO(bool, topmost)
    Q_PROPERTY_AUTO(bool, disabled)
    Q_PROPERTY_AUTO(bool, fixSize)
    Q_PROPERTY_AUTO(bool, dark);
    Q_PROPERTY_AUTO(int, windowEffect);



    QML_ELEMENT

public:
    explicit Frameless(QQuickItem *parent = nullptr);
    void componentComplete() override;
    bool nativeEventFilter(const QByteArray &eventType, void *message,
                           qintptr *result) override;
    Q_INVOKABLE void showFullScreen();
    Q_INVOKABLE void showMaximized();
    Q_INVOKABLE void showMinimized();
    Q_INVOKABLE void showNormal();
    Q_INVOKABLE void setHitTestVisible(QQuickItem *);
    Q_INVOKABLE void onDestruction();



private:
    bool isFullScreen();
    bool isMaximized();
    void updateCursor(int edges);
    void setWindowTopmost(bool topmost);
    bool hitAppBar();
    bool hitMaximizeButton();
    void setMaximizePressed(bool val);
    void setMaximizeHovered(bool val);
    void showSystemMenu(QPoint point);
    bool setWindowDark(bool dark);
   static bool containsCursorToItem(QQuickItem *item);

private:
    quint64 m_current = 0;
    int m_edges = 0;
    int m_margins = 8;
    quint64 m_clickTimer = 0;
    bool m_isWindows11OrGreater = false;
    QList<QPointer<QQuickItem>> _hitTestList;



};
