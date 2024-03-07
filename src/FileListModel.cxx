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

#include "FileListModel.hxx"

#include <string>
#include <regex>


namespace ddfr {

FileListModel::FileListModel( QObject* parent )
: QAbstractListModel( parent )
, m_worker( &m_folderPath, &m_fileList )
{
  m_roleNames[static_cast<int>(RoleNames::OriginalFileName)] = "originalFileName";
  m_roleNames[static_cast<int>(RoleNames::NewFileName)] = "newFileName";

  // The key to understand this concept is as follows:
  // 1. Worker thread starts *Qt event loop*, we won't use QThread::run()
  // 2. This event loop will operate on a separate thread until it finishes
  // 3. Communication between threads is done via signals,
  //    slots and their connections

  m_workerThread.setObjectName( "FileListWorkerThread" );
  m_worker.moveToThread( &m_workerThread );
  connect(
    this, &FileListModel::loadFileList,
    &m_worker, &FileListWorker::loadFileList,
    Qt::QueuedConnection
  );
  connect(
    &m_worker, &FileListWorker::fileListLoaded,
    this, &FileListModel::finishLoadFileList,
    Qt::QueuedConnection
  );

  m_workerThread.start();
}

FileListModel::~FileListModel()
{
  m_workerThread.quit();
  m_workerThread.wait();
  // m_worker destroyed strictly after that point
}

const QUrl& FileListModel::folder() const
{
  return m_folder;
}

void FileListModel::setFolder( const QUrl& newFolder )
{
  if ( m_folder != newFolder )
  {
    m_folder = newFolder;
    m_folderPath.assign( m_folder.toLocalFile().toUtf8().toStdString() );
    emit folderChanged();
  }
}

const int FileListModel::numFiles() const
{
  return m_fileList.size();
}

QHash<int, QByteArray> FileListModel::roleNames() const
{
  return m_roleNames;
}

int FileListModel::rowCount( const QModelIndex& parent ) const
{
  return m_fileList.size();
}

QVariant FileListModel::data( const QModelIndex& index, int role ) const
{
  int row = index.row();

  // boundary check for the row
  if ( (row < 0) || (row >= m_fileList.size()) ) return QVariant();

  auto it = m_fileList.begin();
  std::advance(it, row);

  switch ( role )
  {
    case static_cast<int>(RoleNames::OriginalFileName):
      return (*it).originalFilePath.filename().string().c_str();

    case static_cast<int>(RoleNames::NewFileName):
      return (*it).newFilePath.filename().string().c_str();
  }

  return QVariant(); // An empty QVariant
}

bool FileListModel::move( int from, int to )
{
  // Allowed indices are within index range of existing items
  const auto fileListSize = m_fileList.size();
  if ( from < 0 || from > (fileListSize - 1) ) return false;
  if ( to < 0 || to > (fileListSize - 1) ) return false;
  if ( to == from ) return false; // beginMoveRows() won't allow this

  auto dummy = QModelIndex();

  if ( to < from )
  {
    emit beginMoveRows( dummy, from, from, dummy, to );
  }
  else // to > from
  {
    emit beginMoveRows( dummy, from, from, dummy, to + 1 );
  }

  // Simply swap items
  auto itFrom = m_fileList.begin();
  auto itTo = m_fileList.begin();
  std::advance( itFrom, from );
  std::advance( itTo, to );
  auto item = *itFrom;
  *itFrom = *itTo;
  *itTo = item;

  emit endMoveRows();
  return true;
}

void FileListModel::unloadFileList()
{
  const auto size = m_fileList.size();
  if ( size > 0 )
  {
    emit unloadFileListStarted();
    // We have a guarantee everyone finished their business before list is cleared
    emit beginRemoveRows( QModelIndex(), 0, size - 1 );
    m_fileList.clear();
    emit endRemoveRows();
    emit numFilesChanged();
  }
}

bool FileListModel::installFilter( const Filter filter )
{
  // NOTE: std::string fails when things like length()
  // are used, because they are unaware of UTF8.
  // For now we use std::wstring for lack of something better
  // in std library.
  // However, it's possible to use Qt for everything.

  switch ( filter )
  {
    case Filter::RemoveOldPrefixFilter:
      m_filtersMap.insert_or_assign(
        filter,
        []( Path& newFilePath, const size_t index, const size_t size )
        {
          auto filename = newFilePath.filename().wstring();
          // We use regex to strip out all digits, '.', '-' and space
          // from the beginning of a filename
          std::wregex regex( L"^[\\d\\s\\-\\.]+" );
          std::wsmatch match;

          if ( std::regex_search(filename, match, regex) )
          {
            // Safely assume a single match
            filename.erase( 0, match[0].length() );
            newFilePath.replace_filename( filename );
          }
        }
      );
      return true;
  }

  return false;
}

bool FileListModel::uninstallFilter( const Filter filter )
{
  auto erased = m_filtersMap.erase( filter );
  return erased == 1;
}

bool FileListModel::installPrefix( const Prefix prefix )
{
  // See note in installFilter()

  switch ( prefix )
  {
    case Prefix::PrefixType1:
      m_prefix = []( Path& newFilePath, const size_t index, const size_t size )
      {
        // +1 to index to start from 01
        auto index1 = index + 1;

        auto filename = newFilePath.filename().wstring();
        auto strIndex = std::to_wstring( index1 );
        auto numDigits = std::to_wstring(size).length();
        auto strLeadZeroes = std::wstring(
          numDigits - std::min(numDigits, strIndex.length()), '0'
        );
        auto strPrefix = strLeadZeroes + strIndex + L" - ";
        filename.insert(0, strPrefix);
        newFilePath.replace_filename( filename );
      };
      return true;

    case Prefix::PrefixType2:
      m_prefix = []( Path& newFilePath, const size_t index, const size_t size )
      {
        // +1 to index to start from 01
        auto index1 = index + 1;

        auto filename = newFilePath.filename().wstring();
        auto strIndex = std::to_wstring( index1 );
        auto numDigits = std::to_wstring(size).length();
        auto strLeadZeroes = std::wstring(
          numDigits - std::min(numDigits, strIndex.length()), '0'
        );
        auto strPrefix = strLeadZeroes + strIndex + L". ";
        filename.insert(0, strPrefix);
        newFilePath.replace_filename( filename );
      };
      return true;
  }

  return false;
}

void FileListModel::applyModifiers()
{
  // Considering newFilePath update a "radical change" in data
  // and using beginResetModel() instead of dataChanged()
  emit beginResetModel();

  // First, restore File.newFilePath from File.newFilePath
  for ( auto& file : m_fileList )
  {
    file.newFilePath = file.originalFilePath;
  }

  // Prepare data for lambdas
  size_t index = 0;
  size_t size = m_fileList.size();

  // Next, apply filters to newFilePath. Order shouldn't matter.
  for (
    auto fileIt = m_fileList.begin();
    fileIt != m_fileList.end();
    ++fileIt, ++index
  )
  {
    for ( auto& filter : m_filtersMap )
    {
      filter.second( (*fileIt).newFilePath, index, size );
    }
  }

  // Next, apply prefix
  index = 0;
  for (
    auto fileIt = m_fileList.begin();
    fileIt != m_fileList.end();
    ++fileIt, ++index
  )
  {
    if ( m_prefix ) m_prefix( (*fileIt).newFilePath, index, size );
  }

  emit endResetModel();
}

void FileListModel::applyRenaming()
{
  for ( const auto& file : m_fileList )
  {
    const auto origName = file.originalFilePath.filename().string();
    const auto newName = file.newFilePath.filename().string();
    auto isChangedName = origName != newName;

    if ( isChangedName )
    {
      std::filesystem::rename( file.originalFilePath, file.newFilePath );
    }
  }
  emit filesRenamed();
}

void FileListModel::finishLoadFileList( const bool ok )
{
  if ( ok )
  {
    emit beginInsertRows( QModelIndex(), 0, m_fileList.size() - 1 );
    // Well, worker already inserted everything
    emit endInsertRows();
    emit numFilesChanged();
  }
  emit fileListLoaded( ok );
}

// FileListWorker

FileListWorker::FileListWorker(std::filesystem::path* folderPath, FileList* fileList)
: m_folderPath( folderPath )
, m_fileList( fileList )
{
}

void FileListWorker::loadFileList()
{
  using namespace std::filesystem;

  for ( auto const& dirEntry : directory_iterator(*m_folderPath) )
  {
    File file;
    file.originalFilePath = dirEntry.path();
    file.newFilePath = dirEntry.path();

    m_fileList->push_back( file );
  }
  emit fileListLoaded( true );
}

} // ddfr
