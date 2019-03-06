QT += quick multimedia location texttospeech sensors bluetooth
QT += qml quickcontrols2
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

# Define SOURCE_PATH to know where to get the template files to copy from
DEFINES += SOURCE_PATH=\\\"$$PWD\\\"

include(deps/SortFilterProxyModel/SortFilterProxyModel.pri)

APPVERSION = 0.0.1
DEFINES += \
    APPVERSION=\\\"$$APPVERSION\\\" \

SOURCES += \
        main.cpp \
    src/playgroundmanager.cpp \
    deps/qmlhighlighter/SyntaxHighlighter.cpp \
    deps/qmlhighlighter/QMLHighlighter.cpp
#    uploader.cpp

RESOURCES += qml.qrc \
    wav.qrc \
    showcase.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

OTHER_FILES += \
    $$files(playgrounds/*.qml, true)

HEADERS += \
    src/qttshelper.hpp \
    src/playgroundmanager.h \
    deps/miniz-cpp/zip_file.hpp \
    deps/qmlhighlighter/SyntaxHighlighter.h \
    deps/qmlhighlighter/QMLHighlighter.h \
    src/qclearablecacheqmlengine.hpp


DISTFILES += \
    deps/qmlhighlighter/dictionaries/qml.txt \
    deps/qmlhighlighter/dictionaries/properties.txt \
    deps/qmlhighlighter/dictionaries/keywords.txt \
    deps/qmlhighlighter/dictionaries/javascript.txt



