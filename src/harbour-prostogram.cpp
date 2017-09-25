#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include <QQuickView>
#include <QtQml>
#include <QTranslator>

#include "QtInstagram/src/api/instagramv2.h"
#include "cacheimage.h"
//#define APP_VERSION "0.8.4"

int main(int argc, char *argv[])
{
   QGuiApplication* app = SailfishApp::application(argc, argv);
   QString translationPath(SailfishApp::pathTo("translations").toLocalFile());

   QScopedPointer <QQuickView> view(SailfishApp::createView());
   app->setApplicationName("harbour-prostogram");
   //app->setOrganizationDomain("harbour-prostogram");
   //app->setOrganizationName("harbour-prostogram");

   QTranslator *translator = new QTranslator();
   translator->load(QLocale::system(), "harbour-prostogram", "_", translationPath);
   app->installTranslator(translator);

   app->setApplicationVersion(QString(APP_VERSION));

   view->setTitle("Prostogram");

   //view->rootContext()->setContextProperty("Home",QDir::homePath());

   qmlRegisterType<Instagramv2>("harbour.prostogram",1,0,"Instagram");
   qmlRegisterType<CacheImage>("harbour.prostogram.cache",1,0,"CacheImage");

   QUrl pageSource = SailfishApp::pathTo("qml/harbour-prostogram.qml");
   QObject::connect((QObject*)view->engine(), SIGNAL(quit()), app, SLOT(quit()));
   view->setSource(pageSource);
   //view->showFullScreen();
   view->show();

   return app->exec();
}

