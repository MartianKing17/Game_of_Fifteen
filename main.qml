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
    property int tileHeight: height / 5
    property int tileWidth: width / 4

    /*
      Tommorrow to next:
      * debugging the GridView
      * make animations
    */

    function randomSort()
    {
        var arr = []
        var num = 0;
        var check = false;
        let len = 16;

        for (var i = 1; i < len; ++i)
        {
           num = Math.floor(Math.random() * 16)

           if (num === 0)
           {
             --i
             continue
           }


           for (let j in arr)
           {
               if (arr[j] === num)
               {
                  check = true
                  break
               }
           }

           if (check === true)
           {
              --i
              check = false
              continue
           }

           arr.push(num)
        }

        return arr
    }

    function enterListOfElement()
    {
        var j = 0
        var tile_color = ["#FF0000", "#0000FF", "#9ACD32"];
        var value =
        {
            color: "red",
            index: ""
        };

        dataModel.clear()

        var sum = 0
        var k = 1

        var arr = randomSort()

        for (var c = 1; c < arr.lenght; ++c)
        {
            if (arr[c - 1] > arr[c])
            {
               k = 0
            }

            sum += k
            ++k
        }

        for (let k in arr)
        {
           if (j > 3)
           {
               j = 0
           }

           value.color = Number(tile_color[j]).toString()
           value.index = Number(arr[k]).toString()
           dataModel.append(value)
        }

        value.color = "white"
        value.index = ""
        dataModel.append(value)

        sum += 16
        console.log(sum)
        console.log(sum % 2)
    }

    ListModel
    {
        id: dataModel

        Component.onCompleted:
        {
            enterListOfElement()
        }
    }

    function func(pos)
    {
      var data = dataModel

      if (checkFixClick === false)
      {
         currentCoorPos = data[pos].f()
         currentClickPosInArr = pos
         checkFixClick = true
         return
      }

      var coordinateSecondTile = view.itemAtIndex(pos).f() // getting coordinate second tile which clicked next
      var checkToGoUp = ((currentCoorPos.y + tileHeight) === coordinateSecondTile.y) // checking the ability to go up
      var checkToGoDown = ((coordinateSecondTile.y + tileHeight) === currentCoorPos.y) // checking the ability to go down
      var checkToGoLeft = ((currentCoorPos.x + tileWidth) === coordinateSecondTile.x) // checking the ability to go left
      var checkToGoRight = ((coordinateSecondTile.x + tileWidth) === currentCoorPos.x) // checking the ability to go right


      if (checkToGoUp || checkToGoDown || checkToGoLeft || checkToGoRight)
      {
          if (data[pos].index === "")
          {
            var temp = data[pos]
            data[pos] = data[currentClickPosInArr]
            data[currentClickPosInArr] = temp
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

    OverGameMenu
    {
       id:menu
       visible: false
       anchors.fill: parent
    }

    function checkingGameOver()
    {
       let len = 16
       var data = dataModel

       for (var i = 0; i < len; ++i)
       {
          if (data[i] !== i+1)
          {
             return false
          }
       }

       return true
    }


     GridView
     {
       id: view
       anchors.left: parent.left
       anchors.right: parent.right
       anchors.top: parent.top
       width: parent.width
       height: tileHeight * 4
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
               onClicked:
               {
                   func(view.currentIndex)

                   if(checkingGameOver() === true)
                   {
                       menu.setDefWin(view)
                       view.visible = false
                       menu.visible = true
                   }
               }
           }
        }
    }


  Button
  {
    id: mix
    text: "Mix"
    width: parent.width
    height: parent.height - tileHeight * 4
    anchors.top: view.bottom
    onClicked: enterListOfElement()
  }
}
