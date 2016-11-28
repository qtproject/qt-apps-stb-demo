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

OverlayItem {
    id: webBrowserOverlay

    property alias url: webView.url

    Keys.onPressed: {
        if (event.key === Qt.Key_Enter ||
            event.key === Qt.Key_Return ||
            event.key === Qt.Key_Select) {
            close()
        }
    }

    Rectangle {
        anchors.fill: parent

        color: colors.gray2
    }

    Rectangle {
        anchors.fill: webView
        anchors.margins: -8 * dp

        radius: 8 * dp
        color: colors.white2
    }

    WebView {
        id: webView

        anchors.centerIn: parent

        width: parent.width * 0.8
        height: parent.height * 0.8

        focus: true
    }
}
