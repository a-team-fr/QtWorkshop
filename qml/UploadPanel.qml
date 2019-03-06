import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import "./component"
import Qt.labs.platform 1.1
import Qt.labs.settings 1.1

Frame{
    id : root
    signal closeUploadPanel();
    FileDialog {
        id: fileDialog
        fileMode : FileDialog.OpenFiles
        title: qsTr("Please choose the files you want to publish")
        onAccepted : {
            lstFiles.clear()
            for (var i = 0; i < files.length; i++ ){
                var url =Qt.resolvedUrl(files[i]);
                lstFiles.append({"url":files[i], "filePath":uploader.getFilePathFromUrl(url), "fileName":uploader.getFileNameFromUrl(url),})
            }
        }
    }
    ListModel{
        id:lstFiles
    }

    Settings{
        property alias playgroundAlias : playgroundAlias.text
    }

    Flickable{
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.implicitHeight
        clip:true
        ColumnLayout{
            id:column
            width : parent.width

            GroupBox{
                title:qsTr("Your playground alias")
                Layout.fillWidth:true
                Column{
                    anchors.fill: parent
                    TextField{
                        id:playgroundAlias
                        width:parent.width
                        placeholderText: qsTr("type here your alias (unique name of ftp directory)")
                    }
//                    Button{
//                        enabled: true
//                        text:qsTr("Browse your playground (password is W0rksh0pQt)")
//                        onClicked:Qt.openUrlExternally(Qt.resolvedUrl("ftp://qtworkshop@a-team.fr@ftp.a-team.fr:21/"+playgroundAlias.text))
//                    }
                    TextEdit{
                        text:qsTr("Browse your playground at %1 (password is %2)").arg("ftp://qtworkshop@a-team.fr@ftp.a-team.fr:21/").arg("W0rksh0pQt")
                        selectByMouse: true
                        readOnly: true
                    }
                }
            }
            GroupBox{
                title:qsTr("Select file")
                Layout.fillWidth:true
                Layout.fillHeight:true
                ColumnLayout{
                    anchors.fill: parent
                    Button{
                        text:"choose files to upload to your playground"
                        onClicked: fileDialog.open()
                        Layout.preferredHeight: 35
                        Layout.fillWidth: true
                    }
                    ListView{
                        id:lstSelectedFiles
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        model : lstFiles
                        delegate:RowLayout{
                            width : lstSelectedFiles.width
                            height:30


                            Label{
                                text:fileName
                                Layout.fillWidth: true
                                height:30
                            }
                            ProgressBar{
                                width:100;height:30;from: 0;to:100
                            }

                            FAButton{
                                Layout.preferredHeight: 20
                                Layout.preferredWidth: 20
                                icon: "\uf0ed"
                                onClicked:uploader.triggerUpload( filePath, playgroundAlias.text + "/"+fileName)
                            }

                        }
                    }
                }

            }







        }
    }

    Button{
        text : qsTr("Close dialog")
        //width:100;height:100
        anchors.bottom:parent.bottom
        anchors.right: parent.right
        onClicked: root.closeUploadPanel()
    }
}

