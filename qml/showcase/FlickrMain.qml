import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.XmlListModel 2.0

Pane {
    XmlListModel{
       id:flickerModel
       source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + searchTag.text
       onStatusChanged: {
           if (status ==  XmlListModel.Error)
               console.log(errorString())
       }

       query: "/rss/channel/item"
       namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
       XmlRole { name:"title"; query: "title/string()"}
       XmlRole { name:"url"; query: "media:thumbnail/@url/string()"}
    }


    ColumnLayout{
        anchors.fill: parent
        spacing : 10
        TextField{
            id:searchTag
            Layout.fillWidth: true
            placeholderText: qsTr("type your tags here")
            text:"travel"
            Layout.minimumHeight: 10
            Layout.preferredHeight: 50
            Layout.maximumHeight: 100
        }
        GridView{
           id:lstImages
           Layout.fillWidth: true
           Layout.fillHeight: true
           property int nbImage: 3
           cellHeight: height / nbImage
           cellWidth: cellHeight
           delegate:myDelegate
           model: flickerModel
           clip: true
        }
    }

    Component{
        id:myDelegate
        Item{
            height: lstImages.cellHeight
            width: lstImages.cellHeight

            Image{
                id:highQuality
                height: lstImages.cellHeight
                width: lstImages.cellHeight
                source: image.status == Image.Loading ? "" : url.toString().replace("_s","_b")
                visible : status == Image.Ready
            }
            Image{
                id:image
                source: url
                height: lstImages.cellHeight
                width: lstImages.cellHeight
                visible: highQuality.status == Image.Loading
                Label{
                    id:info
                    text:qsTr("%1 - loading:%2 %").arg(title).arg(Math.ceil(highQuality.progress *100))
                }
            }
        }
    }
}
