#ifndef UPLOADER_H
#define UPLOADER_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QFile>

class DownloadJob : public QObject
{
    Q_OBJECT
public:
    DownloadJob(const QUrl& url, const QString& localfilePath );
public slots:
    void processReply();
signals :
    void finish(const QString& localFilePath);
    void failed(QString);

private:
    QUrl m_url;
    QString m_localFilePath;
};

class UploadJob : public QObject
{
    Q_OBJECT
public:
    UploadJob(const QString& localfilePath , const QUrl& url, QObject* parent = nullptr);
    ~UploadJob();
    bool isOpen(){ return m_isOpen;}

public slots:
    void uploadFinished();
    QIODevice* data(){ return &m_localFile;}
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);

signals :
    void finish(const QString& localFilePath);
    void failed(QString);
    void progressed( const QString& localfilePath, qint64 percProgress);

private:
    QUrl m_url;
    QFile m_localFile;
    bool m_isOpen = false;
};

class PlaygroundManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl templatePath MEMBER templatePath)
    Q_PROPERTY(QUrl localPlaygroundRootPath MEMBER localPlaygroundRootPath)
    Q_PROPERTY(QUrl remotePlaygroundRootPath MEMBER remotePlaygroundRootPath)
    Q_PROPERTY(QString playgroundName MEMBER playgroundName)
public:
    explicit PlaygroundManager(QObject *parent = nullptr);
    bool networkAccessible(){
        return m_nam.networkAccessible() == QNetworkAccessManager::Accessible;}

    Q_INVOKABLE QString readDocument(QUrl documentUrl);
    Q_INVOKABLE void writeDocument(QUrl documentUrl, const QString&);

    Q_INVOKABLE QString urlToFileName(QUrl url){
        return url.fileName();
    }
    Q_INVOKABLE QString urlToFilePath(QUrl url){
        return url.toLocalFile();
        //return url.path();
    }
    Q_INVOKABLE QUrl filePathToUrl(QString filePath){

        return QUrl::fromLocalFile(filePath);
    }
    Q_INVOKABLE bool savePhotoAsProfile(QString photoPath);

    static bool copyDirectory(const QString& src, const QString& dest, bool overwrite = false);

public slots:
    bool triggerUpload( const QString& localfilePath , QUrl url);
    bool triggerDownload(const QUrl& url, const QString& localfilePath );
    bool triggerUnzip(const QString& localfilePath );
    bool createPlayground();
    bool uploadPlayground();

signals:
    void uploadCompleted(const QString& localfilePath);
    void downloadCompleted(const QString& localfilePath);
    void jobProgress(const QString& localfilePath, qint64 percProgress);
    void networkAccessibleChanged();
private:
    bool createArchive(QString srcDirectoryPath, QString dstArchivePath);
    QNetworkAccessManager m_nam;
    std::vector<UploadJob*> m_lstJob;

    QUrl templatePath = QString();
    QUrl localPlaygroundRootPath = QString();
    QUrl remotePlaygroundRootPath = QString();
    QString playgroundName = QString();
};

#endif // UPLOADER_H
