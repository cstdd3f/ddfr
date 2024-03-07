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

import ddfr

Window {
  onClosing: AppSettings.save()

  // Based on contents, considering different localizations applied
  minimumWidth: 350
  minimumHeight: 320

  flags: Qt.Dialog
  modality: Qt.ApplicationModal

  Pane {
    anchors.fill: parent
    leftPadding: 0; rightPadding: 0; topPadding: 0; bottomPadding: 0

    Column {
      anchors.fill: parent

      ListSetting {
        id: settingLanguage
        anchors { left: parent.left; right: parent.right }

        settingList: [ qsTrId("id-language-english"), qsTrId("id-language-russian") ]
        settingIdx: {
          switch (AppSettings.language) {
            case AppSettings.English: 0
              break
            case AppSettings.Russian: 1
              break
          }
        }
        caption: qsTrId("id-language")

        onSettingIdxUpdated: function(newSettingIdx) {
          switch (newSettingIdx) {
            case 0: AppSettings.language = AppSettings.English
              break
            case 1: AppSettings.language = AppSettings.Russian
              break
          }
        }
      }

      ListSetting {
        id: settingTheme
        anchors { left: parent.left; right: parent.right }

        settingList: [ qsTrId("id-theme-light"), qsTrId("id-theme-dark") ]
        settingIdx: {
          switch (AppSettings.theme) {
            case AppSettings.Light: 0
              break
            case AppSettings.Dark: 1
              break
          }
        }
        caption: qsTrId("id-theme")
        description: qsTrId("id-theme-desc")

        onSettingIdxUpdated: function(newSettingIdx) {
          switch (newSettingIdx) {
            case 0: AppSettings.theme = AppSettings.Light
              break
            case 1: AppSettings.theme = AppSettings.Dark
              break
          }
        }
      }

      BoolSetting {
        id: settingPortableMode
        anchors {
          left: parent.left
          right: parent.right
        }

        setting: AppSettings.portableMode
        caption: qsTrId("id-portableMode")
        description: qsTrId("id-portableMode-desc")

        onSwitchToggled: function(checked) {
          AppSettings.portableMode = checked
        }
      }
    }
  }
}
