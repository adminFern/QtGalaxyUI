#include "Tools.h"
#include <QGuiApplication>
#include <QCursor>
#include <QPalette>
#include <QClipboard>
#include <QScreen>
#include <QIcon>

Tools::Tools(QObject *parent) : QObject{parent} {
}

QColor Tools::withOpacity(const QColor &color, qreal opacity) {
    int alpha = qRound(opacity * 255) & 0xff;
    return QColor::fromRgba((alpha << 24) | (color.rgba() & 0xffffff));
}

int Tools::windowBuildNumber() {
#if defined(Q_OS_WIN)
    QSettings regKey{
        QString::fromUtf8(R"(HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion)"),
        QSettings::NativeFormat};
    if (regKey.contains(QString::fromUtf8("CurrentBuildNumber"))) {
        auto buildNumber = regKey.value(QString::fromUtf8("CurrentBuildNumber")).toInt();
        return buildNumber;
    }
#endif
    return -1;
}

bool Tools::isWindows11OrGreater() {
    static QVariant var;
    if (var.isNull()) {
#if defined(Q_OS_WIN)
        auto buildNumber = windowBuildNumber();
        if (buildNumber >= 22000) {
            var = QVariant::fromValue(true);
            return true;
        }
#endif
        var = QVariant::fromValue(false);
        return false;
    } else {
        return var.toBool();
    }
}

bool Tools::isUrl(const QString &val) {
    QUrl url(val);
    return url.isValid() && !url.scheme().isEmpty();
}

void Tools::clipText(const QString &text) {
    QGuiApplication::clipboard()->setText(text);
}

void Tools::deleteLater(QObject *p) {
    if (p) {
        p->deleteLater();
    }
}

QString Tools::readFile(const QString &fileName) {
    QString content;
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        content = stream.readAll();
    }
    return content;
}

bool Tools::writeFile(const QString &fileName, const QString &content) {
    QFile file(fileName);
    if (file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);
        stream << content;
        return true;
    }
    return false;
}

void Tools::setOverrideCursor(Qt::CursorShape shape) {
    QGuiApplication::setOverrideCursor(QCursor(shape));
}

void Tools::restoreOverrideCursor() {
    QGuiApplication::restoreOverrideCursor();
}

QImage Tools::captureDesktop() {
    QScreen *screen = QGuiApplication::screens().at(cursorScreenIndex());
    if (screen) {
        return screen->grabWindow(0).toImage();
    }
    return QImage();
}

int Tools::cursorScreenIndex() {
    int screenIndex = 0;
    int screenCount = QGuiApplication::screens().count();
    if (screenCount > 1) {
        QPoint pos = QCursor::pos();
        for (int i = 0; i <= screenCount - 1; ++i) {
            if (QGuiApplication::screens().at(i)->geometry().contains(pos)) {
                screenIndex = i;
                break;
            }
        }
    }
    return screenIndex;
}
