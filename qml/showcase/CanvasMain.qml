import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtMultimedia 5.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.12

Pane {
    contentItem:ColumnLayout{
        RowLayout{
            Layout.fillWidth: true
            Button{
                id:openColorDialog
                background:Rectangle{ color:colorDialog.color}
                text:qsTr("Color")
                onClicked: colorDialog.open()

                ColorDialog {
                    id: colorDialog
                    property point orig : openColorDialog.mapToGlobal(0, openColorDialog.height)
                    onOrigChanged: console.log("zob"+orig)
                    x:orig.x
                    y:orig.y
                    title: qsTr("Please choose a color")
                    modality: Qt.ApplicationModal
                }


            }
            Button{
                text:qsTr("Save")
                onClicked: savedImg.source = canvas.toDataURL('image/png')
            }

        }
        Rectangle{
            Layout.fillHeight: true
            Layout.fillWidth: true
            color:"white"

            Canvas {
                id: canvas
                anchors.fill:parent
                property real lastX : -1
                property real lastY : -1
                property real lineWidth : 1.5

                function drawLine( newX, newY){
                    if (canvas.lastX < 0)
                    {
                        canvas.lastX = newX
                        canvas.lastY = newY
                        return;
                    }

                    var ctx = getContext('2d')
                    ctx.lineWidth = canvas.lineWidth
                    ctx.strokeStyle = colorDialog.color
                    ctx.beginPath()
                    ctx.moveTo(canvas.lastX, canvas.lastY)
                    ctx.lineTo(newX, newY)
                    canvas.lastX = newX
                    canvas.lastY = newY
                    ctx.stroke()
                    requestPaint();
                }

                MouseArea {
                    anchors.fill: parent
                    onPositionChanged: canvas.drawLine(mouseX,mouseY)
                    onReleased: canvas.lastX = -1
                }
            }

            Image{
                id:savedImg
                anchors.right:parent.right
                anchors.bottom:parent.bottom
                width:parent.width / 3
                height:parent.height / 3
            }
        }


    }

//    Video{
//        anchors.fill:parent
//        autoPlay: true
//        source:"https://hddn01.skylinewebcams.com/live.m3u8?a=ndd0vciri0fjqfiujord4b35s4"
//    }
}
