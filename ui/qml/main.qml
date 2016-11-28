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
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Particles 2.0
import "components"
import "controls"
import "screens"

ApplicationWindow {
    id: appWindow

    property Settings settings: Settings {
        onInitialized: {
            if (missingKeys.length > 0) {
                invalidSettingsOverlay.open()
            }
        }
    }

    onBackPressed: {
        if (overlay.visibleChildren.length > 0) {
            var topOverlayItem = overlay.visibleChildren[overlay.visibleChildren.length - 1]
            if (topOverlayItem.closeOnBackButtonPress) {
                topOverlayItem.close()
            }
        } else if (stackView.depth > 1) {
            stackView.pop()
        } else {
            Qt.quit()
        }
    }

    RadialGradient {
        id: backgroundGradient

        anchors.fill: parent

        horizontalRadius: Math.min(width, height)
        verticalRadius: horizontalRadius

        SequentialAnimation {
            id: horizontalAnimation

            loops: Animation.Infinite
            running: true

            NumberAnimation {
                target: backgroundGradient
                property: "horizontalOffset"
                easing.type: Easing.InOutSine
                duration: 8000
                from: -width / 4
                to: width / 4
                onFromChanged: horizontalAnimation.restart()
                onToChanged: horizontalAnimation.restart()
            }

            NumberAnimation {
                target: backgroundGradient
                property: "horizontalOffset"
                easing.type: Easing.InOutSine
                duration: 8000
                from: width / 4
                to: -width / 4
                onFromChanged: horizontalAnimation.restart()
                onToChanged: horizontalAnimation.restart()
            }
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: colors.background1 }
            GradientStop { position: 0.25; color: colors.background2 }
            GradientStop { position: 0.5; color: colors.background3 }
            GradientStop { position: 0.75; color: colors.background4 }
            GradientStop { position: 1.0; color: colors.background5 }
        }
    }

    ParticleSystem {
        anchors.fill: parent

        ImageParticle {
            groups: "green"
            source: "qrc:/images/particle.png"
            opacity: 0.1
            color: colors.green2
        }

        Emitter {
            anchors.fill: parent

            group: "green"

            emitRate: 2
            startTime: lifeSpan
            lifeSpan: 10000

            size: 1200 * dp
            sizeVariation: 400 * dp

            velocity: AngleDirection {
                angleVariation: 360
                magnitude: 80 * dp
                magnitudeVariation: 20 * dp
            }
        }
    }

    NavigationStack {
        id: stackView

        anchors.fill: parent

        initialItem: MainScreen {}
    }

    Item {
        id: overlay

        anchors.fill: parent
    }

    InvalidSettingsOverlay {
        id: invalidSettingsOverlay

        onAccepted: {
            close()
            stackView.push(Qt.resolvedUrl("qrc:/qml/screens/SettingsScreen.qml"))
        }
    }

    Loader {
        anchors.fill: parent
        source: Qt.platform.os === "tvos" ? "qrc:/qml/controls/TvRemoteInputArea.qml" : ""
    }
}
