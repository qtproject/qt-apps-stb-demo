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
#include <QQmlContext>
#include <QQmlFileSelector>
#include <QFontDatabase>
#include "cuterectangle.h"
#include "processcontroller.h"
#include "webutils.h"

#ifdef QT_WEBENGINE_LIB
#include <QtWebEngine>
#endif

#ifdef QT_WEBVIEW_LIB
#include <QtWebView>
#endif

void loadFonts() {
    QStringList fonts {
        ":/fonts/TitilliumWeb-Bold.ttf",
        ":/fonts/TitilliumWeb-Italic.ttf",
        ":/fonts/TitilliumWeb-Regular.ttf",
        ":/fonts/fontawesome-webfont.ttf"
    };

    foreach (const QString &font, fonts) {
        QFontDatabase::addApplicationFont(font);
    }
}

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QStringList extraSelectors;

    // Order of the selectors is important on macOS, which supports both QtWebEngine and QtWebView.
    // Currently, macOS does not support QtWebView well, regardless of whether the QtWebEngine or
    // native backend is chosen. The webengine selector comes first and so is prioritized over
    // webview.

#ifdef QT_WEBENGINE_LIB
    QtWebEngine::initialize();
    extraSelectors.append(QStringLiteral("webengine"));
#endif

#ifdef QT_WEBVIEW_LIB
    QtWebView::initialize();
    extraSelectors.append(QStringLiteral("webview"));
#endif

    loadFonts();

    qmlRegisterType<CuteRectangle>("Shapes", 1, 0, "CuteRectangle");

    QQmlApplicationEngine engine;

    QQmlFileSelector::get(&engine)->setExtraSelectors(extraSelectors);

    ProcessController processController(&app);
    engine.rootContext()->setContextProperty("processController", &processController);
    WebUtils webUtils(&app);
    engine.rootContext()->setContextProperty("webUtils", &webUtils);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
