import qbs

Project {
    property string minimumQtVersion: "5.8"
    minimumQbsVersion: "1.7.0"
    qbsSearchPaths: ["qbs"]
    references: [
        "openssl/openssl.qbs",
        "plugin/plugin.qbs",
        "ui/ui.qbs",
    ]

    Product {
        name: "qmake project files"
        files: ["**/*.pr[io]"]
    }
}
