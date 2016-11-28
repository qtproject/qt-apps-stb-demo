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
    id: urlInputField

    implicitWidth: 400 * dp
    implicitHeight: 80 * dp

    property real progress: 0.0
    property real minimumProgress: 0.1
    property bool loading: false
    property alias placeholderText: placeholderLabel.text
    property alias text: textInput.text
    readonly property bool acceptingInput: textInput.activeFocus

    property TvRemoteInputMethod tvRemoteInputMethod: TvRemoteInputMethod {
        item: urlInputField
    }

    onLoadingChanged: {
        if (loading) {
            fadeOutAnimation.stop()
            progressRectangle.width = 0
            progressRectangle.opacity = 1
        } else {
            fadeOutAnimation.start()
        }
    }

    onProgressChanged: {
        var newWidth = urlInputField.progress > urlInputField.minimumProgress
                        ? width * urlInputField.progress
                        : width * urlInputField.minimumProgress

        if (newWidth > progressRectangle.width) {
            progressAnimation.stop()
            progressAnimation.from = progressRectangle.width
            progressAnimation.to = newWidth
            progressAnimation.restart()
        } else {
            progressRectangle.width = newWidth
        }
    }

    Rectangle {
        id: backgroundRectangle

        anchors.fill: parent

        radius: Math.round(8 * dp)

        color: colors.gray1
    }

    Rectangle {
        id: progressRectangle

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        radius: Math.round(8 * dp)
        color: colors.white4

        NumberAnimation {
            id: progressAnimation
            target: progressRectangle
            properties: "width"
            duration: 200
            loops: 1
            running: false
        }

        SequentialAnimation {
            id: fadeOutAnimation

            loops: 1
            running: false

            PauseAnimation {
                duration: 500
            }

            NumberAnimation {
                target: progressRectangle
                properties: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
    }

    TextInput {
        id: textInput

        anchors.fill: parent
        anchors.leftMargin: 30 * dp
        anchors.rightMargin: 30 * dp

        verticalAlignment: Text.AlignVCenter

        clip: true

        color: if (urlInputField.activeFocus) colors.green1
               else if (textInput.activeFocus) colors.white2
               else colors.white2
        font.family: fonts.titillium
        font.pixelSize: 30 * dp

        cursorDelegate: Rectangle {
            id: cursorDelegate

            width: 3 * dp

            color: colors.white2

            Connections {
                target: textInput

                onActiveFocusChanged: {
                    if (target.activeFocus) {
                        cursorAnimation.start()
                    } else {
                        cursorAnimation.stop()
                    }
                }

                onCursorPositionChanged: {
                    if (target.activeFocus) {
                        cursorAnimation.restart()
                    }
                }
            }

            SequentialAnimation {
                id: cursorAnimation

                running: false
                loops: SequentialAnimation.Infinite

                onStopped: {
                    cursorDelegate.visible = false
                }

                PropertyAction {
                    target: cursorDelegate
                    property: "visible"
                    value: true
                }

                PauseAnimation {
                    duration: 440
                }

                PropertyAction {
                    target: cursorDelegate
                    property: "visible"
                    value: false
                }

                PauseAnimation {
                    duration: 440
                }
            }
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Enter ||
                event.key === Qt.Key_Return ||
                event.key === Qt.Key_Select)
            {
                urlInputField.forceActiveFocus()
                event.accepted = true
            }
        }
    }

    Label {
        id: placeholderLabel

        anchors.fill: parent
        anchors.leftMargin: 30 * dp
        anchors.rightMargin: 30 * dp

        verticalAlignment: Text.AlignVCenter


        color: urlInputField.activeFocus || textInput.activeFocus ? colors.green1
                                                                  : colors.white3
        font.family: fonts.titillium
        font.pixelSize: 30 * dp

        visible: !textInput.activeFocus && textInput.text === ""
    }

    Rectangle {
        id: focusRectangle

        anchors.fill: parent

        radius: Math.round(8 * dp)

        color: colors.transparent
        border.width: Math.round(3 * dp)
        border.color: colors.green1

        visible: urlInputField.activeFocus || textInput.activeFocus
    }

    Keys.onPressed: {
        if (textInput.activeFocus) {
            return
        }

        if (event.key === Qt.Key_Enter ||
            event.key === Qt.Key_Return ||
            event.key === Qt.Key_Select)
        {
            textInput.forceActiveFocus()
            event.accepted = true
        }
    }
}
