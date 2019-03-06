import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    Label{
        wrapMode: Text.WordWrap
        text:qsTr("<h1>This is your SoundBox playground</h1>
Just empty this file and replace with your qml code...<br>
<h2>what could be done ?</h2>
<ul>
<li>add a button to trigger a sound
<li>learn how to control the sound volume, how to play/stop several sounds at once...
<li>...
</ul>
")
        }
}
