import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle
{
    id: gameOverMenu
    property var window;

    function setDefWin(win)
    {
        window = win
    }

    Text
    {
        id: text
        text: qsTr("Would you like game again?")
        width: (parent.width * 80) / 100
        height: (parent.height * 80) / 100
    }

    Rectangle
    {
        height: (parent.height * 20) / 100
        width: parent.width
        anchors.top: text.bottom
        anchors.topMargin: 5

        Button
        {
           id: restart
           text: "Restart"
           height: parent.height
           width: parent.width / 2
           anchors.left: parent.left
           onClicked:
           {
              enterListOfElement()
              gameOverMenu.visible = false
              window.visible = true
              mix.visible = true
           }
        }

        Button
        {
          id: exit
          text: "Exit"
          height: parent.height
          width: parent.width / 2
          anchors.left: restart.right
          anchors.leftMargin: 5
          onClicked: Qt.quit()
        }
    }
}
