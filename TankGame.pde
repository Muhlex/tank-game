import java.util.List;
import java.util.Map;
import java.util.HashSet;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.geom.Line2D;

PFont font;
final int TICK_RATE = 100;
final int TICK_MS = 1000 / TICK_RATE;
int currentTick = 0;
final float GRAVITY = 0.005;

EntityManager entities;
LevelManager levels;
InputManager inputs;

void setup() {
	size(960, 540);
	pixelDensity(displayDensity());
	frameRate(9999);
	surface.setTitle("Tank Game");

	font = createFont("fonts/barlow-medium.ttf", 16);
	textFont(font);

	entities = new EntityManager();
	levels = new LevelManager();
	inputs = new InputManager();

	thread("setupTick");
}

void setupTick() {
	while (true) {
		tick();
		currentTick++;
		delay(TICK_MS);
	}
}

void tick() {
	entities.OnTick();
}

void draw() {
	background(#aad9dd);

	entities.OnDraw();

	String debugText = "fps: " + (int)frameRate + "\n" +
		"entities: " + entities.getEntityCount();
	push();
	textLeading(16);
	text(debugText, 4, 20);
	pop();
}

void keyPressed() {
	entities.OnKeyPressed();
	inputs.OnKeyPressed();
}

void keyReleased() {
	entities.OnKeyReleased();
	inputs.OnKeyReleased();
}

void mousePressed() {
	if (!inputs.getIsActive("shift"))
		entities.OnMousePressed();
	else
		new DebugBall(new PVector(mouseX, mouseY), (int)random(1, 10), random(0, 1), random(1.0) < 0.5 ? random(0, 1) : random(0.95, 1.0)).spawn();
}

void mouseMoved() {
	entities.OnMouseMoved();
}
