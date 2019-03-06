import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
import SortFilterProxyModel 0.2
import fr.ateam.qtworkshop 1.0
import "./component"

Drawer {
    id:root



    SortFilterProxyModel{
        id: filteredList
        sourceModel: NavMan.selectedPlaygroundList
        sorters: StringSorter { roleName: NavMan.idAliasRoleName;  }
        filters: RegExpFilter {
                roleName: NavMan.idAliasRoleName
                pattern: "^" + searchAlias.text
                caseSensitivity: Qt.CaseInsensitive
            }
    }

    ColumnLayout {
        anchors.fill:parent
        Frame {
            Layout.fillWidth: true
            RowLayout{
                width:parent.width
                TextField {
                    id: searchAlias
                    Layout.fillWidth: true
                    topPadding: 0
                    bottomPadding: 0
                    focus: true
                    selectByMouse: true
                    background: null
                    placeholderText: qsTr("Search")
                }
                FAButton {
                    //Layout.preferredHeight: 30
                    //Layout.preferredWidth: 30
                    Layout.fillHeight: true
                    //background.color:"transparent"
                    enabled:false
                    icon: "\uf002"
                }
            }
        }


        ScrollView{
            Layout.fillWidth: true
            Layout.fillHeight: true
            ListView{
                id:listView
                anchors.fill: parent
                model:filteredList
                clip:true
                delegate: ItemDelegate{
                    width:listView.width
                    highlighted:  model[NavMan.idAliasRoleName] === NavMan.selectedAlias
                    RowLayout{
                        anchors.fill: parent
                        Image{


                            source: NavMan.docRoot + model[NavMan.idAliasRoleName] + "/profile.png"
                            Layout.preferredHeight: 30
                            Layout.preferredWidth : Layout.preferredHeight
                            fillMode: Image.PreserveAspectFit
                        }
                        Label{
                            text:model[NavMan.idAliasRoleName]
                            elide : Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    onClicked:{
                        NavMan.selectedAlias = model[NavMan.idAliasRoleName]
                        root.close();
                    }
                }
            }
        }


        FAButton {
            Layout.preferredHeight: 50
            Layout.fillWidth: true
            color:"yellow"
            icon: "\uf0ed" //"\uf0ee"
            label:qsTr("Download")
            onClicked:NavMan.queryLstPublishedAliases.reload()
        }
    }
}
