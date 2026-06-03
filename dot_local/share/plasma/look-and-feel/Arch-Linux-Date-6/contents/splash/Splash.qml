/*
 *   Copyright 2014 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License version 2,
 *   or (at your option) any later version, as published by the Free
 *   Software Foundation
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick
import org.kde.kirigami 2 as Kirigami

Image {
    id: root
    source: "images/background.png"
    fillMode: Image.PreserveAspectCrop

    property int stage

    onStageChanged: {
        if (stage == 2) {
            introAnimation.running = true;
        } else if (stage == 5) {
            introAnimation.target = busyIndicator;
            introAnimation.from = 1;
            introAnimation.to = 0;
            introAnimation.running = true;
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }

        Image {
            id: logo
            //match SDDM/lockscreen avatar positioning
            property real size: units.gridUnit * 12
            opacity: 0.9
            anchors.horizontalCenter: parent.horizontalCenter
            // Set the y position to be slightly above the vertical center
            y: (parent.height / 2) - (height / 2) - 165 // Adjust -15 to move it higher or lower

            source: "images/logo.png"

            sourceSize.width: size
            sourceSize.height: size
        }

        FontLoader {
            source: "../components/artwork/fonts/OpenSans-Light.ttf"
        }

        Text {
            id: date1
            text: Qt.formatDateTime(new Date(), "hh:mm A")
            font.pointSize: 38
            color: "#ffffff" // High contrast blue color
            opacity: 0.80
            font { family: "OpenSans SemiBold"; weight: Font.SemiBold; capitalization: Font.Capitalize }
            anchors.horizontalCenter: parent.horizontalCenter
            y: (parent.height - height) / 1.2
        }

        Text {
            id: date2
            text: Qt.formatDateTime(new Date(), " dddd MMMM d yyyy")
            font.pointSize: 24
            color: "#ffffff" // High contrast blue color
            opacity: 0.80
            font { family: "OpenSans SemiBold"; weight: Font.SemiBold; capitalization: Font.Capitalize }
            anchors.horizontalCenter: parent.horizontalCenter
            y: (parent.height - height) / 1.1
        }

        // Adding spacing between the logo and the loading indicators
        Item {
            id: busyIndicatorContainer
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: logo.bottom
            anchors.topMargin: units.largeSpacing // Space between logo and loading indicators

            Image {
                id: busyIndicator1
                anchors.centerIn: parent // Center the first busy indicator
                source: "images/busywidget3.svg"
                opacity: 1.00
                sourceSize.height: units.gridUnit * 2.2
                sourceSize.width: units.gridUnit * 2.2
                RotationAnimator on rotation {
                    id: rotationAnimator1
                    from: 360
                    to: 0
                    duration: 1100
                    loops: Animation.Infinite
                }
            }

            Image {
                id: busyIndicator2
                anchors.centerIn: parent // Center the second busy indicator
                source: "images/busywidget4.svg"
                opacity: 0.9
                sourceSize.height: units.gridUnit * 2.6
                sourceSize.width: units.gridUnit * 2.6
                RotationAnimator on rotation {
                    id: rotationAnimator2
                    from: 0
                    to: 360
                    duration: 1100
                    loops: Animation.Infinite
                }
                // Adjust the y position to place it slightly above or below the first indicator
                y: 10 // Adjust this value to control the spacing between the indicators
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
}
