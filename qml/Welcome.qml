import QtQuick 2.9
import QtQuick.Controls 2.2
import fr.ateam.qtworkshop 1.0
import QtMultimedia 5.4
import QtQuick.Layouts 1.2

Pane {

    SwipeView {
        id: view

        currentIndex: 0
        anchors.fill:parent
        clip:true
        interactive:false


        Label {
            wrapMode: Text.WordWrap
            text:"<h1>Welcome to the QtWorkshop</h1>
<h2> This wizard will create your playground :</h2>
<ol>
<li>create your Alias
<li>(optional) customize profile.png
</ol>"

            Button{
                anchors.right:parent.right
                anchors.bottom: parent.bottom
                text:qsTr("Start !")
                onClicked:view.currentIndex++
            }
        }

        ColumnLayout{
            Label{
                text: qsTr("Step 1 : Alias creation")
            }

            PlaygroundConsole{
                Layout.fillHeight: true
                Layout.fillWidth: true
                showDetails : false

            }
            Button{
                enabled : NavMan.myAlias.length > 0
                Layout.alignment: Qt.AlignRight
                text:qsTr("Next")
                onClicked:{
                    NavMan.saveSettings();
                    if (QtMultimedia.availableCameras.length === 0)
                        NavMan.showWelcome = false; //end wizard (skip step2)
                    view.currentIndex++;
                }
            }
        }
        ColumnLayout{
            Label{
                Layout.fillWidth: true
                text: qsTr("Step 2 (optional): profile picture")
            }
            Label{
                wrapMode: Text.WordWrap
                text:"<h1>Hi "+NavMan.myAlias+"</h1>Let's take a picture to customize your profile..."
            }

            Loader{
                id:loader;
                sourceComponent:camObj
                active:view.currentIndex===2
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Component{
                id:camObj
                VideoOutput{

                    fillMode: VideoOutput.PreserveAspectFit
                    source : Camera{
                        id:cam
                        imageCapture.onImageSaved: { //path
                            playgroundManager.savePhotoAsProfile(path);
                            NavMan.showWelcome = false

                        }
                    }
                    Button{
                        text:qsTr("Take photo")
                        onClicked: waitTxt.visible = true
                        highlighted: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label{
                        id:waitTxt
                        text:qsTr("Saving profile...please wait")
                        color : "red"
                        visible:false
                        anchors.centerIn: parent
                        onVisibleChanged: visible ? cam.imageCapture.capture():{}

                    }
                }


            }


            Button{
                Layout.fillWidth: true
                enabled : NavMan.myAlias.length > 0
                Layout.alignment: Qt.AlignRight
                text:qsTr("Finish (Skip)")
                onClicked:NavMan.showWelcome = false
            }


        }
    }
}
