#include "downloadmanager.h"

#include <QTextStream>
#include <QDebug>

using namespace std;

DownloadManager::DownloadManager(QObject *parent)
    : QObject(parent)
{
}

void DownloadManager::append(const QStringList &urls)
{
    for (const QString &urlAsString : urls)
        append(QUrl::fromEncoded(urlAsString.toLocal8Bit()));

    //if (downloadQueue.isEmpty())
    //QTimer::singleShot(0, this, SIGNAL(finished()));
}

void DownloadManager::append(const QUrl &url)
{
    if (downloadQueue.isEmpty())
        QTimer::singleShot(0, this, SLOT(startNextDownload()));

    downloadQueue.enqueue(url);
    ++totalCount;
}

QString DownloadManager::saveFileName(const QUrl &url)
{
    QString path = url.path();
    QString basename = QFileInfo(path).fileName();

    if (basename.isEmpty())
        basename = "download";

    if (QFile::exists(basename)) {
        //qDebug()<<"FileExist, force overwrite!";
        // already exists, don't overwrite
        //int i = 0;
        //basename += '.';
        //while (QFile::exists(basename + QString::number(i)))
        //    ++i;

        //basename += QString::number(i);
    }

    return basename;
}

void DownloadManager::startNextDownload()
{
    if (downloadQueue.isEmpty()) {
        qDebug("%d/%d files downloaded successfully\n", downloadedCount, totalCount);
        //emit finished();
        return;
    }

    QUrl url = downloadQueue.dequeue();
    QDir::setCurrent(cacheLocation);
    QString filename = url.fileName();
    //QFile file(filename);
    //if(!file.isOpen()){
        output.setFileName(filename);

        if(output.exists() && output.size() >= 1){
            qDebug("File Exist. Skip.");
            return;
        }
        if (!output.open(QIODevice::WriteOnly)) {
            qDebug("Problem opening save file '%s' for download '%s': %s\n",
                   qPrintable(filename), url.toEncoded().constData(),
                   qPrintable(output.errorString()));

            startNextDownload();
            return;
        }

        QNetworkRequest request(url);
        currentDownload = manager.get(request);
        connect(currentDownload, SIGNAL(finished()),
                SLOT(downloadFinished()));
        connect(currentDownload, SIGNAL(readyRead()),
                SLOT(downloadReadyRead()));

        // prepare the output
        qDebug("Downloading %s...\n", url.toEncoded().constData());
        downloadTime.start();

    //}
}


void DownloadManager::downloadFinished()
{
    output.close();
    emit fileDownloaded(cacheLocation + output.fileName());
    if (currentDownload->error()) {
        // download failed
        qDebug()<<"Failed"<<currentDownload->errorString();
        //qDebug("Failed: %s\n", qPrintable(currentDownload->errorString()));
        output.remove();
    } else {
        // let's check if it was actually a redirect
        if (isHttpRedirect()) {
            reportRedirect();
            output.remove();
        } else {
            //printf("Succeeded.\n");
            ++downloadedCount;
        }
    }

    //currentDownload->deleteLater();
    currentDownload->close();
    startNextDownload();
}

void DownloadManager::downloadReadyRead()
{
    //output.write(currentDownload->readAll());

    if(output.isOpen() && output.isWritable()) {
        while(currentDownload->bytesAvailable()){
            output.write(currentDownload->read(4096));
        }
    }
    else {
        qDebug()<<"File closed lub huj wie co...";

    }
}

bool DownloadManager::isHttpRedirect() const
{
    int statusCode = currentDownload->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    return statusCode == 301 || statusCode == 302 || statusCode == 303
            || statusCode == 305 || statusCode == 307 || statusCode == 308;
}

void DownloadManager::reportRedirect()
{
    int statusCode = currentDownload->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QUrl requestUrl = currentDownload->request().url();
    QTextStream(stderr) << "Request: " << requestUrl.toDisplayString()
                        << " was redirected with code: " << statusCode
                        << '\n';

    QVariant target = currentDownload->attribute(QNetworkRequest::RedirectionTargetAttribute);
    if (!target.isValid())
        return;
    QUrl redirectUrl = target.toUrl();
    if (redirectUrl.isRelative())
        redirectUrl = requestUrl.resolved(redirectUrl);
    QTextStream(stderr) << "Redirected to: " << redirectUrl.toDisplayString()
                        << '\n';
}
