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

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import ddfr


ApplicationWindow {
  id: appWindow
  title: Qt.application.name

  // Changing theme via bindings to palette
  // NOTE: Prints "Self assignment makes no sense." Ok, but why?
  Binding on palette {
    when: AppSettings.theme == AppSettings.Dark
    value: DarkPalette {}
  }
  Binding on palette {
    when: AppSettings.theme == AppSettings.Light
    value: LightPalette {}
  }

  // Hints
  readonly property var folderOpenedHints: [
    qsTrId("id-statusBar_moveItems"),
    qsTrId("id-statusBar_filtersPrefix")
  ]
  property int currentFolderOpenedHint: 0

  function changeFolderOpenedHint() {
    if ( (currentFolderOpenedHint + 1) >= folderOpenedHints.length ) {
      currentFolderOpenedHint = 0
    }
    else ++currentFolderOpenedHint
  }

  Component.onCompleted: {
    AppSettings.loadTranslation()
    appWindowStateGroup.state = "initial"
  }

  onClosing: function(close) {
    if ( appWindowStateGroup.state === "modified" ) {
      close.accepted = false
      actionExit.trigger()
    }
  }

  width: Screen.desktopAvailableWidth * 0.5
  height: Screen.desktopAvailableHeight * 0.5
  minimumWidth: 800
  minimumHeight: 600
  // Maximum is unlimited

  visible: true

  Action {
    id: actionOpenFolder
    text: "&" + qsTrId("id-open-folder") + "..."
    shortcut: "Ctrl+O"
    onTriggered: {
      if ( appWindowStateGroup.state === "modified" ) {
        windowLoader.sourceComponent = openFolderUnsavedWindow
      }
      else {
        fileDialog.open()
      }
    }
  }
  Action {
    id: actionCloseFolder
    text: "&" + qsTrId("id-close-folder")
    onTriggered: {
      if ( appWindowStateGroup.state === "modified" ) {
        windowLoader.sourceComponent = closeFolderUnsavedWindow
      }
      else {
        if ( appWindowStateGroup.state !== "initial" ) {
          appWindowStateGroup.state = "initial"
        }
      }
    }
  }
  Action {
    id: actionExit
    text: "&" + qsTrId("id-exit")
    onTriggered: {
      if ( appWindowStateGroup.state === "modified" ) {
        windowLoader.sourceComponent = exitUnsavedWindow
      }
      else Qt.quit()
    }
  }
  Action {
    id: actionSettings
    text: "&" + qsTrId("id-settings") + "..."
    onTriggered: windowLoader.sourceComponent = settingsWindow
  }
  Action {
    id: actionAbout
    text: "&" + qsTrId("id-about") + " " + Qt.application.name + "..."
    onTriggered: windowLoader.sourceComponent = aboutWindow
  }

  menuBar: MenuBar {
    Menu {
      title: "&" + qsTrId("id-file")

      MenuItem { action: actionOpenFolder }
      MenuItem { action: actionCloseFolder }
      MenuSeparator {}
      MenuItem { action: actionExit }
    }
    Menu {
      title: "&" + qsTrId("id-edit")

      MenuItem { action: actionSettings }
    }
    Menu {
      title: "&" + qsTrId("id-help")

      MenuItem { action: actionAbout }
    }
  }

  footer: Pane {
    Label { text: AppSingleton.statusBarText }
  }

  StackView {
    id: stackView

    anchors.fill: parent
    initialItem: noFolderOpenedView
    pushEnter: Transition {
      PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
    }
    pushExit: Transition {
      PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
    }
    popEnter: Transition {
      PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
    }
    popExit: Transition {
      PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
    }
  }

  Component {
    id: noFolderOpenedView

    Pane {
      Label {
        anchors.centerIn: parent
        text: qsTrId("id-noFolderOpened")
      }
    }
  }

  Component {
    id: fileListView

    FileListView {
      Component.onCompleted: prefixType1Check = true

      onModelChanged: {
        if ( appWindowStateGroup.state !== "modified" ) {
          appWindowStateGroup.state = "modified"
        }
      }

      onDropHappened: FileListModel.applyModifiers()

      onRemoveOldPrefixChecked: function(checked) {
        if ( checked ) {
          FileListModel.installFilter(FileListModel.RemoveOldPrefixFilter);
        }
        else {
          FileListModel.uninstallFilter(FileListModel.RemoveOldPrefixFilter)
        }
        FileListModel.applyModifiers()
      }

      onPrefixType1Checked: {
        FileListModel.installPrefix(FileListModel.PrefixType1);
        FileListModel.applyModifiers()
      }

      onPrefixType2Checked: {
        FileListModel.installPrefix(FileListModel.PrefixType2);
        FileListModel.applyModifiers()
      }

      onRenamePressed: windowLoader.sourceComponent = confirmRenameWindow

      folder: AppSingleton.localPathFromUrl(FileListModel.folder)
      numFiles: FileListModel.numFiles
      renameEnabled: true

      Connections {
        target: FileListModel

        function onLoadFileList() {
          isLoading = true
        }

        function onFileListLoaded(ok) {
          if (ok) {
            isLoading = false
            FileListModel.applyModifiers()
            fileListModel = FileListModel
          }
          else console.warn("Failed to load FileListModel!")
        }

        function onUnloadFileListStarted() {
          fileListModel = undefined
        }

        function onFilesRenamed() {
          windowLoader.sourceComponent = filesRenamedWindow
          FileListModel.unloadFileList()
          FileListModel.loadFileList()
        }
      }
    }
  }

  Loader { // For loading dialog windows
    id: windowLoader; asynchronous: true; visible: status == Loader.Ready
  }

  Component {
    id: settingsWindow

    SettingsWindow {
      onClosing: windowLoader.sourceComponent = undefined

      title: qsTrId("id-settings")
      width: 350
      height: appWindow.height * 0.8
      minimumHeight: appWindow.height * 0.8
      maximumWidth: 350
      maximumHeight: appWindow.height * 0.8
      visible: windowLoader.visible
      palette: appWindow.palette
    }
  }

  Component {
    id: aboutWindow

    MessageWindow {
      onClosing: windowLoader.sourceComponent = undefined

      imagePath: "qrc:///qt/qml/ddfr/res/dragon_64x64.png"
      title: qsTrId("id-about") + " " + Qt.application.name
      message: Qt.application.name + " v." + Qt.application.version
               + "\n" +  Qt.application.organization
      visible: windowLoader.visible
      palette: appWindow.palette
    }
  }

  Component {
    id: filesRenamedWindow

    MessageWindow {
      onClosing: windowLoader.sourceComponent = undefined

      imagePath: "qrc:///qt/qml/ddfr/res/dragon_64x64.png"
      message: qsTrId("id-done")
      visible: windowLoader.visible
      palette: appWindow.palette
    }
  }

  Component {
    id: closeFolderUnsavedWindow

    ConfirmWindow {
      onClosing: windowLoader.sourceComponent = undefined

      onYesPressed: {
        if ( appWindowStateGroup.state !== "initial" ) {
          appWindowStateGroup.state = "initial"
        }
      }

      confirmText: qsTrId("id-haveUnsavedChanges")
                   + "\n" + qsTrId("id-wantToProceed")
      visible: windowLoader.visible
      palette: appWindow.palette
    }
  }

  Component {
    id: openFolderUnsavedWindow

    ConfirmWindow {
      onClosing: windowLoader.sourceComponent = undefined

      onYesPressed: {
        fileDialog.open()
      }

      confirmText: qsTrId("id-haveUnsavedChanges")
                   + "\n" + qsTrId("id-wantToProceed")
      visible: windowLoader.visible
      palette: appWindow.palette
    }
  }

  Component {
    id: exitUnsavedWindow

    ConfirmWindow {
      onClosing: windowLoader.sourceComponent = undefined

      onYesPressed: {
        appWindowStateGroup.state = "unmodified"
        Qt.quit()
      }

      confirmText: qsTrId("id-haveUnsavedChanges")
                   + "\n" + qsTrId("id-wantToProceed")
      visible: windowLoader.visible
      palette: appWindow.palette
    }
  }

  Component {
    id: confirmRenameWindow

    ConfirmWindow {
      onClosing: windowLoader.sourceComponent = undefined

      onYesPressed: {
        FileListModel.applyRenaming()
        appWindowStateGroup.state = "unmodified"
      }

      confirmText: qsTrId("id-areYouSure")
      visible: windowLoader.visible
      palette: appWindow.palette
    }
  }

  Timer {
    id: statusBarHintTimer

    interval: 30000; repeat: true; onTriggered: changeFolderOpenedHint()
  }

  // NOTE: Unfortunately, FileDialog from QtQuick.Dialogs
  // had major interface changes in Qt6 and lost option
  // to select folder..
  // That option was moved into FolderDialog and into
  // experimental Qt.labs.platform package, which pulls
  // entire Qt Widgets in order to work.
  // That's why FileDialog is used to select any single file
  // from target directory. Then its directory is used.
  FileDialog {
    id: fileDialog

    onAccepted: {
      FileListModel.folder = currentFolder
      if ( appWindowStateGroup.state === "initial" ) {
        appWindowStateGroup.state = "folder-opened"
        appWindowStateGroup.state = "unmodified"
      }
      else {
        FileListModel.unloadFileList()
        FileListModel.loadFileList()
        appWindowStateGroup.state = "unmodified"
      }
    }
  }

  // Windows are not Items and don't have built-in states
  StateGroup {
    id: appWindowStateGroup

    states: [
      State {
        name: "initial"
        PropertyChanges {
          target: AppSingleton
          statusBarText: qsTrId("id-statusBar_openToStart")
        }
        StateChangeScript {
          script: {
            // Unwind stackView to initial view
            stackView.pop(null)
            FileListModel.unloadFileList()
            // Hints for this state
            statusBarHintTimer.stop()
          }
        }
      },
      State {
        name: "folder-opened"
        PropertyChanges {
          target: AppSingleton
          statusBarText: folderOpenedHints[currentFolderOpenedHint]
        }
        StateChangeScript {
          script: {
            stackView.push(fileListView)
            FileListModel.loadFileList()
            // Hints for this state
            currentFolderOpenedHint = 0
            statusBarHintTimer.restart()
          }
        }
      },
      State {
        name: "unmodified"
        PropertyChanges {
          target: AppSingleton
          statusBarText: folderOpenedHints[currentFolderOpenedHint]
        }
      },
      State {
        name: "modified"
        PropertyChanges {
          target: AppSingleton
          statusBarText: folderOpenedHints[currentFolderOpenedHint]
        }
      }
    ]
  }
}
