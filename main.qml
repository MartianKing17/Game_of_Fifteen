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

    /*
      Tomorrow to next:
      * "waiting click" if (click) then rewrite array in func(pos)
      * debugging the GridView
      * centering text pos
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
       console.log(pos)

       var data = dataModel
       var viewer = view


       // search free cell +
       // if (!available free cell in a area) +
       //  do nothing +
       // else
       // "waiting click" if (click) then rewrite array

       /*
       if (pos % 4 === 0) // for 4, 8, 12, 16
       {
            if (pos === 4)
            {
                if (data[3].index === "")
                {
                   if (viewer.itemAtIndex(3).clickArea.clicked)
                   {
                      console.log("Clicked 3")
                   }
                }
                else if (data[8].index === "")
                {

                }
                else
                {
                    return
                }
            }
            else if (pos === 16)
            {
                if (data[12].index === "")
                {

                }
                else if (data[15].index === "")
                {

                }

                else
                {
                    return
                }
            }
            else
            {
               if (data[pos - 4].index === "")
               {

               }
               else if (data[pos - 1].index === "")
               {

               }
               else if (data[pos + 4].index === "")
               {

               }
               else
               {
                   return
               }
            }
       }

       else if (pos % 4 === 1 && pos !== 15)// for 1, 5, 9, 13
       {
            if (pos === 1)
            {
                if (data[2].index === "")
                {

                }
                else if (data[5].index === "")
                {

                }
                else
                {
                    return
                }
            }
            else if (pos === 13)
            {
                if (data[9].index === "")
                {

                }
                else if (data[14].index === "")
                {

                }
                else
                {
                    return
                }
            }
            else
            {
               if (data[pos - 4].index === "")
               {

               }
               else if (data[pos - 1].index === "")
               {

               }
               else if (data[pos + 4].index === "")
               {

               }
               else
               {
                   return
               }
            }
       }
       else if (pos > 1 && pos < 4) // for 2, 3
       {
            if (data[pos - 1].index === "")
            {

            }
            else if (data[pos + 1].index === "")
            {

            }
            else if (data[pos + 4].index === "")
            {

            }
            else
            {
                return
            }
       }
       else if (pos > 13 && pos < 16) // for 14, 15
       {
            if (data[pos - 1].index === "")
            {

            }
            else if (data[pos + 1].index === "")
            {

            }
            else if (data[pos - 4].index === "")
            {

            }
            else
            {
                return
            }
       }
       else // for other's
       {
            if (data[pos - 4].index === "")
            {

            }
            else  if (data[pos + 4].index === "")
            {

            }
            else  if (data[pos - 1].index === "")
            {

            }
            else  if (data[pos + 1].index === "")
            {

            }
            else
            {
                return
            }
       }
       */

    }

    /*
    GridView
    {
        id: view
        anchors.fill: parent
        model: dataModel
        cellHeight: parent.height / 4
        cellWidth:  parent.width / 4

        delegate: Tile
        {
            color: model.color
            width: parent.cellWidth
            height: parent.cellHeight
            index: model.index
            border.color: "black"
            border.width: 3
        }
    }
    */




    Tile
           {
               color: "red"
               width: parent.width / 4
               height: parent.height / 4
               index: 1
               border.color: "black"
               border.width: 3
           }

}
