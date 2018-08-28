#include "cacheimage.h"

CacheImage::CacheImage(QObject *parent) : QObject(parent) {
}

void CacheImage::init() {
    QDir::setCurrent(cacheLocation);
    QDir c(cacheLocation);
    if(!c.exists()){
        c.mkdir(cacheLocation);
    }
    c.setPath(cacheLocation+"profilePic");
    if(!c.exists()){
        c.mkdir(cacheLocation+"profilePic");
    }
}

void CacheImage::clean(){
    QDir::setCurrent(cacheLocation);
    QDir dir(cacheLocation);
    if(dir.count()>300){
        dir.removeRecursively();
    }
    if(!dir.exists())dir.mkdir(cacheLocation);
}


QVariant CacheImage::getFromCache2(const QString &str) {
    QUrl *url = new QUrl(str);
    QString path = cacheLocation + "/" + url->fileName();
    if(QFile::exists(path)) {
        //qDebug()<< "File Exist - "<<url->toString();
        return path;
    }
    else {
        downloadManager.append(*url);
        //qDebug()<< "File Requested - "<<url->toString();
        return url->toString();
    }
}


QVariant CacheImage::getFromCache(const QString &str,bool forceDownload) {
    QUrl *url = new QUrl(str);
    QString path = cacheLocation + "/" + url->fileName();

    if(forceDownload) {
        if(QFile::exists(path)) {
            qDebug()<< "File Exist - Force remove - "<<url->toString();
            QFile::remove(path);
        }
    } else {
        if(QFile::exists(path)) {
            qDebug()<< "File Exist - "<<url->toString();
            return path;
        }
    }
    downloadManager.append(*url);
    //return path;
    return url->toString();

}

QVariant CacheImage::getUserImageFromCache(const QString &str, bool forceDownload) {
    QUrl url(str);
    QString path = cacheLocation +"/profilePic/"+ url.fileName();

    if(forceDownload) {
        if(QFile::exists(path)) {
            qDebug()<< "File Exist - Force remove - "<<url.toString();
            QFile::remove(path);
        }
    } else {
        if(QFile::exists(path)) {
            qDebug()<< "File Exist - "<<url.toString();
            return path;
        }
    }
    downloadManager.append(url);
    //return path;
    return url.toString();

}
