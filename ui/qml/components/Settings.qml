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
import "../scripts/datamodels.js" as DataModels
import "../scripts/3rdparty/YoutubeClientV3.js" as YoutubeClient

QtObject {
    id: settings

    property string youTubeKey: ""
    property string tmdbKey: ""

    readonly property int minimumVolume: 0
    readonly property int maximumVolume: 5
    property int volume: 5

    readonly property var requiredKeys: ["YouTube", "TMDb"]
    property var missingKeys: []

    signal initialized()

    onYouTubeKeyChanged: {
        YoutubeClient.youTubeDataKey = youTubeKey
    }

    onTmdbKeyChanged: {
        DataModels.apiKey = tmdbKey
    }

    Component.onCompleted: {
        if (requiredKeys.length > 0) {
            keyLoader.loadKey(0)
        } else {
            initialized()
        }
    }

    property Loader keyLoader: Loader {
        property int currentKeyIndex

        function loadKey(index) {
            currentKeyIndex = index
            source = Qt.resolvedUrl("qrc:/secrets/%1.qml".arg(requiredKeys[index]))
        }

        onStatusChanged: {
            if (status === Loader.Ready) {
                switch (currentKeyIndex) {
                case 0:
                    settings.youTubeKey = item.key
                    break
                case 1:
                    settings.tmdbKey = item.key
                    break
                }
            } else if (status === Loader.Error) {
                settings.missingKeys.push(settings.requiredKeys[currentKeyIndex])
            }

            if (status === Loader.Ready ||
                status === Loader.Error) {
                if (currentKeyIndex < settings.requiredKeys.length - 1) {
                    loadKey(currentKeyIndex + 1)
                } else {
                    settings.initialized()
                }
            }
        }
    }
}
