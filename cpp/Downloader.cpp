#include "Downloader.h"
#include <QDir>
#include <QCoreApplication>
#include <QStandardPaths>

Downloader::Downloader(QObject *parent)
    : QObject{parent}
{}

Downloader::~Downloader()
{
    if (m_reply) {
        m_reply->deleteLater();
    }
}

void Downloader::startDownload(const QUrl &url, const QString &savePath , const int _folder)
{
    //QDir dir(QCoreApplication::applicationDirPath());
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::DownloadLocation));
    if (!dir.cd("Quran")){
        qDebug() << "Creating Quran  ...";
        dir.mkdir("Quran");
        dir.cd("Quran");
    }

    dir.mkdir(QString("%1").arg(_folder));
    dir.cd(QString("%1").arg(_folder));
    auto full_PATH = dir.absolutePath() + "/";
    full_PATH += savePath;
    qDebug() << "Starting download ..." << url << " ..to " << full_PATH;
    m_file.setFileName(full_PATH);
    connect(this, &Downloader::progressChanged, [](qint64 received, qint64 total) {
        qDebug() << "Progress:" << received << "/" << total << "bytes";
    });

    connect(this, &Downloader::downloadFinished, [](bool success, const QString &msg) {
        qDebug() << (success ? "Success: " : "Error: ") << msg;
    });
    // Open the local file for writing chunked data
    if (!m_file.open(QIODevice::WriteOnly)) {
        Q_EMIT downloadFinished(false, "Could not open local file for writing.");
        qDebug() << "Could not save to local file!";
        return;
    }

    QNetworkRequest request(url);

    // Optional: Follow redirects automatically (highly recommended for media URLs)
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);
    // Connect status trackers to UI text indicators or QProgressBar elements

    m_reply = m_manager.get(request);

    // Establish critical async streaming signal connections
    connect(m_reply, &QNetworkReply::readyRead, this, &Downloader::onReadyRead);
    connect(m_reply, &QNetworkReply::downloadProgress, this, &Downloader::onDownloadProgress);
    connect(m_reply, &QNetworkReply::finished, this, &Downloader::onFinished);
}

QString Downloader::checkSoraDownloaded(const QString &soraIndex, const int &reader)
{
    auto URL = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    URL += QString("/Quran/%1/%2.mp3").arg(reader).arg(soraIndex);
    qDebug() << "Checking ..." << URL;
    QFile Sora(URL);
    if(Sora.exists()){
        qDebug() << "Sora found locall at " << URL;
        return URL;
    }
    else{
        qDebug() << "Sora should be downloaded to " << URL;
        return QString();
    }
}

void Downloader::onReadyRead() {
    // Write new chunks to disk immediately to save RAM footprint
    if (m_reply && m_file.isOpen()) {
        m_file.write(m_reply->readAll());
    }
}

void Downloader::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal) {
    emit progressChanged(bytesReceived, bytesTotal);
}
void Downloader::onFinished() {
    m_file.close(); // Safeguard data lock closure

    if (m_reply->error() != QNetworkReply::NoError) {
        emit downloadFinished(false, m_reply->errorString());
    } else {
        emit downloadFinished(true, "Download completed successfully!");
    }

    m_reply->deleteLater();
    m_reply = nullptr;
}