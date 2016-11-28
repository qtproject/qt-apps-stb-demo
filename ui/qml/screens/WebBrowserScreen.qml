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
import "../controls"

BaseScreen {
    id: webBrowserScreen

    property alias url: webView.url

    ToolBar {
        id: toolBar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: 170 * dp

        focus: true

        RoundButton {
            id: backButton

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 40 * dp

            focus: true

            icon: "\uf060"

            KeyNavigation.right: urlInputField
            KeyNavigation.down: webView

            onClicked: {
                stackView.pop()
            }
        }

        UrlInputField {
            id: urlInputField

            anchors.left: backButton.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 50 * dp
            anchors.rightMargin: 40 * dp

            progress: webView.loadProgress / 100
            loading: webView.loading

            placeholderText: qsTr("Type URL")
            text: webBrowserScreen.url

            KeyNavigation.left: backButton
            KeyNavigation.down: webView

            onAcceptingInputChanged: {
                if (!acceptingInput) {
                    var oldUrl = webBrowserScreen.url
                    webBrowserScreen.url = webUtils.fromUserInput(text)

                    if (oldUrl === webBrowserScreen.url) {
                        webView.reload()
                    }
                }
            }
        }
    }

    FocusScope {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: toolBar.bottom
        anchors.bottom: parent.bottom

        KeyNavigation.up: toolBar

        WebView {
            id: webView

            anchors.fill: parent
            focus: true

            url: "https://youtube.com/"

            property TvRemoteInputMethod tvRemoteInputMethod: TvRemoteInputMethod {
                item: webView
            }
        }
    }
}
