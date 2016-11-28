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
    id: moviesScreen

    QtObject {
        id: selectedMovie

        property string movieId
        property string title
        property string synopsis
        property string imageUrl
        property string releaseYear

        function update(data) {
            if (data) {
                selectedMovie.title = data.title ? data.title : ""
                selectedMovie.imageUrl = data.poster_path ? DataModels.posterPathURL(data.poster_path, 500) : ""
                selectedMovie.releaseYear = data.release_date ? new Date(data.release_date).getFullYear() : ""
                selectedMovie.movieId = data.id
            }
        }
    }

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

            KeyNavigation.right: searchInputField
            KeyNavigation.down: if (catalogsListView.visible && catalogsListView.count > 0) {
                                    catalogsListView
                                } else if (searchCatalogView.visible && searchCatalogView.count > 0) {
                                    searchCatalogView
                                } else {
                                    null
                                }

            onClicked: {
                stackView.pop()
            }
        }

        TextInputField {
            id: searchInputField

            anchors.left: backButton.right
            anchors.right: clearButton.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 50 * dp
            anchors.rightMargin: 50 * dp

            placeholderText: qsTr("Search")

            KeyNavigation.left: backButton
            KeyNavigation.right: clearButton
            KeyNavigation.down: if (catalogsListView.visible && catalogsListView.count > 0) {
                                    catalogsListView
                                } else if (searchCatalogView.visible && searchCatalogView.count > 0) {
                                    searchCatalogView
                                } else {
                                    null
                                }

            Timer {
                id: searchInputTimer

                interval: 2000
                running: searchInputField.acceptingInput
                repeat: true
                triggeredOnStart: true

                onTriggered: {
                    searchModel.source = DataModels.formatQuery("search/movie", { "query" : searchInputField.text })
                }
            }
        }

        TextButton {
            id: clearButton

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 40 * dp

            text: qsTr("Clear")

            KeyNavigation.left: searchInputField
            KeyNavigation.down: if (catalogsListView.visible && catalogsListView.count > 0) {
                                    catalogsListView
                                } else if (searchCatalogView.visible && searchCatalogView.count > 0) {
                                    searchCatalogView
                                } else {
                                    null
                                }

            onClicked: {
                searchInputField.text = ""
            }
        }
    }

    MovieCatalogView {
        id: searchCatalogView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: toolBar.bottom
        anchors.leftMargin: 40 * dp
        anchors.rightMargin: 40 * dp
        anchors.bottomMargin: 40 * dp

        visible: searchInputField.text !== ""

        displayMarginBeginning: anchors.leftMargin
        displayMarginEnd: anchors.rightMargin

        title: qsTr("Search Results")
        model: searchModel

        onCurrentIndexChanged: {
            var data = model.get(currentIndex)
            selectedMovie.update(data)
        }

        onClicked: {
            stackView.push({
                               item: Qt.resolvedUrl("qrc:/qml/screens/MovieDetailsScreen.qml"),
                               properties: {
                                   "selectedMovie" : selectedMovie
                               }
                           })
        }

        KeyNavigation.up: toolBar
        KeyNavigation.priority: KeyNavigation.BeforeItem
    }

    Item {
        id: catalogsListViewArea

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: toolBar.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30 * dp

        layer.enabled: true
        layer.samplerName: "source"
        layer.effect: VerticalDissolveEffect {
            length: 150 * dp
            sourceHeight: catalogsListViewArea.height
        }

        ListView {
            id: catalogsListView

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 40 * dp
            anchors.rightMargin: 40 * dp
            anchors.topMargin: 20 * dp
            anchors.bottomMargin: 80 * dp

            visible: searchInputField.text === ""

            orientation: ListView.Vertical
            snapMode: ListView.SnapToItem
            boundsBehavior: Flickable.StopAtBounds
            highlightMoveDuration: 200
            cacheBuffer: currentItem ? (currentItem.height * count - height)
                                     : 0
            displayMarginBeginning: currentItem ? currentItem.delegateHeight : 0
            displayMarginEnd: currentItem ? currentItem.delegateHeight : 0

            readonly property real delegateWidth: currentItem ? currentItem.width : 0
            readonly property real delegateHeight: currentItem ? currentItem.height : 0
            function item(index) {
                return itemAt(delegateWidth / 2, delegateHeight * (index + 1) + spacing * index - delegateHeight / 2)
            }

            onActiveFocusChanged: {
                if (activeFocus) {
                    var data = currentItem.model.get(currentItem.currentIndex)
                    selectedMovie.update(data)
                }
            }

            // different catalog is selected
            onCurrentIndexChanged: {
                if (activeFocus && currentItem !== null) {
                    var data = currentItem.model.get(currentItem.currentIndex)
                    selectedMovie.update(data)
                }
            }

            model: ListModel {
                // https://developers.themoviedb.org/3/movies
                ListElement { titleText: QT_TR_NOOP("Popular"); query: "movie/popular" }
                ListElement { titleText: QT_TR_NOOP("Now Playing"); query: "movie/now_playing" }
                ListElement { titleText: QT_TR_NOOP("Upcoming"); query: "movie/upcoming" }
                ListElement { titleText: QT_TR_NOOP("Top Rated"); query: "movie/top_rated" }
                // https://www.themoviedb.org/genres
                ListElement { titleText: QT_TR_NOOP("Action"); query: "genre/28/movies" }
                ListElement { titleText: QT_TR_NOOP("Adventure"); query: "genre/12/movies" }
                ListElement { titleText: QT_TR_NOOP("Animation"); query: "genre/16/movies" }
                ListElement { titleText: QT_TR_NOOP("Comedy"); query: "genre/35/movies" }
                ListElement { titleText: QT_TR_NOOP("Crime"); query: "genre/80/movies" }
                ListElement { titleText: QT_TR_NOOP("Documentary"); query: "genre/99/movies" }
                ListElement { titleText: QT_TR_NOOP("Drama"); query: "genre/18/movies" }
                ListElement { titleText: QT_TR_NOOP("Fantasy"); query: "genre/14/movies" }
                ListElement { titleText: QT_TR_NOOP("History"); query: "genre/36/movies" }
                ListElement { titleText: QT_TR_NOOP("Horror"); query: "genre/27/movies" }
                ListElement { titleText: QT_TR_NOOP("Music"); query: "genre/10402/movies" }
                ListElement { titleText: QT_TR_NOOP("Mystery"); query: "genre/9648/movies" }
                ListElement { titleText: QT_TR_NOOP("Romance"); query: "genre/10749/movies" }
                ListElement { titleText: QT_TR_NOOP("Science Fiction"); query: "genre/878/movies" }
                ListElement { titleText: QT_TR_NOOP("TV Movie"); query: "genre/10770/movies" }
                ListElement { titleText: QT_TR_NOOP("Thriller"); query: "genre/53/movies" }
                ListElement { titleText: QT_TR_NOOP("War"); query: "genre/10752/movies" }
                ListElement { titleText: QT_TR_NOOP("Western"); query: "genre/37/movies" }
            }

            function moveFocusUp() {
                var screenFocusIndex = currentItem.currentIndex - currentItem.firstVisibleItemIndex
                var previousCatalog = item(currentIndex - 1)
                previousCatalog.currentIndex = previousCatalog.firstVisibleItemIndex + screenFocusIndex
                decrementCurrentIndex()
            }

            function moveFocusDown() {
                var screenFocusIndex = currentItem.currentIndex - currentItem.firstVisibleItemIndex
                var nextCatalog = item(currentIndex + 1)
                nextCatalog.currentIndex = nextCatalog.firstVisibleItemIndex + screenFocusIndex
                incrementCurrentIndex()
            }

            KeyNavigation.up: toolBar
            Keys.onPressed: {
                var screenFocusIndex

                switch (event.key) {
                case Qt.Key_Up:
                    if (currentIndex > 0) {
                        moveFocusUp()
                        event.accepted = true
                    }
                    break
                case Qt.Key_Down:
                    if (currentIndex < count - 1) {
                        moveFocusDown()
                        event.accepted = true
                    }
                    break
                }
            }

            delegate: MovieCatalogView {
                id: movieCatalogView

                anchors.left: catalogsListView.contentItem.left
                anchors.right: catalogsListView.contentItem.right
                anchors.leftMargin: 40 * dp
                anchors.rightMargin: 40 * dp

                title: titleText

                model: JSONListModel {
                    arrayPropertyName: "results"
                    source: DataModels.formatQuery(query)
                }

                // different movie is selected
                onCurrentIndexChanged: {
                    if (activeFocus && currentItem !== null) {
                        var data = model.get(currentIndex)
                        selectedMovie.update(data)
                    }
                }

                onClicked: {
                    catalogsListView.currentIndex = index

                    stackView.push({
                                       item: Qt.resolvedUrl("qrc:/qml/screens/MovieDetailsScreen.qml"),
                                       properties: {
                                           "selectedMovie" : selectedMovie
                                       }
                                   })
                }

                onSwipedLeft: {
                    movieCatalogView.decrementCurrentIndex()
                }

                onSwipedRight: {
                    movieCatalogView.incrementCurrentIndex()
                }

                onSwipedUp: {
                    if (catalogsListView.currentIndex > 0) {
                        catalogsListView.moveFocusUp()
                    } else {
                        var item = catalogsListView.KeyNavigation.up
                        if (item && item.enabled) {
                            item.forceActiveFocus()
                        }
                    }
                }

                onSwipedDown: {
                    if (catalogsListView.currentIndex < catalogsListView.count - 1) {
                        catalogsListView.moveFocusDown()
                    } else {
                        var item = catalogsListView.KeyNavigation.down
                        if (item && item.enabled) {
                            item.forceActiveFocus()
                        }
                    }
                }
            }
        }
    }

    JSONListModel {
        id: searchModel

        arrayPropertyName: "results"
    }
}
