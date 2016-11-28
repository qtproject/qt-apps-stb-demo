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
    id: imageButton

    implicitWidth: 540 * dp
    implicitHeight: 321 * dp

    property alias imageSource: image.source

    states: [
        State {
            name: ""

            PropertyChanges {
                target: imageButton
                scale: 1
            }
        },
        State {
            name: "selected"
            when: imageButton.activeFocus

            PropertyChanges {
                target: imageButton
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

        visible: imageButton.activeFocus
    }

    Image {
        id: image

        anchors.fill: parent
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
}
