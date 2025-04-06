#pragma once
#include <QtQml>
#include <QObject>
#include <QAbstractNativeEventFilter>
#include <QQmlProperty>
#include <QQuickItem>
#pragma comment(lib, "user32.lib")
#pragma comment(lib, "dwmapi.lib")
#include <windows.h>
#include <windowsx.h>
#include <winuser.h>
#include <dwmapi.h>

class WindowEffect
{
public:
    WindowEffect();
    static QByteArray qtNativeEventType();
    template <typename FuncPtrType>
    static FuncPtrType loadUserFunction(const char *functionName);
    template <typename FuncPtrType>
    static FuncPtrType loadDwmFunction(const char *functionName);
    static UINT getDpiForWindow(HWND hwnd);
    static int getSystemMetricsForDpi(int nIndex, UINT dpi);
    static bool isCompositionEnabled();
    static bool dwmExtendFrameIntoClientArea(HWND hwnd, MARGINS mragins);
    static bool dwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute,
                               _In_reads_bytes_(cbAttribute) LPCVOID pvAttribute,
                               DWORD cbAttribute);
    static std::optional<MONITORINFOEXW> getMonitorForWindow(const HWND hwnd);
    static bool isFullScreen(const HWND hwnd);
    static bool isMaximized(const HWND hwnd);
    static quint32 getDpiForWindow(const HWND hwnd, const bool horizontal);
    static int getSystemMetrics(const HWND hwnd, const int index, const bool horizontal);
    static quint32 getResizeBorderThickness(const HWND hwnd, const bool horizontal,
                                     const qreal devicePixelRatio);
    static void setWindowEffect(HWND hwnd, int type);



};


