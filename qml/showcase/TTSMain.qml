import QtQuick 2.9
import QtQuick.Controls 2.2
import fr.ateam.tts 1.0
import QtQuick.Layouts 1.9
import "../../qml/component"

Pane {
    ColumnLayout{
        anchors.fill: parent
        TextField{
            id:textSource
            placeholderText:qsTr("input here the text to play")
            Layout.fillWidth: true
        }
        FAButton{
            label:qsTr("Text to speech")
            icon:"\uf0a1"
            onClicked: tts.say( textSource.text)
            Layout.fillWidth: true
        }
    }

    TTS{
        id:tts
    }

}
