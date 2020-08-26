import QtQuick 2.12
import QtQuick.Controls 1.2

Rectangle {
    id: gameOverMenu
    property var window;

    function setDefWin(win) {
        window = win;
    }

    Text {
        id: _text
        text: "Would you like game again?"
        width: parent.width * 0.8
        height: parent.height * 0.8
    }

    Rectangle {
        height: gameOverMenu.height - _text.height
        width: parent.width
        anchors.top: _text.bottom
        anchors.topMargin: height / 20

        Button {
            id: restart
            text: "Restart"
            height: parent.height
            width: parent.width / 2.2
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 35
            onClicked: {
                gameOverMenu.visible = false;
                window.visible = true;
            }
        }

        Button {
            text: "Exit"
            height: parent.height
            width: parent.width / 2.2
            anchors.left: restart.right
            anchors.leftMargin: parent.width / 40
            onClicked: Qt.quit()
        }


        Component.onCompleted:
        {
            restart.clicked.connect(mainWindow.signalEnteringElement)
            restart.clicked.connect(mainWindow.mixVisibility)
        }
    }
}
