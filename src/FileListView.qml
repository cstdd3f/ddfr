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

  property var fileListModel
  property bool isLoading: false
  property string folder
  property int numFiles
  property bool prefixType1Check
  property bool prefixType2Check
  property bool renameEnabled: false

  signal modelChanged()
  signal dropHappened()
  signal removeOldPrefixChecked(checked: bool)
  signal prefixType1Checked()
  signal prefixType2Checked()
  signal renamePressed()

  padding: 4; leftPadding: 4; rightPadding: 4; topPadding: 4; bottomPadding: 4

  Pane {
    id: summaryPane

    anchors { left: parent.left; right: parent.right; top: parent.top }
    leftPadding: 0; rightPadding: 0; topPadding:  0; bottomPadding: 4

    RowLayout {
      anchors.fill: parent

      Label {
        text: qsTrId("id-folder") + ": " + folder
        elide: Text.ElideRight
        maximumLineCount: 1
      }

      Item { Layout.fillWidth: true }

      Label {
        text: qsTrId("id-files") + ": " + numFiles
        elide: Text.ElideRight
        maximumLineCount: 1
      }
    }
  }

  Pane {
    id: fileListPane

    anchors {
      left: parent.left; right: parent.right
      top: summaryPane.bottom; bottom: paddingItem.top
    }
    leftPadding: 0; rightPadding: 0; topPadding:  0; bottomPadding: 0
    background: Rectangle { color: palette.midlight }

    ListView {
      id: fileListView

      anchors.fill: parent
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      ScrollBar.vertical: ScrollBar {}

      model: fileListModel

      delegate: FileListDelegate {
        onMouseAreaHovered: function(containsMouse) {
          if (containsMouse) ListView.view.currentIndex = index
        }

        onDropAreaEntered: function(drag) {
          // Note that we are here from perspective of a target, not source!
          drag.source.dropY = y
          fileListModel.move( drag.source.DelegateModel.itemsIndex, index )
          modelChanged()
        }

        onDropped: dropHappened()

        width: ListView.view.width
        originalFileName: model.originalFileName
        newFileName: model.newFileName
      }

      highlight: Rectangle {
        z: 3 // Fly above dragged FileListDelegate (z == 2)
        color: palette.highlight
        opacity: 0.1
      }
    }

    BusyIndicator {
      anchors.centerIn: fileListView
      running: isLoading
    }
  }

  Item {
    id: paddingItem

    anchors {
      left: parent.left; right: parent.right
      bottom: groupBoxRow.top
    }
    height: control.padding
  }

  Row {
    id: groupBoxRow

    anchors { left: parent.left; bottom: parent.bottom }
    spacing: 8

    GroupBox {
      id: optionsGroupBox
      title: qsTrId("id-filters")

      GridLayout {
        anchors.fill: parent
        rows: 1; columns: 3

        CheckBox {
          id: removeOldPrefixCheckBox

          onCheckedChanged: removeOldPrefixChecked(checked)

          text: qsTrId("id-filter_removeOldPrefix")
          Layout.columnSpan: 1; Layout.rowSpan: 1
          Layout.column: 0; Layout.row: 0
        }
      }
    }

    GroupBox {
      id: prefixGroupBox
      title: qsTrId("id-prefix")

      GridLayout {
        anchors.fill: parent
        rows: 1; columns: 2

        RadioButton {
          id: prefixType1RadioButton

          onCheckedChanged: if (checked) prefixType1Checked()

          text: "01 - ..."
          checked: prefixType1Check
          Layout.columnSpan: 1; Layout.rowSpan: 1
          Layout.column: 0; Layout.row: 0
        }
        RadioButton {
          id: prefixType2RadioButton

          onCheckedChanged: if (checked) prefixType2Checked()

          text: "01. ..."
          checked: prefixType2Check
          Layout.columnSpan: 1; Layout.rowSpan: 1
          Layout.column: 1; Layout.row: 0
        }
      }
    }
  }

  Button {
    id: renameButton

    onClicked: renamePressed()

    anchors { right: parent.right; bottom: parent.bottom }
    text: qsTrId("id-rename")
    enabled: renameEnabled
  }
}
