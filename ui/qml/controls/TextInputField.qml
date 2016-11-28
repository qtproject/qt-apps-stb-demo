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
    id: textInputField

    implicitWidth: 400 * dp
    implicitHeight: 80 * dp

    property alias placeholderText: placeholderLabel.text
    property alias text: textInput.text
    readonly property bool acceptingInput: textInput.activeFocus

    property TvRemoteInputMethod tvRemoteInputMethod: TvRemoteInputMethod {
        item: textInputField
    }

    Rectangle {
        id: backgroundRectangle

        anchors.fill: parent

        radius: Math.round(8 * dp)

        color: colors.gray1
    }

    TextInput {
        id: textInput

        anchors.fill: parent
        anchors.leftMargin: 30 * dp
        anchors.rightMargin: 30 * dp

        verticalAlignment: Text.AlignVCenter

        clip: true

        color: if (textInputField.activeFocus) colors.green1
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
                textInputField.forceActiveFocus()
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

        color: textInputField.activeFocus || textInput.activeFocus ? colors.green1
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

        visible: textInputField.activeFocus || textInput.activeFocus
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
