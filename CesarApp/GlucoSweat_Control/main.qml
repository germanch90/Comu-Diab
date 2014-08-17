import QtQuick 2.2
import QtQuick.Controls 1.1
import QtSensors 5.3

ApplicationWindow {
    title: qsTr("Accelerate Logo")
    id: mainWindow
    visible: true
    width: 640
    height: 480
    color: "#343434"

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    Image {
        id: icon
        smooth: true
        property real centerX: mainWindow.width / 2
        property real centerY: mainWindow.height / 2
        property real iconCenterX: icon.width / 2
        property real iconCenterY: icon.height / 2
        x: centerX - iconCenterX
        y: centerY - iconCenterY
        width: 312
        height: 216
        source: "LOGO.png"

        Behavior on y {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
        Behavior on x {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
    }
    Accelerometer {
        id: accel
        dataRate:100
        active: true

        onReadingChanged: {
            var newX = (icon.x + calcRoll(accel.reading.x, accel.reading.y, accel.reading.z) * 0.1)
            var newY = (icon.y - calcPitch(accel.reading.x, accel.reading.y, accel.reading.z) * 0.1)

            if (isNaN(newX) || isNaN(newY))
                return;

            if (newX < 0)
                newX = 0

            if (newX > mainWindow.width - icon.width)
                newX = mainWindow.width - icon.width

            if (newY < 18)
                newY = 18

            if (newY > mainWindow.height - icon.height)
                newY = mainWindow.height - icon.height

                icon.x = newX
                icon.y = newY
        }
    }
    function calcPitch(x, y, z) {
        return -(Math.atan(y / Math.sqrt(x * x + z * z)) * 57.2957795);
    }
    function calcRoll(x, y, z) {
        return -(Math.atan(x / Math.sqrt(y * y + z * z)) * 57.2957795);
    }
}

