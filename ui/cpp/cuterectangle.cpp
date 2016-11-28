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

#include "cuterectangle.h"

CuteRectangle::CuteRectangle(QQuickItem *parent) :
    QQuickPaintedItem(parent),
    mColor("#000000"),
    mBorderColor("#000000"),
    mBorderWidth(0)
{
    connect(this, SIGNAL(colorChanged(QColor)), this, SLOT(update()));
    connect(this, SIGNAL(borderColorChanged(QColor)), this, SLOT(update()));
    connect(this, SIGNAL(borderWidthChanged(int)), this, SLOT(update()));
}

void CuteRectangle::paint(QPainter *painter)
{
    QPen pen(mBorderColor);
    pen.setWidth(0);
    if (mBorderWidth == 0) {
        pen.setColor(mColor);
    }
    painter->setPen(pen);

    QBrush brush(mColor);
    painter->setBrush(brush);

    painter->setRenderHint(QPainter::Antialiasing);

    float centerX = width() / 2.0f;
    float centerY = height() / 2.0f;

    const float padding = 1.0f; // from each side, to prevent clipping
    float paintedWidth;
    float paintedHeight;
    float cornerRadius;

    if (width() > height()) {
        paintedHeight = height() - padding * 2.0f;
        paintedWidth = paintedHeight * 1.35f;
    } else {
        paintedWidth = width() - padding * 2.0f;
        paintedHeight = paintedWidth * 0.74f;
    }

    cornerRadius = paintedWidth * 0.143f;

    QPainterPath path;
    // start from the top right corner
    path.moveTo(centerX + paintedWidth / 2.0f, centerY - paintedHeight / 2.0f);
    // moving clockwise
    path.lineTo(centerX + paintedWidth / 2.0f, centerY + paintedHeight / 2.0f - cornerRadius);
    path.lineTo(centerX + paintedWidth / 2.0f - cornerRadius, centerY + paintedHeight / 2.0f);
    path.lineTo(centerX - paintedWidth / 2.0f, centerY + paintedHeight / 2.0f);
    path.lineTo(centerX - paintedWidth / 2.0f, centerY - paintedHeight / 2.0f + cornerRadius);
    path.lineTo(centerX - paintedWidth / 2.0f + cornerRadius, centerY - paintedHeight / 2.0f);
    path.lineTo(centerX + paintedWidth / 2.0f, centerY - paintedHeight / 2.0f);

    painter->drawPath(path);
}

QColor CuteRectangle::color() const
{
    return mColor;
}

void CuteRectangle::setColor(const QColor &color)
{
    if (color == mColor) return;
    mColor = color;
    emit colorChanged(color);
}

QColor CuteRectangle::borderColor() const
{
    return mBorderColor;
}

void CuteRectangle::setBorderColor(const QColor &color)
{
    if (color == mBorderColor) return;
    mBorderColor = color;
    emit borderColorChanged(color);
}

int CuteRectangle::borderWidth() const
{
    return mBorderWidth;
}

void CuteRectangle::setBorderWidth(int width)
{
    if (width == mBorderWidth) return;
    mBorderWidth = width;
    emit borderWidthChanged(width);
}
