import 'dart:html';
import 'dart:math';

enum Players { first, second }

final ButtonElement rollBtn = querySelector('.roll-dice-btn');
final ButtonElement holdBtn = querySelector('.hold-points-btn');
final ButtonElement newGameBtn = querySelector('.new-game-btn');
final ImageElement dice = querySelector('.dice');
final intGenerator = Random();
final scores = {
  Players.first: 0,
  Players.second: 0,
};
final namePanels = {
  Players.first: querySelector('#name-0') as DivElement,
  Players.second: querySelector('#name-1') as DivElement,
};
final playerBlocks = {
  Players.first: querySelector('.player--0') as DivElement,
  Players.second: querySelector('.player--1') as DivElement,
};
final scorePanels = {
  Players.first: querySelector('#score-0') as DivElement,
  Players.second: querySelector('#score-1') as DivElement,
};
final currentScorePanels = {
  Players.first: querySelector('#current-0') as DivElement,
  Players.second: querySelector('#current-1') as DivElement,
};

var roundScore = 0;
var gameOver = true;
var activePlayer = Players.first;

bool checkWinner() {
  return scores[activePlayer] >= 100;
}

void updateRoundScore() {
  currentScorePanels[activePlayer].innerHtml = roundScore.toString();
}

void changePlayer() {
  activePlayer = activePlayer == Players.first ? Players.second : Players.first;

  playerBlocks.forEach((_, div) => div.classes.toggle('player--active'));
}

void resetGame() {
  scores.forEach((player, _) => scores[player] = 0);
  roundScore = 0;
  activePlayer = Players.first;
  gameOver = false;

  currentScorePanels.forEach((_, div) => div.innerHtml = '0');
  scorePanels.forEach((_, div) => div.innerHtml = '0');
  var count = 1;
  namePanels.forEach((_, div) => div.innerHtml = 'Player ${count++}');
  playerBlocks.forEach((_, div) {
    div.classes.remove('winner');
    div.classes.remove('player--active');
  });

  playerBlocks[activePlayer].classes.add('player--active');
  dice.style.display = 'none';
}

void rollHandler(MouseEvent _) {
  if (gameOver) return;

  var diceScore = intGenerator.nextInt(6) + 1;

  dice.setAttribute('src', '/images/dice-$diceScore.png');
  dice.style.display = 'block';

  if (diceScore == 1) {
    roundScore = 0;
    updateRoundScore();
    return changePlayer();
  }

  roundScore += diceScore;
  updateRoundScore();
}

void holdHandler(MouseEvent _) {
  if (gameOver) return;

  dice.style.display = 'none';
  scores[activePlayer] += roundScore;
  roundScore = 0;
  updateRoundScore();
  scorePanels[activePlayer].innerHtml = scores[activePlayer].toString();

  if (!checkWinner()) {
    return changePlayer();
  }

  gameOver = true;
  namePanels[activePlayer].innerHtml = 'Winner';
  playerBlocks[activePlayer].classes.add('winner');
}

void main() {
  newGameBtn.onClick.listen((_) => resetGame());
  rollBtn.onClick.listen(rollHandler);
  holdBtn.onClick.listen(holdHandler);

  resetGame();
}
