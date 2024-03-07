// Copyright (C) 2024 Mikhail Dryuchin <cstddef@gmail.com>
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Pane {
  id: control

  // List of setting values
  required property var settingList
  // Current setting index in settingList
  required property int settingIdx
  required property string caption
  property string description

  property alias settingCaption: settingCaption
  property alias settingDescription: settingDescription
  property alias settingLabel: settingLabel

  signal settingIdxUpdated(newSettingIdx: int)

  hoverEnabled: true

  // NOTE: There's no way to use a single MouseArea on GridLayout
  // So, for having entire GridLayout content mouse-clickable
  // each Label must have own MouseArea
  GridLayout {
    id: settingLayout
    anchors.fill: parent
    columns: 2; rows: 2

    Label {
      id: settingCaption
      text: caption
      font.pointSize: Qt.application.font.pixelSize * 1.1 // Slightly bigger font
      maximumLineCount: 1
      elide: Qt.ElideRight
      Layout.fillWidth: true
      Layout.columnSpan: 1; Layout.rowSpan: 1
      Layout.column: 0; Layout.row: 0

      MouseArea {
        anchors.fill: parent
        onClicked: settingPopup.open()
      }
    }

    Label {
      id: settingDescription
      text: description
      font.pointSize: Qt.application.font.pixelSize * 0.8 // Slightly smaller font
      wrapMode: Text.WordWrap
      maximumLineCount: 3
      elide: Qt.ElideRight
      visible: text === "" ? false : true
      Layout.fillWidth: true
      Layout.columnSpan: 1; Layout.rowSpan: 1
      Layout.column: 0; Layout.row: 1

      MouseArea {
        anchors.fill: parent
        onClicked: settingPopup.open()
      }
    }

    Label {
      id: settingLabel
      text: settingIdx >= 0 ? settingList[settingIdx] : "Wrong settingIdx!"
      color: control.palette.highlight
      font.pointSize: Qt.application.font.pixelSize * 1.1 // Slightly bigger font
      elide: Qt.ElideRight
      Layout.alignment: Qt.AlignTop
      Layout.columnSpan: 1; Layout.rowSpan: 2
      Layout.column: 1; Layout.row: 0

      MouseArea {
        anchors.fill: parent
        onClicked: settingPopup.open()
      }
    }
  }

  Popup {
    id: settingPopup

    anchors.centerIn: parent // The only available option
    width: control.width / 2
    height: {
      // Nice hack..
      // Based on fact, that delegate label is similar to settingCaption
      var basedOnList =
        topPadding + bottomPadding
        + (control.topPadding + control.bottomPadding + settingCaption.height)
        * settingList.length
      if ( basedOnList > control.parent.height ) control.parent.height / 2
      else basedOnList
    }
    focus: true

    ListView {
      anchors.fill: parent

      clip: true
      boundsBehavior: Flickable.StopAtBounds

      model: settingList
      delegate:
        Pane {
          id: settingDelegatePane

          required property int index

          anchors { left: parent.left; right: parent.right }
          hoverEnabled: true

          Label {
            id: settingDelegate

            text: settingList[index]

            anchors.fill: parent
            font.pointSize: Qt.application.font.pixelSize * 1.1 // Slightly bigger font
            elide: Qt.ElideRight

            MouseArea {
              anchors.fill: parent
              onClicked: {
                settingIdxUpdated(index)
                settingPopup.close()
              }
            }
          }

          states: [
            State {
              name: "unhovered"
              when: !settingDelegatePane.hovered
              PropertyChanges {
                target: settingDelegatePane
                background.color: settingDelegatePane.palette.window
              }
            },
            State {
              name: "hovered"
              when: settingDelegatePane.hovered
              PropertyChanges {
                target: settingDelegatePane
                background.color: settingDelegatePane.palette.alternateBase
              }
            }
          ]

          transitions:
            Transition {
              ColorAnimation {
                target: settingDelegatePane
                property: "background.color"
                duration: 50
              }
            }
        }
      }
  }

  states: [
    State {
      name: "unhovered"
      when: !control.hovered
      PropertyChanges {
        target: control
        background.color: control.palette.window
      }
    },
    State {
      name: "hovered"
      when: control.hovered
      PropertyChanges {
        target: control
        background.color: control.palette.alternateBase
      }
    }
  ]

  transitions:
    Transition {
      ColorAnimation {
        target: control;
        property: "background.color";
        duration: 50
      }
    }
}
