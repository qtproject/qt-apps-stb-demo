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

StackView {
    id: navigationStack

    readonly property int transitionDuration: 300

    onCurrentItemChanged: {
        if (currentItem && overlay.visibleChildren.length === 0) {
            currentItem.forceActiveFocus()
        }
    }

    delegate: StackViewDelegate {
        pushTransition: StackViewTransition {
            ParallelAnimation {
                PropertyAnimation {
                    target: enterItem
                    property: "scale"
                    from: 1.4
                    to: 1
                    duration: navigationStack.transitionDuration
                }

                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: navigationStack.transitionDuration
                }
            }

            ParallelAnimation {
                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: navigationStack.transitionDuration / 2
                }
            }
        }

        popTransition: StackViewTransition {
            ParallelAnimation {
                PropertyAnimation {
                    target: exitItem
                    property: "scale"
                    from: 1
                    to: 1.4
                    duration: navigationStack.transitionDuration / 2
                }

                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: navigationStack.transitionDuration / 2
                }
            }

            ParallelAnimation {
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: navigationStack.transitionDuration
                }
            }
        }
    }
}
