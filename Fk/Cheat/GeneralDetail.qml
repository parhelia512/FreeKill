// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Flickable {
  id: root
  anchors.fill: parent
  property var extra_data: ({})

  signal finish()

  contentHeight: details.height
  ScrollBar.vertical: ScrollBar {}

  ColumnLayout {
    id: details
    width: parent.width - 40
    x: 20

    TextEdit {
      id: skillDesc

      Layout.fillWidth: true
      font.pixelSize: 18
      color: "#E4D5A0"

      readOnly: true
      selectByKeyboard: true
      selectByMouse: false
      wrapMode: TextEdit.WordWrap
      textFormat: TextEdit.RichText
    }
  }

  onExtra_dataChanged: {
    if (!extra_data.generals) return;
    skillDesc.text = "";

    extra_data.generals.forEach((g) => {
      const data = lcall("GetGeneralDetail", g);
      skillDesc.append(luatr(data.kingdom) + " " + luatr(g) + " " + (data.hp === data.maxHp
        ? ((g.startsWith('hs__') || g.startsWith('ld__') || g.includes('heg__'))
          ? ((data.mainMaxHp != 0 || data.deputyMaxHp != 0)
            ? ((data.hp + data.mainMaxHp) / 2 + '/' + (data.hp + data.deputyMaxHp) / 2)
            : data.hp / 2)
          : data.hp)
        : data.hp + "/" + data.maxHp));
      if (data.headnote !== "") skillDesc.append("<font color=\"lightslategrey\">" + luatr(data.headnote) + "</font>");
      if (data.companions.length > 0){
        let ret = '';
        ret +="<font color=\"slategrey\"><b>" + luatr("Companions") + "</b>: ";
        data.companions.forEach(t => {
          ret += luatr(t) + ' '
        });
        skillDesc.append(ret)
      }
      data.skill.forEach(t => {
        skillDesc.append((t.is_related_skill ? "<font color=\"purple\"><b>" : "<b>") + luatr(t.name) +
          "</b>: " + t.description + (t.is_related_skill ? "</font>" : ""));
      });
      if (data.endnote !== "") skillDesc.append("<font color=\"lightslategrey\">" + luatr(data.endnote) + "</font>");
      skillDesc.append("\n");
    });
  }
}
