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

#ifndef CUTERECTANGLE_H
#define CUTERECTANGLE_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QPainterPath>

class CuteRectangle : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QColor borderColor READ borderColor WRITE setBorderColor NOTIFY borderColorChanged)
    Q_PROPERTY(int borderWidth READ borderWidth WRITE setBorderWidth NOTIFY borderWidthChanged)

public:
    CuteRectangle(QQuickItem *parent = 0);

    void paint(QPainter *painter);

    QColor color() const;
    void setColor(const QColor &color);
    QColor borderColor() const;
    void setBorderColor(const QColor &color);
    int borderWidth() const;
    void setBorderWidth(int width);

private:
    QColor mColor;
    QColor mBorderColor;
    int mBorderWidth;

signals:
    void colorChanged(QColor color);
    void borderColorChanged(QColor color);
    void borderWidthChanged(int width);
};

#endif // CUTERECTANGLE_H
