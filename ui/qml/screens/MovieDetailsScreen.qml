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
import "../scripts/datamodels.js" as DataModels
import "../controls"
import "../components"
import "MoviesControls"

BaseScreen {
    id: movieDetailsScreen

    property var selectedMovie

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

            KeyNavigation.right: trailerButton
            KeyNavigation.down: movieImagesView.count > 0 ? movieImagesView : null

            onClicked: {
                stackView.pop()
            }
        }

        Row {
            anchors.left: backButton.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 50 * dp

            spacing: 30 * dp

            TextButton {
                id: trailerButton

                width: 260 * dp

                text: qsTr("Watch Trailer")

                KeyNavigation.left: backButton
                KeyNavigation.right: imdbButton
                KeyNavigation.down: movieImagesView.count > 0 ? movieImagesView : null

                onClicked: {
                    stackView.push({
                                       item: Qt.resolvedUrl("qrc:/qml/screens/TrailerScreen.qml"),
                                       properties: {
                                           "movieId" : movieQuery.youtubeId,
                                           "movieTitle" : selectedMovie.title
                                       }
                                   })
                }
            }

            TextButton {
                id: imdbButton

                text: qsTr("IMDB")

                KeyNavigation.left: trailerButton
                KeyNavigation.down: movieImagesView.count > 0 ? movieImagesView : null

                onClicked: {
                    if (movieQuery.imdbId !== "") {
                        webViewOverlay.url = "http://www.imdb.com/title/%1".arg(movieQuery.imdbId)
                    } else {
                        webViewOverlay.url = "https://www.themoviedb.org/movie/%1".arg(selectedMovie.movieId)
                    }
                    webViewOverlay.open()
                }
            }
        }
    }

    MoviePoster {
        id: moviePosterImage

        anchors.left: parent.left
        anchors.top: toolBar.bottom
        anchors.bottom: movieImagesView.top
        anchors.leftMargin: 80 * dp
        anchors.topMargin: 20 * dp
        anchors.bottomMargin: 40 * dp

        width: height * 0.66

        source: selectedMovie.imageUrl
    }

    Label {
        id: movieTitleLabel

        anchors.left: moviePosterImage.right
        anchors.right: parent.right
        anchors.top: toolBar.bottom
        anchors.leftMargin: 40 * dp
        anchors.rightMargin: 20 * dp
        anchors.topMargin: 20 * dp

        color: colors.white2
        font.family: fonts.titillium
        font.pixelSize: 50 * dp
        font.bold: true

        text: selectedMovie.title
    }

    Row {
        id: movieInfoRow

        anchors.left: moviePosterImage.right
        anchors.right: parent.right
        anchors.top: movieTitleLabel.bottom

        anchors.leftMargin: 40 * dp
        anchors.rightMargin: 20 * dp

        spacing: 10 * dp

        Label {
            anchors.verticalCenter: parent.verticalCenter

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 30 * dp

            text: selectedMovie.releaseYear
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter

            spacing: 5 * dp

            Repeater {
                id: ratingStarsRepeater

                model: 5
                delegate: Label {
                    color: colors.yellow1
                    font.family: fonts.fontAwesome
                    font.pixelSize: 30 * dp

                    text: {
                        if (index + 1 < movieQuery.vote_average) "\uf005"
                        else if (movieQuery.vote_average - index > 0.25) "\uf123"
                        else "\uf006"
                    }
                }
            }
        }

        AnimatedText {
            anchors.verticalCenter: parent.verticalCenter

            color: colors.white2
            font.family: fonts.titillium
            font.pixelSize: 30 * dp

            text: movieQuery.runtime
        }
    }

    AnimatedText {
        id: movieGenresLabel

        anchors.left: moviePosterImage.right
        anchors.right: parent.right
        anchors.top: movieInfoRow.bottom

        anchors.leftMargin: 40 * dp
        anchors.rightMargin: 20 * dp

        color: colors.white2
        font.family: fonts.titillium
        font.pixelSize: 30 * dp
        font.italic: true

        text: movieQuery.genres
    }

    AnimatedText {
        id: movieDescriptionLabel

        anchors.left: moviePosterImage.right
        anchors.right: parent.right
        anchors.top: movieGenresLabel.bottom
        anchors.bottom: movieImagesView.bottom
        anchors.leftMargin: 40 * dp
        anchors.rightMargin: 20 * dp
        anchors.topMargin: 20 * dp
        anchors.bottomMargin: 20 * dp

        wrapMode: Text.Wrap
        color: colors.white2
        font.family: fonts.titillium
        font.pixelSize: 30 * dp

        text: movieQuery.synopsis
    }

    MovieImagesView {
        id: movieImagesView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 80 * dp
        anchors.rightMargin: 80 * dp
        anchors.bottomMargin: 40 * dp

        KeyNavigation.up: toolBar
        KeyNavigation.priority: KeyNavigation.BeforeItem

        onClicked: {
            imagePreviewOverlay.model = movieQuery.images
            imagePreviewOverlay.currentIndex = currentIndex
            imagePreviewOverlay.open()
        }

        onSwipedLeft: {
            movieImagesView.decrementCurrentIndex()
        }

        onSwipedRight: {
            movieImagesView.incrementCurrentIndex()
        }

        onSwipedUp: {
            var item = movieImagesView.KeyNavigation.up
            if (item && item.enabled) {
                item.forceActiveFocus()
            }
        }

        onSwipedDown: {
            var item = movieImagesView.KeyNavigation.down
            if (item && item.enabled) {
                item.forceActiveFocus()
            }
        }
    }

    JSONQuery {
        id: movieQuery

        property string synopsis
        property string youtubeId
        property real vote_average
        property int vote_count
        property string imdbId
        property string genres
        property string runtime
        property var images: []

        source: DataModels.formatQuery("movie/%1".arg(selectedMovie.movieId), { append_to_response: "trailers,images"} )

        onResultChanged: {
            var i

            // Extract genres
            if (result.genres) {
                var genresArray = []

                for (i = 0; i < result.genres.length; i++) {
                    genresArray.push(result.genres[i].name)
                }

                genres = genresArray.join(", ")
            }

            // Extract trailer if available
            var trailer
            if (result.trailers) {
                for (i = 0; i < result.trailers.youtube.length; i++) {
                    trailer = result.trailers.youtube[i].source
                    break
                }
            }

            youtubeId = trailer ? trailer : ""

            // Extract previews
            if (result.images) {
                var backdrops = result.images.backdrops

                for (i = 0; i < backdrops.length; i++) {
                    images.push(backdrops[i].file_path)
                }
            }

            // Extract overview
            if (result.overview) {
                synopsis = result.overview
            } else {
                synopsis = qsTr("No synopsis available")
            }

            if (result.imdb_id) {
                imdbId = result.imdb_id
            }

            if (result.vote_average) {
                vote_average = result.vote_average / 2
            } else {
                vote_average = 0
            }

            // Extract runtime
            if (result.runtime) {
                var hours = Math.floor(result.runtime / 60)
                var minutes = result.runtime - hours * 60
                if (hours > 0) {
                    runtime = "%1h %2m".arg(hours).arg(minutes)
                } else {
                    runtime = "%1m".arg(minutes)
                }
            }

            movieImagesView.model = images
        }
    }

    ImagePreviewOverlay {
        id: imagePreviewOverlay
    }

    WebViewOverlay {
        id: webViewOverlay
    }
}
