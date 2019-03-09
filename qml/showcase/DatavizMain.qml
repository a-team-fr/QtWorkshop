import QtQuick 2.9
import QtQuick.Controls 2.2
import QtDataVisualization 1.2
import QtQuick.Layouts 1.2

Pane {
    id:root
    Surface3D {
        id: surfaceLayers
        width: parent.width
        height: parent.height

        shadowQuality: AbstractGraph3D.ShadowQualityMedium

        theme: Theme3D {
            backgroundEnabled: false
            gridEnabled: false
            labelBackgroundEnabled:false
            labelBorderEnabled :false
            //labelTextColor: "transparent"
            windowColor: "grey"
        }

        Surface3DSeries {
            id: firenze
            colorStyle:Theme3D.ColorStyleObjectGradient
            baseGradient: ColorGradient {
                ColorGradientStop { position: 0.0; color: "black" }
                ColorGradientStop { position: 0.31; color: "tan" }
                ColorGradientStop { position: 0.32; color: "green" }
                ColorGradientStop { position: 0.40; color: "darkslategray" }
                ColorGradientStop { position: 1.0; color: "white" }
            }
            dataProxy:HeightMapSurfaceDataProxy {
                id:elevation
                heightMapFile: ":/res/heightmap.png"
            }
            flatShadingEnabled: true
            drawMode: Surface3DSeries.DrawSurface
            visible: true
            textureFile: ":/res/Firenze.png"
            itemLabelVisible:false
            meshSmooth: true
        }
    }

    Flow{
        anchors.fill: parent
        CheckBox{
            checked: firenze.textureFile.length > 0
            onClicked: firenze.textureFile.length > 0 ? firenze.textureFile = "" : firenze.textureFile = ":/res/Firenze.png"
            text:qsTr("use texture")
        }
        CheckBox{
            checked: firenze.flatShadingEnabled
            onClicked: firenze.flatShadingEnabled ? firenze.flatShadingEnabled = false : firenze.flatShadingEnabled =true
            text:qsTr("flat shading")
        }
        CheckBox{
            checked: firenze.drawMode === QSurface3DSeries.DrawSurface
            onClicked: checked ? firenze.drawMode = QSurface3DSeries.DrawSurface : firenze.drawMode = QSurface3DSeries.DrawWireframe
            text:qsTr("draw surface")
        }
        ComboBox{
            width:70
            height:40
            model:["FrontLow","Front","FrontHigh","LeftLow","Left", "LeftHigh","RightLow","Right", "RightHigh","BehindLow","Behind", "BehindHigh","IsoLeft","IsoRight", "LeftHigh"]
            //displayText:"Position :"+currentText
            onCurrentIndexChanged: surfaceLayers.scene.activeCamera.cameraPreset = currentIndex
        }

    }

}
