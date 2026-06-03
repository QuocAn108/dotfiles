import QtQuick

Item {
    property string latitud
    property string longitud
    readonly property bool fullCoordinates: latitud !== "" && longitud !== ""

    property int deepNight: 1230
    property int day: 360
    property bool apiDataReceived: false
    property bool apiIsDay: true

    readonly property bool isday: apiDataReceived ? apiIsDay : systemIsDay

    property bool systemIsDay: {
        var hour = new Date().getHours()
        return hour >= 6 && hour < 18
    }

    property string apiUrlFinal: "https://api.sunrise-sunset.org/json?lat=" + latitud + "&lng=" + longitud + "&formatted=0"

    signal update

    // reevaluate system clock fallback every minute
    Timer {
        id: clockFallbackTimer
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            var hour = new Date().getHours()
            systemIsDay = hour >= 6 && hour < 18
        }
    }

    Timer {
        id: delayFetchTimer
        interval: 50
        repeat: false
        onTriggered: {
            if (fullCoordinates) {
                fetchSunData(apiUrlFinal)
            }
        }
    }

    Timer {
        id: retryUpdate
        interval: 12000
        running: false
        repeat: true
        onTriggered: {
            fetchSunData(apiUrlFinal)
        }
    }

    function minutesOfDayISO8601(dat){
        var hours = parseInt(Qt.formatDateTime(dat, "h")) * 60
        var minutes = parseInt(Qt.formatDateTime(dat, "m"))
        return hours + minutes;
    }

    function minutesOfDay(dat){
        var UTCstring = dat.toUTCString();
        let parts = UTCstring.split(" ");
        let hoursMinutes = parts[3].split(":");
        let hours = parseInt(hoursMinutes[0])
        let minutes = parseInt(hoursMinutes[1])
        return (hours * 60) + minutes
    }

    function fetchSunData(url) {
        retryUpdate.stop()
        var minutesDay = minutesOfDay(new Date())
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.status === "OK") {
                    deepNight = minutesOfDayISO8601(response.results.astronomical_twilight_end);
                    day = minutesOfDayISO8601(response.results.sunrise);
                    var AdjustedNightSchedule = deepNight < day ? deepNight + 1440 : deepNight
                    apiIsDay = minutesDay > day && minutesDay < AdjustedNightSchedule
                    apiDataReceived = true
                    console.log("isDay (API):", apiIsDay)
                }
            }
        };
        xhr.send();
    }

    onLatitudChanged: delayFetchTimer.restart()
    onLongitudChanged: delayFetchTimer.restart()

    onUpdate: {
        if (fullCoordinates) {
            fetchSunData(apiUrlFinal)
        } else {
            retryUpdate.start()
        }
    }

    Component.onCompleted: {
         var hour = new Date().getHours()
         systemIsDay = hour >= 6 && hour < 18
    }
}
