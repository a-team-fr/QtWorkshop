import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import fr.ateam.qtworkshop 1.0

Pane {

    SwipeView {
        id: view

        currentIndex: 0
        anchors.fill:parent
        anchors.bottomMargin: 30
        clip:true



        ColumnLayout{
            width:view.Width
            Label {
                Layout.maximumWidth:view.width
                Layout.alignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
                text:qsTr("<h1>Qt workshop showcase</h1>")
            }
            Image{
                fillMode: Image.PreserveAspectFit
                Layout.fillHeight: true
                Layout.maximumWidth:view.width
                Layout.alignment: Qt.AlignHCenter
                source:"qrc:/res/qtday2019logo.png"
            }

            Label {
                Layout.maximumWidth:view.width
                Layout.alignment: Qt.AlignRight
                wrapMode: Text.WordWrap
                text:"https://github.com/a-team-fr/QtWorkshop"
            }
        }

        Label {
            wrapMode: Text.WordWrap
            text:qsTr("<h2>How to start ?</h2><br>Use the toolbar to discover the topic candidates we could experience during the workshop, such as :
<ul>
<li>have fun with a sound box
<li>discover how to use the camera
<li>display a map with dynamic markers
<li>...
</ul>
<br>See you there !
")
        }
    }

    PageIndicator {
        count: view.count
        currentIndex: view.currentIndex
        anchors.top: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        onCurrentIndexChanged: NavMan.showTopicSelector = currentIndex === 1
    }
}
