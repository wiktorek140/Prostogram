#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QtNetwork>
#include <QtCore>

class DownloadManager: public QObject
{
    Q_OBJECT
public:
    explicit DownloadManager(QObject *parent = nullptr);

    void append(const QUrl &url);
    void append(const QStringList &urls);
    static QString saveFileName(const QUrl &url);

signals:
    void finished();

private slots:
    void startNextDownload();
    void downloadFinished();
    void downloadReadyRead();

private:
    bool isHttpRedirect() const;
    void reportRedirect();

    const QString cacheLocation = QStandardPaths::writableLocation(QStandardPaths::CacheLocation)+"/images/";

    QNetworkAccessManager manager;
    QQueue<QUrl> downloadQueue;
    QNetworkReply *currentDownload = nullptr;
    QFile output;
    QTime downloadTime;

    int downloadedCount = 0;
    int totalCount = 0;
    bool isProile = false;
};

#endif
