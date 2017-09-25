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
    QTextStream(stdout) << "Write Path: " << cacheLocation << endl;
}

QString CacheImage::getFromCache(const QString &str){
    QUrl url(str);

    path = cacheLocation+url.fileName();
    //QTextStream(stdout) << "File Path: " << path << endl;
    if(QFile::exists(path) && QFile(path).size()>0)
        return path;
    else {
        downloaded=false;
        QDir::setCurrent(cacheLocation);
        output.setFileName(url.fileName());
        output.open(QIODevice::WriteOnly);

        requestImage(url);

        return path;
    }
}

void CacheImage::requestImage(const QUrl &url){

    //QNetworkRequest request(url);
    //QNetworkAccessManager manager;
    currentDownload = manager.get(QNetworkRequest(QUrl(url)));
    connect(currentDownload, SIGNAL(finished()),
            SLOT(downloadFinished()));
    connect(currentDownload, SIGNAL(readyRead()),
            SLOT(downloadReadyRead()));


    QEventLoop event;
    connect(currentDownload,SIGNAL(finished()),&event,SLOT(quit()));
    event.exec();
}

void CacheImage::downloadFinished()
{
    //output.close();
    //QTextStream(stdout) <<"Download finished"<<endl;
    downloaded=true;
    output.close();
    if (currentDownload->error()) {
        QTextStream(stdout) <<"Error:"<<currentDownload->errorString();
    } else {
        emit finishedImage();
    }

    currentDownload->deleteLater();
}

void CacheImage::downloadReadyRead()
{
    output.write(currentDownload->readAll());
    //QTextStream(stdout) <<"Odczyt udany";
    //emit finishedImage();
}



void CacheImage::clean(){

    QDir::setCurrent(cacheLocation);
    QDir dir(cacheLocation);
    if(dir.count()>100){
        dir.removeRecursively();
        QTextStream(stdout) <<"cache cleaned"<<endl;
    }
}

