import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

Pane {
    id:root
    property color backgroundRectangleColor : "white"
    property var button : null
    property var warning : null

    function initLayout(){
        password2.y = password1.y+50

    }

    function deleteDynamics(){
        if (button)
            button.destroy();
        if (warning)
            warning.destroy();

    }

    function createButton(){
        if (root.button) return;

        root.backgroundRectangleColor="grey"
        root.button = superButton.createObject(root, {"label":"Register","width":200, "height":50 })
        root.button.y = password2.y+50
    }

    Component{
        id:warningCpnt
        Rectangle{
            color:"red"
            Label{
                x:(parent.width - width)/2
                text:"Passwords are not indentical"
            }
        }
    }

    Component{
        id:superButton

        Item{
            id:sbRoot
            property string label : ""
            onLabelChanged:text.text = label

            Rectangle{
                id:fondRectangle
                color:root.backgroundRectangleColor
                radius:3
                anchors.fill:sbRoot

                Label{
                    id:text
                }
            }

            MouseArea{
                width:fondRectangle.width
                height:fondRectangle.height
                onClicked:{
                    console.log("check pwd1 and pwd2 are identical")
                    if (password1.text !== password2.text)
                    {
                        root.warning = warningCpnt.createObject(root, {"width":root.width, "height":50} )
                        console.log("show message error")
                        password1.y+=50
                        password2.y+=50
                        root.button.y+=50
                        return;
                    }
                    else {
                        messageOKWhenDone.visible = true
                        root.deleteDynamics()
                    }
                }
            }
        }


    }

    TextField{
        id:password1
        width:parent.width
        Label{
            id:placeholder1
            text:"Type here your password"
            anchors.fill:parent

        }
        onTextEdited:{

            if (text.length>0) {

                placeholder1.visible = false;
                password2.enabled=true
            }
            else placeholder1.visible = true;
        }

    }

    TextField{
        id:password2
        width:parent.width
        enabled:false
        Component.onCompleted: root.initLayout()
        onTextEdited:{

            if (text.length>0)
            {
                placeholder2.visible = false;
                if (password1.length>0)
                    root.createButton()
            }

        }
        Label{
            id:placeholder2
            text:"Re-type here your password to confirm"
            anchors.fill:parent

        }
    }

    Rectangle{
        id:messageOKWhenDone
        width:parent.width
        height:parent.height
        color:"green"
        visible:false
        z:100 //we don't want the register button to be shown when register is completed
        Label{
            width:parent.width
            height:parent.height
            text:"OK ACCOUNT IS CREATED, click to restart"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    parent.parent.visible = false
                    password1.text = ""
                    password2.text = ""
                }
            }
        }


    }


}
