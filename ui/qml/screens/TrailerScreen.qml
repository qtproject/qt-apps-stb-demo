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
import QtMultimedia 5.5
import "../scripts/3rdparty/YoutubeClientV3.js" as YoutubeClient
import "../controls"

BaseScreen {
    id: trailerScreen

    property string movieTitle
    property string movieId

    function onFailure(error) {
        busyIndicator.visible = false
        errorLabel.text = error.details
    }

    function onVideoUrlObtained(url) {
        videoPlayer.source = url
        busyIndicator.visible = false
    }

    Component.onCompleted: {
        YoutubeClient.getVideoUrl(movieId, onVideoUrlObtained, onFailure)
    }

    Rectangle {
        anchors.fill: parent

        color: colors.black
    }

    BusyIndicator {
        id: busyIndicator

        anchors.centerIn: parent
    }

    Label {
        id: errorLabel

        anchors.fill: parent

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        wrapMode: Text.Wrap

        color: colors.white1
        font.family: fonts.titillium
        font.pixelSize: 30 * dp
        font.bold: true
    }

    VideoPlayer {
        id: videoPlayer

        anchors.fill: parent

        focus: true

        onClosePressed: {
            stackView.pop()
        }
    }
}
