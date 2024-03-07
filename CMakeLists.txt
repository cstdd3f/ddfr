cmake_minimum_required(VERSION 3.16)

project(
  ddfr
  VERSION 1.0.3
  LANGUAGES CXX
)

# Require specific minimum C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Load Qt6 packages for CMake
find_package( Qt6 6.5
  COMPONENTS
    Gui Quick QuickControls2 LinguistTools
  REQUIRED
)

# Directories
set(src_dir "src")
set(ts_dir  "translations")
set(res_dir "res")

## Set up QML project
qt_standard_project_setup(REQUIRES 6.5)
qt_add_executable( ${PROJECT_NAME}
  ${src_dir}/main.cxx
  ${src_dir}/tr-strings.cxx
  ${res_dir}/ddfr.rc
)
# qt_add_qml_module() applied on executable target compiles QML
# and resources right into this executable
qt_add_qml_module( ${PROJECT_NAME}
  URI ${PROJECT_NAME}
  VERSION 1.0
  QML_FILES
    ${src_dir}/AppWindow.qml
    ${src_dir}/FileListView.qml
    ${src_dir}/FileListDelegate.qml
    ${src_dir}/SettingsWindow.qml
    ${src_dir}/BoolSetting.qml
    ${src_dir}/ListSetting.qml
    ${src_dir}/MessageWindow.qml
    ${src_dir}/ConfirmWindow.qml
    ${src_dir}/DarkPalette.qml
    ${src_dir}/LightPalette.qml
  SOURCES
    ${src_dir}/AppSettings.hxx
    ${src_dir}/AppSettings.cxx
    ${src_dir}/AppSingleton.hxx
    ${src_dir}/AppSingleton.cxx
    ${src_dir}/FileListModel.hxx
    ${src_dir}/FileListModel.cxx
  RESOURCES
    ${res_dir}/dragon_64x64.png
)

target_include_directories( ${PROJECT_NAME}
  PUBLIC ${src_dir}
)

set_target_properties( ${PROJECT_NAME}
  PROPERTIES
    OUTPUT_NAME ${PROJECT_NAME}
)
if(WIN32)
  set_target_properties( ${PROJECT_NAME}
    PROPERTIES
      WIN32_EXECUTABLE true
  )
endif()

target_link_libraries( ${PROJECT_NAME}
  PRIVATE
    Qt::Gui
    Qt::Quick
    Qt::QuickControls2
)

## Translations
set(ts_files
  ${ts_dir}/lang_en_US.ts
  ${ts_dir}/lang_ru_RU.ts
)
# Put translations into subdir
set_source_files_properties(
  ${ts_files}
  PROPERTIES
    OUTPUT_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/${ts_dir}"
)
qt_add_translations( ${PROJECT_NAME}
  TS_FILES ${ts_files}
  QM_FILES_OUTPUT_VARIABLE qm_files
  LUPDATE_OPTIONS
    -no-obsolete # Removes 'vanished' and other obsolete entries
  LRELEASE_OPTIONS
    -idbased # Required for ID-based translation functions
)
# Add translations targets to 'all' targets,
# so they always execute together
add_custom_target( addTsToAll
  ALL
  DEPENDS
    update_translations
    release_translations
)

## Installing
install(TARGETS ${PROJECT_NAME}
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
install(FILES ${qm_files} DESTINATION "bin/${ts_dir}")
