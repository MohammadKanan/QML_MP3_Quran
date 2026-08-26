#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QSharedPointer>

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int reader MEMBER theReader FINAL)
    Q_PROPERTY(int sora MEMBER theSoraIndex FINAL)
    Q_PROPERTY(QString soraURL MEMBER SoraURL FINAL)
    Q_PROPERTY(double position MEMBER thePosition  FINAL)
public:
    explicit Settings(QObject *parent = nullptr);
    Q_INVOKABLE void saveSettings(const int _reader, const int& _sora , const QString& _soraURL, const double _position);
    Q_INVOKABLE void loadSettings();

private:
    QSharedPointer<QSettings> HamsaSettings = nullptr;
    int theReader;
    int theSoraIndex;
    QString SoraURL;
    double thePosition;

signals:
};

#endif // SETTINGS_H
