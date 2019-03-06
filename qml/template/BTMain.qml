import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    Label{
        wrapMode: Text.WordWrap
        text:qsTr("<h1>This is your Bluetooth playground</h1>
Just empty this file and replace with your qml code...<br>
<h2>what could be done ?</h2>
<ul>
<li>Connect with a BT device
<li>Retrieve information, use the strenght of the signal to determine distance
<li>...
</ul>
")
    }
}
