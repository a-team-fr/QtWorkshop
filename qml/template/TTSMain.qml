import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    contentItem:Label{
        wrapMode: Text.WordWrap
        text:qsTr("<h1>This is your TextToSpeach playground</h1>
Just empty this file and replace with your qml code...<br>
<h2>what could be done ?</h2>
<ul>
<li>TTS is supported in Qt with a C++ API, make a TTS available in your qml
<li>Connect a text field content to a TTS item
<li>Is it possible to change the TTS voice ?
<li>...
</ul>
")
    }
}
