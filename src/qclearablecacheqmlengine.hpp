#ifndef QCLEARABLECACHEQMLENGINE_HPP
#define QCLEARABLECACHEQMLENGINE_HPP

#include <QQmlApplicationEngine>

class QClearableCacheQmlEngine : public QQmlApplicationEngine
{
    Q_OBJECT
public:


    Q_INVOKABLE void clearCache(){
        clearComponentCache();
    }

};

#endif // QCLEARABLECACHEQMLENGINE_HPP
