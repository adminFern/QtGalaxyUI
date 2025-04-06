#include "WindowEffect.h"

WindowEffect::WindowEffect() {

}
QByteArray WindowEffect::qtNativeEventType(){
    static const auto result = "windows_generic_MSG";
    return result;
}
template <typename FuncPtrType>
FuncPtrType WindowEffect::loadUserFunction(const char *functionName){
    HMODULE module = LoadLibraryW(L"user32.dll");
    if (module) {
        return reinterpret_cast<FuncPtrType>(GetProcAddress(module, functionName));
    }
    return nullptr;
}
template <typename FuncPtrType>
FuncPtrType WindowEffect::loadDwmFunction(const char *functionName){

    HMODULE module = LoadLibraryW(L"dwmapi.dll");
    if (module) {
        return reinterpret_cast<FuncPtrType>(GetProcAddress(module, functionName));
    }
    return nullptr;
}
UINT WindowEffect::getDpiForWindow(HWND hwnd){

    typedef UINT(WINAPI * GetDpiForWindowPtr)(HWND hWnd);
    GetDpiForWindowPtr get_dpi_for_window = loadUserFunction<GetDpiForWindowPtr>("GetDpiForWindow");
    if (get_dpi_for_window) {
        return get_dpi_for_window(hwnd);
    }
    return 96;
}

int WindowEffect::getSystemMetricsForDpi(int nIndex, UINT dpi){
    typedef int(WINAPI * GetSystemMetricsForDpiPtr)(int nIndex, UINT dpi);
    GetSystemMetricsForDpiPtr get_system_metrics_for_dpi =
        loadUserFunction<GetSystemMetricsForDpiPtr>("GetSystemMetricsForDpi");
    if (get_system_metrics_for_dpi) {
        return get_system_metrics_for_dpi(nIndex, dpi);
    }
    return GetSystemMetrics(nIndex);
}
bool WindowEffect::isCompositionEnabled(){

    typedef HRESULT(WINAPI * DwmIsCompositionEnabledPtr)(BOOL * pfEnabled);
    DwmIsCompositionEnabledPtr dwm_is_composition_enabled =
        loadDwmFunction<DwmIsCompositionEnabledPtr>("DwmIsCompositionEnabled");
    if (dwm_is_composition_enabled) {
        BOOL composition_enabled = FALSE;
        dwm_is_composition_enabled(&composition_enabled);
        return composition_enabled;
    }
    return false;
}
bool WindowEffect::dwmExtendFrameIntoClientArea(HWND hwnd, MARGINS mragins){
    typedef HRESULT(WINAPI * DwmExtendFrameIntoClientAreaPtr)(HWND hWnd, const MARGINS *pMarInset);
    DwmExtendFrameIntoClientAreaPtr dwm_extendframe_into_client_area_ =
        loadDwmFunction<DwmExtendFrameIntoClientAreaPtr>("DwmExtendFrameIntoClientArea");
    if (dwm_extendframe_into_client_area_) {
        dwm_extendframe_into_client_area_(hwnd, &mragins);
        return true;
    }
    return false;
}
bool WindowEffect::dwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute,
                                         _In_reads_bytes_(cbAttribute) LPCVOID pvAttribute,
                                         DWORD cbAttribute){


    typedef HRESULT(WINAPI * DwmSetWindowAttributePtr)(
        HWND hwnd, DWORD dwAttribute, _In_reads_bytes_(cbAttribute) LPCVOID pvAttribute,
        DWORD cbAttribute);
    DwmSetWindowAttributePtr dwm_set_window_attribute_ =
        loadDwmFunction<DwmSetWindowAttributePtr>("DwmSetWindowAttribute");
    if (dwm_set_window_attribute_) {
        dwm_set_window_attribute_(hwnd, dwAttribute, pvAttribute, cbAttribute);
        return true;
    }
    return false;
}
std::optional<MONITORINFOEXW> WindowEffect::getMonitorForWindow(const HWND hwnd){

    Q_ASSERT(hwnd);
    if (!hwnd) {
        return std::nullopt;
    }
    const HMONITOR monitor = ::MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
    if (!monitor) {
        return std::nullopt;
    }
    MONITORINFOEXW monitorInfo;
    ::SecureZeroMemory(&monitorInfo, sizeof(monitorInfo));
    monitorInfo.cbSize = sizeof(monitorInfo);
    if (::GetMonitorInfoW(monitor, &monitorInfo) == FALSE) {
        return std::nullopt;
    }
    return monitorInfo;
}
bool WindowEffect::isFullScreen(const HWND hwnd) {
    RECT windowRect = {};
    if (::GetWindowRect(hwnd, &windowRect) == FALSE) {
        return false;
    }
    const std::optional<MONITORINFOEXW> mi = getMonitorForWindow(hwnd);
    if (!mi.has_value()) {
        return false;
    }
    RECT rcMonitor = mi.value().rcMonitor;
    return windowRect.top == rcMonitor.top && windowRect.left == rcMonitor.left &&
           windowRect.right == rcMonitor.right && windowRect.bottom == rcMonitor.bottom;
}
bool WindowEffect::isMaximized(const HWND hwnd) {
    WINDOWPLACEMENT wp;
    ::GetWindowPlacement(hwnd, &wp);
    return wp.showCmd == SW_MAXIMIZE;
}
quint32 WindowEffect::getDpiForWindow(const HWND hwnd, const bool horizontal) {
    if (const UINT dpi = getDpiForWindow(hwnd)) {
        return dpi;
    }
    if (const HDC hdc = ::GetDC(hwnd)) {
        bool valid = false;
        const int dpiX = ::GetDeviceCaps(hdc, LOGPIXELSX);
        const int dpiY = ::GetDeviceCaps(hdc, LOGPIXELSY);
        if ((dpiX > 0) && (dpiY > 0)) {
            valid = true;
        }
        ::ReleaseDC(hwnd, hdc);
        if (valid) {
            return (horizontal ? dpiX : dpiY);
        }
    }
    return 96;
}
int WindowEffect::getSystemMetrics(const HWND hwnd, const int index, const bool horizontal) {
    const UINT dpi = getDpiForWindow(hwnd, horizontal);
    if (const int result = getSystemMetricsForDpi(index, dpi); result > 0) {
        return result;
    }
    return ::GetSystemMetrics(index);
}
void WindowEffect::setWindowEffect(HWND hwnd, int type) {

    MARGINS margins{1, 1, 0, 1};
    //云母
    if (type == 0x0001) {
        dwmExtendFrameIntoClientArea(hwnd, margins);
        int system_backdrop_type = 2;
        dwmSetWindowAttribute(hwnd, 38, &system_backdrop_type, sizeof(int));
    } else if (type == 0x0002) {
        //亚克力
        dwmExtendFrameIntoClientArea(hwnd, margins);
        int system_backdrop_type = 3;
        dwmSetWindowAttribute(hwnd, 38, &system_backdrop_type, sizeof(int));
    }else if (type == 0x0004){ //深度 韵母
        dwmExtendFrameIntoClientArea(hwnd, margins);
        int system_backdrop_type = 4;
        dwmSetWindowAttribute(hwnd, 38, &system_backdrop_type, sizeof(int));
    } else {
        dwmExtendFrameIntoClientArea(hwnd, margins);//正常
    }

}
quint32 WindowEffect::getResizeBorderThickness(const HWND hwnd, const bool horizontal,
                                               const qreal devicePixelRatio) {
    auto frame = horizontal ? SM_CXSIZEFRAME : SM_CYSIZEFRAME;
    auto result =
        getSystemMetrics(hwnd, frame, horizontal) + getSystemMetrics(hwnd, 92, horizontal);
    if (result > 0) {
        return result;
    }
    int thickness = isCompositionEnabled() ? 8 : 4;
    return qRound(thickness * devicePixelRatio);
}
