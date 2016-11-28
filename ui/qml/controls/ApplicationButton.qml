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
import Shapes 1.0

AbstractButton {
    id: applicationButton

    opacity: enabled ? 1 : 0.25

    width: 446 * dp
    height: 330 * dp

    property alias text: label.text
    property alias icon: icon.text

    states: [
        State {
            name: ""

            PropertyChanges {
                target: applicationButton
                scale: 1
            }
        },
        State {
            name: "selected"
            when: applicationButton.activeFocus

            PropertyChanges {
                target: applicationButton
                scale: 1.07
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "selected"

            PropertyAnimation {
                property: "scale"
                duration: 160
                easing.type: Easing.InOutQuad
            }
        }
    ]

    CuteRectangle {
        anchors.fill: parent

        color: applicationButton.activeFocus ? colors.green1
                                             : colors.gray1
    }

    Label {
        id: icon

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -30 * dp

        horizontalAlignment: Text.AlignHCenter

        font.family: fonts.fontAwesome
        font.pixelSize: 140 * dp
        color: applicationButton.activeFocus ? colors.white1
                                             : colors.white2
    }

    Label {
        id: label

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20 * dp

        horizontalAlignment: Text.AlignHCenter

        font.family: fonts.titillium
        font.pixelSize: 42 * dp
        color: applicationButton.activeFocus ? colors.white1
                                             : colors.white2
    }
}
