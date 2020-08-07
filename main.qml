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
    property var currentCoorPos: ({x, y})
    property int tileHeight: height / 5
    property int tileWidth: width / 4


      // To do to next week:
      // * make animations
      // * debugging mix bug


    function enterListOfElement()
    {
        var tileColor = ["#FF0000", "#00BFFF", "#9ACD32"];
        var value =
        {
            color: "red",
            number: ""
        };

        function summary(arr)
        {
            var sum = 0
            var sumArr = []


            for (let i in arr)
            {

                if (arr[i] === 0)
                {
                   sum += Number(i) + 1
                   continue
                }

                sumArr.push(arr[i])
            }

            for (var j = 0; j < (sumArr.length - 1); ++j)
            {

               if (sumArr[j] > sumArr[j+1])
               {
                  continue
               }

               ++sum
            }

            return sum
        }

        function randomSort()
        {
            var arr = []
            var num = 0;
            var check = false;
            let len = 16;

            for (var i = 0; i < len; ++i)
            {
               num = Math.floor(Math.random() * 16)

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

        var sum = 1
        var arr = []

        while (sum % 2 !== 0)
        {
            arr = randomSort()
            sum = summary(arr)
        }


        var j = 0
        dataModel.clear()

        for (let k in arr)
        {
           if (j > 2)
           {
               j = 0
           }

           if (arr[k] === 0)
           {
               value.color = "white"
               value.number = ""
               dataModel.append(value)
               continue
           }

           value.color = tileColor[j]
           value.number = Number(arr[k]).toString()
           dataModel.append(value)
           ++j
        }
    }

    ListModel
    {
        id: dataModel

        Component.onCompleted:
        {
            enterListOfElement()
        }
    }

    function func(item, index, width, height)
    {

      function indexing(index)
      {
         var x = 0, y = 0

         if (index <= 3)
         {
            x = index
            y = 0
         }
         else if (index > 3 && index <= 7)
         {
            x = index - 4
            y = 1
         }
         else if (index > 7 && index <= 11)
         {
             x = index - 8
             y = 2
         }
         else if (index > 11 && index <= 15)
         {
             x = index - 12
             y = 3
         }

         return {x, y}
      }

      var data = dataModel

      // Maybe bug here

      if (checkFixClick === false)
      {
         if (item.number === "")
         {
           return
         }
         var coordinateFirstTile = {x, y}
         coordinateFirstTile = indexing(index)
         currentCoorPos.x = coordinateFirstTile.x * width
         currentCoorPos.y = coordinateFirstTile.y * height
         currentClickPosInArr = index
         checkFixClick = true
         return
      }

      if (currentClickPosInArr === index && item.number !== "")
      {
         return
      }

      var coordinateSecondTile =  {x, y} // getting coordinate second tile which clicked next
      coordinateSecondTile = indexing(index)
      coordinateSecondTile.x = coordinateSecondTile.x * width
      coordinateSecondTile.y = coordinateSecondTile.y * height

      var checkToGoUp = ((coordinateSecondTile.y + tileHeight) === currentCoorPos.y) // checking the ability to go up
      var checkToGoDown = ((currentCoorPos.y + tileHeight) === coordinateSecondTile.y) // checking the ability to go down
      var checkToGoLeft = ((coordinateSecondTile.x + tileWidth) === currentCoorPos.x) // checking the ability to go left
      var checkToGoRight = ((currentCoorPos.x + tileWidth) === coordinateSecondTile.x) // checking the ability to go right

      if (checkToGoUp || checkToGoDown || checkToGoLeft || checkToGoRight)
      {
          if (item.number === "")
          {
            var swap =
            {
              color : "",
              number : ""
            };

            var temp = data.get(index)
            swap.color = temp.color
            swap.number = temp.number
            data.set(index , data.get(currentClickPosInArr))
            data.set(currentClickPosInArr, swap)
            checkFixClick = false
            currentClickPosInArr = 0
            currentCoorPos = {}
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
       let len = 15
       var data = dataModel

       for (var i = 0; i < len; ++i)
       {
          if (Number(data.get(i).number) !== i+1)
          {
             return false
          }
       }

       return true
    }

    function test()
    {
       var data = dataModel

       var value =
       {
          color : "red",
          number : ""
       }

       data.clear()

       var arr = []

       let len = 16

       for (var i = 1; i < len; ++i)
       {
          arr.push(i)
       }

       for (let i in arr)
       {
          value.number = Number(arr[i]).toString()
          data.append(value)
       }

       value.color = "white"
       value.number = ""
       data.append(value)
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
       interactive: false

       delegate: Tile
       {
           id: tile
           color: model.color
           width: view.cellWidth
           height: view.cellHeight
           number: model.number
           border.color: "black"
           border.width: 1

           MouseArea
           {
               anchors.fill: parent
               onClicked:
               {
                   func(view.children[0].children[index], index, view.cellWidth, view.cellHeight)

                   if(checkingGameOver() === true)
                   {
                       menu.setDefWin(view)
                       view.visible = false
                       menu.visible = true
                       mix.visible = false
                   }
               }
           }
        }

      PropertyAnimation
      {
         id: animation
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

