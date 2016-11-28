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

QtObject {
    id: colors

    readonly property color background1: "#3b7c74"
    readonly property color background2: "#104a58"
    readonly property color background3: "#04304d"
    readonly property color background4: "#041f3a"
    readonly property color background5: "#021124"

    readonly property color gray1: Qt.rgba(0.0, 0.0, 0.0, 0.4)
    readonly property color gray2: Qt.rgba(0.0, 0.0, 0.0, 0.8)
    readonly property color gray3: "#999999"
    readonly property color gray4: "#555555"

    readonly property color green1: "#41cd52"
    readonly property color green2: "#dcfcbd"

    readonly property color yellow1: "#ffef26"

    readonly property color white1: "#ffffff"
    readonly property color white2: Qt.rgba(1.0, 1.0, 1.0, 0.8)
    readonly property color white3: Qt.rgba(1.0, 1.0, 1.0, 0.5)
    readonly property color white4: Qt.rgba(1.0, 1.0, 1.0, 0.06)

    readonly property color black: "#000000"
    readonly property color transparent: Qt.rgba(0.0, 0.0, 0.0, 0.0)
}
