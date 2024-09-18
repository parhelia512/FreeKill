// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Fk

Item {
  property alias cards: cardArea.cards
  property alias length: cardArea.length
  property var selectedCards: []
  property var movepos

  signal cardSelected(int cardId, bool selected)

  id: area

  CardArea {
    anchors.fill: parent
    id: cardArea
    onLengthChanged: area.updateCardPosition(true);
  }

  function add(inputs)
  {
    cardArea.add(inputs);
    if (inputs instanceof Array) {
      for (let i = 0; i < inputs.length; i++)
        filterInputCard(inputs[i]);
    } else {
      filterInputCard(inputs);
    }
  }

  function filterInputCard(card)
  {
    card.autoBack = true;
    card.draggable = lcall("CanSortHandcards", Self.id);
    card.selectable = false;
    card.clicked.connect(adjustCards);
    card.released.connect(updateCardReleased);
    card.xChanged.connect(updateCardDragging);
  }

  function remove(outputs)
  {
    const result = cardArea.remove(outputs);
    let card;
    for (let i = 0; i < result.length; i++) {
      card = result[i];
      card.draggable = false;
      card.selectable = false;
      card.selectedChanged.disconnect(adjustCards);
      card.released.disconnect(updateCardReleased);
      card.xChanged.disconnect(updateCardDragging);
      card.prohibitReason = "";
    }
    return result;
  }

  function enableCards(cardIds)
  {
    let card, i;
    cards.forEach(card => {
      card.selectable = cardIds.includes(card.cid);
      if (!card.selectable) {
        card.selected = false;
        unselectCard(card);
      }
    });
    updateCardPosition(true);
  }

  function updateCardPosition(animated)
  {
    cardArea.updateCardPosition(false);

    cards.forEach(card => {
      if (card.selected) {
        card.origY -= 20;
      }
      if (!card.selectable) {
        if (config.hideUseless) {
          card.origY += 60;
        }
      }
    });

    if (animated) {
      cards.forEach(card => card.goBack(true));
    }
  }

  function updateCardDragging()
  {
    let _card, c;
    let index;
    for (index = 0; index < cards.length; index++) {
      c = cards[index];
      if (c.dragging) {
        _card = c;
        break;
      }
    }
    if (!_card) return;
    _card.goBackAnim.stop();
    _card.opacity = 0.8

    let card;
    movepos = null;
    for (let i = 0; i < cards.length; i++) {
      card = cards[i];
      if (card.dragging) continue;

      if (card.x > _card.x) {
        movepos = i - (index < i ? 1 : 0);
        break;
      }
    }
    if (movepos == null) { // 最右
      movepos = cards.length;
    }
  }

  function updateCardReleased(_card)
  {
    let i;
    if (movepos != null) {
      i = cards.indexOf(_card);
      cards.splice(i, 1);
      cards.splice(movepos, 0, _card);
      movepos = null;
    }
    updateCardPosition(true);
  }

  function adjustCards()
  {
    area.updateCardPosition(true);

    for (let i = 0; i < cards.length; i++) {
      const card = cards[i];
      if (card.selected) {
        if (!selectedCards.includes(card))
          selectCard(card);
      } else {
        if (selectedCards.includes(card))
          unselectCard(card);
      }
    }
  }

  function selectCard(card)
  {
    selectedCards.push(card);
    cardSelected(card.cid, true);
  }

  function unselectCard(card)
  {
    for (let i = 0; i < selectedCards.length; i++) {
      if (selectedCards[i] === card) {
        selectedCards.splice(i, 1);
        cardSelected(card.cid, false);
        break;
      }
    }
  }

  function unselectAll(exceptId) {
    let card = undefined;
    for (let i = 0; i < selectedCards.length; i++) {
      if (selectedCards[i].cid !== exceptId) {
        selectedCards[i].selected = false;
      } else {
        card = selectedCards[i];
        card.selected = true;
      }
    }
    if (card === undefined) {
      selectedCards = [];
    } else {
      selectedCards = [card];
    }
    updateCardPosition(true);
  }
}
