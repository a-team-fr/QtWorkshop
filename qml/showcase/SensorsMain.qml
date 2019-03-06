import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtSensors 5.9

Pane {
    //Display
    Row{
        id: view
        anchors.fill:parent
        spacing : 5
        Flickable {
            id: rawSensorsReading
            height:parent.height
            width : parent.width/2 - parent.spacing
            contentHeight: column.implicitHeight
            contentWidth: width
            clip:true

            AmbientTemperatureSensor{
                id:ambiantTempSensor
                active:true
                property string strReading : reading ? qsTr("%1 °C").arg(reading.temperature) : qsTr("no readings available")
            }
            Magnetometer{
                id:magnetometer
                active:true
                property string strReading : reading ? qsTr("x:%1 y:%2 z:%3").arg(reading.x.toFixed(2)).arg(reading.y.toFixed(2)).arg(reading.z.toFixed(2)) : qsTr("no readings available")
            }
            Gyroscope{
                id:gyroscope
                active:true
                property string strReading : reading ? qsTr("x:%1 y:%2 z:%3").arg(gyroscope.reading.x.toFixed(2)).arg(gyroscope.reading.y.toFixed(2)).arg(gyroscope.reading.z.toFixed(2)) : qsTr("no readings available")
            }
            RotationSensor{
                id:rotationSensor
                active:true
                property string strReading : reading ? qsTr("x:%1 y:%2 z:%3").arg( rotationSensor.reading.x.toFixed(2)).arg(rotationSensor.reading.y.toFixed(2)).arg(rotationSensor.reading.z.toFixed(2)) : qsTr("no readings available")
            }
            OrientationSensor{
                id:orientationSensor
                active:true
                property string strReading : reading ? strOrientation( reading.orientation) : qsTr("no readings available")
                function strOrientation( orient)
                {
                    switch (orient)
                    {
                    case OrientationReading.TopUp: return qsTr("Top up");
                    case OrientationReading.TopDown: return qsTr("Top down");
                    case OrientationReading.LeftUp: return qsTr("LeftUp");
                    case OrientationReading.RightUp: return qsTr("RightUp");
                    case OrientationReading.FaceUp: return qsTr("FaceUp");
                    case OrientationReading.FaceDown: return qsTr("FaceDown");
                    }
                    return qsTr("Unknown");
                }

            }
            AmbientLightSensor{
                id:ambiantLightSensor
                active:true
                property string strReading : reading ? strAmbiantLight( reading.lightLevel) : qsTr("no readings available")
                function strAmbiantLight( lightLevel)
                {
                    switch (lightLevel)
                    {
                    case AmbientLightReading.Dark: return qsTr("Dark");
                    case AmbientLightReading.Twilight: return qsTr("Twilight");
                    case AmbientLightReading.Light: return qsTr("Light");
                    case AmbientLightReading.Bright: return qsTr("Bright");
                    case AmbientLightReading.Sunny: return qsTr("Sunny");
                    }
                    return qsTr("Unknown");
                }

            }
            LightSensor {
                id:lightSensor
                active: true
                property string strReading : reading ? qsTr("Luminosity : %1").arg(reading.illuminance) : qsTr("no readings available")
            }
            ProximitySensor {
                id:proximitySensor
                active: true
                property string strReading : reading ? qsTr("Proximity : %1").arg( reading.near ? qsTr("near") : qsTr("far")) : qsTr("no readings available")
            }

            ColumnLayout {
                id: column
                width: parent.width


                GroupBox{
                    title:qsTr("AmbientTemperatureSensor")
                    Layout.fillWidth:true
                    Label{
                        text:ambiantTempSensor.strReading
                    }
                }

                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Magnetometer")
                    Label{
                        text:magnetometer.strReading
                        fontSizeMode:Text.HorizontalFit
                        minimumPointSize : 6
                        font.pointSize : 12

                    }
                }
                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Orientation")
                    Label{
                        text:orientationSensor.strReading
                    }
                }
                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Ambiant light")
                    Label{
                        text: ambiantLightSensor.strReading
                    }
                }
                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Gyroscope")
                    Label{
                        text:gyroscope.strReading
                        fontSizeMode:Text.HorizontalFit
                        minimumPointSize : 6
                        font.pointSize : 12
                    }
                }

                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Rotation")
                    Label{
                        text:rotationSensor.strReading
                        fontSizeMode:Text.HorizontalFit
                        minimumPointSize : 6
                        font.pointSize : 12
                    }
                }

                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Light")
                    Label{
                        text:lightSensor.strReading
                    }
                }
                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Proximity")
                    Label{
                        text:proximitySensor.strReading

                    }
                }


            }

        }


        Flow{
            height:parent.height
            width : parent.width/2 - parent.spacing
            clip:true
            TiltSensor {
                id:tiltSensor
                active: true
                property string strReading : reading ? qsTr("Tilt is x:%1 y:%2").arg( reading.xRotation).arg( reading.yRotation) : qsTr("no readings available")
                property bool swapRollPitch : false
                property bool invertPitch : false
                property bool invertRoll : false
                property real pitch : 0
                property real roll : 0

                onReadingChanged : {
                    if (!reading) {
                        pitch = 0;
                        roll = 0;
                    }
                    else {
                        pitch = swapRollPitch ? reading.yRotation : reading.xRotation;
                        roll = swapRollPitch ? reading.xRotation : reading.yRotation;

                        if (invertPitch ) pitch = -pitch;
                        if (invertRoll ) roll = -roll;
                    }
                }


            }


            Rectangle {
                id:movingBall
                width:Math.min(parent.width, parent.height)
                height:width
                color:"transparent"
                border.width:1
                border.color:"black"
                property real pitch: tiltSensor.pitch
                property real roll:tiltSensor.roll
                property real inertiaFactor : 0.1

                property alias ballRadius : ball.radius
                property alias ballColor: ball.color

                onRollChanged: {
                    ball.x += roll*inertiaFactor
                    ball.x = Math.max(0, ball.x);
                    ball.x = Math.min(width - 2*ballRadius, ball.x)
                }
                onPitchChanged: {
                    ball.y += pitch*inertiaFactor
                    ball.y = Math.max(0, ball.y);
                    ball.y = Math.min(height - 2*ballRadius, ball.y)
                }

                Rectangle {
                    id: ball
                    color: "blue"
                    width: 30; height : 30;radius: 15
                    smooth: true
                    x: parent.width / 2 - radius
                    y: parent.height / 2 - radius

                }
            }
            Button{
                text: qsTr("swap pitch & roll")
                onClicked:tiltSensor.swapRollPitch = !tiltSensor.swapRollPitch
            }
            Button{
                text: qsTr("invert pitch")
                onClicked:tiltSensor.invertPitch = !tiltSensor.invertPitch
            }
            Button{
                text: qsTr("invert roll")
                onClicked:tiltSensor.invertRoll = !tiltSensor.invertRoll
            }
            Button{
                text: qsTr("calibrate")
                onClicked:tiltSensor.calibrate()
            }
        }

    }


}
