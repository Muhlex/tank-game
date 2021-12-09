import java.util.List;
import java.util.Map;
import java.util.HashSet;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.geom.Line2D;
import de.lighti.clipper.*;

final int DEFAULT_WIDTH = 960;
final int DEFAULT_HEIGHT = 540;
final int TICK_RATE = 100;
final int TICK_MS = 1000 / TICK_RATE;
final float GRAVITY = 0.005;

float globalScale = 1.0;
long currentTick = 0; // TODO: move to level
long lastTickMillis = 0;
float tickRate = 0;
int lastTickDuration = 0;

EntityManager entities;
LevelManager levels;
InputManager inputs;

PFont fontRegular;
PFont fontBold;

void settings() {
	size(DEFAULT_WIDTH, DEFAULT_HEIGHT, P2D);
	pixelDensity(displayDensity());
}

void setup() {
	frameRate(1000);
	surface.setTitle("Untitled Tank Game");
	// surface.setResizable(true);

	fontRegular = createFont("fonts/barlow-medium.ttf", 64);
	fontBold = createFont("fonts/barlow-extrabold.ttf", 64);
	textFont(fontRegular);

	entities = new EntityManager();
	levels = new LevelManager();
	inputs = new InputManager();

	TimerTask tickTask = new TimerTask() {
		void run() {
			long millis = System.currentTimeMillis();

			tick();
			currentTick++;

			lastTickDuration = (int)(System.currentTimeMillis() - millis);
			tickRate = (float)(1000 / (millis - lastTickMillis == 0 ? 1 : millis - lastTickMillis));
			lastTickMillis = millis;
		}
	};
	new Timer().scheduleAtFixedRate(tickTask, 0L, (long)TICK_MS);
}

void tick() {
	inputs.OnTick();
	entities.OnTick();
}

void draw() {
	background(#aad9dd);

	globalScale = width / (float)DEFAULT_WIDTH;
	scale(globalScale);

	entities.OnDraw();

	String debugText = "fps: " + (int)frameRate + "\n" +
		"tps: " + (int)tickRate + " (" + lastTickDuration + "ms)\n" +
		"entities: " + entities.getEntityCount();
	push();
	textSize(16);
	textLeading(16);
	text(debugText, 4, 16);
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
		new DebugBall(inputs.getMousePos(), (int)random(1, 10), random(0, 1), random(1.0) < 0.5 ? random(0, 1) : random(0.95, 1.0)).spawn();
}

void mouseMoved() {
	entities.OnMouseMoved();
}
