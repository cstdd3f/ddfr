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

#ifndef DRAGONDROPFILERENAMER_DDFR_FILELISTMODEL_HXX
#define DRAGONDROPFILERENAMER_DDFR_FILELISTMODEL_HXX

#include <list>
#include <map>
#include <filesystem>

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include <QThread>


namespace ddfr {

// A music file descriptor
struct File {
  std::filesystem::path originalFilePath;
  std::filesystem::path newFilePath;
};

using FileList = std::list<File>;

class FileListWorker : public QObject
{
  Q_OBJECT

  public:
    explicit FileListWorker( std::filesystem::path* folderPath, FileList* fileList );

  public slots:
    void loadFileList();

  signals:
    void fileListLoaded( const bool ok ) const;

  private:
    std::filesystem::path* m_folderPath;
    FileList* m_fileList;
};

class FileListModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    // QAbstractItemModel interface
    Q_PROPERTY( QUrl folder
      READ folder
      WRITE setFolder
      NOTIFY folderChanged
    )

    // Number of files in this model
    Q_PROPERTY( int numFiles
      READ numFiles
      NOTIFY numFilesChanged
    )

  public:
    enum class RoleNames {
      OriginalFileName = Qt::UserRole,
      NewFileName
    };
    Q_ENUM( RoleNames )

    enum class Filter {
      RemoveOldPrefixFilter
    };
    Q_ENUM( Filter )

    enum class Prefix {
      PrefixType1,
      PrefixType2
    };
    Q_ENUM( Prefix )

  public:
    explicit FileListModel( QObject *parent = nullptr );
    ~FileListModel();

    const QUrl& folder() const;
    void setFolder( const QUrl& newFolder );
    const int numFiles() const;

  public: // QAbstractItemModel interface
    virtual QHash<int, QByteArray> roleNames() const override;
    virtual int rowCount( const QModelIndex &parent ) const override;
    virtual QVariant data( const QModelIndex &index, int role ) const override;

  public slots:
    bool move( int from, int to );
    void unloadFileList();
    bool installFilter( const Filter filter );
    bool uninstallFilter( const Filter filter );
    bool installPrefix( const Prefix prefix );
    void applyModifiers();
    void applyRenaming();

  signals:
    void loadFileList() const;
    void unloadFileListStarted() const;
    void fileListLoaded( const bool ok ) const;
    void folderChanged() const;
    void numFilesChanged() const;
    void filesRenamed() const;

  private: // QAbstractItemModel implementation members
    QHash<int, QByteArray> m_roleNames;

  private: // Private types
    using Path = std::filesystem::path;
    using ModifierType = void(*)( Path& newFilePath, const size_t index, const size_t size );

  private: // Logic implementation members
    QUrl m_folder;
    std::filesystem::path m_folderPath;
    FileList m_fileList;
    std::map<Filter, ModifierType> m_filtersMap;
    ModifierType m_prefix = nullptr;
    FileListWorker m_worker;
    QThread m_workerThread;

  private:
    void finishLoadFileList( const bool ok );    
};

} // ddfr

#endif  // DRAGONDROPFILERENAMER_DDFR_FILELISTMODEL_HXX
