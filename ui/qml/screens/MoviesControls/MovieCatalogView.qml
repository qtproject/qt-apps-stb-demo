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
import "../../scripts/datamodels.js" as DataModels

ListView {
    id: movieCatalogView

    property alias title: titleLabel.text

    property int itemsOnScreen: 7
    property real delegateSizeAspectRatio: 0.7
    spacing: 30 * dp
    property int spacesOnScreen: Math.max(itemsOnScreen - 1, 0)
    property real delegateWidth: spacesOnScreen > 0 ? width / itemsOnScreen - spacing * spacesOnScreen / itemsOnScreen
                                                    : 200 * dp
    property real delegateHeight: delegateWidth / delegateSizeAspectRatio
    property int firstVisibleItemIndex: Math.round(Math.abs(contentX / (delegateWidth + spacing)))

    height: customHeaderItem.height + delegateHeight
    orientation: ListView.Horizontal
    snapMode: ListView.SnapToItem
    boundsBehavior: Flickable.StopAtBounds
    highlightMoveDuration: 200
    displayMarginBeginning: delegateWidth
    displayMarginEnd: delegateWidth

    signal clicked()
    signal swipedLeft()
    signal swipedRight()
    signal swipedUp()
    signal swipedDown()

    Item {
        id: customHeaderItem

        height: 80 * dp

        Label {
            id: titleLabel
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * dp

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 30 * dp
            font.bold: true
        }
    }

    delegate: MovieCatalogButton {
        anchors.bottom: movieCatalogView.contentItem.bottom

        width: movieCatalogView.delegateWidth
        height: movieCatalogView.delegateHeight

        thumbnailSource: DataModels.posterPathURL(model.poster_path, 92)
        text: model.title ? model.title : ""

        onPressedChanged: {
            if (pressed) {
                movieCatalogView.currentIndex = index
            }
        }

        onClicked: movieCatalogView.clicked()

        property TvRemoteInputMethod tvRemoteInputMethod: TvRemoteInputMethod {
            mode: manualFocusMode

            onSwipedLeft: {
                movieCatalogView.swipedLeft()
            }

            onSwipedRight: {
                movieCatalogView.swipedRight()
            }

            onSwipedUp: {
                movieCatalogView.swipedUp()
            }

            onSwipedDown: {
                movieCatalogView.swipedDown()
            }
        }
    }
}
