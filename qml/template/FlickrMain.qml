import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    contentItem:Label{
        wrapMode: Text.WordWrap
        text:qsTr("<h1>This is your Flick'r playground</h1>
Just empty this file and replace with your qml code...<br>
<h2>what could be done ?</h2>
<ul>
<li>Use a xml model to get data from flick'r
<li>...
</ul>
")
    }
}
