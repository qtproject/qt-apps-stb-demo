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
import QtMultimedia 5.5

FocusScope {
    id: videoPlayer

    property alias autoPlay: video.autoPlay
    property int hideControlPanelTimeout: hideControlPanelTimer.interval
    property alias duration: video.duration
    property alias playbackRate: video.playbackRate
    property alias playbackState: video.playbackState
    property alias position: video.position
    property alias source: video.source
    property alias volume: video.volume

    signal closePressed()

    function play() {
        video.play()
    }

    function stop() {
        video.stop()
    }

    function pause() {
        video.pause()
    }

    function seek(offset) {
        video.seek(offset)
    }

    Video {
        id: video

        anchors.fill: parent

        autoPlay: true
        volume: (settings.volume - settings.minimumVolume) / settings.maximumVolume

        function fastForwardPlaybackRate() {
            if (playbackRate < 2.0) {
                return 2.0
            } else if (playbackRate < 5.0) {
                return 5.0
            } else if (playbackRate < 10.0) {
                return 10.0
            } else if (playbackRate < 30.0) {
                return 30.0
            } else if (playbackRate < 60.0) {
                return 60.0
            } else {
                return 2.0
            }
        }

        function fastBackwardPlaybackRate() {
            if (playbackRate > -2.0) {
                return -2.0
            } else if (playbackRate > -5.0) {
                return -5
            } else if (playbackRate > -10.0) {
                return -10.0
            } else if (playbackRate > -30.0) {
                return -30.0
            } else if (playbackRate > -60.0) {
                return -60.0
            } else {
                return -2.0
            }
        }

        function formatDuration(durationInMilliseconds) {
            var hours = Math.floor(durationInMilliseconds / (1000 * 60 * 60))
            hours = (hours > 0) ? hours + ":" : ""
            var minutes = Math.floor((durationInMilliseconds / (1000 * 60)) % 60)
            minutes = (minutes < 10) ? "0" + minutes : minutes
            var seconds = Math.floor((durationInMilliseconds / 1000) % 60)
            seconds = (seconds < 10) ? "0" + seconds : seconds

            return "%1%2:%3".arg(hours).arg(minutes).arg(seconds)
        }

        function userActionDetected() {
            if (!controlPanel.visible) {
                controlPanel.visible = true
            }

            hideControlPanelTimer.restart()
        }

        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState) {
                playbackRate = 1.0

                if (position === duration) {
                    seek(0)
                }
            }
        }
    }

    Timer {
        id: hideControlPanelTimer

        interval: 3000
        repeat: false
        running: true
        onTriggered: {
            controlPanel.visible = false
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressedChanged: {
            video.userActionDetected()
        }
    }

    FocusScope {
        id: controlPanel

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: 180 * dp

        focus: true

        Rectangle {
            anchors.fill: parent

            color: colors.gray2
        }

        VideoPlayerButton {
            id: closeButton

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 50 * dp
            anchors.topMargin: 30 * dp

            focus: true

            icon: "\uf053"

            KeyNavigation.right: fastBackwardButton

            Keys.onPressed: {
                video.userActionDetected()
            }

            onPressedChanged: {
                video.userActionDetected()
            }

            onClicked: {
                videoPlayer.stop()
                videoPlayer.closePressed()
            }
        }

        Label {
            anchors.right: playbackControlButtonsRow.left
            anchors.top: parent.top
            anchors.rightMargin: 50 * dp
            anchors.topMargin: 31 * dp

            visible: videoPlayer.playbackRate < -1.0

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 35 * dp

            text: "%1×".arg(Math.abs(videoPlayer.playbackRate))
        }

        Row {
            id: playbackControlButtonsRow

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30 * dp

            spacing: 60 * dp

            VideoPlayerButton {
                id: fastBackwardButton

                icon: "\uf04a"

                onPressedChanged: {
                    video.userActionDetected()
                }

                KeyNavigation.left: closeButton
                KeyNavigation.right: playPauseButton

                Keys.onPressed: {
                    video.userActionDetected()
                }

                onClicked: {
                    var temp = video.fastBackwardPlaybackRate()

                    if (videoPlayer.playbackState === MediaPlayer.PausedState ||
                        videoPlayer.playbackState === MediaPlayer.StoppedState)
                    {
                        videoPlayer.play()
                    }

                    videoPlayer.playbackRate = temp
                }
            }

            VideoPlayerButton {
                id: playPauseButton

                icon: videoPlayer.playbackState === MediaPlayer.PausedState ||
                      videoPlayer.playbackState === MediaPlayer.StoppedState ? "\uf04b"
                                                                             : "\uf04c"

                KeyNavigation.left: fastBackwardButton
                KeyNavigation.right: fastForwardButton

                Keys.onPressed: {
                    video.userActionDetected()
                }

                onPressedChanged: {
                    video.userActionDetected()
                }

                onClicked: {
                    if (videoPlayer.playbackState === MediaPlayer.PausedState ||
                        videoPlayer.playbackState === MediaPlayer.StoppedState)
                    {
                        videoPlayer.play()
                    } else {
                        videoPlayer.pause()
                        videoPlayer.playbackRate = 1.0
                    }
                }
            }

            VideoPlayerButton {
                id: fastForwardButton

                icon: "\uf04e"

                KeyNavigation.left: playPauseButton
                KeyNavigation.right: volumeDownButton

                Keys.onPressed: {
                    video.userActionDetected()
                }

                onPressedChanged: {
                    video.userActionDetected()
                }

                onClicked: {
                    var temp = video.fastForwardPlaybackRate()

                    if (videoPlayer.playbackState === MediaPlayer.PausedState ||
                        videoPlayer.playbackState === MediaPlayer.StoppedState)
                    {
                        videoPlayer.play()
                    }

                    videoPlayer.playbackRate = temp
                }
            }
        }

        Label {
            anchors.left: playbackControlButtonsRow.right
            anchors.top: parent.top
            anchors.leftMargin: 50 * dp
            anchors.topMargin: 31 * dp

            visible: videoPlayer.playbackRate > 1.0

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 35 * dp

            text: "%1×".arg(Math.abs(videoPlayer.playbackRate))
        }

        Row {
            id: volumeControlButtonsRow

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 50 * dp
            anchors.topMargin: 30 * dp

            spacing: 10 * dp

            VideoPlayerButton {
                id: volumeDownButton

                icon: "\uf027"

                KeyNavigation.left: fastForwardButton
                KeyNavigation.right: volumeUpButton

                Keys.onPressed: {
                    video.userActionDetected()
                }

                onPressedChanged: {
                    video.userActionDetected()
                }

                onClicked: {
                    var newVolume = (settings.volume - 1)
                    if (newVolume >= settings.minimumVolume) {
                        settings.volume = newVolume
                    }
                }
            }

            HorizontalSpacer {
                width: 10 * dp
            }

            Repeater {
                model: 5
                delegate: Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -5 * dp

                    font.family: fonts.fontAwesome
                    font.pixelSize: 24 * dp

                    color: colors.white2
                    text: (index + 1) > settings.volume ? "\uf10c" : "\uf111"
                }
            }

            HorizontalSpacer {
                width: 10 * dp
            }

            VideoPlayerButton {
                id: volumeUpButton

                icon: "\uf028"

                KeyNavigation.left: volumeDownButton

                Keys.onPressed: {
                    video.userActionDetected()
                }

                onPressedChanged: {
                    video.userActionDetected()
                }

                onClicked: {
                    var newVolume = (settings.volume + 1)
                    if (newVolume <= settings.maximumVolume) {
                        settings.volume = newVolume
                    }
                }
            }
        }

        Label {
            id: playbackPositionLabel

            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 50 * dp
            anchors.bottomMargin: 25 * dp

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 35 * dp

            text: video.formatDuration(videoPlayer.position)
        }

        SeekSlider {
            id: seekSlider

            anchors.left: playbackPositionLabel.right
            anchors.right: durationLabel.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20 * dp
            anchors.rightMargin: 20 * dp
            anchors.bottomMargin: 10 * dp

            position: (videoPlayer.duration > 0) ? videoPlayer.position / videoPlayer.duration : 0

            property bool wasPlayingWhenSeekingStarted: false

            onSeekingChanged: {
                video.userActionDetected()

                if (seeking) {
                    wasPlayingWhenSeekingStarted = (videoPlayer.playbackState === MediaPlayer.PlayingState)
                    videoPlayer.pause()
                    videoPlayer.playbackRate = 1.0
                } else {
                    videoPlayer.seek(videoPlayer.duration * seekingPosition)

                    if (wasPlayingWhenSeekingStarted) {
                        videoPlayer.play()
                    }
                }
            }

            Timer {
                interval: 1000
                repeat: true
                running: seekSlider.seeking
                triggeredOnStart: true
                onTriggered: {
                    video.userActionDetected()

                    videoPlayer.seek(videoPlayer.duration * seekSlider.seekingPosition)
                }
            }
        }

        Label {
            id: durationLabel

            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 50 * dp
            anchors.bottomMargin: 25 * dp

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 35 * dp

            text: video.formatDuration(videoPlayer.duration)
        }
    }
}
