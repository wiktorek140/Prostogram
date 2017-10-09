#include "cacheimage.h"

CacheImage::CacheImage(QObject *parent) : QObject(parent)
{
}

void CacheImage::init() {
    QDir::setCurrent(cacheLocation);
    QDir c(cacheLocation);
    if(!c.exists()){
        c.mkdir(cacheLocation);
    }
}

QString CacheImage::getFromCache(const QString &str){
    QUrl url(str);
    path = cacheLocation+"/"+url.fileName();
    if(QFile::exists(path) && QFile(path).size()>0)
        return path;
    else {
        downloaded=false;
        QDir::setCurrent(cacheLocation);
        output.setFileName(url.fileName());
        requestImage(url);
        return path;
    }
}

void CacheImage::requestImage(const QUrl &url){
    currentDownload = manager.get(QNetworkRequest(QUrl(url)));
    connect(currentDownload, &QIODevice::readyRead,
            this, &CacheImage::downloadReadyRead);
    connect(currentDownload, &QNetworkReply::finished,
            this, &CacheImage::downloadFinished);


    QEventLoop event;
    connect(currentDownload,&QNetworkReply::finished,&event,&QEventLoop::quit);
    event.exec();
}

void CacheImage::downloadFinished()
{
    downloaded=true;
    output.close();
    if (currentDownload->error()) {
        qDebug() << "Error: " << currentDownload->errorString();
    } else {
        emit finishedImage();
    }
    currentDownload->deleteLater();
}

void CacheImage::downloadReadyRead()
{
    if(!output.isOpen()){output.open(QIODevice::WriteOnly);}
    output.write(currentDownload->readAll());
}

void CacheImage::clean(){
    QDir::setCurrent(cacheLocation);
    QDir dir(cacheLocation);
    if(dir.count()>100){
        dir.removeRecursively();
    }
}
