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
  // A bool setting which is typically set externally as a binding.
  // This binding propagates into settingSwitch
  required property bool setting
  required property string caption
  property string description

  property alias settingCaption: settingCaption
  property alias settingDescription: settingDescription

  // Use this signal to get updates from checking a switch and
  // maintain external binding for setting at the same time
  signal switchToggled(checked: bool)

  GridLayout {
    anchors.fill: parent
    rows: 2; columns: 2

    Label {
      id: settingCaption
      text: caption
      font.pointSize: Qt.application.font.pixelSize * 1.1 // Slightly bigger font
      maximumLineCount: 1
      elide: Qt.ElideRight
      Layout.fillWidth: true
      Layout.columnSpan: 1; Layout.rowSpan: 1
      Layout.column: 0; Layout.row: 0
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
    }

    Switch {
      id: settingSwitch
      onToggled: switchToggled(checked)
      checked: setting
      Layout.alignment: Qt.AlignTop
      Layout.columnSpan: 1; Layout.rowSpan: 2
      Layout.column: 1; Layout.row: 0
    }
  }
}
