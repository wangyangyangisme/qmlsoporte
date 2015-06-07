import QtQuick 2.0
import Extensions 1.0
import com.components.processes 1.0
import "misfunciones.js" as FuncPpal


Rectangle {
    id:root
    width: 320
    height: 500
    color: "#151518"
    radius: 6
    border.width: 2
    border.color: "#607D8B"

    MouseArea{ //drag window
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XandYAxis
    }

    property var mihostnameAcc
    property alias resultLabel: resultLabel

    function editaAccion(argNserv,argParams,argUbic,argId)
    {
        ventanaEdAccion.textAccName.text=argNserv;
        ventanaEdAccion.textAccParam.text=argParams;
        ventanaEdAccion.textAccProgram.text=argUbic;
        ventanaEdAccion.idAcc.text=argId;
        ventanaEdAccion.visible=true;
    }

    SQLiteModel { id: modelAcciones }

    Component.onCompleted: { FuncPpal.baseQueryListaAcciones();}

    Process{
        id: process
        onError: resultLabel.text = "<font color='red'>" + qsTr("Error") + "</font>"
        onReadyRead: resultLabel.text = process.readAllStandardOutput()
    }

    ListView {
        id: listViewVAcciones
        anchors.bottomMargin: 214
        anchors.topMargin: 50
        anchors.fill: parent; anchors.margins: 5
        delegate: listAccDelegate
        focus: true
    }

    Component {
            id: listAccDelegate
            Item {
            width: listViewVAcciones.width; height: 40; id:itemAcc
            Rectangle{
                color: "#b3a60241";height: 1;width: 262
            Row{
                spacing: 2
                Column{
                    width: 260
                    Text {id:textAcc;text: nombreservicio;color:"#FFC107"}
                    Text {text: parametroprecedente;width: 220;height: 20;wrapMode: Text.WordWrap;color:"#C5CAE9";fontSizeMode: Text.Fit; minimumPixelSize: 6; font.pixelSize: 10 }
                }
                Image{
                       id: itemBtnAcc
                       anchors.verticalCenter: parent.verticalCenter
                       source: "red.png"

                    MouseArea {
                         anchors.fill: parent;
                         onEntered: {
                             itemBtnAcc.source= "grey.png"
                         }
                         onExited: {
                             itemBtnAcc.source= "red.png"
                         }
                         onCanceled: {
                             itemBtnAcc.source= "red.png"
                         }
                         onClicked:{
                              listViewVAcciones.currentIndex = index;

                              var str = parametroprecedente;
                              var res = str.replace("%mpbauser%", miMPBAUser).replace("%mpbapass%", miMPBAPass).replace("%host%", mihostnameAcc);
                              var comando = ubicacion+" "+res.replace(/,/gi," ")//global insensitive
                              process.command=comando
                              process.start();

                         }
                   }
                }

                Image{
                       id: itemBtnEdAcc
                       anchors.verticalCenter: parent.verticalCenter
                       source: "yellow.png"

                    MouseArea {
                         anchors.fill: parent;
                         onEntered: { itemBtnEdAcc.source= "red.png" }
                         onExited: { itemBtnEdAcc.source= "yellow.png" }
                         onCanceled: { itemBtnEdAcc.source= "yellow.png" }
                         onClicked:{ editaAccion(nombreservicio,parametroprecedente,ubicacion,id) }
                   }
                }
            }
            }
            }
        }


    Rectangle {
        id: rectangleFondoCerrar
        y: 259
        height: 200
        color: "#b3000000"
        radius: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5

        Text {
            id: resultLabel
            color: "#cfb411"
            x: 8
            y: 10
            width: 294
            height: 182
            text: qsTr("Salida Consola...")
            textFormat: Text.AutoText
            wrapMode: Text.WordWrap
            font.pixelSize: 10
        }
    }

    Rectangle {
        id: rectangleFondoHostname
        width: 320
        height: 33
        color: "#b3000000"
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 8

        Text {
            id: texthostname
            color: "#FFFFFF"
            text: mihostnameAcc
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 16

            Image {
                id: imageAccCerrar
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.top: parent.top
                anchors.topMargin: 8
                source: "delete.png"

                MouseArea{
                    anchors.fill: parent
                    id:mouseAreaSalir
                    x: 122
                    y: 264
                    onClicked: {
                        root.destroy();
                   }
                }
            }
        }
    }

    EditarAcc{
        id:ventanaEdAccion
        visible: false
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        onVisibleChanged: {
            FuncPpal.baseQueryListaAcciones();
        }
    }    
}

