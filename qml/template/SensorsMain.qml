import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    Label{
        wrapMode: Text.WordWrap
        text:qsTr("<h1>This is your Sensors playground</h1>
Just empty this file and replace with your qml code...<br>
<h2>what could be done ?</h2>
<ul>
<li>Use magnetometer reading to drive a ball in a maze
<li>Retrieve Euler angle to drive an attitude indicator
<li>...
</ul>
")
    }
}
