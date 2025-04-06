#ifndef APPHELPER_H
#define APPHELPER_H
#include <QObject>
#include <QQmlEngine>
class AppHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isOSTheme READ isOSTheme NOTIFY themeChanged)
    QML_NAMED_ELEMENT(AppHelper)
    QML_UNCREATABLE("")
    QML_SINGLETON

public:
    explicit AppHelper(QObject *parent = nullptr);
     ~AppHelper();  // 添加析构函数声明
    bool isOSTheme() const;

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;

signals:
    void themeChanged(bool isDark);
};

#endif // APPHELPER_H
