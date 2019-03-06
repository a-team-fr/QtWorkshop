import QtQuick 2.9
import QtQuick.Controls 2.2
import QtMultimedia 5.9
import QtSensors 5.9
import "../../qml/component"

Pane{
    id:root
    function shoot(){
        if (( !delayShoot.selected) && camera.imageCapture.ready)
            camera.imageCapture.capture();
        else{
            delayTimer.start();
        }
    }

    Timer{
        id:delayTimer
        interval : 1000
        property int remainingSec : 5
        property int nbSec : 5
        repeat: true
        onTriggered: {
            if (remainingSec <= 0)
            {
                stop();
                remainingSec = nbSec;
                camera.imageCapture.capture();
            }
            else remainingSec--;
        }

    }

    Camera {
        id: camera
        imageCapture {
            onImageSaved: {
                imagePreview.lastPhotoPath = path
                imagePreview.open()
            }
        }
    }

    VideoOutput {
        id: viewfinder
        anchors.fill : parent
        source: camera
        autoOrientation: true
        orientation: camera.orientation

        PinchArea{
            id:zoomPinch
            anchors.fill: viewfinder
            enabled: true
            pinch.minimumScale: 1
            pinch.maximumScale: camera.maximumDigitalZoom
            scale: camera.digitalZoom
            onPinchStarted: scale = camera.digitalZoom;
            onPinchUpdated: camera.digitalZoom = pinch.scale;
        }
        ProgressBar{
            id:zoom
            //visible:zoomPinch.pinch.active
            width: 15
            height: viewfinder.height
            anchors.right : viewfinder.right
            value : camera.opticalZoom * camera.digitalZoom
            from: 1
            rotation:90
            transformOrigin: Item.Center
            to: camera.maximumOpticalZoom * camera.maximumDigitalZoom
        }
        Rectangle{
            id:crosshair
            width: 100; height: width
            anchors.centerIn:viewfinder
            opacity : 0.2
            color: "transparent"
            radius : 50
            border.width: 5
            visible: camera.imageCapture.ready && !timeOut.visible

            Rectangle{
                width: 50; height: width
                anchors.centerIn:parent
                radius : 25
            }
            MouseArea{
                anchors.fill : parent
                enabled: camera.imageCapture.ready
                onClicked: root.shoot()
            }

        }
        Label{
            id:timeOut
            anchors.centerIn: viewfinder
            visible : delayTimer.running
            text : delayTimer.remainingSec
        }

        Column{
            id:controlPanel
            height:viewfinder.height
            x:viewfinder.x
            y:viewfinder.y
            width:100
            spacing: 5

            FAButton{
                id:flash
                icon:"\uf0e7;"
                width:100; height:width
                selected: camera.flash.mode === Camera.FlashOn
                onClicked: camera.flash.mode = selected ? Camera.FlashOff : Camera.FlashOn
            }

            FAButton{
                id:delayShoot
                icon:"\uf254"
                width:100; height:width
                onClicked: selected = !selected
            }

            FAButton{
                icon:"\uf0e2"
                width:100; height:width
                selected:camera.position===Camera.BackFace
                onClicked: camera.position = selected ? Camera.FrontFace : Camera.BackFace
            }

        }
    }

    Popup{
        id:imagePreview
        width:parent.width;
        height:parent.height;
        property string lastPhotoPath :""
        Image{
            visible: imagePreview.lastPhotoPath != ""
            source : visible ? "file:///"+imagePreview.lastPhotoPath : ""
            autoTransform:true
            transformOrigin: Item.Center
            fillMode : Image.PreserveAspectFit
            anchors.fill: parent
        }
        FAButton{
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            icon:"\uf00d"
            onClicked: imagePreview.close()
        }

    }
}


