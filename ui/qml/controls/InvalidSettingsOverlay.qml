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

OverlayItem {
    id: invalidSettingsOverlay

    closeOnOuterClick: false
    closeOnBackButtonPress: false

    signal accepted()

    Rectangle {
        anchors.fill: parent

        color: colors.gray2
    }

    Rectangle {
        anchors.centerIn: parent

        width: 1200 * dp
        height: 360 * dp

        radius: 8 * dp
        color: colors.black
        border.width: 4 * dp
        border.color: colors.white2

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 40 * dp
            anchors.rightMargin: 40 * dp
            anchors.topMargin: 20 * dp

            Label {
                anchors.left: parent.left
                anchors.right: parent.right

                wrapMode: Text.Wrap

                color: colors.green1
                font.family: fonts.titillium
                font.pixelSize: 50 * dp

                text: qsTr("Missing YouTube and/or TMDb API keys")
            }

            Label {
                anchors.left: parent.left
                anchors.right: parent.right

                wrapMode: Text.Wrap

                color: colors.white2
                font.family: fonts.titillium
                font.pixelSize: 30 * dp

                text: qsTr("Please enter valid API keys for these services in Settings to access film trailers and information in Movies.")
            }
        }

        TextButton {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 40 * dp
            anchors.bottomMargin: 40 * dp

            width: 260 * dp

            focus: true

            text: qsTr("Go to Settings")

            onClicked: {
                invalidSettingsOverlay.accepted()
            }
        }
    }
}
