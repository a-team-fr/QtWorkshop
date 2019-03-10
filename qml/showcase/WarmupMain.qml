import QtQuick 2.9
import QtQuick.Controls 2.2

Pane {
    id:root
    states: [
        State{
            name:"Step1"
            PropertyChanges{ target : grid; visible:false}
        },
        State{
            name:"Step2"
            PropertyChanges{ target : grid; visible:false}
            PropertyChanges{ target : side1; visible:true}
            PropertyChanges{ target : side2; visible:true}
        },
        State{
            name:"Step3"
            PropertyChanges{ target : mainRect; colorArray:[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]}
        },
        State{
            name:"Step4"
        }

    ]
    state:stateSelector.currentText

    ComboBox{
        id:stateSelector
        model:["Step1","Step2","Step3","Step4"]
    }

    Rectangle{
        id:mainRect
        width:300
        height:300
        anchors.centerIn:parent

        border.width:5
        border.color:"red"

        radius : 15
        color : "lightgreen"

        property var colorArray:[0,0,1,1,2,2,2,0,0,3,3,0,0,3,3,0]

        Grid{
            id:grid
            anchors.fill : parent
            anchors.margins: 50
            property int ceilSize : width / 4.
            Repeater{
                model:mainRect.colorArray
                delegate: Rectangle{
                    width : grid.ceilSize
                    height:grid.ceilSize
                    color:{
                        switch(modelData)
                        {
                            case 1: return "orange";
                            case 2: return "blue";
                            case 3: return "red";
                        }
                        return "transparent"
                    }
                }
            }
        }
    }

    Rectangle{
        id:side1
        width:50
        height:50
        color:"lightgrey"
        visible:false
        anchors.bottom : mainRect.bottom
        anchors.right:mainRect.left
    }
    Rectangle{
        id:side2
        width:50
        height:50
        color:"lightgrey"
        visible:false
        anchors.top : mainRect.top
        anchors.left:mainRect.right
    }

}
