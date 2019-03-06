import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import fr.ateam.qtworkshop 1.0
import "./component"

Frame {
    id:root




    FAButton{
        width:height; height: parent.height
        icon : "\uf104"
        visible : view.currentIndex > 0
        onClicked: view.currentIndex--
    }
    ListView{
        id:view
        anchors.fill: parent
        anchors.leftMargin: height
        anchors.rightMargin: height
        spacing:5
        clip : true
        orientation : ListView.Horizontal
        highlightFollowsCurrentItem:true
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.ApplyRange
        model:NavMan.lstTopics
        delegate: FAButton{
            height: view.height
            width: 4 * height - view.spacing
                selected : index === NavMan.currentTopic
                label:model.label
                icon : model.image
                onClicked: NavMan.currentTopic = index

            }

    }
    FAButton{
        width:height; height: parent.height
        anchors.right:parent.right
        icon : "\uf105"
        visible : view.currentIndex < (NavMan.lstTopics.count-1)
        onClicked: view.currentIndex++
    }


}
