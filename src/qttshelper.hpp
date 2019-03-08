#ifndef QTTSHELPER_HPP
#define QTTSHELPER_HPP

#include <QObject>
#include <QTextToSpeech>
#include <QQmlContext>
#include <QVector>

class QTTSHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY( QStringList locales READ locales NOTIFY localesChanged)
    Q_PROPERTY( QStringList voices READ voices NOTIFY voicesChanged)
public:
    QTTSHelper(QQmlContext* ctx, QObject* parent = nullptr):QObject(parent){
        ctx->setContextProperty("tts", &m_tts);
        ctx->setContextProperty("ttsHelper", this);
        qRegisterMetaType<QTextToSpeech::State>("TTSState");
    }

    QStringList locales(){
        QStringList lst;
        for (auto loc : m_tts.availableLocales()){
            lst.append(loc.name());
        }
        return lst;
    }
    QStringList voices(){
        QStringList lst;
        for (auto voice : m_tts.availableVoices()){
            lst.append(voice.name());
        }
        return lst;
    }
    Q_INVOKABLE void selectLocale(int idx){
        QVector<QLocale> lst = m_tts.availableLocales();
        if (idx >= lst.length() ) return;
        m_tts.setLocale( lst.at(idx));
        emit voicesChanged();
        selectVoice(0);
    }
    Q_INVOKABLE void selectVoice(int idx){
        QVector<QVoice> lst = m_tts.availableVoices();
        if (idx >= lst.length() ) return;
        m_tts.setVoice( lst.at(idx));
    }

signals :
    void voicesChanged();
    void localesChanged();


private:
    QTextToSpeech m_tts;
};

#endif // QTTSHELPER_HPP
