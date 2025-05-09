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
  property bool isCustomName
  property string newFileName
  property real dropY: y

  signal mouseAreaHovered(containsMouse: bool)
  signal dropAreaEntered(drag: DragEvent)
  signal dropped()
  signal customNameChecked(checked: bool)
  signal customNameEdited(text: string)
  signal removeClicked()

  // Private properties
  property bool dragActive: mouseAreaLeft.drag.active || mouseAreaRight.drag.active

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

  width: contentPane.width
  height: contentPane.height
  Drag.hotSpot.x: width / 2
  Drag.hotSpot.y: height / 2
  Drag.keys: [ "dragDelegateItem" ]

  Pane {
    id: contentPane

    anchors.fill: parent
    horizontalPadding: 5; verticalPadding: 0
    contentWidth: width - (leftPadding + rightPadding)
    background: Rectangle {
      color: palette.base
      border { color: palette.alternateBase; width: 1 }
    }

    RowLayout {
      anchors.fill: parent

      Label {
        id: originalFileNameLabel

        text: control.originalFileName
        maximumLineCount: 1
        elide: Text.ElideRight
        Layout.preferredWidth: parent.width / 2 - arrowLabel.width
      }

      Label {
        id: arrowLabel

        text: "\u21DB"
      }

      CheckBox {
        id: customNameCheckbox

        onCheckedChanged: control.customNameChecked(checked)

        checkable: true
        checked: control.isCustomName

        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.text: qsTrId("id-setCustomName")
      }

      TextInput {
        id: newFileNameTextEdit

        onEditingFinished: control.customNameEdited(text)

        enabled: customNameCheckbox.checked

        text: control.newFileName
        wrapMode: TextEdit.NoWrap
        clip: true
        Layout.fillWidth: true

        color: palette.text
      }

      Button {
        id: removeButton

        onClicked: removeClicked()

        text: "X"
        font.bold: true
        Layout.preferredWidth: implicitContentWidth + horizontalPadding * 2
      }
    }
  }

  // Area that covers control's originalFileNameLabel and arrowLabel
  MouseArea {
    id: mouseAreaLeft

    property bool held: false

    onPressAndHold: held = true
    onReleased: held = false
    onHoveredChanged: control.mouseAreaHovered(containsMouse)

    height: contentPane.height
    width: originalFileNameLabel.width + contentPane.horizontalPadding
           + arrowLabel.width + contentPane.horizontalPadding

    pressAndHoldInterval: 100
    hoverEnabled: true
    drag.target: parent
    drag.axis: Drag.YAxis
  }

  // Area that covers control's newFileNameTextEdit
  MouseArea {
    id: mouseAreaRight

    property bool held: false

    enabled: !customNameCheckbox.checked

    onPressAndHold: held = true
    onReleased: held = false
    onHoveredChanged: control.mouseAreaHovered(containsMouse)

    height: contentPane.height
    width: newFileNameTextEdit.width
    x: mouseAreaLeft.width + contentPane.horizontalPadding + customNameCheckbox.width

    pressAndHoldInterval: 100
    hoverEnabled: true
    drag.target: parent
    drag.axis: Drag.YAxis
  }

  DropArea {
    onEntered: function(drag) { control.dropAreaEntered(drag) }

    anchors.fill: parent
    keys: [ "dragDelegateItem" ]
  }

  states: [
    State {
      when: mouseAreaLeft.held || mouseAreaRight.held
      PropertyChanges {
        control.z: 2 // Fly above other elements with z == 1
      }
    }
  ]
}
