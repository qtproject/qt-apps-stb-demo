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
import "../controls"

BaseScreen {
    id: settingsScreen

    ToolBar {
        id: toolBar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: 170 * dp

        focus: true

        RoundButton {
            id: backButton

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 40 * dp

            focus: true

            icon: "\uf060"

            KeyNavigation.down: youTubeKeyInputField

            onClicked: {
                stackView.pop()
            }
        }

        Label {
            anchors.left: backButton.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 40 * dp
            anchors.rightMargin: 40 * dp

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 50 * dp
            font.bold: true

            text: qsTr("Settings")
        }
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: toolBar.bottom
        anchors.leftMargin: 40 * dp
        anchors.rightMargin: 40 * dp

        Label {
            anchors.left: parent.left
            anchors.right: parent.right

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 30 * dp
            font.bold: true

            text: qsTr("YouTube Data Key")
        }

        VerticalSpacer {
            height: 10 * dp
        }

        TextInputField {
            id: youTubeKeyInputField
            anchors.left: parent.left
            anchors.right: parent.right

            text: settings.youTubeKey

            onTextChanged: {
                settings.youTubeKey = text
            }

            KeyNavigation.up: backButton
            KeyNavigation.down: tmbKeyInputField
        }

        VerticalSpacer {
            height: 20 * dp
        }

        Label {
            anchors.left: parent.left
            anchors.right: parent.right

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 30 * dp
            font.bold: true

            text: qsTr("TMDb API Key")
        }

        VerticalSpacer {
            height: 10 * dp
        }

        TextInputField {
            id: tmbKeyInputField
            anchors.left: parent.left
            anchors.right: parent.right

            text: settings.tmdbKey

            onTextChanged: {
                settings.tmdbKey = text
            }

            KeyNavigation.up: youTubeKeyInputField
        }
    }
}
