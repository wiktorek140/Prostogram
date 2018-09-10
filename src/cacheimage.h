#ifndef CACHEIMAGE_H
#define CACHEIMAGE_H

#include <QObject>
#include <QUrl>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QStandardPaths>

#include "downloadmanager.h"

class CacheImage : public QObject
{
    Q_OBJECT
public:
    explicit CacheImage(QObject *parent = 0);

    Q_INVOKABLE void init();
    Q_INVOKABLE void clean();

    Q_INVOKABLE QVariant getFromCache(const QString &str, bool forceDownload = false);
    Q_INVOKABLE QVariant getUserImageFromCache(const QString &str, bool forceDownload = false);
    Q_INVOKABLE QVariant getFromCache2(const QString &str);

    const QString cacheLocation = QStandardPaths::writableLocation(QStandardPaths::CacheLocation)+"/images/";

private:
    DownloadManager downloadManager;
};

#endif // CACHEIMAGE_H
