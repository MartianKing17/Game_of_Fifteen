import QtQuick 2.9
import QtQuick.Controls 1.2

Rectangle
{
    property var index: 0
    width: 480
    height: 270

    FontMetrics
    {
      id: fontMetrics
    }

    Text
    {
      property var fontPixelSize: 0.075 * parent.width  + 0.4 * parent.height
      x: (parent.width * 40) / 100
      y: (parent.height * 20) / 100
      // Отцентрировать по fontPixelSize
      // Отцентрировать по fontPixelSize
      width: fontPixelSize
      height: fontPixelSize
      text: index
      font.pixelSize: fontPixelSize
   }

    MouseArea
    {
      id: clickArea
      anchors.fill: parent
      onClicked: func(3)
    }
}
