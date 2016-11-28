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
import "../../scripts/datamodels.js" as DataModels
import "../../controls"

OverlayItem {
    id: imagePreviewOverlay

    property int currentIndex: -1
    property alias model: listView.model

    onCurrentIndexChanged: {
        listView.positionViewAtIndex(currentIndex, ListView.Center)
        listView.currentIndex = currentIndex
    }

    Rectangle {
        anchors.fill: parent

        color: colors.gray2
    }

    ListView {
        id: listView

        anchors.fill: parent

        focus: true

        orientation: ListView.Horizontal
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds
        highlightMoveDuration: 300
        cacheBuffer: width * 2
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: width

        delegate: Item {
            width: listView.width
            height: listView.height

            Keys.onPressed: {
                if (event.key === Qt.Key_Enter ||
                    event.key === Qt.Key_Return ||
                    event.key === Qt.Key_Select) {
                    imagePreviewOverlay.close()
                }
            }

            property TvRemoteInputMethod tvRemoteInputMethod: TvRemoteInputMethod {
                mode: manualFocusMode

                onSwipedLeft: {
                    listView.decrementCurrentIndex()
                }

                onSwipedRight: {
                    listView.incrementCurrentIndex()
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    imagePreviewOverlay.close()
                }
            }

            BusyIndicator {
                id: busyIndicator

                anchors.centerIn: parent

                visible: image.status !== Image.Ready
            }

            Rectangle {
                anchors.fill: image
                anchors.margins: -8 * dp

                radius: 8 * dp
                color: colors.white2

                visible: image.status === Image.Ready
            }

            Image {
                id: image

                anchors.centerIn: parent

                property real aspectRatio: sourceSize.width / sourceSize.height
                width: parent.width * 0.8
                height: width / aspectRatio

                source: DataModels.posterPathURL(modelData, 1000)
            }
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        // distance between bottom side of the image and bottom side of the screen
        height: (parent.height - (parent.width * 0.8 / 1.78)) / 2

        PageIndicator {
            anchors.centerIn: parent

            count: listView.count
            currentIndex: listView.currentIndex
        }
    }
}
