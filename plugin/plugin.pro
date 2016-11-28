TEMPLATE = app
QT += qml webkit
CONFIG += console
CONFIG -= app_bundle

TARGET = qt-tv-npapi-host

darwin {
    QMAKE_RPATHDIR += @loader_path/../Frameworks
    QMAKE_LFLAGS += "-Wl,-sectcreate,__TEXT,__info_plist,$$PWD/Info.plist"
}


SOURCES += \
    cpp/main.cpp

RESOURCES += \
    qml/qml.qrc
