<center><img src="https://lh3.googleusercontent.com/o21-9p_DBuzEvC8jtRB0dnb-I6QxeIMzEsETrIL137wV9uEUAMq8SVeVK9oN3CkJT3c=s360-rw" alt="QtWorkshop logo" width:"30%"></center>

# QtWorkshop
A workshop project to practice QML [(more)](https://github.com/a-team-fr/QtWorkshop/wiki)

## purpose
The aim of this project is to provide an application squeleton to help practicing Qt and QML during a workshop.
The first experience will be during the QtDay2019 in Firenze. 
It is meant to be a good way for easing any introduction to Qt/Qml workshop, have a try in your Qt meetup !

## How it works ?
The application consists of a list a of _**topics candidate**_ (a.k.a. "TC") to play with (for instance playing with the camera is one TC while playng sounds is another). 
A _**TC**_ is provided with some guidelines to help QML newbies to start with or simply with ideas about what could be done. A set of ressources is also part of the application (for instance a sounds bank, an height map...) so that implementing _**TC**_ is not spoiled with the cumbersome activity to look after suitable assets.

![overview](https://user-images.githubusercontent.com/9682519/53829831-54f23000-3f81-11e9-9e87-e53e99e29683.png)

A _**playground**_ is the implementation of TC for a given player.
When the application starts (from a clean clone and build), it starts with the playground creation :
 * ask for the playground name
 * optionnaly use the camera to create a player profile picture
Once created, the application zip and transfer the playground through a FTP on a remote location.

Using QtCreator, players can modify their playground QML document to implement a given topic.

Using QtWorkshop application, it is possible to switch from one topic to another using the toolbar or select a playground using the left drawer.


![drawermenu](https://user-images.githubusercontent.com/9682519/53829900-7f43ed80-3f81-11e9-889d-36ab6a6de6b2.png)

At anytime, one can download others players playground and/or upload its playground to share its progress using the dedicated buttons on the footer menu or through the integrated playground console.

![playgroundconsole](https://user-images.githubusercontent.com/9682519/53829872-75ba8580-3f81-11e9-87af-dd0c67df553e.png)

As the published playgrounds of others players are actually donwloaded locally, it is easy to browse the QML content - using QML creator, all the playgrounds documents are listed in "others files" (rerun qmake to update if required).

Finally, the application can show the QML content and support live editing (credits to Oleg Yadrov) 

![inlineeditor](https://user-images.githubusercontent.com/9682519/53829885-7a7f3980-3f81-11e9-94e6-32200c0803dc.png)

## topics candidate
[(See the wiki)](https://github.com/a-team-fr/QtWorkshop/wiki) (Work In Progress)

<table style="border:0px;" width="100%">
<tr>
<td><img width="342" height="295" src="https://user-images.githubusercontent.com/9682519/53829928-91be2700-3f81-11e9-86f4-ec95f4aff762.png" alt="topicmap"></td>
<td><img width="342" height="295" src="https://user-images.githubusercontent.com/9682519/53829923-91be2700-3f81-11e9-8277-502d9408b00a.png" alt="topicdataviz"></td>
</tr>
<tr>
<td><img width="342" height="295" src="https://user-images.githubusercontent.com/9682519/53829926-91be2700-3f81-11e9-90e2-66e84521f8a4.png" alt="topicflickr"></td>
<td><img width="342" height="295" src="https://user-images.githubusercontent.com/9682519/53829929-9256bd80-3f81-11e9-9dae-93057e3d7217.png" alt="topicsensors"></td>
</tr></table>

## requirements
It is strongly advised to use the latest stable Qt version (Qt5.12.1 at the time of the project start) but an effort has been made for the project to run with Qt5.9 (untested).

The remote location of playgrounds support HTTPS but only HTTP is used by default to avoid introducing a SSL requirement on local host building QtWorkshop.

## how to start ?

1. git clone the project
' git clone https://github.com/a-team-fr/QtWorkshop.git

2. Open the project with QtCreator

3. Build, run and follow the instructions

## available on iOS and Android
The app has been published but in "showcase" mode : it is not possible to create a playground, upload/download so it is way less interesting. 

The sole purpose of the showcase is to give you an idea of what kind of things you could produce during the workshop.
<center><table style="border:0px;"><tr>
 <td width="300"><a href="https://play.google.com/store/apps/details?id=fr.ateam.qtworkshop"><img height="150" src="https://www.technobuffalo.com/wp-content/uploads/2012/03/google_play_03.jpg" alt="QtWorkshop on Google play"></a></td>
 <td width="300"><a href="https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1454568374&mt=8"><img height="150" src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/App_Store_OS_X.svg/220px-App_Store_OS_X.svg.png" alt="QtWorkshop on AppStore"></a></td>
 </tr></table></center>

## Roadmap
### Version 0.1 - QtDay Firenze
 * features / improvements
   * [x] basic squeleton : able to select topic, select a user with a few topics
   * [x] share playground over ftp : upload / download
   * [X] use the camera to get a profile image when creating the playground
   * [x] add a show details for a given topic candidate to give more information (link to github wiki)
   * [x] add an edit mode showing the QML code, enable modification and update
   * [x] create a warmup topic
   * [x] improve UI/UX
   * [ ] improve syntax highlight
 * Topics
   * [ ] warmup
      * [ ] wiki page created
   * [x] SoundBox
      * [x] wiki page created
   * [x] Camera
      * [ ] wiki page created
   * [x] Map
      * [ ] wiki page created
   * [x] TTS
      * [ ] wiki page created
   * [x] Sensors
      * [ ] wiki page created
   * [x] Uncharted
      * [ ] wiki page created
   * [x] Flick'r
      * [ ] wiki page created
   * [ ] Messy ( a refactoring challenges)
      * [ ] wiki page created
   * [ ] Canvas
      * [ ] wiki page created
   * [ ] Websocket
      * [ ] wiki page created
   * [x] Free
      * [ ] wiki page created
 * Successfully built on
   * MacOs 
     * [x] Qt5.12.1 
     * [ ] Qt5.9.7
   * MS Windows 10
     * [x] Qt5.12.1
   * GNU/Linux (Debian Jessy)
     * [x] Qt5.10.2
 
 ### Version 1.0
  * [ ] chat support
  * [ ] polling
  
