import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQml.Models 2.2
import QtMultimedia 5.9
import "../../qml/component"

Pane {
    contentItem:Grid{
        id:grid
        anchors.centerIn : parent
        width : Math.min(parent.width, parent.height) - 3 * spacing
        height : width
        property int boxSize : width / 4
        property var colors : ["green","yellow","blue","red"]
        spacing : 5; padding:0;
        columns: 4; rows : 4
        Repeater{
            model:16
            delegate:Button {
                id:control
                property int colorRank :Math.floor( index / 4)
                property real colorShade :1 + (index % 4 ) / 5
                //autoRepeat: true
                text : sound.playing ? loop ? qsTr("loop") : qsTr("once"):""
                property bool loop : false
                highlighted:sound.playing
                background:Rectangle{
                    anchors.fill:parent
                    color: Qt.darker( grid.colors[colorRank], colorShade )
                    radius: 2
                    border.width:sound.playing ? 1 : 0
                    border.color:"white"
                }
                width: grid.boxSize; height: grid.boxSize
                onClicked:sound.play();
                onPressAndHold: {loop = !loop;sound.play();}
                SoundEffect{ id:sound; loops:control.loop ? SoundEffect.Infinite:1 ;source : "qrc:/res/wav/Sounds"+index+".wav" }

            }
        }


    }
}
