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

#include "AppSingleton.hxx"


namespace ddfr {

AppSingleton::AppSingleton( QObject* parent )
: QObject( parent )
{
}

QString AppSingleton::statusBarText() const
{
  return m_statusBarText;
}

QString AppSingleton::localPathFromUrl( const QUrl& url )
{
  return url.toLocalFile();
}

void AppSingleton::setStatusBarText( const QString& newStatusBarText )
{
  if ( m_statusBarText != newStatusBarText )
  {
    m_statusBarText = newStatusBarText;
    emit statusBarTextChanged( m_statusBarText );
  }
}

} // ddfr
