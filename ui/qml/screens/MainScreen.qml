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

import QtQuick 2.5
import QtQuick.Controls 1.4
import Shapes 1.0
import "../controls"
import "../components"

BaseScreen {
    id: mainScreen

    Time {
        id: time

        twentyFourHourFormat: false
    }

    Label {
        id: timeLabel

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        color: colors.white2
        font.family: fonts.titillium
        font.pixelSize: 100 * dp
        font.weight: Font.Thin
        text: "%1:%2"
                .arg(time.hour)
                .arg(time.minute < 10 ? "0" + time.minute : time.minute)

        Label {
            anchors.left: parent.right
            anchors.leftMargin: 8 * dp
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 26 * dp

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 30 * dp
            font.bold: true
            text: time.amPm
        }
    }

    Grid {
        id: buttonsGrid

        anchors.centerIn: parent

        columns: 2
        rows: 2
        columnSpacing: 50 * dp
        rowSpacing: 50 * dp

        ApplicationButton {
            id: moviesButton

            focus: true

            icon: "\uf26c"
            text: qsTr("MOVIES")

            KeyNavigation.right: settingsButton
            KeyNavigation.down: webBrowserButton

            onClicked: {
                stackView.push(Qt.resolvedUrl("qrc:/qml/screens/MoviesScreen.qml"))
            }
        }

        ApplicationButton {
            id: settingsButton

            icon: "\uf085"
            text: qsTr("SETTINGS")

            KeyNavigation.left: moviesButton
            KeyNavigation.down: npapiPluginButton

            onClicked: {
                stackView.push(Qt.resolvedUrl("qrc:/qml/screens/SettingsScreen.qml"))
            }
        }

        ApplicationButton {
            id: webBrowserButton

            enabled: webUtils.available

            icon: "\uf0ac"
            text: qsTr("WEB BROWSER")

            KeyNavigation.up: moviesButton
            KeyNavigation.right: npapiPluginButton

            onClicked: {
                stackView.push(Qt.resolvedUrl("qrc:/qml/screens/WebBrowserScreen.qml"))
            }
        }

        ApplicationButton {
            id: npapiPluginButton

            enabled: processController.available

            icon: "\uf1c8"
            text: qsTr("NPAPI PLUGIN")

            Component.onCompleted: {
                if (Qt.platform.os === "macos") {
                    processController.program = "./../Executables/qt-tv-npapi-host"
                } else {
                    processController.program = "./qt-tv-npapi-host"
                }
            }

            KeyNavigation.left: webBrowserButton
            KeyNavigation.up: settingsButton

            onClicked: {
                processController.running = true
            }
        }
    }
}
