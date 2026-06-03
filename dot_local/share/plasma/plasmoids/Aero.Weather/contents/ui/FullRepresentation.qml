import QtQuick
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import "components" as Components
import org.kde.kirigami as Kirigami

Item {
    id: fullRepresentationRoot

    readonly property bool isPlanar: Plasmoid.formFactor === PlasmaCore.Types.Planar
    readonly property int popupPadding: Kirigami.Units.mediumSpacing
    readonly property real popupPreferredWidth: Kirigami.Units.gridUnit * (isPlanar ? 16 : 18)
    readonly property real popupPreferredHeight: Kirigami.Units.gridUnit * (isPlanar ? 13.2 : 13)
    readonly property real popupMaxWidth: Kirigami.Units.gridUnit * (isPlanar ? 18 : 20)
    readonly property real popupMaxHeight: Kirigami.Units.gridUnit * (isPlanar ? 16.2 : 15)

    implicitWidth: Math.min(Math.max(contentLayout.implicitWidth + (popupPadding * 2), popupPreferredWidth), popupMaxWidth)
    implicitHeight: Math.min(Math.max(contentLayout.implicitHeight + (popupPadding * 2), popupPreferredHeight), popupMaxHeight)
    Layout.minimumWidth: popupPreferredWidth
    Layout.minimumHeight: popupPreferredHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.maximumWidth: popupMaxWidth
    Layout.maximumHeight: popupMaxHeight

    Components.WeatherData {
        id: weatherData
    }

    property int temperatureUnit: Plasmoid.configuration.temperatureUnit
    property color fontColorResolved: root.useCustomFontColor ? root.fontColor : Kirigami.Theme.textColor
    property var dayLabels: [
        i18n("Sun"),
        i18n("Mon"),
        i18n("Tue"),
        i18n("Wed"),
        i18n("Thu"),
        i18n("Fri"),
        i18n("Sat")
    ]

    function sumarDia(a) {
        var currentDay = (new Date()).getDay()
        var day = ((currentDay + a) % 7 ) === 7 ? 0 : (currentDay + a) % 7
        return day
    }

    property string tomorrow: sumarDia(1)
    property string dayAftertomorrow: sumarDia(2)
    property string twoDaysAfterTomorrow: sumarDia(3)

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: popupPadding
        spacing: Kirigami.Units.mediumSpacing

        // --- Offline / Error State ---
        Item {
            id: offlineState
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: visible ? 1 : 0
            visible: !weatherData.dataAvailable

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Icon {
                    source: weatherData.networkError ? "network-disconnect" : (weatherData.isDay ? "weather-clear" : "weather-clear-night")
                    Layout.preferredWidth: Kirigami.Units.iconSizes.large
                    Layout.preferredHeight: Kirigami.Units.iconSizes.large
                    Layout.alignment: Qt.AlignHCenter
                    opacity: 0.6
                }

                PlasmaComponents3.Label {
                    text: weatherData.networkError
                          ? i18n("No Internet Connection")
                          : i18n("Loading weather data…")
                    font.pixelSize: Kirigami.Units.gridUnit
                    font.weight: Font.DemiBold
                    color: fontColorResolved
                    opacity: 0.9
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                PlasmaComponents3.Label {
                    text: weatherData.networkError
                          ? i18n("Please check your network and try again.")
                          : i18n("Fetching the latest weather information.")
                    font.pixelSize: Kirigami.Units.gridUnit * 0.8
                    color: fontColorResolved
                    opacity: 0.55
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.maximumWidth: parent.width * 0.8
                }

                PlasmaComponents3.Button {
                    text: i18n("Retry")
                    icon.name: "view-refresh"
                    visible: weatherData.networkError
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: {
                        weatherData.updateWeather(1);
                    }
                }
            }
        }

        // --- Normal Weather Content ---
        Item {
            id: currentWeather
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: visible ? Kirigami.Units.gridUnit * (isPlanar ? 6.6 : 6.5) : 0
            visible: weatherData.dataAvailable
            
            Column {
                id: currentSection
                width: parent.width
                height: temperatura.implicitHeight + longweathertext.implicitHeight + probText.implicitHeight + (spacing * 2)
                anchors.centerIn: parent
                spacing: Kirigami.Units.smallSpacing

                PlasmaComponents3.Label {
                    id: temperatura
                    text: temperatureUnit === 0 ? weatherData.temperaturaActual + "°C" : weatherData.temperaturaActual + "°F"
                    width: parent.width
                    font.pixelSize: Kirigami.Units.gridUnit * 2.8
                    color: fontColorResolved
                    horizontalAlignment: Text.AlignHCenter
                }
                PlasmaComponents3.Label {
                    id: longweathertext
                    text: weatherData.weatherLongtext
                    width: parent.width
                    font.pixelSize: Kirigami.Units.gridUnit * 1.2
                    color: fontColorResolved
                    horizontalAlignment: Text.AlignHCenter
                }
                PlasmaComponents3.Label {
                    id: probText
                    text: weatherData.textProbability + ": " + weatherData.probabilidadDeLLuvia + "%"
                    width: parent.width
                    font.pixelSize: Kirigami.Units.gridUnit * 0.9
                    color: fontColorResolved
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Row {
            id: forecastSection
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: visible ? Kirigami.Units.gridUnit * (isPlanar ? 5.2 : 4.9) : 0
            spacing: Kirigami.Units.mediumSpacing
            visible: weatherData.dataAvailable

            Repeater {
                model: 3
                delegate: Column {
                    height: parent.height
                    width: (parent.width - (forecastSection.spacing * 2)) / 3
                    spacing: Kirigami.Units.smallSpacing

                    PlasmaComponents3.Label {
                        width: parent.width
                        text: dayLabels[sumarDia(modelData + 1)] || ""
                        color: fontColorResolved
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Kirigami.Units.gridUnit * 0.8
                    }

                    Kirigami.Icon {
                        source: weatherData.asingicon(modelData === 0 ? weatherData.codeweatherTomorrow : modelData === 1 ? weatherData.codeweatherDayAftertomorrow : weatherData.codeweatherTwoDaysAfterTomorrow)
                        width: Kirigami.Units.iconSizes.medium
                        height: Kirigami.Units.iconSizes.medium
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: Math.max(1, Kirigami.Units.smallSpacing / 2)
                        anchors.horizontalCenter: parent.horizontalCenter
                        PlasmaComponents3.Label {
                            text: Math.round(modelData === 0 ? weatherData.maxweatherTomorrow : modelData === 1 ? weatherData.maxweatherDayAftertomorrow : weatherData.maxweatherTwoDaysAfterTomorrow) + "°"
                            color: fontColorResolved
                            font.weight: Font.Bold
                            font.pixelSize: Kirigami.Units.gridUnit * 0.9
                        }
                        PlasmaComponents3.Label {
                            text: Math.round(modelData === 0 ? weatherData.minweatherTomorrow : modelData === 1 ? weatherData.minweatherDayAftertomorrow : weatherData.minweatherTwoDaysAfterTomorrow) + "°"
                            color: fontColorResolved
                            opacity: 0.6
                            font.pixelSize: Kirigami.Units.gridUnit * 0.8
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: {
            tomorrow = sumarDia(1)
            dayAftertomorrow = sumarDia(2)
            twoDaysAfterTomorrow = sumarDia(3)
        }
    }
}
