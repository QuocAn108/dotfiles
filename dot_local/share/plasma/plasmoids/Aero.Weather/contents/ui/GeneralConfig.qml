import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: configRoot

    QtObject {
        id: unidWeatherValue
        property var value
    }

    QtObject {
        id: fontsizeValue
        property var value
    }

    signal configurationChanged

    property alias cfg_temperatureUnit: unidWeatherValue.value
    property alias cfg_sizeFontConfig: fontsizeValue.value
    property alias cfg_latitudeC: latitude.text
    property alias cfg_longitudeC: longitude.text
    property alias cfg_useCoordinatesIp: autamateCoorde.checked
    property alias cfg_boldfonts: boldfont.checked
    property alias cfg_textweather: textweather.checked
    property alias cfg_useCustomFontColor: useCustomFontColor.checked
    property string cfg_fontColor

    Kirigami.FormLayout {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Kirigami.Units.largeSpacing
        }

        ComboBox {
            textRole: "text"
            valueRole: "value"
            id: positionComboBox
            Kirigami.FormData.label: i18n("Temperature Unit:")
            model: [
                {text: i18n("Celsius (°C)"), value: 0},
                {text: i18n("Fahrenheit (°F)"), value: 1},
            ]
            onActivated: unidWeatherValue.value = currentValue
            Component.onCompleted: currentIndex = indexOfValue(unidWeatherValue.value)
        }
        CheckBox {
            id: textweather
            Kirigami.FormData.label: i18n('Show weather text on panel:')
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Location")
        }
        CheckBox {
            id: autamateCoorde
            Kirigami.FormData.label: i18n('Use IP location:')
        }
        TextField {
            id: latitude
            visible: !autamateCoorde.checked
            Kirigami.FormData.label: i18n("Latitude:")
            implicitWidth: 200
        }
        TextField {
            id: longitude
            visible: !autamateCoorde.checked
            Kirigami.FormData.label: i18n("Longitude:")
            implicitWidth: 200
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Font Appearance")
        }
        CheckBox {
            id: boldfont
            Kirigami.FormData.label: i18n('Bold font:')
        }
        ComboBox {
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n('Font Size:')
            id: valueForSizeFont
            model: [
                {text: i18n("8"), value: 8},
                {text: i18n("9"), value: 9},
                {text: i18n("10"), value: 10},
                {text: i18n("11"), value: 11},
                {text: i18n("12"), value: 12},
                {text: i18n("13"), value: 13},
                {text: i18n("14"), value: 14},
                {text: i18n("15"), value: 15},
                {text: i18n("16"), value: 16},
                {text: i18n("17"), value: 17},
                {text: i18n("18"), value: 18},

            ]
            onActivated: fontsizeValue.value = currentValue
            Component.onCompleted: currentIndex = indexOfValue(fontsizeValue.value)
        }
        CheckBox {
            id: useCustomFontColor
            Kirigami.FormData.label: i18n('Custom font color:')
        }
        Button {
            id: fontColorButton
            visible: useCustomFontColor.checked
            Kirigami.FormData.label: i18n('Font Color:')
            implicitWidth: 100
            implicitHeight: 30
            contentItem: Rectangle {
                color: cfg_fontColor
                radius: 4
                border.color: Qt.darker(cfg_fontColor, 1.2)
                border.width: 1
            }
            onClicked: colorDialog.open()
        }
        ColorDialog {
            id: colorDialog
            title: i18n("Choose Font Color")
            selectedColor: cfg_fontColor
            onAccepted: {
                cfg_fontColor = selectedColor
            }
        }
    }

}
