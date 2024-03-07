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


Item {
  id: control

  property string originalFileName
  property string newFileName
  property real dropY: y

  signal mouseAreaHovered(containsMouse: bool)
  signal dropAreaEntered(drag: DragEvent)
  signal dropped()

  // Private properties
  property bool dragActive: mouseArea.drag.active

  onDragActiveChanged: {
    if (dragActive) {
      dropY = y
      Drag.start()
    } else {
      // Order matters!
      Drag.drop()
      y = dropY
      dropped()
    }
  }

  implicitWidth: contentPane.implicitWidth
  implicitHeight: contentPane.implicitHeight
  Drag.hotSpot.x: width / 2
  Drag.hotSpot.y: height / 2
  Drag.keys: "dragDelegateItem"

  Pane {
    id: contentPane

    anchors.fill: parent
    padding: 5; leftPadding: 5; rightPadding: 5; topPadding: 5; bottomPadding: 5
    contentWidth: width - (leftPadding + rightPadding)
    background: Rectangle {
      color: palette.base
      border { color: palette.alternateBase; width: 1 }
    }

    RowLayout {
      anchors.fill: parent

      Label {
        id: originalFileNameLabel

        text: originalFileName
        maximumLineCount: 1
        elide: Text.ElideRight
        Layout.preferredWidth: parent.width / 2 - arrowLabel.width
      }

      Label {
        id: arrowLabel

        text: "\u21DB"
        Layout.preferredWidth: contentWidth * 2
      }

      Label {
        id: newFileNameLabel

        text: newFileName
        maximumLineCount: 1
        elide: Text.ElideRight
        Layout.fillWidth: true
      }
    }
  }

  MouseArea {
    id: mouseArea

    property bool held: false

    onPressAndHold: held = true
    onReleased: held = false
    onHoveredChanged: mouseAreaHovered(containsMouse)

    anchors.fill: parent
    pressAndHoldInterval: 100
    hoverEnabled: true
    drag.target: parent
    drag.axis: Drag.YAxis
  }

  DropArea {
    onEntered: function(drag) { dropAreaEntered(drag) }

    anchors.fill: parent
    keys: "dragDelegateItem"
  }

  states: [
    State {
      when: mouseArea.held
      PropertyChanges {
        target: control
        z: 2 // Fly above other elements with z == 1
      }
    }
  ]
}
