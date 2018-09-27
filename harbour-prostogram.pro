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
CONFIG += sailfishapp alpha

alpha {
    TARGET = harbour-prostogram-alpha
} else {
    TARGET = harbour-prostogram
}

#TARGET = harbour-prostogram

i18n_files.files = translations
i18n_files.path = /usr/share/$$TARGET

INSTALLS += i18n_files



#QMAKE_CXXFLAGS_RELEASE -= -O
#QMAKE_CXXFLAGS_RELEASE -= -O1
#QMAKE_CXXFLAGS_RELEASE *= -O2


include(QtInstagram/QtInstagram.pri)

SOURCES += src/harbour-prostogram.cpp \
    src/cacheimage.cpp \
    src/downloadmanager.cpp


OTHER_FILES += qml/harbour-prostogram.qml \
    qml/cover/*.qml \
    qml/components/*.qml \
    qml/pages/*.qml \
    qml/*.js \
    rpm/harbour-prostogram.spec \
    translations/* \
    LICENSE

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

DISTFILES += \
    qml/*.qml \
    qml/components/*.qml \
    qml/pages/*.qml \
    qml/images/*.png \
    qml/images/*.jpg \
    qml/images/*.svg \
    qml/components/LoaderImage.qml \
    qml/components/LoaderCarusel.qml \
    qml/images/carusel.svg \
    qml/components/MainItemLoader.qml \
    qml/components/LoaderVideo.qml \
    qml/images/volume-up.svg \
    qml/images/volume-off.svg \
    qml/images/refresh.svg \
    qml/components/SmallMediaElement.qml \
    qml/pages/ExplorePage.qml \
    qml/components/LoaderVideoPreview.qml \
    qml/images/next.svg \
    qml/components/ThreadView.qml \
    qml/components/ThreadMessageItem.qml \
    qml/pages/StoryShowPage.qml \
    qml/components/FeedBottom.qml \
    qml/components/FeedHeader.qml \
    qml/components/StoriesList.qml \
    qml/itemLoader.js \
    qml/MediaTypes.js \
    qml/components/Border.qml \
    qml/pages/SingleMediaPage.qml \
    qml/pages/SearchPage.qml \
    qml/js/Settings.js \
    qml/components/UserFollowItem.qml \
    qml/components/LoaderPreview.qml \
    qml/components/LoaderAd.qml \
    qml/images/usertagged.svg \
    qml/pages/SettingsPage.qml

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
                translations/harbour-prostogram_tt.ts \
                translations/harbour-prostogram.ts \
                translations/harbour-prostogram_zh_CN.ts

HEADERS += \
    src/cacheimage.h \
    src/harbour-prostogram.h \
    src/downloadmanager.h


DEFINES += APP_VERSION=\\\"$$VERSION\\\"
