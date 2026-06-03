import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.15
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import "components" as Components

Item {
    id: iconAndTem

    readonly property real minimumWidgetHeight: activeweathershottext
        ? Kirigami.Units.gridUnit * 2.6
        : Kirigami.Units.gridUnit * 2.2
    readonly property real minimumWidgetWidth: isVertical
        ? Kirigami.Units.gridUnit * 2.2
        : Kirigami.Units.gridUnit * 2.6

    // calculate height with fallback to minimum height
    implicitHeight: isVertical
        ? Math.max(wrapper_vertical.implicitHeight, minimumWidgetHeight)
        : Math.max(initial.implicitHeight, minimumWidgetHeight)

    implicitWidth: isVertical
        ? Math.max(wrapper_vertical.implicitWidth, minimumWidgetWidth)
        : Math.max(initial.implicitWidth, minimumWidgetWidth)

    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.minimumWidth: minimumWidgetWidth
    Layout.minimumHeight: minimumWidgetHeight

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    property bool textweather: Plasmoid.configuration.textweather
    property bool activeweathershottext: textweather && weatherData.dataAvailable
    property int fonssizes: Plasmoid.configuration.sizeFontConfig
    readonly property int compactIconSize: fonssizes < 12 ? 16 : (fonssizes < 16 ? 22 : 24)
    property color fontColorResolved: root.useCustomFontColor ? root.fontColor : Kirigami.Theme.textColor
    property int widthWidget: Math.max(temOfCo.implicitWidth, wrapper_weathertext.visible ? wrapper_weathertext.implicitWidth : 0)

    Components.WeatherData {
        id: weatherData
    }
    MouseArea {
        id: compactMouseArea
        anchors.fill: parent

        hoverEnabled: true

        onClicked: root.expanded = !root.expanded
    }

    RowLayout {
        id: initial
        anchors.centerIn: parent
        implicitHeight: weatherData.dataAvailable
            ? Math.max(icon.height, columntemandweathertext.implicitHeight)
            : icon.height
        spacing: icon.width / 5
        visible: !isVertical
        Kirigami.Icon {
            id: icon
            width: compactIconSize
            height: width
            source: weatherData.dataAvailable ? weatherData.iconWeatherCurrent : (weatherData.isDay ? "weather-clear" : "weather-clear-night")
            Layout.alignment: Qt.AlignVCenter
            roundToIconSize: false
        }
        Column {
            id: columntemandweathertext
            width: widthWidget
            height: implicitHeight
            spacing: 1
            Layout.alignment: Qt.AlignVCenter
            visible: weatherData.dataAvailable
            Row {
                id: temOfCo
                width: textGrados.implicitWidth + subtextGrados.implicitWidth
                height: textGrados.implicitHeight

                Label {
                    id: textGrados
                    height: parent.height
                    width: parent.width - subtextGrados.implicitWidth
                    text: weatherData.temperaturaActual
                    font.bold: boldfonts
                    font.pixelSize: fonssizes
                    color: fontColorResolved
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                Label {
                    id: subtextGrados
                    height: parent.height
                    width: parent.width - textGrados.implicitWidth
                    text: (Number(root.temperatureUnit) === 0) ? " °C " : " °F "
                    horizontalAlignment: Text.AlignLeft
                    font.bold: boldfonts
                    font.pixelSize: fonssizes
                    color: fontColorResolved
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Item {
                id: wrapper_weathertext
                height: shortweathertext.implicitHeight
                width: shortweathertext.implicitWidth
                visible: activeweathershottext && textweather
                Label {
                    id: shortweathertext
                    text: weatherData.weatherShottext
                    font.pixelSize: fonssizes
                    font.bold: true
                    color: fontColorResolved
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    ColumnLayout {
        id: wrapper_vertical
        anchors.centerIn: parent
        implicitWidth: Math.max(icon_vertical.width, temOfCo_vertical.visible ? temOfCo_vertical.width : 0)
        implicitHeight: icon_vertical.height + (temOfCo_vertical.visible ? (spacing + temOfCo_vertical.implicitHeight) : 0)
        spacing: 2
        visible: isVertical
        Kirigami.Icon {
            id: icon_vertical
            width: root.width < 17 ? 16 : root.width < 24 ? 22 : 24
            height: root.width < 17 ? 16 : root.width < 24 ? 22 : 24
            source: weatherData.dataAvailable ? weatherData.iconWeatherCurrent : (weatherData.isDay ? "weather-clear" : "weather-clear-night")
            Layout.alignment: Qt.AlignHCenter
            roundToIconSize: false
        }
        Row {
            id: temOfCo_vertical
            width: textGrados_vertical.implicitWidth + subtextGrados_vertical.implicitWidth
            height: textGrados_vertical.implicitHeight
            Layout.alignment: Qt.AlignHCenter
            visible: weatherData.dataAvailable

            Label {
                id: textGrados_vertical
                height: parent.height
                text: weatherData.temperaturaActual
                font.bold: boldfonts
                font.pixelSize: fonssizes
                color: fontColorResolved
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                id: subtextGrados_vertical
                height: parent.height
                text: (Number(root.temperatureUnit) === 0) ? " °C" : " °F"
                font.bold: boldfonts
                font.pixelSize: fonssizes
                color: fontColorResolved
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

}



