#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include <QQuickView>
#include <QtQml>
#include <QTranslator>
#include "QtInstagram/src/api2/instagramv2.h"

#include "harbour-prostogram.h"
#include "cacheimage.h"

int main(int argc, char *argv[])
{
   QGuiApplication* app = SailfishApp::application(argc, argv);
   QString translationPath(SailfishApp::pathTo("translations").toLocalFile());

   QScopedPointer <QQuickView> view(SailfishApp::createView());
   app->setApplicationName("harbour-prostogram");

   QTranslator *translator = new QTranslator();
   translator->load(QLocale::system(), "harbour-prostogram", "_", translationPath);
   app->installTranslator(translator);

   app->setApplicationVersion(QString(APP_VERSION));

   view->setTitle("Prostogram");

   qmlRegisterType<Instagramv2>("harbour.prostogram", 1,0, "Instagram");
   qmlRegisterType<CacheImage>("harbour.prostogram.cache", 1,0, "CacheImage");
   //qmlRegisterType<Capturer>("harbour.prostogram.saver", 1,0, "Capturer");

   QUrl pageSource = SailfishApp::pathTo("qml/harbour-prostogram.qml");
   view->setSource(pageSource);
   view->show();
   return app->exec();
}

