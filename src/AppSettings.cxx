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

#include "AppSettings.hxx"

#include <QCoreApplication>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>


namespace ddfr {

AppSettings::AppSettings( QObject* parent )
: QObject( parent )
, m_translator( this )
{
  load();

  { // Making proper connections
    connect(
      this, &AppSettings::objectCreated,
      this, &AppSettings::handleFirstLaunch,
      Qt::QueuedConnection
    );
    // Dynamically switch app language.
    // Every translation will change via bindings
    connect(
      this, &AppSettings::languageChanged,
      this, &AppSettings::loadTranslation,
      Qt::QueuedConnection
    );
    // Switching of portable mode is special
    connect(
      this, &AppSettings::portableModeChanged,
      this, &AppSettings::switchPortableMode,
      Qt::DirectConnection
    );
  }

  emit objectCreated();
}

AppSettings::Language AppSettings::language() const
{
  return m_language;
}

AppSettings::Theme AppSettings::theme() const
{
  return m_theme;
}

bool AppSettings::portableMode() const
{
  return m_portableMode;
}

void AppSettings::setLanguage( const Language newLanguage )
{
  if ( m_language != newLanguage )
  {
    m_language = newLanguage;
    m_settingsChanged = true;
    emit languageChanged( m_language );
  }
}

void AppSettings::setTheme( const Theme newTheme )
{
  if ( m_theme != newTheme )
  {
    m_theme = newTheme;
    m_settingsChanged = true;
    emit themeChanged( m_theme );
  }
}

void AppSettings::setPortableMode( const bool newPortableMode )
{
  if ( m_portableMode != newPortableMode )
  {
    m_portableMode = newPortableMode;
    m_settingsChanged = true;
    emit portableModeChanged( m_keepSession );
  }
}

void AppSettings::load()
{
  // First, determine, if we are running in portable mode
  QDir appDir( QCoreApplication::applicationDirPath() );
  m_portableMode = QFile::exists( appDir.filePath(portableFlagFileName) );

  // Then determine settings file dir
  QDir settingsDir;
  if ( m_portableMode )
  { // Settings are inside application dir
    settingsDir.setPath( appDir.path() );
  }
  else
  { // Settings are inside user application dir
    auto appDataDir =
      QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );
    settingsDir.setPath( appDataDir );
  }

  // First app launch determined by absence of settings file.
  // It's not very accurate criteria, but should work for the moment.
  m_isFirstLaunch = !QFile::exists( settingsDir.filePath(settingsFileName) );

  // Now create m_qSettings. We use this object as parent.
  m_qSettings = new QSettings(
    settingsDir.filePath( settingsFileName ), QSettings::IniFormat, this
  );

  // Finally, load actual values while giving default values
  m_qSettings->beginGroup(groupSettings);
  QString strTmp;
  // m_language
  strTmp = m_qSettings->value(keyLanguage, languageString(Language::English)).toString();
  if (strTmp == languageString(Language::English)) m_language = Language::English;
  else if (strTmp == languageString(Language::Russian)) m_language = Language::Russian;
  else
  {
    qWarning() << "Unknown '" << keyLanguage << "': " << strTmp << "; "
      << "defaulting to " << languageString(Language::English);
    m_language = Language::English;
  }
  // m_theme
  strTmp = m_qSettings->value(keyTheme, themeString(Theme::Dark)).toString();
  if (strTmp == themeString(Theme::Light)) m_theme = Theme::Light;
  else if (strTmp == themeString(Theme::Dark)) m_theme = Theme::Dark;
  else
  {
    qWarning() << "Unknown '" << keyTheme << "': " << strTmp << "; "
      << "defaulting to " << themeString(Theme::Dark);
    m_theme = Theme::Dark;
  }
  // m_portableMode already loaded
  m_qSettings->endGroup();
}

void AppSettings::save()
{
  if ( m_settingsChanged )
  {
    m_qSettings->beginGroup(groupSettings);
    m_qSettings->setValue(keyLanguage, languageString(m_language));
    m_qSettings->setValue(keyTheme, themeString(m_theme));
    // We don't save m_portableMode, this is handled in switchPortableMode()
    m_qSettings->endGroup();
    m_qSettings->sync();

    // After saving settings are unchanged
    m_settingsChanged = false;
  }
}

void AppSettings::loadTranslation()
{
  QString baseName = "lang_";

  switch (m_language)
  {
    case Language::English:
      // For now we just use "Engeneering English" of
      // Qt ID-based translation system and don't load anything
      baseName += "en_US";
      break;

    case Language::Russian:
      baseName += "ru_RU";
      break;

    default:
      qCritical() << "Unknown language, translations won't load!";
      return;
  }

  if ( !m_translator.isEmpty() )
  {
    QCoreApplication::removeTranslator(&m_translator);
  }
  bool ok = m_translator.load(baseName, "translations");
  if ( !ok )
  {
    qCritical() << "Failed to load translation: " << baseName;
    return;
  }
  ok = QCoreApplication::installTranslator(&m_translator);
  if ( !ok )
  {
    qCritical() << "Failed to install translation: " << baseName;
    return;
  }
  // By this moment context is usually available, so function won't fail
  qmlEngine(this)->retranslate();
}

void AppSettings::handleFirstLaunch()
{
  if ( m_isFirstLaunch )
  {
    m_settingsChanged = true;
    save();
  }
}

void AppSettings::switchPortableMode()
{
  // Unbind from parent and delete m_qSettings
  m_qSettings->setParent(nullptr);
  delete m_qSettings;

  QDir appDir( QCoreApplication::applicationDirPath() );
  QFile portableFlagFile( appDir.filePath(portableFlagFileName) );
  QDir settingsDir;
  bool ok;

  if ( m_portableMode )
  {
    // We need to create the portable mode flag file in the application dir and
    // switch m_qSettings to this dir
    ok = portableFlagFile.open(QIODevice::WriteOnly);
    if ( !ok )
    {
      qWarning() << "Couldn't create '" << portableFlagFileName
        << "' file in application directory! Check access rights.";
    }

    settingsDir.setPath( appDir.path() );
  }
  else
  {
    // We need to delete the portable mode flag file in the application dir and
    // switch m_qSettings to user dir
    if ( portableFlagFile.exists() )
    {
      ok = portableFlagFile.remove();
      if ( !ok )
      {
        qWarning() << "Couldn't remove '" << portableFlagFileName
          << "' file from application directory! Check access rights.";
      }
    }

    auto appDataDir =
      QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );
    settingsDir.setPath( appDataDir );
  }

  // Create new m_qSettings
  m_qSettings = new QSettings(
    settingsDir.filePath( settingsFileName ), QSettings::IniFormat, this
  );
}

}  // ddfr
