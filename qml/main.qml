import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import fr.ateam.qtworkshop 1.0
import SyntaxHighlighter 1.1

import "./component"

ApplicationWindow {
    id:mainApp
    visible: true
    width: 640
    height: 960
    title: qsTr("QtDay 2019 - workshop")

    Binding{  target:playgroundManager; property:"playgroundName"; value:NavMan.myAlias  }
    Binding{  target:playgroundManager; property:"templatePath"; value: (NavMan.templatePath)  }
    Binding{  target:playgroundManager; property:"localPlaygroundRootPath"; value:(NavMan.localDocRoot)  }
    Binding{  target:playgroundManager; property:"remotePlaygroundRootPath"; value:(NavMan.remoteRoot)  }

    header:TopicSelection{
        id:topic
        width:mainApp.width
        height:visible ? 54 : 0
        Behavior on height{ NumberAnimation{ duration:500}}
        visible : NavMan.showTopicSelector
    }

    LeftMenu{
        id:leftMenu
        y:topic.height
        width:mainApp.contentItem.width * .3
        height:mainApp.contentItem.height
    }

    Row{
        x:leftMenu.position * leftMenu.width
        width:parent.width - x
        height:parent.height
        Flickable{
            id:flick
            width:NavMan.showDocumentCode ? parent.width /2 : 0
            height : parent.height
            visible:NavMan.showDocumentCode && NavMan.isCodeShowable
            contentHeight: editor.contentHeight
            contentWidth: width
            clip:true
            flickableDirection: Flickable.VerticalFlick
            TextArea{
                id:editor
                x:2;y:2
                width : parent.width - 4
                text:playgroundManager.readDocument(NavMan.currentPage)
                wrapMode: Text.WordWrap
                selectByMouse: true
                textFormat: TextEdit.PlainText
                inputMethodHints: Qt.ImhNoPredictiveText

                SyntaxHighlighter {
                    id: syntaxHighlighter

                    normalColor: "white"
                    commentColor: "grey"
                    numberColor: "red"
                    stringColor: "orange"
                    operatorColor: "yellow"
                    keywordColor: "lightgreen"
                    builtInColor: "cyan"
                    markerColor: "green"
                    itemColor: "red"
                    propertyColor: "yellow"
                }

                Component.onCompleted: {
                    syntaxHighlighter.setHighlighter(editor)
                }
            }
            FAButton{
                anchors.right: parent.right//loader.x-width
                parent:flick
                y:0
                icon:"\uf021"
                color:"green"
                //text:qsTr("update")
                width:50;height:width
                onClicked: {
                    playgroundManager.writeDocument(NavMan.currentPage, editor.text)
                    loader.source=""
                    qmlEngine.clearCache();
                    loader.source= Qt.binding(function(){ return NavMan.currentPage;})
                }
            }
        }



        Loader{
            id:loader
            width:flick.visible ? parent.width /2 : parent.width
            height : parent.height
            source: NavMan.currentPage

            Label{
                text:qsTr("loading document...please wait")
                color : "red"
                opacity : 1 - loader.progress
                anchors.centerIn: parent
                visible:loader.status === Loader.Loading
            }

            Connections{
                ignoreUnknownSignals: true
                target : loader.item
                onCloseUploadPanel : NavMan.showUploadPanel = false
            }
        }
    }



    footer:RowLayout{
        width:mainApp.width
        height : 40
        FAButton{
            label: leftMenu.visible ? qsTr("Close menu") : qsTr("Open menu")
            visible:!showCaseMode && !NavMan.showWelcome
            //Layout.fillHeight: true
            //Layout.preferredWidth: 100
            icon:"\uf0a8"
            iconRotation: leftMenu.position * 180
            onClicked: leftMenu.visible ? leftMenu.close() : leftMenu.open()
        }

        Switch{
            Layout.alignment: Qt.AlignRight
            checked: NavMan.showDocumentCode
            visible: NavMan.isCodeShowable &&  !NavMan.showWelcome
            text:qsTr("Show code")
            onCheckedChanged: NavMan.showDocumentCode = !NavMan.showDocumentCode
        }

        Switch{
            Layout.alignment: Qt.AlignRight
            checked: NavMan.showPlaygroundConsole
            text:qsTr("Show console")
            visible:!NavMan.showWelcome
            onCheckedChanged: NavMan.showPlaygroundConsole = !NavMan.showPlaygroundConsole
        }
        FAButton {
            color:"yellow"
            icon: "\uf0ee"
            visible:!NavMan.showWelcome
            onClicked:playgroundManager.uploadPlayground();
        }

        FAButton {
            color:"yellow"
            icon: "\uf0ed"
            visible:!NavMan.showWelcome
            onClicked:NavMan.queryLstPublishedAliases.reload()
        }

        FAButton {
            color:"lightgreen"
            icon: "\uf059"
            visible:NavMan.currentTopic>=0 && NavMan.lstTopics.get(NavMan.currentTopic).details && !NavMan.showWelcome
            onClicked:Qt.openUrlExternally(NavMan.lstTopics.get(NavMan.currentTopic).details)
        }

    }


}
