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

.pragma library

var baseurl = "https://api.themoviedb.org/3/"
var apiKey = ""

function formatQuery(query, arguments) {
    var result = "%1%2?api_key=%3".arg(baseurl).arg(query).arg(apiKey)

    for (var key in arguments) {
        result += "&%1=%2".arg(key).arg(arguments[key])
    }

    return result
}

function posterPathURL(posterPath, size) {
    return posterPath ? "https://image.tmdb.org/t/p/w%1%2".arg(size).arg(posterPath) : ""
}
