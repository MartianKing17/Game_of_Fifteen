import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.5

Window {
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Game of fifteen")
    property int tileHeight: height / 5
    property int tileWidth: width / 4
    property int emptyIndex: 0

    function abs(number) {
        if (number < 0) {
            return number * -1;
        }

        return number;
    }

    function checkIndex(firstIndex, secondIndex) {
        return (abs(firstIndex - secondIndex) === 1) || (abs(firstIndex - secondIndex) === 4)
    }

    function enterListOfElement() {
        var tileColor = ["#FF0000", "#00BFFF", "#9ACD32"];
        var value = {
            color: "red",
            number: ""
        };

        function summary(arr) {
            var sum = 0;
            var sumArr = [];


            for (let i in arr) {

                if (arr[i] === 0) {
                    sum += Number(i) + 1;
                    continue;
                }

                sumArr.push(arr[i]);
            }

            for (var j = 0; j < (sumArr.length - 1); ++j) {

                if (sumArr[j] > sumArr[j+1]) {
                    continue;
                }

                ++sum;
            }

            return sum;
        }

        function randomSort() {
            var arr = [];
            var num = 0;
            var check = false;
            let len = 16;

            for (var i = 0; i < len; ++i) {
                num = Math.floor(Math.random() * 16);

                for (let j in arr) {
                    if (arr[j] === num) {
                        check = true;
                        break;
                    }
                }

                if (check === true) {
                    --i;
                    check = false;
                    continue;
                }

                arr.push(num);
            }

            return arr;
        }

        var sum = 1;
        var arr = [];

        while (sum % 2 !== 0) {
            arr = randomSort();
            sum = summary(arr);
        }


        var j = 0;
        dataModel.clear();

        for (let k in arr) {

            if (j > 2) {
                j = 0;
            }

            if (arr[k] === 0) {
                emptyIndex = k;
                value = {};
                dataModel.append(value);
                continue;
            }

            value.color = tileColor[j];
            value.number = Number(arr[k]).toString();
            dataModel.append(value);
            ++j;
        }
    }

    ListModel {
        id: dataModel

        Component.onCompleted: {
            enterListOfElement()
        }
    }


    function move(index) {
        var data = dataModel;

        function swap(firstIndex, secondIndex) {
            var temp = data.get(firstIndex);
            var a = {color: "", number: ""};
            var b = {color: "", number: ""};

            a.color = temp.color;
            a.number = temp.number;

            temp = data.get(secondIndex);

            b.color =  temp.color;
            b.number = temp.number;

            data.set(firstIndex, b);
            data.set(secondIndex, a);
        }

        function someFunc(index) {

            if (index >= 0 && index < 4) {
                return 0;
            } else if (index >= 4 && index < 8) {
                return 1;
            } else if (index >= 8 && index < 12) {
                return 2;
            } else if (index > 12) {
                return 3;
            }
        }

        if (checkIndex(index, emptyIndex) === true) {
            if (abs(emptyIndex - index) === 1 && (someFunc(index) !== someFunc(emptyIndex))) {
                return;
            }

            data.move(index, emptyIndex, 1);

            if (abs(emptyIndex - index) === 4) {
                var i = index > emptyIndex ? ++emptyIndex : --emptyIndex;
                var add = index > emptyIndex ? 1 : -1;
                var len = index;
                var f = index > emptyIndex ? (i, len) => {return i < len} : (i, len) => {return i > len};

                for (; f(i, len); i += add) {
                    swap(i, i + add);
                }
            }

            emptyIndex = index;
        }
    }

    OverGameMenu {
        id:menu
        visible: false
        anchors.fill: parent
    }

    function checkingGameOver() {
        let len = 15;
        var data = dataModel;

        for (var i = 0; i < len; ++i) {
            if (Number(data.get(i).number) !== i+1) {
                return false;
            }
        }
        return true;
    }

    GridView {
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
        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 1000; easing.type: Easing.OutBounce }
        }


        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight
            Tile {
                color: model.color
                width: view.cellWidth
                height: view.cellHeight
                number: model.number
                border.color: "black"
                border.width: 1
                visible: model.number === "" ? false : true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    move(index);

                    if(checkingGameOver() === true) {
                        menu.setDefWin(view);
                        view.visible = false;
                        menu.visible = true;
                        mix.visible = false;
                    }
                }
            }
        }
    }


    Button {
        id: mix
        text: "Mix"
        width: parent.width
        height: parent.height - tileHeight * 4
        anchors.top: view.bottom
        onClicked: enterListOfElement()
    }
}

