#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "src/qttshelper.hpp"
#include "src/playgroundmanager.h"
#include "src/qclearablecacheqmlengine.hpp"
#include "./deps/qmlhighlighter/SyntaxHighlighter.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("A-Team");
    app.setOrganizationDomain("a-team.fr");
    app.setApplicationName("QtWorkshop");

    //qmlRegisterType<QTTSHelper>("fr.ateam.tts", 1, 0, "TTS");
    QClearableCacheQmlEngine engine;
    PlaygroundManager playgroundManager;
    qmlRegisterType<SyntaxHighlighter>("SyntaxHighlighter", 1, 1, "SyntaxHighlighter"); //
    engine.rootContext()->setContextProperty("qmlEngine", &engine);
//    QTextToSpeech tts;
//    engine.rootContext()->setContextProperty("tts", &tts);
    QTTSHelper tts( engine.rootContext() );
    engine.rootContext()->setContextProperty("playgroundManager", &playgroundManager);
    engine.rootContext()->setContextProperty("sourcePath", QString(SOURCE_PATH)); //QMake defined
    engine.rootContext()->setContextProperty("showCaseMode", true);     //showCaseMode is used for publish to store (without menu)
    qmlRegisterSingletonType( QUrl("qrc:/qml/NavigationSingleton.qml"),"fr.ateam.qtworkshop", 1, 0,"NavMan");

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
