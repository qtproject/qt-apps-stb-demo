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

#ifndef PROCESSCONTROLLER_H
#define PROCESSCONTROLLER_H

#include <QObject>
#include <QCoreApplication>
#include <QFileInfo>
#include <QDebug>

class ProcessControllerPrivate;

class ProcessController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString program READ program WRITE setProgram NOTIFY programChanged)
    Q_PROPERTY(bool running READ isRunning WRITE setRunning NOTIFY runningChanged)
    Q_PROPERTY(bool available READ isAvailable NOTIFY programChanged)

public:
    explicit ProcessController(QObject *parent = 0);
    virtual ~ProcessController();

    QString program() const;
    void setProgram(const QString &program);

    bool isRunning() const;
    void setRunning(bool running);

    bool isAvailable() const;

private:
    QScopedPointer<ProcessControllerPrivate> d;

signals:
    void programChanged();
    void runningChanged();
};

#endif // PROCESSCONTROLLER_H
