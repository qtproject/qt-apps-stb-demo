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

Item {
    id: seekSlider

    height: 80 * dp

    property real position: 0.5
    property real sliderHeight: 20 * dp
    property alias seeking: mouseArea.pressed
    readonly property alias seekingPosition: mouseArea.seekingPosition

    function updateHandlePosition() {
        if (seeking) {
            handle.x = (seekSlider.width - handle.width) * seekSlider.seekingPosition
        } else {
            handle.x = (seekSlider.width - handle.width) * seekSlider.position
        }
    }

    onWidthChanged: {
        updateHandlePosition()
    }

    onPositionChanged: {
        updateHandlePosition()
    }

    onSeekingChanged: {
        updateHandlePosition()
    }

    onSeekingPositionChanged: {
        updateHandlePosition()
    }

    Rectangle {
        id: progressRectangle

        anchors.left: parent.left
        anchors.right: handle.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: handle.radius

        height: seekSlider.sliderHeight

        radius: height / 2
        color: colors.white2
    }

    Rectangle {
        id: backgroundRectangle

        anchors.left: handle.horizontalCenter
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: handle.radius

        height: seekSlider.sliderHeight

        radius: height / 2
        color: colors.white3
    }

    Rectangle {
        id: handle

        anchors.verticalCenter: parent.verticalCenter

        width: 60 * dp
        height: 60 * dp

        radius: 30 * dp

        color: colors.gray3
        border.width: 20 * dp
        border.color: colors.white1
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        property real seekingPosition: 0.0

        onMouseXChanged: {
            if (mouseX < handle.width / 2) {
                seekingPosition = 0.0
            } else if (mouseX > seekSlider.width - handle.width / 2) {
                seekingPosition = 1.0
            } else {
                seekingPosition = (mouseX - handle.width / 2) / (seekSlider.width - handle.width)
            }
        }
    }
}
