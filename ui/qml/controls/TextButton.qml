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
    id: textButton

    implicitWidth: 220 * dp
    implicitHeight: 80 * dp

    opacity: enabled ? 1 : 0.4

    property alias text: label.text

    Rectangle {
        anchors.fill: parent

        radius: Math.round(8 * dp)

        color: textButton.activeFocus ? colors.green1
                                      : colors.gray1
    }

    Label {
        id: label

        anchors.fill: parent
        anchors.leftMargin: 30 * dp
        anchors.rightMargin: 30 * dp

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        color: textButton.activeFocus ? colors.white1
                                      : colors.white2
        font.family: fonts.titillium
        font.pixelSize: 30 * dp
        font.bold: true
    }
}
