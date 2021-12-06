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

PFont font;
final int TICK_RATE = 100;
final int TICK_MS = 1000 / TICK_RATE;
long currentTick = 0; // TODO: move to level
long lastTickMillis = 0;
float tickRate = 0;
int lastTickDuration = 0;
final float GRAVITY = 0.005;

EntityManager entities;
LevelManager levels;
InputManager inputs;

void setup() {
	size(960, 540, P2D);
	pixelDensity(displayDensity());
	frameRate(1000);
	surface.setTitle("Tank Game");

	font = createFont("fonts/barlow-medium.ttf", 16);
	textFont(font);

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

	entities.OnDraw();

	String debugText = "fps: " + (int)frameRate + "\n" +
		"tps: " + (int)tickRate + " (" + lastTickDuration + "ms)\n" +
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
