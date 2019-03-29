import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    contentItem:Label{
        wrapMode: Text.WordWrap
        text:qsTr("<h1>This is your Map playground</h1>
Just empty this file and replace with your qml code...<br>
<h2>what could be done ?</h2>
<ul>
<li>add a map, learn how to change plugin
<li>learn how to display a map on a specific coordinate, use a GPS to initialize the map position
<li>try to draw over the map, some statically defined points of interest or connect a model
<li>learn how to do geocoding, navigation
<li>...
</ul>
")
    }
}
