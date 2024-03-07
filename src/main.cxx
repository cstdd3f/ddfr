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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QThread>
#include <QQuickStyle>

int main( int argc, char *argv[] )
{
  QGuiApplication app(argc, argv);

  QCoreApplication::setOrganizationName("Mikhail Dryuchin <cstddef@gmail.com>"); // that's me :)
  QCoreApplication::setApplicationName("DragonDropFileRenamer");
  QCoreApplication::setApplicationVersion("1.0.3");
  QGuiApplication::setWindowIcon(QIcon(":/qt/qml/ddfr/res/dragon_64x64.png"));

  QThread::currentThread()->setObjectName("MainThread");

  // We will support only Fusion style
  QQuickStyle::setStyle("Fusion");

  QQmlApplicationEngine engine;

  // Exit application with error if engine will fail to load
  QObject::connect(
    &engine,
    &QQmlApplicationEngine::objectCreationFailed,
    &app,
    []() { QCoreApplication::exit(-1); },
    Qt::QueuedConnection
  );

  engine.loadFromModule("ddfr", "AppWindow");

  return app.exec();
}
