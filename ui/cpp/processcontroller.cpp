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

#include "processcontroller.h"
#include <QProcess>

class ProcessControllerPrivate {
public:
#ifndef QT_NO_PROCESS
    QProcess process;
#endif
};

ProcessController::ProcessController(QObject *parent)
    : QObject(parent)
    , d(new ProcessControllerPrivate)
{
}

ProcessController::~ProcessController()
{
}

QString ProcessController::program() const
{
#ifndef QT_NO_PROCESS
    return d->process.program();
#else
    return QString();
#endif
}

void ProcessController::setProgram(const QString &program)
{
#ifndef QT_NO_PROCESS
    if (d->process.program() != program) {
        if (d->process.state() == QProcess::NotRunning) {
            d->process.setProgram(program);
            emit programChanged();
        }
    }
#else
    Q_UNUSED(program);
#endif
}

bool ProcessController::isRunning() const
{
#ifndef QT_NO_PROCESS
    return d->process.state() == QProcess::NotRunning;
#else
    return false;
#endif
}

void ProcessController::setRunning(bool running)
{
#ifndef QT_NO_PROCESS
    if (running) {
        if (d->process.state() == QProcess::NotRunning) {
            d->process.start();
            emit runningChanged();
        }
    } else {
        if (d->process.state() != QProcess::NotRunning) {
            d->process.close();
            emit runningChanged();
        }
    }
#else
    Q_UNUSED(running);
#endif
}

bool ProcessController::isAvailable() const
{
#ifndef QT_NO_PROCESS
    return QFileInfo(d->process.program()).exists();
#else
    return false;
#endif
}
