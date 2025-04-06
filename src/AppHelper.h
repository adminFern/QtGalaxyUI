#ifndef APPHELPER_H
#define APPHELPER_H
#include <QObject>
#include <QQmlEngine>
class AppHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isOSTheme READ isOSTheme NOTIFY themeChanged)


    QML_ELEMENT
    QML_SINGLETON

public:
    explicit AppHelper(QObject *parent = nullptr);
     ~AppHelper();  // 添加析构函数声明
    bool isOSTheme() const;
    Q_INVOKABLE QString resolvedUrl(const QString &path);

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;
     QQmlEngine *m_engine = nullptr;
     QString m_baseUrl=nullptr;

signals:
    void themeChanged(bool isDark);
};

#endif // APPHELPER_H
