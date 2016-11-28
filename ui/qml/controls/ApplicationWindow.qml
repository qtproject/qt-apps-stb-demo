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
import "../components"

Window {
    id: applicationWindow

    visible: true
    visibility: Window.FullScreen
    flags: Qt.Window | Qt.WindowFullscreenButtonHint
    color: colors.white1
    title: Qt.application.name

    readonly property Colors colors: Colors {}
    readonly property Fonts fonts: Fonts {}

    readonly property real dp: physicalSizeMultiplier > 0 ? Screen.pixelDensity * 25.4 / 160 * physicalSizeMultiplier
                                                          : Screen.pixelDensity * 25.4 / 160
    readonly property real originalDeviceDiagonal: 15 // 15 inch macbook pro
    property real physicalSizeMultiplier: (((Math.sqrt(Math.pow(Screen.width, 2) + Math.pow(Screen.height, 2)) / Screen.pixelDensity) / 25.4) / originalDeviceDiagonal)

//    Component.onCompleted: {
//        var diagonalInPixels = Math.sqrt(Math.pow(Screen.width, 2) + Math.pow(Screen.height, 2))
//        var diagonalInMillimeters = diagonalInPixels / Screen.pixelDensity
//        var diagonalInInches = diagonalInMillimeters / 25.4

//        physicalSizeMultiplier = diagonalInInches / testDeviceDiagonal
//    }

    property Item focusedItem: null
    signal backPressed()

    onActiveFocusItemChanged: {
        if (focusedItem !== null && focusedItem.Keys !== undefined)
            focusedItem.Keys.onPressed.disconnect(onKeyPressed)

        if (activeFocusItem !== null)
        {
            activeFocusItem.Keys.onPressed.connect(onKeyPressed)
            focusedItem = activeFocusItem
        }
    }

    function onKeyPressed(event) {
        if (event.key === Qt.Key_Back ||
            event.key === Qt.Key_Escape ||
            event.key === Qt.Key_Menu)
        {
            if (Qt.inputMethod.visible) {
                Qt.inputMethod.hide()
            } else {
                backPressed()
            }

            event.accepted = true
        }
    }
}
