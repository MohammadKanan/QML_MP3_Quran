#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QFile>
#include <QUrl>
class Downloader : public QObject
{
    Q_OBJECT
public:
    explicit Downloader(QObject *parent = nullptr);
    ~Downloader();
    Q_INVOKABLE void startDownload(const QUrl &url, const QString &mp3File , const int _folder);
    Q_INVOKABLE QString checkSoraDownloaded(const QString& soraIndex , const int& reader);

private slots:
    void onReadyRead();
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void onFinished();

private:
    QNetworkAccessManager m_manager;
    QNetworkReply *m_reply = nullptr;
    QFile m_file;
    QString full_Path;
signals:
    void progressChanged(qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(bool success, QString message);

};

#endif // DOWNLOADER_H
