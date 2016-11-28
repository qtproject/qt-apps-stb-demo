TEMPLATE = app
QT += core gui qml quick network multimedia
qtHaveModule(webengine): QT += webengine
qtHaveModule(webview): QT += webview

darwin: \
    TARGET = "Qt TV"
else: \
    TARGET = qt-tv

darwin: QMAKE_RPATHDIR += @loader_path/../Frameworks

SOURCES += \
    cpp/cuterectangle.cpp \
    cpp/main.cpp \
    cpp/processcontroller.cpp \
    cpp/webutils.cpp

HEADERS += \
    cpp/cuterectangle.h \
    cpp/processcontroller.h \
    cpp/webutils.h

RESOURCES += \
    ../assets/assets.qrc \
    ../assets/shared.qrc \
    qml/qml.qrc

exists(../secrets/TMDb.qml):exists(../secrets/YouTube.qml): \
    RESOURCES += ../APIKeys.qrc

macos: QMAKE_INFO_PLIST = Info.plist
ios|tvos: QMAKE_INFO_PLIST = Info-ios.plist

qtHaveModule(webkit):macos {
    plugin_exe.files = "$$OUT_PWD/../plugin/qt-tv-npapi-host"
    plugin_exe.path = Contents/Executables
    QMAKE_BUNDLE_DATA += plugin_exe
}

darwin: \
    target.path = /Applications
else: \
    target.path = /bin
INSTALLS += target

android {
    DISTFILES += \
        android/AndroidManifest.xml \
        android/res/values/libs.xml \
        android/build.gradle

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}
