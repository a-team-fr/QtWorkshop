#include "playgroundmanager.h"
#include "../deps/miniz-cpp/zip_file.hpp"
#include <QDir>
#include <QDebug>
#include <QImage>

PlaygroundManager::PlaygroundManager(QObject *parent) : QObject(parent)
{
    connect(&m_nam, &QNetworkAccessManager::networkAccessibleChanged, this, &PlaygroundManager::networkAccessibleChanged);

}

void PlaygroundManager::writeDocument(QUrl documentUrl, const QString & newText)
{
    QFile file( documentUrl.toLocalFile() );
    //QFile file( documentUrl.path() );;
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
              return;
    file.write(newText.toLatin1());
}

bool PlaygroundManager::savePhotoAsProfile(QString photoPath)
{
    QImage img;
    img.load(photoPath);
    img.convertToFormat( QImage::Format_RGB32 ).save(localPlaygroundRootPath.toLocalFile()+playgroundName+QDir::separator()+"profile.png","PNG");
    //img.convertToFormat( QImage::Format_RGB32 ).save(localPlaygroundRootPath.path()+playgroundName+QDir::separator()+"profile.png","PNG");
    return true;
}

QString PlaygroundManager::readDocument(QUrl documentUrl)
{
    QFile file( documentUrl.toLocalFile() );
    //QFile file( documentUrl.path() );
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
              return QString();
    return file.readAll();
}

bool PlaygroundManager::triggerDownload(const QUrl &url, const QString &localfilePath)
{
    DownloadJob* dlw = new DownloadJob(url, localfilePath);

    QNetworkRequest request(url);
    QNetworkReply* reply = m_nam.get(request);

    connect(reply, &QNetworkReply::finished, dlw, &DownloadJob::processReply);
    connect(dlw, &DownloadJob::finish, this, &PlaygroundManager::downloadCompleted);
    connect(dlw, &DownloadJob::finish, this, &PlaygroundManager::triggerUnzip);

    return true;

}



bool PlaygroundManager::triggerUpload(const QString &localfilePath, QUrl url)
{
    UploadJob* up = new UploadJob( localfilePath, url);

    url.setScheme("ftp");
    url.setHost("ftp.a-team.fr");
    url.setUserName("qtworkshop@a-team.fr");
    url.setPassword("W0rksh0pQt");
    url.setPort(21);

    QNetworkRequest request(url);
    if (up->isOpen())
    {
        QNetworkReply* reply = m_nam.put(request, up->data() );

        connect(reply, &QNetworkReply::finished, up, &UploadJob::uploadFinished);
        connect(up, &UploadJob::finish, this, &PlaygroundManager::uploadCompleted);
        connect(reply, &QNetworkReply::uploadProgress, up, &UploadJob::uploadProgress);
        connect(up, &UploadJob::progressed, this, &PlaygroundManager::jobProgress);

    }
    else {
        qDebug() << QString("Could not opened %1").arg(localfilePath);
        up->deleteLater();
    }
    return true;

}

bool PlaygroundManager::copyDirectory(const QString& src, const QString& dst, bool overwrite)
{
    QDir dir(src);
    if (! dir.exists()) {
        qDebug() << "error : template directory does not exist at " << src;
        return false;
    }


    //create directories exist
    dir.mkpath(dst);
    foreach (QString d, dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
        QString dst_path = dst + QDir::separator() + d;
        if ( !dir.mkpath(dst_path)) {
            qDebug() << "error creating directory " << dst_path;
            return false;
        }
        if ( !copyDirectory(src+ QDir::separator() + d, dst_path , overwrite) ) return false;
    }

    //then create all files
    foreach (QString f, dir.entryList(QDir::Files)) {
        QString dstFile = QString(dst + QDir::separator() + f);
        QString srcFile = QString(src + QDir::separator() + f);
        if (overwrite) QFile::remove( dstFile );
        if ( !QFile::copy( srcFile , dstFile) ) {
            qDebug() << "error copying file from " << srcFile << " to " << dstFile;
            return false;
        }
    }
    return true;

}
bool PlaygroundManager::createPlayground()
{
    QString playgroundFullPath = localPlaygroundRootPath.toLocalFile() + playgroundName;
    //QString playgroundFullPath = localPlaygroundRootPath.path() + playgroundName;

    if ( ! QDir(playgroundFullPath).removeRecursively() ){
        qDebug() << "error removing existing local playground";
        return false;
    }

    if (! copyDirectory( templatePath.toLocalFile(), playgroundFullPath) )
    //if (! copyDirectory( templatePath.path(), playgroundFullPath) )
    {
        qDebug() << "error copying template directory copy as a new playground";
        return false;
    }

    return uploadPlayground();
}

bool PlaygroundManager::uploadPlayground()
{
    QString playgroundFullPath = localPlaygroundRootPath.toLocalFile() + playgroundName;
    //QString playgroundFullPath = localPlaygroundRootPath.path() + playgroundName;
    QDir dir(playgroundFullPath);
    if (! dir.exists()) {
        qDebug() << "error : playground does not exist at " << playgroundFullPath;
        return false;
    }

    //Zip directory - overwriting in local playground root
    QString localTarball = localPlaygroundRootPath.toLocalFile() + playgroundName + ".zip";
    //QString localTarball = localPlaygroundRootPath.path() + playgroundName + ".zip";
    if (QFile::exists(localTarball))
        QFile::remove( localTarball );
    createArchive( playgroundFullPath, localTarball);

    //Upload zip - overwritting in remote playground root
    triggerUpload( localTarball, playgroundName + ".zip" );
    return true;
}


bool addDirectoryContentToArchive(miniz_cpp::zip_file& arc, QDir dir, QString parentPrefix){
    foreach (QString d, dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot))
        addDirectoryContentToArchive(arc, dir.path()+QDir::separator()+d, parentPrefix.isEmpty() ?  d : parentPrefix+QDir::separator()+d);

    foreach (QString f, dir.entryList(QDir::Files)) {
        QFile file( dir.path()+QDir::separator()+f);
        if (!file.open(QIODevice::ReadOnly ))
              continue;

        QString arcName = parentPrefix.isEmpty() ? f : parentPrefix+QDir::separator()+f;
        arc.writestr(  arcName.toStdString(), file.readAll().toStdString() );
        file.close();
    }

    return true;
}

bool PlaygroundManager::triggerUnzip(const QString &localfilePath)
{    
    qDebug() << "received:" << localfilePath << " -> start unzipping";

    miniz_cpp::zip_file zip(localfilePath.toStdString() );
    QString fileName = QUrl(localfilePath).fileName().split('.')[0];
    QString outPath(localPlaygroundRootPath.toLocalFile()+fileName+QDir::separator());
    //QString outPath(localPlaygroundRootPath.path()+fileName+QDir::separator());
    QDir(outPath).mkpath(outPath);
    zip.extractall( outPath.toStdString());
    return true;
}

bool PlaygroundManager::createArchive(QString srcDirectoryPath, QString dstArchivePath)
{
    //Ensure existence of playground
    QDir dir(srcDirectoryPath);
    if (! dir.exists()) {
        qDebug() << "Directory to archive does not exists here:" << srcDirectoryPath;
        return false;
    }
    //remove possible existing archive
    QFile::remove( dstArchivePath );

    //create new archive
    miniz_cpp::zip_file arc;
    addDirectoryContentToArchive( arc, dir, "");
    arc.save( dstArchivePath.toStdString() );

    return true;

}


UploadJob::UploadJob(const QString &localfilePath, const QUrl &url, QObject* parent):QObject(parent), m_url(url), m_localFile(localfilePath)
{

    m_isOpen = m_localFile.open(QIODevice::ReadOnly);
    QFileInfo inf (localfilePath);
    qDebug() << inf.size();
    qDebug() << inf.exists();
    if (!m_isOpen){
        QString error;
        if ( !m_localFile.exists() )
        {
            error = tr("File %1 does not exist").arg( localfilePath);
            emit failed( error);
            qDebug() << error;
        }
        else {
            error = tr("File %1 size is %2 exist").arg( localfilePath).arg(m_localFile.size());
               qDebug() <<error;
        }
    }

}

UploadJob::~UploadJob()
{
    if (m_isOpen)
        m_localFile.close();

}

void UploadJob::uploadFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply && reply->error() == QNetworkReply::NoError)
    {
        emit finish( m_localFile.fileName() );
        qDebug() << tr("Success uploading %1").arg( m_localFile.fileName() );
    }
    else {
        emit failed( tr("ERROR uploading file %1 with error :%2").arg( m_localFile.fileName()).arg(reply->errorString()) );
        qDebug() << reply->errorString();
    }

    reply->deleteLater();

    deleteLater();

}

void UploadJob::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    if (bytesTotal==0 ) return;
    emit progressed( m_localFile.fileName(), 100 * bytesSent / bytesTotal);
    qDebug() << QString("Sending %1 : %2 / %3").arg(m_localFile.fileName()).arg(bytesSent).arg(bytesTotal);

}


DownloadJob::DownloadJob(const QUrl &url, const QString &localfilePath):m_url(url), m_localFilePath(localfilePath)
{
    QFileInfo fileinfo( m_localFilePath );
    QDir dir( fileinfo.path() );

    //ensure directory exists
    if (!dir.exists())
    {
        dir.mkpath( fileinfo.path() );
        qDebug()<< "create directory:" << fileinfo.path();
    }
}

void DownloadJob::processReply()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply && reply->error() == QNetworkReply::NoError)
    {
        if (reply->bytesAvailable() > 0)
        {
            int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            if( httpStatusCode == 200 ) {
                QFile file( m_localFilePath);
                if ( !file.open(QIODevice::WriteOnly ) )
                    emit failed( tr("File error : cannot open file %1").arg(m_localFilePath) );
                if ( file.write( reply->readAll() ) == -1)
                    emit failed( tr("File error : cannot write file %1").arg(m_localFilePath) );
                emit finish( m_localFilePath );
                file.deleteLater();
            } else emit failed( tr("download error %1").arg(httpStatusCode) );
        }
    } else emit failed( tr("ERROR loading image %1 with error :%2").arg(m_localFilePath).arg(reply->errorString()) );

    reply->deleteLater();

    deleteLater();

}
