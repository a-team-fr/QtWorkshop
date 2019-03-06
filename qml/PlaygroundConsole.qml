import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "./component"
import fr.ateam.qtworkshop 1.0

Pane{
    id:root
//    contentHeight: column.childrenRect.height
//    contentWidth : width
//    clip:true
    property bool showDetails : true
    state:""
    states: [
        State {
          name: "alreadyUsedAlias"
          PropertyChanges { target: message; text: qsTr("Alias is already used. Please choose another one") }
        },
        State {
          name: "createPlayground"
          PropertyChanges { target: message; text: qsTr("Creating your own playground locally from template") }
        }
        ]


    ColumnLayout{
        id:column
        anchors.fill : parent

        Label{
            id:message
            property bool isError : root.state === "alreadyUsedAlias"
            Layout.fillWidth:true
            color:isError ? "red" : "green"
            wrapMode: Text.WordWrap
            visible:text.length > 0
            text:""
        }
        GroupBox{
            title:qsTr("Playground alias (uid)")
            Layout.fillWidth:true
            RowLayout{
                width:parent.width
                TextField{
                    id:inputAlias
                    Layout.fillWidth:true
                    placeholderText:qsTr("Your playground name and public alias")
                    text:NavMan.myAlias
                    readOnly: NavMan.myAlias.length >0


                }
                FAButton{
                    label:"create"
                    visible:NavMan.myAlias.length === 0
                    icon:"\uf234"
                    onClicked: {
                        //Check if alias is already taken : is the file already exists ?
                        if ( NavMan.isAliasAlreadyUsed(inputAlias.text))
                        {
                            root.state = "alreadyUsedAlias";
                            return;
                        }

                        //save alias
                        NavMan.myAlias = inputAlias.text;
                        playgroundManager.playgroundName = NavMan.myAlias;
                        root.state = "createPlayground";
                        playgroundManager.createPlayground()
                    }
                }

            }

        }
        FAButton{
            id:resetSettings
            label:qsTr("reset settings")
            visible : false
            color:"red"
            onClicked: NavMan.resetSettings()


        }


        Connections{
            target:NavMan.queryLstPublishedAliases
            onReloaded: {
                for ( var i =0; i < NavMan.lstPublishedAliases.count; i++)
                {
                    var a = NavMan.lstPublishedAliases.get(i).uidAlias;
                    if ( a === NavMan.myAlias) continue;

                    lstEvents.append({"action":"<--","file":NavMan.localDocRoot+ a + ".zip","details":"download triggered", "color":"grey"})
                }

            }
        }
        Connections{
            target:playgroundManager
            onUploadCompleted: {
                console.log("done uploading:"+localfilePath)
                lstEvents.append({"action":"-->","file":localfilePath,"details":"upload completed", "color":"green"})
            }
            onDownloadCompleted: {
                console.log("done uploading:"+localfilePath)
                lstEvents.append({"action":"<--","file":localfilePath,"details":"download completed", "color":"green"})
            }
        }

        ListModel{
            id:lstEvents
        }

        GroupBox{
            title: qsTr("Events log")
            visible : showDetails
            Layout.fillWidth:true
            Layout.fillHeight:true

            ListView{
                id:view
                anchors.fill: parent
                model:lstEvents
                clip:true
                delegate:RowLayout{
                    width:view.width
                    height:30
                    Label{text:action;}
                    Label{text:file; Layout.fillWidth: true; elide: Text.ElideLeft}
                    Label{text:details; color:model.color; Layout.fillWidth: true}
                }

            }
            MouseArea{
                anchors.fill: parent
                pressAndHoldInterval: 5000
                onPressAndHold: resetSettings.visible = true
            }
        }
        RowLayout{
            visible : showDetails
            Layout.fillWidth: true
            FAButton {
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                color:"yellow"
                icon: "\uf0ee"
                visible:NavMan.myAlias.length > 0
                label:qsTr("Upload your playground")
                onClicked:{
                    playgroundManager.uploadPlayground();
                    lstEvents.append({"action":"-->","file":"upload your playground "+NavMan.myAlias+".zip","details":"upload triggered", "color":"grey"})
                }
            }

            FAButton {
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                color:"yellow"
                icon: "\uf0ed" //"\uf0ee"
                label:qsTr("Download others playground")
                onClicked:{
                    NavMan.queryLstPublishedAliases.reload()


                }
            }
        }

//        FAButton{
//            Layout.alignment: Qt.AlignRight
//            label:"Close"
//            icon:"\uf00d"
//            onClicked: NavMan.showPlaygroundConsole = false;
//        }


    }

}
