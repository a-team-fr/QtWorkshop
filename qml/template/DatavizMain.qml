import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    contentItem:Label{
        wrapMode: Text.WordWrap
        text:qsTr("<h1>This is your Charts playground</h1>
Just empty this file and replace with your qml code...<br>
<h2>what could be done ?</h2>
<ul>
<li>Use a charts to monitor a sensor readings
<li>get elevation data and display a digital terrain model
<li>...
</ul>
")
    }
}
