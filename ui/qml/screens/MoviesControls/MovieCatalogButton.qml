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
import "../../controls"

AbstractButton {
    id: movieCatalogButton

    implicitWidth: 100 * dp
    implicitHeight: 100 * dp

    property alias thumbnailSource: thumbnail.source
    property alias text: label.text

    states: [
        State {
            name: ""

            PropertyChanges {
                target: movieCatalogButton
                scale: 1
            }
        },
        State {
            name: "selected"
            when: movieCatalogButton.activeFocus

            PropertyChanges {
                target: movieCatalogButton
                scale: 1.07
            }
        }
    ]

    transitions: [
        Transition {
            from: "selected"
            to: ""

            PropertyAnimation {
                property: "scale"
                duration: 160
                easing.type: Easing.InOutQuad
            }
        }
    ]

    Rectangle {
        id: backgroundRectangle

        anchors.fill: parent

        radius: Math.round(8 * dp)

        color: colors.gray1
    }

    Rectangle {
        id: focusRectangle

        anchors.fill: parent

        radius: Math.round(8 * dp)

        color: colors.transparent
        border.width: Math.round(3 * dp)
        border.color: colors.green1

        visible: movieCatalogButton.activeFocus
    }

    Image {
        id: thumbnail

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20 * dp

        height: width

        visible: status === Image.Ready
        opacity: status === Image.Ready ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }
        }

        fillMode: Image.PreserveAspectCrop
    }

    Label {
        id: label

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: thumbnail.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20 * dp
        anchors.rightMargin: 20 * dp
        anchors.topMargin: 10 * dp

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        maximumLineCount: 2

        font.family: fonts.titillium
        font.pixelSize: height / 4
        font.bold: true

        color: movieCatalogButton.activeFocus ? colors.green1
                                              : colors.white2
    }
}
