# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-prostogram

i18n_files.files = translations
i18n_files.path = /usr/share/$$TARGET

INSTALLS += i18n_files

CONFIG += sailfishapp

SOURCES += src/harbour-prostogram.cpp \
    QtInstagram/src/api/instagram.cpp \
    QtInstagram/src/api/instagramrequest.cpp \
    QtInstagram/src/cripto/hmacsha.cpp

OTHER_FILES += qml/harbour-prostogram.qml \
    qml/cover/*.qml \
    qml/components/*.qml \
    qml/pages/*.qml \
    qml/*.js \
    rpm/harbour-prostogram.spec \
    translations/* \
    LICENSE \
    Changelog

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

DISTFILES += \
    qml/*.qml \
    qml/components/*.qml \
    qml/pages/*.qml \
    qml/images/header_logo.png \
    qml/images/cover.jpg

TRANSLATIONS += translations/harbour-prostogram_ca.ts \
                translations/harbour-prostogram_cs_CZ.ts \
                translations/harbour-prostogram_da.ts \
                translations/harbour-prostogram_de.ts \
                translations/harbour-prostogram_el.ts \
                translations/harbour-prostogram_en.ts \
                translations/harbour-prostogram_es_AR.ts \
                translations/harbour-prostogram_es.ts \
                translations/harbour-prostogram_fi.ts \
                translations/harbour-prostogram_fr.ts \
                translations/harbour-prostogram_it_IT.ts \
                translations/harbour-prostogram_nl_NL.ts \
                translations/harbour-prostogram_pl.ts \
                translations/harbour-prostogram_ru.ts \
                translations/harbour-prostogram_sl_SI.ts \
                translations/harbour-prostogram_sv_SE.ts \
                translations/harbour-prostogram.ts \
                translations/harbour-prostogram_zh_CN.ts

HEADERS += \
    QtInstagram/src/api/instagram.h \
    QtInstagram/src/api/instagramrequest.h \
    QtInstagram/src/cripto/hmacsha.h

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
