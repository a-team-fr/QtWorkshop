import QtQuick 2.9
import QtQuick.Controls 2.2
import QtPositioning 5.9
import QtLocation 5.9
import QtQuick.Layouts 1.2
import QtQuick.XmlListModel 2.0
import "../../qml/component"

Pane{


    Plugin{
        id:plugin
        name:"esri"
    }

    Map{
        id:myMap
        anchors.fill:parent
        plugin:plugin
        center:QtPositioning.coordinate(43.777079, 11.250628)
        zoomLevel: myMap.maximumZoomLevel

        PositionSource{
            id:positionSource
            active: false
            onPositionChanged: myMap.center = position.coordinate
            preferredPositioningMethods: PositionSource.AllPositioningMethods
        }

        MapItemView{
            model: staticModel
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(Latitude,Longitude)
                sourceItem:  Text{
                    width:100
                    height:50
                    text:model.Label
                    rotation: model.Orientation
                    opacity: 0.6
                    color:model.Color
                }
            }

        }
        MapItemView{
            model: bikeModel
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.latitude,model.longitude)
                sourceItem:  FAButton{ width:50;height:50;icon:"\uf206"}
            }

        }

        MapItemView{
            model: psm
            delegate: MapQuickItem {
                coordinate: model.place.location.coordinate
                sourceItem:  Image{ width:64;height:64;source:model.place.icon.url(Qt.size(64,64));
                    Label{
                        anchors.fill:parent
                        text:model.title
                    }

                }
            }

        }


        //Bunch of static items
        MapQuickItem {
            //a static item (fixed screen size) always at 50m west of the map center
            id:west50mScreenDimension
            coordinate: myMap.center.atDistanceAndAzimuth(50,270)
            sourceItem:  Rectangle{
                width:50; height:50; radius:25; color:"blue"; opacity:0.8
            }
        }
        MapCircle {
            //a static item (fixed real dimension) always at 100m east of the map center
            id:east100mFixedDimension
            center: myMap.center.atDistanceAndAzimuth(100,90)
            opacity:0.8
            color:"red"
            radius:10

        }

        MapQuickItem {
            id:geocodeResult
            coordinate: geocode.count >  0 ? geocode.get(0).coordinate : QtPositioning.coordinate()
            sourceItem:  FAButton{ width:150;height:150;icon:"\uf041"}

        }

    }

    XmlListModel
    {
        id:bikeModel
        source: "https://www.capitalbikeshare.com/data/stations/bikeStations.xml"
        query: "/stations/station"
        XmlRole { name: "latitude"; query: "lat/string()"; isKey: true }
        XmlRole { name: "longitude"; query: "long/string()"; isKey: true }
    }

    //////////////////Geocode - /////////////
    GeocodeModel{
        id:geocode
        plugin:plugin
        autoUpdate:false
    }

    /////////////////////PSM model - search restaurants around 10km///////////////////////
    PlaceSearchModel {
        id: psm
        plugin: plugin
        searchTerm: "restaurant"
        searchArea: QtPositioning.circle(myMap.center, Number(searchFieldRadius.text));
        Component.onCompleted: update()
        limit:100

    }


    /////////////////////Static model///////////////////////
    ListModel{
        id:staticModel
        ListElement {
            Latitude: 47.212047
            Longitude: -1.551647
            Label: "something"
            Orientation: 0
            Color:"green"

        }
        ListElement {
            Latitude: 47.3
            Longitude: -1.581647
            Label: "something else"
            Orientation: 90
            Color:"darkgreen"
        }

    }

    RouteQuery{
        id:route
        travelModes:RouteQuery.CarTravel
        routeOptimizations : RouteQuery.FastestRoute
    }

    RouteModel {
        id: routeModel
        plugin:plugin
        query: route
        onQueryChanged: Console.log(count)
        autoUpdate: false

    }

    /////////////////////Display map error///////////////////////
    NotificationPopup{
        backgroundColor:"red"
        modal:true
        showOnTextChange : true
        width:parent.width
        height:25
        text:myMap.errorString
    }


    /////////////////////Control panel///////////////////////
    Button{
        width:50;height:50;
        text:"\u2713"

        background:Rectangle{color :"red";radius:2;opacity:0.9}
        onClicked: {
            if (controlPanel.x < parent.width)
                controlPanel.x = parent.width;
            else controlPanel.x = parent.width - controlPanel.width;
        }
    }


    Frame{
        id:controlPanel
        width: parent.width*2/3
        height:parent.height
        x:parent.width

        Behavior on x{
            NumberAnimation { duration: 1000 }
        }

        background:Rectangle{
            anchors.fill: parent
            color:"grey"
            opacity : 0.7
        }
        Flickable{
            width: controlPanel.width
            height:controlPanel.height
            contentHeight: column.childrenRect.height
            contentWidth : width
            clip:true

            ColumnLayout{
                id:column
                width:parent.width
//                GroupBox{
//                    title:qsTr("Plugin")
//                    Layout.fillWidth:true
//                    ComboBox{
//                        width:parent.width
//                        model: ["esri", "here","itemsoverlay","mapbox","osm"]
//                        onCurrentIndexChanged: plugin.name = currentText
//                    }
//                }
                GroupBox{
                    title:qsTr("Position source")
                    Layout.fillWidth:true
                    CheckBox{
                        Layout.fillWidth:true
                        text:qsTr("use current location")
                        onCheckedChanged: positionSource.active = checked

                    }
                }
                GroupBox{
                    title:qsTr("Map type")
                    Layout.fillWidth:true
                    ComboBox{
                        id:mapType
                        width:parent.width
                        model: myMap.supportedMapTypes
                        textRole:"name"
                        onCurrentIndexChanged: myMap.activeMapType = myMap.supportedMapTypes[currentIndex]
                    }
                }
                GroupBox{
                    title:qsTr("Zoom control")
                    Layout.fillWidth:true
                    Slider{
                        width:parent.width
                        value:myMap.maximumZoomLevel
                        from: myMap.minimumZoomLevel
                        to: myMap.maximumZoomLevel
                        onValueChanged: myMap.zoomLevel=value

                    }
                }
                GroupBox{
                    title:qsTr("Tilt control")
                    Layout.fillWidth:true
                    Slider{
                        width:parent.width
                        value:myMap.minimumTilt
                        from: myMap.minimumTilt
                        to: myMap.maximumTilt
                        onValueChanged: myMap.tilt=value

                    }
                }
                GroupBox{
                    title:qsTr("Add a new item")
                    Layout.fillWidth:true
                    Column{
                        width:parent.width
                        TextField{
                            width:parent.width
                            id:newItemName;text:"new item label";
                        }
                        TextField{
                            Layout.fillWidth:true
                            id:newItemColor;text:"red";
                        }
                        TextField{
                            Layout.fillWidth:true
                            id:newItemOrientation;text:"90";
                        }
                        Button{
                            Layout.fillWidth:true
                            text:qsTr("Add new item")
                            onClicked: {
                                staticModel.append({"Latitude": myMap.center.latitude,"Longitude":myMap.center.longitude,"Label":newItemName.text , "Color":newItemColor.text, "Orientation":Number(newItemOrientation.text), })
                            }
                        }
                        Button{
                            Layout.fillWidth:true
                            text:qsTr("Clear")
                            onClicked: {
                                staticModel.clear();
                            }
                        }
                    }

                }
                GroupBox{
                    Layout.fillWidth:true
                    title:qsTr("Search POI")
                    Column{
                        width:parent.width
                        TextField{
                            width:parent.width
                            id:searchFieldName;
                            text:qsTr("restaurant");}
                        TextField{
                            Layout.fillWidth:true
                            id:searchFieldRadius;
                            text:"5000";}
                        TextField{
                            Layout.fillWidth:true
                            readOnly: true; text:qsTr("%1 results").arg(psm.count)}
                        Button{
                            Layout.fillWidth:true
                            text:qsTr("update");
                            onClicked:
                            {
                                psm.searchTerm = searchFieldName.text
                                psm.update()
                            }
                        }
                    }

                }
                GroupBox{
                    title:qsTr("adress lookup")
                    Layout.fillWidth:true
                    Column{
                        width:parent.width
                        TextField{ id:searchAddress;
                            width:parent.width
                            text:"Piazza dell'Unità Italiana, 6, 50123 Firenze FI, Italie";}
                        Button{ text:qsTr("update"); onClicked: {
                                geocode.query =  searchAddress.text;
                                geocode.update()
                            }}
                    }

                }




            }

        }


    }
}


