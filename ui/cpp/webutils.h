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

#ifndef WEBUTILS_H
#define WEBUTILS_H

#include <QtCore/QFileInfo>
#include <QtCore/QUrl>

class WebUtils : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool available READ isAvailable CONSTANT)

public:
    WebUtils(QObject *parent = 0);

    bool isAvailable() const;

    Q_INVOKABLE static QUrl fromUserInput(const QString& userInput);
};

inline QUrl WebUtils::fromUserInput(const QString& userInput)
{
    QFileInfo fileInfo(userInput);

    if (fileInfo.exists()) {
        return QUrl::fromLocalFile(fileInfo.absoluteFilePath());
    }

    return QUrl::fromUserInput(userInput);
}

#endif // WEBUTILS_H
