import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import fr.ateam.qtworkshop 1.0

Control{
    id:root
    property alias icon :icon.text
    property alias label : label.text
    property color color : Material.foreground
    property alias iconRotation : icon.rotation
    signal clicked();
    property bool selected : false

    hoverEnabled: true
    implicitHeight:30
    implicitWidth: content.childrenRect.width + (( !icon.isEmpty && !label.isEmpty) ? 1 : 0) * content.spacing

    background:Rectangle{
        color : "Grey"
        opacity : root.hovered ? 0.9 : 0.1
        border.width:root.selected ? 1 : 0
        border.color : Material.accent
        radius:2
    }

    contentItem: Row{
        id:content
        spacing : 5
        Text{
            id : icon
            color : root.selected ? Material.accent : root.color
            readonly property bool isEmpty : text.length === 0
            font.family: NavMan.fa.name
            y : parent.height * 0.1 + content.spacing
            x:y
            height:parent.height * 0.8 - 2 * content.spacing
            width:visible ? height / 0.8 + 2 * content.spacing : 0
            visible : !isEmpty
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment : Text.AlignVCenter

            font.pointSize : 40
            minimumPixelSize: 6
            fontSizeMode: Text.Fit
            //            Rectangle{
            //                anchors.fill:parent
            //                color:"red"
            //                z:-1

            //            }


        }
        Label{
            id:label
            color : root.selected ? Material.accent : root.color
            elide: Text.ElideRight
            visible : !isEmpty
            readonly property bool isEmpty : text.length === 0
            horizontalAlignment: icon.isEmpty ? Text.AlignHCenter :  Text.AlignLeft
            verticalAlignment : Text.AlignVCenter
            height:parent.height
            //            Rectangle{
            //                anchors.fill:parent
            //                color:"blue"
            //                z:-1

            //            }
        }
    }


    MouseArea{
        enabled : root.visible
        hoverEnabled:true
        anchors.fill : parent
        onClicked: root.clicked();
    }

}


