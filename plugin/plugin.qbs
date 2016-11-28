import qbs

QtGuiApplication {
    Depends { name: "Android.ndk"; required: false }

    Depends { name: "Qt.core"; versionAtLeast: project.minimumQtVersion }
    Depends { name: "Qt"; submodules: ["qml"] }
    Depends { name: "Qt.webkit"; required: false }
    Depends { name: "openssl"; profiles: [] }

    condition: Qt.webkit.present
    cpp.cxxLanguageVersion: "c++11"
    cpp.rpaths: qbs.targetOS.contains("darwin") ? ["@loader_path/../Frameworks"] : undefined
    consoleApplication: true
    targetName: "qt-tv-npapi-host"

    Properties {
        condition: qbs.targetOS.contains("android")
        architectures: ["x86", "armv7"]
        Android.ndk.appStl: "gnustl_shared"
    }

    architectures: undefined

    files: [
        "Info.plist",
    ]

    Group {
        name: "C++"
        prefix: "cpp/"
        files: [
            "main.cpp",
        ]
    }

    QMLGroup {
        name: "QML"
        prefix: "qml/"
        files: [
            "main.qml",
        ]
    }

    Group {
        fileTagsFilter: product.type
        qbs.install: true
        qbs.installDir: qbs.targetOS.contains("darwin")
                        ? "Applications/Qt TV.app/Contents/Executables"
                        : "bin"
    }
}
