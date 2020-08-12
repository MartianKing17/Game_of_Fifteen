import QtQuick 2.9
import QtQuick.Controls 1.2

Rectangle {
    property var number: 0


    FontMetrics {
        id: fontMetrics
    }

    Text {
        property var fontPixelSize: 0.075 * parent.width  + 0.4 * parent.height
        anchors.centerIn: parent
        width: fontPixelSize
        height: fontPixelSize
        text: number
        font.pixelSize: Math.min(parent.width, parent.height) / 2
    }
}
