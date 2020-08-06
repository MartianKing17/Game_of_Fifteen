import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.5

Window
{
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Game of fifteen")
    property bool checkFixClick: false
    property int currentClickPosInArr: 0;
    property var currentCoorPos: ({})
    property int tileWidth: width / 4
    property int tileHeight: height / 4

    /*
      Today to next:
      * debugging the GridView
    */

    ListModel
    {
        id: dataModel

        Component.onCompleted:
        {
            let len = 15
            var value

            var tile_color = ["#FF0000", "#0000FF", "#9ACD32"]

            value =
            {
                color: "red",
                index: ""
            }

            var i = 1, j = 0

            for (var k = 0; k < len; ++k)
            {
                if (j > 3)
                {
                    j = 0
                }

               value.color = Number(tile_color[j]).toString()

              if (i === 14)
              {
                 i = 15
              }
              else if (i === 16)
              {
                i = 14
              }

               value.index = Number(i).toString()
               append(value)

               ++i
               ++j
            }

            value.color = "white"
            value.index = ""
            append(value)
        }

    }

    function func(pos)
    {
      var data = dataModel
      var viewer = view

      if (checkFixClick === false)
      {
         currentCoorPos = dataModel[pos].f()
         currentClickPosInArr = pos
         checkFixClick = true
         return
      }

      var coordinateSecondTile = viewer.itemAtIndex(pos).f() // getting coordinate second tile which clicked next
      var checkToGoUp = ((currentCoorPos.y + tileHeight) === coordinateSecondTile.y) // checking the ability to go up
      var checkToGoDown = ((coordinateSecondTile.y + tileHeight) === currentCoorPos.y) // checking the ability to go down
      var checkToGoLeft = ((currentCoorPos.x + tileWidth) === coordinateSecondTile.x) // checking the ability to go left
      var checkToGoRight = ((coordinateSecondTile.x + tileWidth) === currentCoorPos.x) // checking the ability to go right


      if (checkToGoUp || checkToGoDown || checkToGoLeft || checkToGoRight)
      {
          if (dataModel[pos].index === "")
          {
            var temp = dataModel[pos]
            dataModel[pos] = dataModel[currentClickPosInArr]
            dataModel[currentClickPosInArr] = temp
          }
          else
          {
            checkFixClick = false
            currentClickPosInArr = 0
            currentCoorPos = {}
            return
          }
      }
      else
      {
        checkFixClick = false
        return
      }
   }


   GridView
   {
       id: view
       anchors.fill: parent
       model: dataModel
       cellHeight: tileHeight
       cellWidth: tileWidth

       delegate: Tile
       {
           color: model.color
           width: parent.cellWidth
           height: parent.cellHeight
           index: model.index
           border.color: "black"
           border.width: 3

           MouseArea
           {
               anchors.fill: parent
               onClicked: func(view.currentIndex)
           }
      }
  }
}
