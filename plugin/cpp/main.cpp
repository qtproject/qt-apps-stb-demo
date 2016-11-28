/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt demos.
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
****************************************************************************/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QtWebKit/QWebSettings>

void loadFonts() {
    QStringList fonts {
        ":/fonts/TitilliumWeb-Black.ttf",
        ":/fonts/TitilliumWeb-Bold.ttf",
        ":/fonts/TitilliumWeb-BoldItalic.ttf",
        ":/fonts/TitilliumWeb-ExtraLight.ttf",
        ":/fonts/TitilliumWeb-ExtraLightItalic.ttf",
        ":/fonts/TitilliumWeb-Italic.ttf",
        ":/fonts/TitilliumWeb-Light.ttf",
        ":/fonts/TitilliumWeb-LightItalic.ttf",
        ":/fonts/TitilliumWeb-Regular.ttf",
        ":/fonts/TitilliumWeb-SemiBold.ttf",
        ":/fonts/TitilliumWeb-SemiBoldItalic.ttf",
        ":/fonts/fontawesome-webfont.ttf"
    };

    foreach (const QString &font, fonts) {
        QFontDatabase::addApplicationFont(font);
    }
}

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    loadFonts();

    QWebSettings::globalSettings()->setAttribute(QWebSettings::PluginsEnabled, true);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
