#include "Frameless.h"
#include"Tools.h"
#include"WindowEffect.h"
//#include <QQuickWindow>
#include <QGuiApplication>
#include <QScreen>
#include <QDateTime>
#include <QTimer>




bool Frameless::containsCursorToItem(QQuickItem *item) {
    if (!item || !item->isVisible()) {
        return false;
    }
    auto point = item->window()->mapFromGlobal(QCursor::pos());
    auto rect = QRectF(item->mapToItem(item->window()->contentItem(), QPointF(0, 0)), item->size());
    if (rect.contains(point)) {
        return true;
    }
    return false;
}

Frameless::Frameless(QQuickItem *parent) : QQuickItem{parent} {
    m_fixSize = false;
    m_appbar = nullptr;
    m_buttonMaximized = nullptr;
    m_topmost = false;
    m_disabled = false;
    m_windowEffect = 0;
    m_isWindows11OrGreater = Tools::getInstance()->isWindows11OrGreater();
}

void Frameless::onDestruction() {
    QGuiApplication::instance()->removeNativeEventFilter(this);
}

void Frameless::componentComplete() {
    if (m_disabled) {
        connect(this, &Frameless::topmostChanged, [this] { setWindowTopmost(topmost()); });
        setWindowTopmost(topmost());
        return;
    }
    int w = window()->width();
    int h = window()->height();
    m_current = window()->winId();

    window()->installEventFilter(this);
    QGuiApplication::instance()->installNativeEventFilter(this);
    if (m_buttonMaximized) {
        setHitTestVisible(m_buttonMaximized);
    }
#ifdef Q_OS_WIN
    window()->setFlag(Qt::CustomizeWindowHint, true);
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    DWORD style = ::GetWindowLongPtr(hwnd, GWL_STYLE);
    if (m_fixSize) {
        ::SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_THICKFRAME | WS_CAPTION | WS_MINIMIZEBOX);
    } else {
        ::SetWindowLongPtr(hwnd, GWL_STYLE,
                           style | WS_MAXIMIZEBOX | WS_THICKFRAME | WS_CAPTION | WS_MINIMIZEBOX);
    }
    if (!WindowEffect::isCompositionEnabled()) {
        DWORD dwStyle = GetClassLong(hwnd, GCL_STYLE);
        SetClassLong(hwnd, GCL_STYLE, dwStyle | CS_DROPSHADOW | WS_EX_LAYERED);
        window()->setProperty("__borderWidth", 1);
    }
    SetWindowPos(hwnd, nullptr, 0, 0, 0, 0,
                 SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
    //开启窗口特效
    if (!window()->property("__windowEffectDisabled").toBool()) {
      WindowEffect::setWindowEffect(hwnd, this->windowEffect());
    }
    connect(this, &Frameless::darkChanged, this, [this] { setWindowDark(dark()); });
    connect(this, &Frameless::windowEffectChanged, this,
            [this, hwnd] { WindowEffect::setWindowEffect(hwnd, this->windowEffect()); });
#endif
    int appBarHeight = 0;
    if (m_appbar) {
        appBarHeight = m_appbar->height();
    }
    h = h + appBarHeight;
    if (m_fixSize) {
        window()->setMaximumSize(QSize(w, h));
        window()->setMinimumSize(QSize(w, h));
    } else {
        window()->setMinimumHeight(window()->minimumHeight() + appBarHeight);
        window()->setMaximumHeight(window()->maximumHeight() + appBarHeight);
    }
    window()->resize(QSize(w, h));
    connect(this, &Frameless::topmostChanged, this, [this] { setWindowTopmost(topmost()); });
    setWindowTopmost(topmost());
    setWindowDark(dark());

}

void Frameless::showSystemMenu(QPoint point) {
#ifdef Q_OS_WIN
    QScreen *screen = window()->screen();
    if (!screen) {
        screen = QGuiApplication::primaryScreen();
    }
    if (!screen) {
        return;
    }
    const QPoint origin = screen->geometry().topLeft();
    auto nativePos =
        QPointF(QPointF(point - origin) * window()->devicePixelRatio()).toPoint() + origin;
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    auto hMenu = ::GetSystemMenu(hwnd, FALSE);
    if (isMaximized() || isFullScreen()) {
        ::EnableMenuItem(hMenu, SC_MOVE, MFS_DISABLED);
        ::EnableMenuItem(hMenu, SC_RESTORE, MFS_ENABLED);
    } else {
        ::EnableMenuItem(hMenu, SC_MOVE, MFS_ENABLED);
        ::EnableMenuItem(hMenu, SC_RESTORE, MFS_DISABLED);
    }
    if (!m_fixSize && !isMaximized() && !isFullScreen()) {
        ::EnableMenuItem(hMenu, SC_SIZE, MFS_ENABLED);
        ::EnableMenuItem(hMenu, SC_MAXIMIZE, MFS_ENABLED);
    } else {
        ::EnableMenuItem(hMenu, SC_SIZE, MFS_DISABLED);
        ::EnableMenuItem(hMenu, SC_MAXIMIZE, MFS_DISABLED);
    }
    ::EnableMenuItem(hMenu, SC_CLOSE, MFS_ENABLED);
    const int result = ::TrackPopupMenu(
        hMenu,
        (TPM_RETURNCMD | (QGuiApplication::isRightToLeft() ? TPM_RIGHTALIGN : TPM_LEFTALIGN)),
        nativePos.x(), nativePos.y(), 0, hwnd, nullptr);
    if (result) {
        ::PostMessageW(hwnd, WM_SYSCOMMAND, result, 0);
    }
#endif
}

bool Frameless::nativeEventFilter(const QByteArray &eventType, void *message,
                                  qintptr *result) {
#ifdef Q_OS_WIN
    if ((eventType != WindowEffect::qtNativeEventType()) || !message) {
        return false;
    }
    const auto msg = static_cast<const MSG *>(message);
    auto hwnd = msg->hwnd;
    if (!hwnd) {
        return false;
    }
    const quint64 wid = reinterpret_cast<qint64>(hwnd);
    if (wid != m_current) {
        return false;
    }
    const auto uMsg = msg->message;
    const auto wParam = msg->wParam;
    const auto lParam = msg->lParam;
    if (uMsg == WM_WINDOWPOSCHANGING) {
        auto *wp = reinterpret_cast<WINDOWPOS *>(lParam);
        if (wp != nullptr && (wp->flags & SWP_NOSIZE) == 0) {
            wp->flags |= SWP_NOCOPYBITS;
            *result = static_cast<qintptr>(
                ::DefWindowProcW(hwnd, uMsg, wParam, lParam));
            return true;
        }
        return false;
    } else if (uMsg == WM_NCCALCSIZE && wParam == TRUE) {
        const auto clientRect =
            ((wParam == FALSE) ? reinterpret_cast<LPRECT>(lParam)
                               : &(reinterpret_cast<LPNCCALCSIZE_PARAMS>(lParam))->rgrc[0]);
       // bool isMax = ::isMaximized(hwnd);
        bool isMax = WindowEffect::isMaximized(hwnd);
        bool isFull = WindowEffect::isFullScreen(hwnd);



        if (isMax && !isFull) {
            auto ty = WindowEffect::getResizeBorderThickness(hwnd, false, window()->devicePixelRatio());
            clientRect->top += ty;
            clientRect->bottom -= ty;
            auto tx = WindowEffect::getResizeBorderThickness(hwnd, true, window()->devicePixelRatio());
            clientRect->left += tx;
            clientRect->right -= tx;
        }
        if (isMax || isFull) {
            APPBARDATA abd;
            SecureZeroMemory(&abd, sizeof(abd));
            abd.cbSize = sizeof(abd);
            const UINT taskbarState = ::SHAppBarMessage(ABM_GETSTATE, &abd);
            if (taskbarState & ABS_AUTOHIDE) {
                bool top = false, bottom = false, left = false, right = false;
                int edge = -1;
                APPBARDATA abd2;
                SecureZeroMemory(&abd2, sizeof(abd2));
                abd2.cbSize = sizeof(abd2);
                abd2.hWnd = ::FindWindowW(L"Shell_TrayWnd", nullptr);
                if (abd2.hWnd) {
                    const HMONITOR windowMonitor =
                        ::MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
                    if (windowMonitor) {
                        const HMONITOR taskbarMonitor =
                            ::MonitorFromWindow(abd2.hWnd, MONITOR_DEFAULTTOPRIMARY);
                        if (taskbarMonitor) {
                            if (taskbarMonitor == windowMonitor) {
                                ::SHAppBarMessage(ABM_GETTASKBARPOS, &abd2);
                                edge = abd2.uEdge;
                            }
                        }
                    }
                }
                top = (edge == ABE_TOP);
                bottom = (edge == ABE_BOTTOM);
                left = (edge == ABE_LEFT);
                right = (edge == ABE_RIGHT);
                if (top) {
                    clientRect->top += 1;
                } else if (bottom) {
                    clientRect->bottom -= 1;
                } else if (left) {
                    clientRect->left += 1;
                } else if (right) {
                    clientRect->right -= 1;
                } else {
                    clientRect->bottom -= 1;
                }
            } else {
                if (isFull && this->m_isWindows11OrGreater) {
                    clientRect->bottom += 1;
                }
            }
        }
        *result = 0;
        return true;
    } else if (uMsg == WM_NCHITTEST) {
        if (m_isWindows11OrGreater) {
            if (hitMaximizeButton()) {
                if (*result == HTNOWHERE) {
                    *result = HTZOOM;
                }
                setMaximizeHovered(true);
                return true;
            }
            setMaximizeHovered(false);
            setMaximizePressed(false);
        }
        POINT nativeGlobalPos{GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam)};
        POINT nativeLocalPos = nativeGlobalPos;
        ::ScreenToClient(hwnd, &nativeLocalPos);
        RECT clientRect{0, 0, 0, 0};
        ::GetClientRect(hwnd, &clientRect);
        auto clientWidth = clientRect.right - clientRect.left;
        auto clientHeight = clientRect.bottom - clientRect.top;
        bool left = nativeLocalPos.x < m_margins;
        bool right = nativeLocalPos.x > clientWidth - m_margins;
        bool top = nativeLocalPos.y < m_margins;
        bool bottom = nativeLocalPos.y > clientHeight - m_margins;
        *result = 0;
        if (!m_fixSize && !isFullScreen() && !isMaximized()) {
            if (left && top) {
                *result = HTTOPLEFT;
            } else if (left && bottom) {
                *result = HTBOTTOMLEFT;
            } else if (right && top) {
                *result = HTTOPRIGHT;
            } else if (right && bottom) {
                *result = HTBOTTOMRIGHT;
            } else if (left) {
                *result = HTLEFT;
            } else if (right) {
                *result = HTRIGHT;
            } else if (top) {
                *result = HTTOP;
            } else if (bottom) {
                *result = HTBOTTOM;
            }
        }
        if (0 != *result) {
            return true;
        }
        if (hitAppBar() && !this->isFullScreen()) {
            *result = HTCAPTION;
            return true;
        }
        *result = HTCLIENT;
        return true;
    } else if (uMsg == WM_NCPAINT) {
        if (WindowEffect::isCompositionEnabled() && !this->isFullScreen()) {
            return false;
        }
        *result = FALSE;
        return true;
    } else if (uMsg == WM_NCACTIVATE) {
        if (WindowEffect::isCompositionEnabled()) {
            return false;
        }
        *result = true;
        return true;
    } else if (m_isWindows11OrGreater && uMsg == WM_NCMOUSELEAVE) {
        setMaximizePressed(false);
        setMaximizeHovered(false);
    } else if (m_isWindows11OrGreater && (uMsg == WM_NCLBUTTONDBLCLK || uMsg == WM_NCLBUTTONDOWN)) {
        if (hitMaximizeButton()) {
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonPress, QPoint(), QPoint(),
                                            Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(m_buttonMaximized, &event);
            setMaximizePressed(true);
            return true;
        }
    } else if (m_isWindows11OrGreater && (uMsg == WM_NCLBUTTONUP || uMsg == WM_NCRBUTTONUP)) {
        if (hitMaximizeButton()) {
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonRelease, QPoint(), QPoint(),
                                            Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(m_buttonMaximized, &event);
            setMaximizePressed(false);
            return true;
        }
    } else if (uMsg == WM_NCRBUTTONDOWN) {
        // 屏蔽右键点击标题弹出系统菜单
        // if (wParam == HTCAPTION) {
        //     auto pos = window()->position();
        //     auto offset = window()->mapFromGlobal(QCursor::pos());
        //     showSystemMenu(QPoint(pos.x() + offset.x(), pos.y() + offset.y()));
        //     return true;
        // }
    } else if (uMsg == WM_KEYDOWN || uMsg == WM_SYSKEYDOWN) {
        const bool altPressed = ((wParam == VK_MENU) || (::GetKeyState(VK_MENU) < 0));
        const bool spacePressed = ((wParam == VK_SPACE) || (::GetKeyState(VK_SPACE) < 0));
        if (altPressed && spacePressed) {
            auto pos = window()->position();
            showSystemMenu(QPoint(pos.x(), qRound(pos.y() + m_appbar->height())));
            return true;
        }
    }
    return false;
#else
    return false;
#endif
}
bool Frameless::isMaximized() {
    return window()->visibility() == QWindow::Maximized;
}

bool Frameless::isFullScreen() {
    return window()->visibility() == QWindow::FullScreen;
}

bool Frameless::hitAppBar() {
    for (int i = 0; i <= _hitTestList.size() - 1; ++i) {
        auto item = _hitTestList.at(i);
        if (Frameless::containsCursorToItem(item)) {
            return false;
        }
    }
    if (Frameless::containsCursorToItem(m_appbar)) {
        return true;
    }
    return false;
}

bool Frameless::hitMaximizeButton() {
    if (Frameless::containsCursorToItem(m_buttonMaximized)) {
        return true;
    }
    return false;
}

void Frameless::setMaximizePressed(bool val) {
    if (m_buttonMaximized) {
        m_buttonMaximized->setProperty("down", val);
    }
}

void Frameless::setMaximizeHovered(bool val) {
    if (m_buttonMaximized) {
        m_buttonMaximized->setProperty("hover", val);
    }
}

void Frameless::updateCursor(int edges) {
    switch (edges) {
        case 0:
            window()->setCursor(Qt::ArrowCursor);
            break;
        case Qt::LeftEdge:
        case Qt::RightEdge:
            window()->setCursor(Qt::SizeHorCursor);
            break;
        case Qt::TopEdge:
        case Qt::BottomEdge:
            window()->setCursor(Qt::SizeVerCursor);
            break;
        case Qt::LeftEdge | Qt::TopEdge:
        case Qt::RightEdge | Qt::BottomEdge:
            window()->setCursor(Qt::SizeFDiagCursor);
            break;
        case Qt::RightEdge | Qt::TopEdge:
        case Qt::LeftEdge | Qt::BottomEdge:
            window()->setCursor(Qt::SizeBDiagCursor);
            break;
        default:
            break;
    }
}

void Frameless::showFullScreen() {
    if (window()->visibility() == QWindow::Maximized) {
        window()->showNormal();
        QTimer::singleShot(150, this, [this] { window()->showFullScreen(); });
    } else {
        window()->showFullScreen();
    }
}

void Frameless::showMaximized() {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    ::ShowWindow(hwnd, 3);
#else
    window()->setVisibility(QQuickWindow::Maximized);
#endif
}

void Frameless::showMinimized() {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    ::ShowWindow(hwnd, 2);
#else
    window()->setVisibility(QQuickWindow::Minimized);
#endif
}

void Frameless::showNormal() {
    window()->setVisibility(QQuickWindow::Windowed);
}

void Frameless::setHitTestVisible(QQuickItem *val) {
    if (!_hitTestList.contains(val)) {
        _hitTestList.append(val);
    }
}

void Frameless::setWindowTopmost(bool topmost) {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    if (topmost) {
        ::SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    } else {
        ::SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    }
#else
    window()->setFlag(Qt::WindowStaysOnTopHint, topmost);
#endif
}

bool Frameless::setWindowDark(bool dark) {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    BOOL value = dark;
    return WindowEffect::dwmSetWindowAttribute(hwnd, 20, &value, sizeof(BOOL));
#endif
    return false;
}

