// Snake Patrick Fieger - Matrikelnummer 732712

// Feldgröße
int fieldSize = 30;
int gutter = 15;
int maxLength = 100;


color bgColor = #F4F4F4;
int snakeLength;
int snakePositions[][] = new int[maxLength][2]; // [][X,Y]
int cookiePosition[] = {
		(int) random(fieldSize), (int) random(fieldSize)
}; // [X,Y]

int direction; //  = hoch, 1 = runter, 2 = links, 3 = rechts
int negativeSpeed; // je höher umso langsamer ist die Schlange
int speedStep = negativeSpeed;


/**
 * Funktion zum zurücksetzen des Spiels
 */
void reset() {
		bgColor = #F4F4F4;
		snakeLength = 5;
		direction = 2;
		negativeSpeed = 10;
		for (int i = 0; i < snakeLength; i++) {
				snakePositions[i][0] = fieldSize / 2 + (i * 1);
				snakePositions[i][1] = fieldSize / 2;
		}
}


void setup() {
		reset();
		size(gutter * fieldSize, gutter * fieldSize);
}


void draw() {
		background(bgColor);
		
		if (speedStep >= negativeSpeed && direction >= 0) {
				moveSnake();
				speedStep = 0;
		} else speedStep++;

		drawCookie();
		drawSnake();
		Infos();
}


/**
 * Zeichnet die Schlange
 */
void drawSnake() {
		stroke(#FFFFFF);
		fill(#000000);
	for(int i = 0; i < snakeLength; i++) {
				rect(snakePositions[i][0] * gutter, snakePositions[i][1] * gutter, gutter, gutter);
		}
}

/**
 * Zeichnet den Cookie, denn die Schlange essen muss
 */
void drawCookie() {
		ellipseMode(CORNER);
		stroke(#8C0303);
		fill(#8C0303);
		ellipse(cookiePosition[0] * gutter, cookiePosition[1] * gutter, gutter, gutter);
}


void moveSnake() {
		// Schneide das letzte Stück der Schlange ab
		for (int n = snakeLength - 1; n >= 1; n--) {
				arrayCopy(snakePositions[n - 1], snakePositions[n], 2);
		}
		// Und setze vorne ein neues Element hinzu, spricht bewege den Kopf der Schlange
		switch (direction) {
				case 0: // oben
						snakePositions[0][1]--;
						break;
				case 1: // unten
						snakePositions[0][1]++;
						break;
				case 2: // links
						snakePositions[0][0]--;
						break;
				case 3: // rechts
						snakePositions[0][0]++;
						break;
		}
		
		
		if (checkCollision(snakePositions[0])) gameOver();

		if (foundCookie()) {
				negativeSpeed--;
				if (snakeLength < maxLength) {
						arrayCopy(snakePositions[snakeLength - 1], snakePositions[snakeLength]);
						snakeLength++;
				}
		}
}

/**
 * Funktion zum checken ob die Schlange den Rand berührt hat, oder sich selbst
 * Check auch die Position eines neu Gesetzten Cookies
 * @param  int Array
 * @return boolean
 */
boolean checkCollision(int[] pos) {
		
		// Rand Berührung
		if (pos[0] >= fieldSize || pos[0] < 0 || pos[1] >= fieldSize || pos[1] < 0) return true;
		
		// Schlange berührt sich selbst, oder Cookie wird auf der Schlange abgelegt --> siehe foundCookie();
		for (int i = 1; i < snakeLength; i++)
				if (snakePositions[i][0] == pos[0] && snakePositions[i][1] == pos[1]) return true;
		
		return false;
}

/**
 * Funktion wenn die Schlange sich selbst berührt oder den Spielfeldrand
 */
void gameOver() {
		bgColor = #EB0F0F;
		direction = -1;
}

/**
 * Funktion zum Setzen der Richtung & resetten des Spiels
 */
void keyPressed() {
		if (key == CODED && direction >= 0) {
				switch (keyCode) {
						case UP:
								direction = 0;
								break;
						case DOWN:
								direction = 1;
								break;
						case LEFT:
								direction = 2;
								break;
						case RIGHT:
								direction = 3;
								break;
				}
		} else {
				switch (key) {
						case BACKSPACE:
								reset();
								break;
				}
		}
}

/**
 * Funktion zum checken ob der Cookie gefunden wurde
 * Falls der Cookie gefunden wurde, wird dem Cookie eine neue Position zugewiesen
 * Der Cookie darf aber nicht außerhalb des Spielfeldes sein und auch nicht "auf" der Schlange selbst
 * @return boolean
 */
boolean foundCookie() {
		if (snakePositions[0][0] == cookiePosition[0] && snakePositions[0][1] == cookiePosition[1]) {
				do {
						cookiePosition[0] = (int) random(fieldSize);
						cookiePosition[1] = (int) random(fieldSize);
				} while (checkCollision(cookiePosition));
				return true;
		}
		return false;
}

/**
 * Funktion zum Anzeigen der Schlangenlänge und der aktuellen Geschwindigkeit
 */
void Infos() {
		fill(0);
		text("Schlangenlänge: " + snakeLength, 10, 10, 150, 20);
		text("Schnelligkeit: " + (30 - negativeSpeed), 10, 23, 150, 20);
}