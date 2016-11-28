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

ShaderEffect {
    id: verticalDissolveEffect

    property real length: sourceHeight / 2
    property real sourceHeight: 0
    readonly property real effectiveLength: {
        if (length <= 0) sourceHeight
        else if (length >= (sourceHeight / 2)) 1
        else Math.sqrt(1 / Math.pow(length / sourceHeight, 2))
    }

    fragmentShader: "
        varying highp vec2 qt_TexCoord0;
        uniform lowp float qt_Opacity;
        uniform sampler2D source;

        uniform lowp float effectiveLength;

        void main() {
            lowp vec4 texture = texture2D(source, qt_TexCoord0);

            lowp float dist = abs(qt_TexCoord0.y - 0.5) * (effectiveLength * 2.0);
            texture *= min(1.0, (effectiveLength - dist));

            gl_FragColor = texture * qt_Opacity;
        }"
}
