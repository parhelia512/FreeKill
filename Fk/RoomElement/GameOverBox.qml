// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels
import Fk.Pages
import Fk.Common

GraphicsBox {
  property string winner: "tobechanged"
  property string my_role: "" // 拿不到Self.role
  property var summary: []

  id: root
  title.text: winner !== "" ? (winner.split("+").indexOf(my_role)=== -1 ?
                              luatr("Game Lose") : luatr("Game Win"))
                            : luatr("Game Draw")
  width: 780
  height: queryResultList.height + 96

  /**
  Rectangle {
    id: queryResultList
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width - 30
    height: parent.height - 30 - body.height - title.height
    y: title.height + 10
    color: "#222222"
    radius: 8
    clip: true

    Text {
      text: ""
    }
    ListView {
      id: resultList
      clip: true
      anchors.fill: parent
      //width: parent.width - 5
      orientation: ListView.Vertical
      boundsBehavior: Flickable.StopAtBounds // 禁止列表首尾滑动
      //ScrollBar.horizontal: ScrollBar {}
      //ScrollBar.horizontal: ScrollBar {
        //active: true
      //}
      flickableDirection: Flickable.HorizontalFlick
      contentWidth: 500

      model: ListModel {
        id: model
      }
      header: RowLayout {
        width: resultList.width
        height: 35
        Text {
          id: generalText
          Layout.preferredWidth: 100
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 18
          text: { return luatr("General"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          id: scnameText
          Layout.preferredWidth: 100
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 18
          text: { return luatr("Name"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr("Role"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr("Turn"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr("Recover"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr("Damage"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr("Damaged"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr("Kill"); }
          color: "#D6D6D6"
          font.bold: true
        }
        Text {
          id: honorText
          Layout.preferredWidth: 180
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr("Honor"); }
          color: "#D6D6D6"
          font.bold: true
        }
      }

      delegate: RowLayout {
        width: resultList.width
        height: 35

        Text {
          id: generalText
          Layout.preferredWidth: 100
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 18
          text: {
            let ret = luatr(general);
            if (deputy) {
              ret += "/" + luatr(deputy);
            }
            return ret;
          }
          color: "#D6D6D6"
          elide: Text.ElideRight
          MouseArea{
            id: genralMa
            hoverEnabled: true
            anchors.fill: parent
          }

          ToolTip{
            height: 25
            x: 20
            y: 20
            visible: genralMa.containsMouse && generalText.contentWidth > 95 // 98不行
            contentItem: Text {
              text: {
                let ret = luatr(general);
                if (deputy) {
                  ret += "/" + luatr(deputy);
                }
                return ret;
              }
              color: "#D6D6D6"
            }
            background: Rectangle {
              color: "#222222"
            }
          }
        }
        Text {
          id: scnameText
          Layout.preferredWidth: 100
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 18
          text: scname
          color: "#D6D6D6"
          elide: Text.ElideRight
          MouseArea{
            id: nameMa
            hoverEnabled: true
            anchors.fill: parent
          }

          ToolTip{
            height: 25
            x: 20
            y: 20
            visible: nameMa.containsMouse && scnameText.contentWidth > 95 // 98不行
            contentItem: Text {
              text: scname
              color: "#D6D6D6"
            }
            background: Rectangle {
              color: "#222222"
            }
          }
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: { return luatr(role); }
          color: "#D6D6D6"
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: turn
          color: "#D6D6D6"
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: recover
          color: "#D6D6D6"
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: damage
          color: "#D6D6D6"
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: damaged
          color: "#D6D6D6"
        }
        Text {
          Layout.preferredWidth: 30
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          text: kill
          color: "#D6D6D6"
        }
        Text {
          id: honorText
          //Layout.preferredWidth: 180
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: 20
          fontSizeMode: Text.Fit
          text: honor
          color: "#D6D6D6"
          elide: Text.ElideRight
          MouseArea{
            id: titleMa
            hoverEnabled: true
            anchors.fill: parent
          }

          ToolTip{
            height: 25
            x: 20
            y: 20
            visible: titleMa.containsMouse && honorText.contentWidth > 75
            contentItem: Text {
              text: honor
              color: "#D6D6D6"
            }
            background: Rectangle {
              color: "#222222"
            }
          }
        }
      }
    }
  }
  */

  TableView {
    id: queryResultList
    anchors.horizontalCenter: parent.horizontalCenter
    // width: parent.width - 30
    // height: parent.height - 30 - body.height - title.height
    width: Math.min(contentWidth, parent.width - 30)
    height: contentHeight
    y: title.height + 10
    clip: true
    columnSpacing: 10
    pressDelay: 500

    rowHeightProvider: () => 34
    columnWidthProvider: (col) => {
      let w = explicitColumnWidth(column);
      if (w >= 0)
        return Math.max(40, w);
      return implicitColumnWidth(column);
    }

    model: TableModel {
      id: tableModel
      TableModelColumn { display: "general" }
      TableModelColumn { display: "scname" }
      TableModelColumn { display: "role" }
      TableModelColumn { display: "turn" }
      TableModelColumn { display: "recover" }
      TableModelColumn { display: "damage" }
      TableModelColumn { display: "damaged" }
      TableModelColumn { display: "kill" }
      TableModelColumn { display: "honor" }

      rows: [
        {
          general: `<b>${luatr("General")}</b>`,
          scname: `<b>${luatr("Name")}</b>`,
          role: `<b>${luatr("Role")}</b>`,
          turn: `<b>${luatr("Turn")}</b>`,
          recover: `<b>${luatr("Recover")}</b>`,
          damage: `<b>${luatr("Damage")}</b>`,
          damaged: `<b>${luatr("Damaged")}</b>`,
          kill: `<b>${luatr("Kill")}</b>`,
          honor: `<b>${luatr("Honor")}</b>`,
        }
      ]
    }

    delegate: Text {
      text: display
      color: "#E4D5A0"
      font.pixelSize: 20
      horizontalAlignment: column === 8 ? Text.AlignLeft : Text.AlignHCenter
    }
  }

  RowLayout {
    id: body
    anchors.right: parent.right
    anchors.rightMargin: 15
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10
    width: parent.width
    spacing: 15

    Item { Layout.fillWidth: true }
    MetroButton {
      text: luatr("Back To Room")
      visible: !config.observing

      onClicked: {
        roomScene.resetToInit();
        finished();
      }
    }

    MetroButton {
      text: luatr("Back To Lobby")

      onClicked: {
        if (config.replaying) {
          mainStack.pop();
          Backend.controlReplayer("shutdown");
        } else {
          ClientInstance.notifyServer("QuitRoom", "[]");
        }
      }
    }

    MetroButton {
      id: repBtn
      text: luatr("Save Replay")
      visible: config.observing && !config.replaying // 旁观

      onClicked: {
        repBtn.visible = false;
        lcall("SaveRecord");
        toast.show("OK.");
      }
    }

    MetroButton {
      id: bkmBtn
      text: luatr("Bookmark Replay")
      visible: !config.observing && !config.replaying // 玩家

      onClicked: {
        bkmBtn.visible = false;
        Backend.saveBlobRecordToFile(ClientInstance.getMyGameData()[0].id); // 建立在自动保存录像基础上
        toast.show("OK.");
      }
    }
  }

  function getSummary() {
    const summaryData = leval("ClientInstance.banners['GameSummary']");
    lcall("FindMosts");
    summaryData.forEach((s, index) => {
      let _s = lcall("Entitle", s, index, winner);
      _s.turn = s.turn.toString();
      _s.recover = s.recover.toString();
      _s.damage = s.damage.toString();
      _s.damaged = s.damaged.toString();
      _s.kill = s.kill.toString();
      _s.scname = s.scname; // client拿不到
      _s.role = luatr(_s.role);
      _s.general = luatr(_s.general);
      if (!_s.general) {
        _s.general = "----";
      }
      if (_s.deputy) {
        _s.general = _s.general + "/" + luatr(_s.deputy);
      }
      // model.append(_s);
      tableModel.appendRow(_s)
    });
  }

  onWinnerChanged: {
    let sound;
    if (winner === "") {
      sound = "draw";
    } else {
      let splited = winner.split("+");
      if (splited.includes(my_role)) {
        sound = "win";
      } else {
        sound = "lose";
      }
    }
    Backend.playSound("./audio/system/" + sound);
    getSummary();
  }

  Component.onCompleted: {
    my_role = leval("Self.role");
  }
}
