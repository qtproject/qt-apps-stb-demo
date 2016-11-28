/*-
 * Copyright (c) 2014 Peter Tworek
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the author nor the names of any co-contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

.pragma library

var _youtube_data_v3_url = "https://www.googleapis.com/youtube/v3/";

//Replace this line with your own key
var youTubeDataKey = ""

function getYoutubeV3Url(reference, queryParams)
{
    var locale = Qt.locale().name;
    if (locale === "C") {
        locale = "en_US";
    }

    var url =  _youtube_data_v3_url + reference +
            "?regionCode=" + regionCode +
            "&key=" + youTubeDataKey +
            "&hl=" + locale +
            "&maxResults=" + 25

    for (var key in queryParams) {
        if (queryParams.hasOwnProperty(key)) {
            url += "&" + key + "=" + queryParams[key];
        }
    }
    return url;
}

function getVideoCategories(onSuccess, onFailure)
{
    var url = getYoutubeV3Url("videoCategories", {"part" : "snippet"});

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                var categories = JSON.parse(xhr.responseText)["items"];
                onSuccess(categories);
            } else {
                var details = xhr.responseText ? JSON.parse(xhr.responseText) : undefined;
                onFailure({"code" : xhr.status, "details" : details});
            }
        }
    }
    xhr.open("GET", url);
    xhr.send();
}

function getVideosInCategory(categoryId, onSuccess, onFailure, pageToken)
{
    var qParams = {};

    qParams["part"] = "snippet";
    //qParams["maxResults"] = resultsPerPage;
    qParams["chart"] = "mostPopular";
    qParams["videoCategoryId"] = categoryId;

    var url = getYoutubeV3Url("videos", qParams);

    if (pageToken !== undefined) {
        url += "&pageToken=" + pageToken;
    }

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                onSuccess(JSON.parse(xhr.responseText));
            } else {
                var details = xhr.responseText ? JSON.parse(xhr.responseText) : "";
                onFailure({"code" : xhr.status, "details" : details});
            }
        }
    }
    xhr.open("GET", url);
    xhr.send();
}

function getVideosInPlaylist(playlistId, onSuccess, onFailure)
{
    var url = getYoutubeV3Url("playlistItems",{"part" : "snippet", "playlistId" : playlistId});

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status !== 200) {
                var errDetails = xhr.responseText ? JSON.parse(xhr.responseText) : undefined;
                onFailure({"code" : xhr.status, "details" : errDetails});
                return;
            }
            var response = JSON.parse(xhr.responseText);
            onSuccess(response);
        }
    }
    xhr.open("GET", url);
    xhr.send()
}

function getVideoDetails(videoId, onSuccess, onFailure)
{
    var url = getYoutubeV3Url("videos", {"part" : "contentDetails, snippet, statistics",
                              "id" : videoId});

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status !== 200) {
                var errDetails = xhr.responseText ? JSON.parse(xhr.responseText) : undefined;
                onFailure({"code" : xhr.status, "details" : errDetails});
                return;
            }
            var details = JSON.parse(xhr.responseText);
            onSuccess(details.items[0]);
        }
    }
    xhr.open("GET", url);
    xhr.send();
}

function getChannelDetails(channelId, onSuccess, onFailure)
{
    var url = getYoutubeV3Url("channels",
        {"part" : "snippet,statistics,contentDetails", "id" : channelId});

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status !== 200) {
                var errDetails = xhr.responseText ? JSON.parse(xhr.responseText) : undefined;
                onFailure({"code" : xhr.status, "details" : errDetails});
                return;
            }
            var response = JSON.parse(xhr.responseText);
            onSuccess(response);
        }
    }
    xhr.open("GET", url);
    xhr.send();
}

function getSearchResults(query, onSuccess, onFailure, pageToken)
{
    var qParams = {};
    qParams["q"] = query;
    qParams["part"] = "snippet";
    qParams["type"] = "video,channel";
    qParams["safeSearch"] = "none";

    if (pageToken) {
        qParams["pageToken"] = pageToken;
    }

    var url = getYoutubeV3Url("search", qParams);

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            if (xhr.status !== 200) {
                var details = xhr.responseText ? JSON.parse(xhr.responseText) : undefined;
                onFailure({"code" : xhr.status, "details" : details});
                return;
            }
            var response = JSON.parse(xhr.responseText);
            onSuccess(response);
        }
    }
    xhr.open("GET", url);
    xhr.send();
}

function getVideoUrl(videoId, onSuccess, onFailure)
{
    var req = "https://www.youtube.com/get_video_info?video_id=" + videoId +
            "&el=player_embedded&gl=US&hl=en&eurl=https://youtube.googleapis.com/v/&asf=3&sts=1588";
    var availableSizes = [];

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status !== 200) {
                onFailure({"code" : xhr.status, "details" : JSON.parse(xhr.responseText)});
                return;
            }
            var stream_map_str = undefined;
            var tokens = xhr.responseText.split("&");
            for (var i = 0; i < tokens.length; i++) {
                var pair = tokens[i].split("=");
                if (pair[0] === "url_encoded_fmt_stream_map") {
                    stream_map_str = decodeURIComponent(pair[1]);
                    break;
                }
            }

            if (stream_map_str === undefined) {
                onFailure({"code" : 0, "details" : "No video streams found!"});
                return;
            }

            var stream_map_array = [];
            tokens = stream_map_str.split(',');
            for (var i = 0; i < tokens.length; i++) {
                var map_elements = tokens[i].split('&');
                var map = {};
                for (var k = 0; k < map_elements.length; k++) {
                    var map_entry = map_elements[k].split('=');
                    if ( map_entry[0] == "itag" ) { // get sizes
                        availableSizes.push(map_entry[1])
                    }

                    if (map_entry[0] === 'url') {
                        map[map_entry[0]] = decodeURIComponent(map_entry[1]);
                    } else {
                        map[map_entry[0]] = map_entry[1];
                    }
                }
                stream_map_array[i] = map;
            }

            var selected_url = undefined;
            for (var i = 0; i < stream_map_array.length; i++) {
                var size = availableSizes.indexOf("22") !== -1 ? "22" : "18"
                if (stream_map_array[i].itag === size) { // 22
                    if ("s" in stream_map_array[i]) {
                        onFailure({"code" : 0, "details" : "Encrypted signature detected, can't play video directly"});
                        return
                    } else if ("sig" in stream_map_array[i]) {
                        selected_url = stream_map_array[i].url +
                                "&signature=" + stream_map_array[i].sig;
                    } else {
                        selected_url = stream_map_array[i].url;
                    }

                    break;
                }
            }

            if (selected_url === undefined) {
                onFailure({"code" : 0, "details" : "No 360p video stream found!"});
                return;
            }

            onSuccess(selected_url);
        }
    }
    xhr.open("GET", req);
    xhr.send();
}
