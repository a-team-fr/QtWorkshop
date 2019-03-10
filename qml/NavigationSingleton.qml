import QtQuick 2.2
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
pragma Singleton

Item {
    id:root
    /*------------------------------------------------------------------------------------------
                Settings
    ------------------------------------------------------------------------------------------*/
    property var settings : Settings{
        property string myAlias : ""
        property bool showWelcome : true
        property url localDocRoot : playgroundManager.filePathToUrl(sourcePath+"/playgrounds/")
    }

    Component.onCompleted: console.log("DocRoot"+localDocRoot)
    Component.onDestruction: {
        settings.myAlias = myAlias;
        settings.localDocRoot = localDocRoot;
        settings.showWelcome = showWelcome

    }

    function resetSettings()
    {

        myAlias = "";
        playgroundManager.playgroundName = "";
        settings.myAlias = ""
        showWelcome = true;
        settings.showWelcome = true;
        settings.localDocRoot = playgroundManager.filePathToUrl(sourcePath+"/playgrounds/")
        localDocRoot = playgroundManager.filePathToUrl(sourcePath+"/playgrounds/")

    }

    /*------------------------------------------------------------------------------------------
                kinda inputs (modified from anywhere outside)
    ------------------------------------------------------------------------------------------*/
    property string myAlias : settings.myAlias
    property url localDocRoot : settings.localDocRoot// playgroundManager.filePathToUrl(sourcePath+"/playgrounds/")//"file://"+sourcePath+"/playgrounds/"//settings.localDocRoot
    property bool showWelcome : settings.showWelcome

    property bool useRemote : false
    property int currentTopic : showCaseMode ? -1 : 0 //managed by TopicSelection.qml
    property string selectedAlias : myAlias //managed by LeftMenu.qml
    property bool showPlaygroundConsole : false //managed by LeftMenu.qml
    property bool showTopicSelector : isAliasSelected && !showPlaygroundConsole && !showWelcome
    property bool showDocumentCode : false

    /*------------------------------------------------------------------------------------------
                kinda output (usefull properties with readonly binding)
    ------------------------------------------------------------------------------------------*/
    readonly property url templatePath : playgroundManager.filePathToUrl(sourcePath+"/qml/template")//"file://"+sourcePath+"/qml/template"
    readonly property var selectedPlaygroundList : useRemote ? remotePlaygrounds : localPlaygrounds
    readonly property url docRoot : useRemote ? remoteRoot : localDocRoot
    readonly property url remoteRoot : "http://a-team.fr/qtworkshop/"
    readonly property bool isAliasSelected : selectedAlias.length > 0
    readonly property bool isTopicSelected : currentTopic > -1
    readonly property string idAliasRoleName : useRemote ? "uidAlias" :"fileName"
    readonly property bool isCodeShowable : currentPage.toString().slice(0,3) !== "qrc"

    readonly property url currentPage : {
        if (showPlaygroundConsole)
            return "qrc:/qml/PlaygroundConsole.qml";
        if (showCaseMode){
            if (!isTopicSelected) return "qrc:/qml/Showcase.qml";
            else return "qrc:/qml/showcase/"+ lstTopics.get(currentTopic).qmlName;
        }
        if (!selectedAlias || showWelcome)
            return "qrc:/qml/Welcome.qml";

        console.info("Playing document : "+docRoot + selectedAlias+"/"+ lstTopics.get(currentTopic).qmlName);
        return docRoot + selectedAlias+"/"+ lstTopics.get(currentTopic).qmlName;

    }

    readonly property var fa:FontLoader{ source: "qrc:/qml/component/fontawesome-webfont.ttf" }

    /*------------------------------------------------------------------------------------------
                Models
    ------------------------------------------------------------------------------------------*/
    property var lstTopics : ListModel{
        ListElement{ label:"Warmup"; image:"\uf2cb"; qmlName:"WarmupMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Warmup" }
        ListElement{ label:"SoundBox"; image:"\uf1c7"; qmlName:"SoundBoxMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Soundbox" }
        ListElement{ label:"Camera"; image:"\uf030"; qmlName:"CameraMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Camera" }
        ListElement{ label:"Map"; image:"\uf279"; qmlName:"MapMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Map" }
        ListElement{ label:"TTS"; image:"\uf29d"; qmlName:"TTSMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/TTS" }
        ListElement{ label:"Sensors"; image:"\uf076"; qmlName:"SensorsMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Sensors" }
        ListElement{ label:"Uncharted"; image:"\uf1fe"; qmlName:"DatavizMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/DataViz" }
        ListElement{ label:"Flick'r"; image:"\uf16e"; qmlName:"FlickrMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Flickr" }
        ListElement{ label:"Messy"; image:"\uf165"; qmlName:"MessyMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Messy" }
        ListElement{ label:"Canvas"; image:"\uf044"; qmlName:"CanvasMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Canvas" }
        ListElement{ label:"Free"; image:"\uf2c5"; qmlName:"FreeMain.qml"; details:"https://github.com/a-team-fr/QtWorkshop/wiki/Free" }
    }

    FolderListModel{
        id:localPlaygrounds
        showDotAndDotDot: false
        showHidden: false
        showFiles:false
        showOnlyReadable: true
        folder:root.docRoot//sourcePath+"/playgrounds/"//root.docRoot
        onCountChanged: console.log("There are "+count+" playgrounds in "+folder)
        Component.onCompleted: folder = root.docRoot //needed with Windows OS (??)
        onFolderChanged: {
            if (folder === root.docRoot) return;
            console.log("Hey you stupid MSWindows, I said I want folder to be ("+ root.docRoot + ") not ("+folder+")")
            folder =root.docRoot
        }
    }


    QtObject{
        id:queryListFolder
        property var lstModel: null
        property bool ready : xhr.readyState === XMLHttpRequest.DONE
        property var xhr : {
               xhr = new XMLHttpRequest();
               xhr.onreadystatechange = function() {
                   if(xhr.readyState === XMLHttpRequest.DONE)
                       lstModel = Qt.createQmlObject(xhr.responseText.toString(), queryListFolder,"queryListFolder");
               }

               reload()
           }
        function reload(){
            xhr.open("GET", remoteRoot + "ListFolder.php"); //https would work but it is better to avoid openssl requirement
            xhr.send();
        }

    }
    property var queryLstPublishedAliases : queryLstPublishedAliases
    QtObject{
        id:queryLstPublishedAliases
        signal reloaded();
        property bool loaded : false
        property var lstModel: null
        property var xhr : {
               xhr = new XMLHttpRequest();
               xhr.onreadystatechange = function() {
                   if(xhr.readyState === XMLHttpRequest.DONE)
                   {
                       lstModel = Qt.createQmlObject(xhr.responseText.toString(), queryLstPublishedAliases,"queryLstPublishedAliases");
                       queryLstPublishedAliases.reloaded();
                       if (queryLstPublishedAliases.loaded){
                           queryLstPublishedAliases.downloadAllPlaygrounds()
                           console.log("Download all others playground");
                       }
                       queryLstPublishedAliases.loaded = true;

                   }
               }

               reload()
           }
        function reload(){
            console.log("reload playgrounds list");
            xhr.open("GET", remoteRoot + "ListZipFiles.php");
            xhr.send();
        }
        function downloadAllPlaygrounds(){
            for ( var i =0; i < root.lstPublishedAliases.count; i++)
            {
                var a = root.lstPublishedAliases.get(i).uidAlias;
                if ( a === root.myAlias) continue;

                playgroundManager.triggerDownload( root.remoteRoot + a +".zip" , playgroundManager.urlToFilePath(root.localDocRoot+ a + ".zip"));
            }
        }

    }
    property var remotePlaygrounds : queryListFolder.lstModel
    property var lstPublishedAliases : queryLstPublishedAliases.lstModel

    function isAliasAlreadyUsed( aliasToTry)
    {
        for ( var i =0; i < lstPublishedAliases.count; i++)
        {
            if (lstPublishedAliases.get(i).uidAlias === aliasToTry)
                return true;
        }
        return false;
    }





}




