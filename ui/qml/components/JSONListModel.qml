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
import "../scripts/XMLHttpRequestCache.js" as XMLHttpRequestCache

ListModel {
    id: jsonListModel

    property string source: ""
    property bool working: false
    property string arrayPropertyName: ""
    property bool cached: true
    property int cacheUpdateInterval: 1000 * 60 * 10 // 10 minutes

    onSourceChanged: {
        function processResponse(responseText) {
            var items = JSON.parse(responseText)[arrayPropertyName]

            if (items) {
                var i = 0
                var count = items.length
                for (; i < count; i++) {
                    var item = items[i]
                    if (typeof item === "object") {
                        jsonListModel.append(item)
                    }
                }
            }

            working = false
        }

        working = true

        jsonListModel.clear()

        var usingCacheData = false

        if (cached) {
            var cacheData = XMLHttpRequestCache.cache[source]

            if (cacheData) {
                if (new Date().getTime() - cacheData.timestamp < cacheUpdateInterval) {
                    usingCacheData = true
                    processResponse(cacheData.response)
                }
            }
        }

        if (!usingCacheData) {
            var xhr = new XMLHttpRequest
            xhr.open("GET", source)

            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    XMLHttpRequestCache.cache[source] = {
                        timestamp: new Date().getTime(),
                        response: xhr.responseText
                    }

                    processResponse(xhr.responseText)
                }
            }

            xhr.send()
        }
    }
}
