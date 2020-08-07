import QtQuick 2.9
import QtQuick.Controls 1.2

Rectangle
{
    property var number: 0

    FontMetrics
    {
      id: fontMetrics
    }

    Text
    {
      property var fontPixelSize: 0.075 * parent.width  + 0.4 * parent.height
      x: (parent.width * 40) / 100
      y: (parent.height * 20) / 100
      width: fontPixelSize
      height: fontPixelSize
      text: number
      font.pixelSize: fontPixelSize
   }
}
