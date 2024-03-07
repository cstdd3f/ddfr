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

#ifndef DRAGONDROPFILERENAMER_DDFR_APPSETTINGS_HXX
#define DRAGONDROPFILERENAMER_DDFR_APPSETTINGS_HXX

#include <QObject>
#include <QQmlEngine>
#include <QSettings>
#include <QTranslator>


namespace ddfr {

// Applications settings class
// Handles loading and saving settings from/to a file
class AppSettings : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    // Application language
    Q_PROPERTY( Language language
      READ language
      WRITE setLanguage
      NOTIFY languageChanged
    )

    // Application theme
    Q_PROPERTY( Theme theme
      READ theme
      WRITE setTheme
      NOTIFY themeChanged
    )

    // Switch to portable mode
    Q_PROPERTY( bool portableMode
      READ portableMode
      WRITE setPortableMode
      NOTIFY portableModeChanged
    )

  public: // Public declarations
    // Application languages supported
    enum class Language { English, Russian };
    Q_ENUM(Language)
    static constexpr const char* languageString( const Language language )
    {
      switch (language)
      {
        case Language::English: return "English";
        case Language::Russian: return "Russian";
        default: return "English";
      }
    }

    // Application themes supported
    enum class Theme { Light, Dark };
    Q_ENUM(Theme)
    static constexpr const char* themeString( const Theme theme )
    {
      switch (theme)
      {
        case Theme::Light: return "Light";
        case Theme::Dark: return "Dark";
        default: return "Dark";
      }
    }

    // File names
    static constexpr const char* settingsFileName = "settings.ini";
    static constexpr const char* portableFlagFileName = "portable";

  public: // Class interface
    explicit AppSettings( QObject *parent = nullptr );

    Language language() const;
    Theme theme() const;
    bool portableMode() const;

  public slots:
    void setLanguage( const Language newLanguage );
    void setTheme( const Theme newTheme );
    void setPortableMode( const bool newPortableMode );

    // Load settings from file
    void load();

    // Save settings to file
    void save();

    // Loads translation
    void loadTranslation();

  signals:
    void objectCreated() const;
    void languageChanged( const Language newLanguage );
    void themeChanged( const Theme newKeepUserSettings );
    void portableModeChanged( const bool newPortableMode );

  private: // Members
    // Settings
    Language m_language = Language::English;
    Theme m_theme = Theme::Dark;
    bool m_keepSession = false;
    bool m_portableMode = false;

    // Strings for querying INI file.
    // These are settings groups with keys under them
    static constexpr const char* groupSettings = "Settings";
      static constexpr const char* keyLanguage = "Language";
      static constexpr const char* keyTheme = "Theme";
      static constexpr const char* keyPortableMode = "PortableMode";

    QSettings* m_qSettings = nullptr;
    QTranslator m_translator;

    bool m_isFirstLaunch = true;
    bool m_settingsChanged = false;

  private: // Functions
    void handleFirstLaunch();
    void switchPortableMode();
};

} // ddfr

#endif  // DRAGONDROPFILERENAMER_DDFR_APPSETTINGS_HXX
