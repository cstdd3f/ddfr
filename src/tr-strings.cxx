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


// This file is a pure fake just to gather all translatable strings
// in one place and make ID-based QT translations work.
// Manage translation strings here and use them via ID in application

// lupdate isn't capable of reading a resource file, only source code.
// Hence, this file is a C++ source and it needs to be included in
// CMakeLists.txt to be parsed by translation tools.

// You need to pass -idbased option to lrelease for
// ID-based QT translations to work.
// Use qt_add_translations(... LRELEASE_OPTIONS -idbased ...)

#include <QtGlobal>

namespace ddfr {

// AppWindow

//% "File"
static constexpr const char* file = QT_TRID_NOOP("id-file");
//% "Open Files"
static constexpr const char* openFiles = QT_TRID_NOOP("id-openFiles");
//% "Close Files"
static constexpr const char* closeFiles = QT_TRID_NOOP("id-closeFiles");
//% "Exit"
static constexpr const char* exit = QT_TRID_NOOP("id-exit");
//% "Edit"
static constexpr const char* edit = QT_TRID_NOOP("id-edit");
//% "Settings"
static constexpr const char* settings = QT_TRID_NOOP("id-settings");
//% "Help"
static constexpr const char* help = QT_TRID_NOOP("id-help");
//% "About"
static constexpr const char* about = QT_TRID_NOOP("id-about");

// Status bar
//% "Select files to open or select a single file to open entire folder"
static constexpr const char* statusBar_openToStart = QT_TRID_NOOP("id-statusBar_openToStart");
//% "Drag and drop to move items"
static constexpr const char* statusBar_moveItems = QT_TRID_NOOP("id-statusBar_moveItems");
//% "You can use file name filters and choose prefix for files to rename"
static constexpr const char* statusBar_filtersPrefix = QT_TRID_NOOP("id-statusBar_filtersPrefix");
//% "You can change the start index of renaming sequence"
static constexpr const char* statusBar_startIndex = QT_TRID_NOOP("id-statusBar_startIndex");
//% "Use checkbox to customize new file name"
static constexpr const char* statusBar_customNames = QT_TRID_NOOP("id-statusBar_customNames");
//% "You can exclude items from renaming with X button"
static constexpr const char* statusBar_removeItems = QT_TRID_NOOP("id-statusBar_removeItems");

// SettingsWindow

//% "Language"
static constexpr const char* language = QT_TRID_NOOP("id-language");
//% "English"
static constexpr const char* language_english = QT_TRID_NOOP("id-language-english");
//% "Russian"
static constexpr const char* language_russian = QT_TRID_NOOP("id-language-russian");
//% "Theme"
static constexpr const char* theme = QT_TRID_NOOP("id-theme");
//% "May require application restart"
static constexpr const char* theme_desc = QT_TRID_NOOP("id-theme-desc");
//% "Light"
static constexpr const char* theme_light = QT_TRID_NOOP("id-theme-light");
//% "Dark"
static constexpr const char* theme_dark = QT_TRID_NOOP("id-theme-dark");
//% "Portable mode"
static constexpr const char* portableMode = QT_TRID_NOOP("id-portableMode");
//% "Run application in portable mode. In this mode settings are stored in application directory"
static constexpr const char* portableMode_desc = QT_TRID_NOOP("id-portableMode-desc");

// MessageWindow

//% "Close"
static constexpr const char* close = QT_TRID_NOOP("id-close");

// MessageWindow: texts

//% "Done!"
static constexpr const char* done = QT_TRID_NOOP("id-done");

// ConfirmationWindow

//% "Yes"
static constexpr const char* yes = QT_TRID_NOOP("id-yes");
//% "Cancel"
static constexpr const char* cancel = QT_TRID_NOOP("id-cancel");

// ConfirmationWindow: texts

//% "You have unsaved changes"
static constexpr const char* haveUnsavedChanges = QT_TRID_NOOP("id-haveUnsavedChanges");
//% "Do you want to proceed?"
static constexpr const char* wantToProceed = QT_TRID_NOOP("id-wantToProceed");
//% "Are you sure?"
static constexpr const char* areYouSure = QT_TRID_NOOP("id-areYouSure");

// InitialView

//% "No files are opened"
static constexpr const char* noFilesOpened = QT_TRID_NOOP("id-noFilesOpened");

// FileListView

//% "Filters"
static constexpr const char* filters = QT_TRID_NOOP("id-filters");
//% "Detect and remove old prefix"
static constexpr const char* filter_removeOldPrefix = QT_TRID_NOOP("id-filter_removeOldPrefix");
//% "Prefix"
static constexpr const char* prefix = QT_TRID_NOOP("id-prefix");
//% "Index"
static constexpr const char* index = QT_TRID_NOOP("id-index");
//% "Start from"
static constexpr const char* index_startFrom = QT_TRID_NOOP("id-index_startFrom");
//% "Rename"
static constexpr const char* rename = QT_TRID_NOOP("id-rename");


// FileListDelegate

//% "Folder"
static constexpr const char* folder = QT_TRID_NOOP("id-folder");
//% "Files"
static constexpr const char* files = QT_TRID_NOOP("id-files");
//% "Set custom name"
static constexpr const char* setCustomName = QT_TRID_NOOP("id-setCustomName");

} // ddfr
