import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    id:root

    function reset()
    {
        password1.text="";
        password2.text="";
    }

    Component{
        id:superButton
        Item{
            property string text : ""
            property color backgroundColor : "lightgrey"
            signal clicked();
            implicitWidth: 100
            implicitHeight: 40
            Rectangle{
                anchors.fill:parent
                color:parent.backgroundColor
                radius:3
            }
            Label{
                text:parent.text
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill:parent
                onClicked:parent.clicked()
            }
        }
    }

    Column{
        anchors.fill : parent
        Label{
            id:warningMessage
            width:parent.width
            text:qsTr("Passwords are not identical")
            color : "red"
            visible : (password2.text.length > 0 ) && password1.text !== password2.text
        }

        TextField{
            id:password1
            width:parent.width
            echoMode: TextInput.PasswordEchoOnEdit
            placeholderText: qsTr("Type here your password")
        }
        TextField{
            id:password2
            width:parent.width
            echoMode: TextInput.PasswordEchoOnEdit
            enabled:password1.text.length>0
            placeholderText: qsTr("Re-type here your password to confirm")
        }

        Loader{
            id:loader
            sourceComponent: superButton
            active:(password1.text.length > 0 ) && (password2.text.length > 0 ) && !warningMessage.visible
            onLoaded: item.text = qsTr("Register");

            Connections{
                ignoreUnknownSignals: true
                target : loader.item
                onClicked:completePopup.open()
            }
        }


    }

    Popup{
        id:completePopup
        modal:true
        width:200
        height:200
        x: (parent.width - width)/2
        y: (parent.height - height)/2
        MouseArea{
            anchors.fill:parent
            onClicked: completePopup.close()
        }
        closePolicy: Popup.NoAutoClose
        onClosed: root.reset()
        Label{
            anchors.fill: parent
            wrapMode: Text.WordWrap
            text:qsTr("OK ACCOUNT IS CREATED, click to restart")
        }
    }
}
