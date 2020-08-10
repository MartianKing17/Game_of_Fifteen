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
    property int tileHeight: height / 5
    property int tileWidth: width / 4
    property int emptyIndex: 0
    property int moveToX: 0
    property int moveToY: 0


      // Today to next:
      // * make animations

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

    function checkIndex(firstIndex, secondIndex)
    {
       if ((firstIndex - 1 === secondIndex) || (secondIndex - 1 === firstIndex))
       {
          return true
       }
       else if ((firstIndex - 4 === secondIndex) || (secondIndex - 4 === firstIndex))
       {
          return true
       }
       else
       {
          return false
       }
    }

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
               emptyIndex = k
               var pos = indexing(k)
               moveToX = pos.x
               moveToY = pos.y
               value = {}
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


    function move(index)
    {
        var data = dataModel

        if (checkIndex(index, emptyIndex) === true)
        {
            var value = data.get(index)
            var swap = {color: "", number: ""}
            var val1 = {color: "", number: ""}
            swap.color = value.color
            swap.number = value.number

            for (var i = 0; i < data.count; ++i)
            {
                if (i === emptyIndex)
                {
                   data.set(emptyIndex, swap)
                }

                if (i === index)
                {
                   val1.color = "white"
                   val1.number = ""
                   data.set(index, val1)
                }
            }

            emptyIndex = index
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

               Behavior on x
               {
                 SpringAnimation {to: moveX; spring: 2; damping: 0.3}
               }

               Behavior on y
               {
                 SpringAnimation {to: moveY; spring: 2; damping: 0.3}
               }


               MouseArea
               {
                   anchors.fill: parent
                   onClicked:
                   {
                       move(index)

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

       move: Transition {
           NumberAnimation { properties: "x,y"; duration: 1000; easing.type: Easing.OutBounce }
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

