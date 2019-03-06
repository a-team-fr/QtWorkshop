import QtQuick 2.9
import QtQuick.Controls 2.2
import QtDataVisualization 1.2

Pane {
    id:root
    Surface3D {
        id: surfaceLayers
        width: parent.width
        height: parent.height

        shadowQuality: AbstractGraph3D.ShadowQualityMedium
        scene.activeCamera.cameraPreset: Camera3D.CameraPresetIsometricLeft


        Surface3DSeries {
            id: layerOneSeries
            colorStyle:Theme3D.ColorStyleObjectGradient
            baseGradient: ColorGradient {
                ColorGradientStop { position: 0.0; color: "black" }
                ColorGradientStop { position: 0.31; color: "tan" }
                ColorGradientStop { position: 0.32; color: "green" }
                ColorGradientStop { position: 0.40; color: "darkslategray" }
                ColorGradientStop { position: 1.0; color: "white" }
            }
            HeightMapSurfaceDataProxy {
                heightMapFile: ":/res/heightmap.png"
            }
            flatShadingEnabled: false
            drawMode: Surface3DSeries.DrawSurface
            visible: true
        }
    }

}
