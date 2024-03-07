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

#ifndef DRAGONDROPFILERENAMER_DDFR_APPSINGLETON_HXX
#define DRAGONDROPFILERENAMER_DDFR_APPSINGLETON_HXX

#include <QObject>
#include <QQmlEngine>

namespace ddfr {

// QML-side singletons cumbersome for this project
// as they require providing (and proper managing of) qmldir file
// which breaks qmldir autogeneration.
// For this reason singleton fuctionality is provided from C++ into QML.
class AppSingleton : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    // Status bar text
    Q_PROPERTY( QString statusBarText
      READ statusBarText
      WRITE setStatusBarText
      NOTIFY statusBarTextChanged
    )

  public:
    explicit AppSingleton( QObject* parent = nullptr );

    QString statusBarText() const;

  public slots:
    static QString localPathFromUrl( const QUrl& url );
    void setStatusBarText( const QString& newStatusBarText );

  signals:
    void statusBarTextChanged( const QString& newStatusBarText );

  private:
    QString m_statusBarText;
};

} // ddfr

#endif  // DRAGONDROPFILERENAMER_DDFR_APPSINGLETON_HXX
