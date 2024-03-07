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
import QtQuick.Window
import QtQuick.Controls


Window {
  id: window

  required property string message
  property string imagePath

  minimumWidth: contentPane.implicitWidth + 40
  minimumHeight: contentPane.implicitHeight + 20
  maximumWidth: contentPane.implicitWidth + 40
  maximumHeight: contentPane.implicitHeight + 20

  flags: Qt.Dialog
  modality: Qt.ApplicationModal

  Pane {
    id: contentPane

    anchors.fill: parent

    Column {
      anchors.centerIn: parent
      spacing: 8

      Image {
        anchors.horizontalCenter: parent.horizontalCenter
        source: imagePath
      }

      Label {
        anchors.horizontalCenter: parent.horizontalCenter
        text: message
        horizontalAlignment: Text.AlignHCenter
      }

      Button {
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTrId("id-close")
        onClicked: window.close()
      }
    }
  }
}
