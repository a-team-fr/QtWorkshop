#ifndef QTTSHELPER_HPP
#define QTTSHELPER_HPP

#include <QObject>
#include <QTextToSpeech>

class QTTSHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool ttsReady READ isReady NOTIFY isSpeakingChanged)

signals:
    void isSpeakingChanged();
public slots:
    void say(const QString& text){
        m_tts.say(text);
        emit isSpeakingChanged();
    }
    void stopTTS(){
        m_tts.stop();
        emit isSpeakingChanged();
    }
    bool isReady(){
        return m_tts.state() == QTextToSpeech::Ready;
    }
private:
    QTextToSpeech m_tts;
};

#endif // QTTSHELPER_HPP
