import qbs
import qbs.File
import qbs.FileInfo
import qbs.Utilities

Project {
    AndroidApk {
        condition: qbs.targetOS.contains("android")
        name: "qt-tv"
        packageName: "io.qt.stbdemo"
        targetName: "qt-tv"
        Depends {
            productTypes: ["android.nativelibrary"]
            limitToSubProject: true
        }
    }

    QtGuiApplication {
        Depends { name: "Android.ndk"; required: false }

        Depends { name: "Qt.core"; versionAtLeast: project.minimumQtVersion }
        Depends { name: "Qt"; submodules: ["gui", "qml", "quick", "network", "multimedia"] }
        Depends { name: "openssl"; profiles: [] }

        Depends { name: "Qt.webengine"; required: false }
        Depends { name: "Qt.webview"; required: false }

        Properties {
            condition: qbs.targetOS.contains("android")
            architectures: ["x86", "armv7"]
            Android.ndk.appStl: "gnustl_shared"
        }

        architectures: undefined
        cpp.minimumIosVersion: "8.0"
        cpp.cxxLanguageVersion: "c++11"
        cpp.rpaths: qbs.targetOS.contains("darwin") ? ["@loader_path/../Frameworks"] : undefined
        bundle.isBundle: qbs.targetOS.contains("darwin")
        targetName: bundle.isBundle ? "Qt TV" : "qt-tv"

        files: [
            "Info.plist",
        ]

        Group {
            name: "C++"
            prefix: "cpp/"
            files: [
                "main.cpp",
                "processcontroller.cpp",
                "processcontroller.h",
                "cuterectangle.cpp",
                "cuterectangle.h",
                "webutils.cpp",
                "webutils.h",
            ]
        }

        Group {
            name: "Resources"
            files: [
                "../assets/assets.qrc",
                "../assets/shared.qrc",
            ]
        }

        QMLGroup {
            name: "API Keys"
            condition: files.every(function (f) {
                return File.exists(FileInfo.joinPaths(product.sourceDirectory, prefix, f));
            })
            prefix: "../secrets/"
            files: [
                "TMDb.qml",
                "YouTube.qml"
            ]

            Qt.core.resourceSourceBase: "../secrets"
            Qt.core.resourcePrefix: "/secrets"
        }

        QMLGroup {
            name: "QML"
            prefix: "qml/"
            files: [
                "main.qml",
            ]
        }

        QMLGroup {
            name: "QML - Components"
            prefix: "qml/components/"
            files: [
                "Colors.qml",
                "Fonts.qml",
                "JSONListModel.qml",
                "JSONQuery.qml",
                "Settings.qml",
            ]
        }

        QMLGroup {
            name: "QML - Controls"
            prefix: "qml/controls/"
            files: [
                "+webengine/WebView.qml",
                "+webview/WebView.qml",
                "AbstractButton.qml",
                "ApplicationButton.qml",
                "ApplicationWindow.qml",
                "BaseScreen.qml",
                "BusyIndicator.qml",
                "InvalidSettingsOverlay.qml",
                "Label.qml",
                "NavigationStack.qml",
                "RoundButton.qml",
                "TextButton.qml",
                "TextInputField.qml",
                "VideoPlayer.qml",
                "VerticalSpacer.qml",
                "UrlInputField.qml",
                "SeekSlider.qml",
                "VideoPlayerButton.qml",
                "HorizontalSpacer.qml",
                "WebView.qml",
                "VerticalDissolveEffect.qml",
                "OverlayItem.qml",
                "ToolBar.qml",
                "PageIndicator.qml",
            ]
        }

        QMLGroup {
            name: "QML - Screens"
            prefix: "qml/screens/"
            files: [
                "MainScreen.qml",
                "MoviesControls/AnimatedText.qml",
                "MoviesControls/BackgroundPoster.qml",
                "MoviesControls/MovieCatalogButton.qml",
                "MoviesControls/MoviePoster.qml",
                "MoviesControls/ImageButton.qml",
                "MoviesControls/MovieCatalogView.qml",
                "MoviesControls/ImagePreviewOverlay.qml",
                "MoviesControls/MovieImagesView.qml",
                "MoviesControls/WebViewOverlay.qml",
                "MoviesScreen.qml",
                "SettingsScreen.qml",
                "TrailerScreen.qml",
                "WebBrowserScreen.qml",
                "MovieDetailsScreen.qml",
            ]
        }

        QMLGroup {
            name: "Scripts"
            prefix: "qml/scripts/"
            files: [
                "datamodels.js",
                "3rdparty/YoutubeClientV3.js",
                "XMLHttpRequestCache.js",
            ]
        }

        Group {
            fileTagsFilter: ["application", "aggregate_infoplist", "pkginfo"]
            qbs.install: true
            qbs.installDir: bundle.isBundle ? "Applications" : "bin"
            qbs.installSourceBase: product.buildDirectory
        }
    }
}
