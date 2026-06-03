import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.1
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
  id: root

  readonly property bool isPlanar: Plasmoid.formFactor === PlasmaCore.Types.Planar
  readonly property bool showDesktopWeatherDirect: isPlanar

  readonly property real compactW: (compactRepresentationItem && compactRepresentationItem.implicitWidth > 0) ? compactRepresentationItem.implicitWidth : Kirigami.Units.gridUnit * 5
  readonly property real compactH: (compactRepresentationItem && compactRepresentationItem.implicitHeight > 0) ? compactRepresentationItem.implicitHeight : Kirigami.Units.gridUnit * 4
  
  readonly property real fullW: (fullRepresentationItem && fullRepresentationItem.implicitWidth > 0) ? fullRepresentationItem.implicitWidth : Kirigami.Units.gridUnit * 16
  readonly property real fullH: (fullRepresentationItem && fullRepresentationItem.implicitHeight > 0) ? fullRepresentationItem.implicitHeight : Kirigami.Units.gridUnit * 13.2

  readonly property real currentWidth: showDesktopWeatherDirect ? fullW : compactW
  readonly property real currentHeight: showDesktopWeatherDirect ? fullH : compactH

  implicitWidth: currentWidth
  implicitHeight: currentHeight
  Layout.minimumWidth: currentWidth
  Layout.minimumHeight: currentHeight
  Layout.preferredWidth: currentWidth
  Layout.preferredHeight: currentHeight
  Layout.maximumWidth: showDesktopWeatherDirect ? Kirigami.Units.gridUnit * 40 : currentWidth
  Layout.maximumHeight: showDesktopWeatherDirect ? Kirigami.Units.gridUnit * 40 : currentHeight

  Plasmoid.backgroundHints: isPlanar
      ? (PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground)
      : (PlasmaCore.Types.NoBackground | PlasmaCore.Types.ConfigurableBackground)

  preferredRepresentation: showDesktopWeatherDirect ? fullRepresentation : compactRepresentation

  property bool boldfonts: plasmoid.configuration.boldfonts
  property int temperatureUnit: plasmoid.configuration.temperatureUnit
  property string sizeFontConfg: plasmoid.configuration.sizeFontConfig
  property bool useCustomFontColor: plasmoid.configuration.useCustomFontColor
  property string fontColor: plasmoid.configuration.fontColor

  property var days: []

  property int syncPasses: 0

  function applySize() {
      if (!isPlanar) return;
      root.width = currentWidth;
      root.height = currentHeight;
      if (typeof root.minimumWidthChanged === "function") root.minimumWidthChanged();
      if (typeof root.minimumHeightChanged === "function") root.minimumHeightChanged();
      if (typeof root.maximumWidthChanged === "function") root.maximumWidthChanged();
      if (typeof root.maximumHeightChanged === "function") root.maximumHeightChanged();
  }

  function triggerSync() {
      if (!isPlanar) return;
      syncPasses = 3;
      Qt.callLater(applySize);
      syncTimer.restart();
  }

  Timer {
      id: syncTimer
      interval: 100
      repeat: false
      running: false
      onTriggered: {
          applySize();
          syncPasses--;
          if (syncPasses > 0) {
              syncTimer.restart();
          }
      }
  }

  onCurrentWidthChanged: triggerSync()
  onCurrentHeightChanged: triggerSync()

  Component.onCompleted: triggerSync()


  DayOfWeekRow {
    id: daysWeek
    visible: false
    delegate: Item {
      Component.onCompleted: {
        days.push(shortName)
      }
    }
  }

  compactRepresentation: CompactRepresentation {}
  fullRepresentation: FullRepresentation {}
}
