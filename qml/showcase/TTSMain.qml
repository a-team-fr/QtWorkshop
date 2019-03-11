import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
//import fr.ateam.tts 1.0
import "../../qml/component"

Pane {

    ColumnLayout{
        anchors.fill: parent
        TextArea{
            id:textSource
            text:"Fai parte dell'innovazione del mondo Qt e incontra tutti i protagonisti del settore. QtDay ti offre l'opportunit? di costruire la rete giusta."
            placeholderText:qsTr("input here the text to play")
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        RowLayout{
            Layout.fillWidth: true
            GroupBox{
                title: qsTr("Rate")
                Slider{
                    from:-1;to:1
                    onPositionChanged: tts.rate=position
                }


            }
            GroupBox{
                title: qsTr("Pitch")
                Layout.alignment: Qt.AlignRight
                Slider{
                    from:-1;to:1
                    onPositionChanged: tts.pitch=position
                }
            }
        }

        RowLayout{
            Layout.fillWidth: true
            GroupBox{
                title: qsTr("Locale")
                ComboBox{
                    model:ttsHelper.locales
                    onCurrentTextChanged: ttsHelper.selectLocale(currentIndex)
                }
            }
            GroupBox{
                title: qsTr("Voice")
                Layout.alignment: Qt.AlignRight
                ComboBox{
                    model:ttsHelper.voices
                    onCurrentTextChanged: ttsHelper.selectVoice(currentIndex)
                }
            }
        }

        Row{
            Layout.fillWidth: true
            FAButton{
                label:qsTr("Text to speech")
                icon:"\uf0a1"
                onClicked: tts.say( textSource.text)

            }
        }

    }
}
