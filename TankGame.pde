import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.HashSet;
import java.util.Iterator;
import java.util.ListIterator;
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
ParticleManager particles;
LevelManager levels;
InputManager inputs;
Camera camera;

PFont fontRegular;
PFont fontBold;

void settings() {
	size(DEFAULT_WIDTH, DEFAULT_HEIGHT, P2D);
	pixelDensity(displayDensity());
	PJOGL.setIcon("textures/tank.png");
}

void setup() {
	frameRate(1000);
	cursor(loadImage("textures/xhair.png"), 16, 16);
	surface.setTitle("Untitled Tank Game");
	// surface.setResizable(true);

	colorMode(HSB, 360.0, 1.0, 1.0, 1.0);

	fontRegular = createFont("fonts/barlow-medium.ttf", 64);
	fontBold = createFont("fonts/barlow-extrabold.ttf", 64);
	textFont(fontRegular);

	camera = new Camera(new PVector(DEFAULT_WIDTH / 2.0, DEFAULT_HEIGHT / 2.0), DEFAULT_WIDTH * 2);
	entities = new EntityManager();
	particles = new ParticleManager();
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
	particles.OnTick();
	camera.OnTick();
}

void draw() {
	background(#aad9dd);

	camera.OnDraw();

	String debugText = "fps: " + (int)frameRate + "\n" +
		"tps: " + (int)tickRate + " (" + lastTickDuration + "ms)\n" +
		"entities: " + entities.getCount() + "\n" +
		"particles: " + particles.getCount();
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
	if (!inputs.getIsActive("debug"))
		entities.OnMousePressed();
	else if (mouseButton != CENTER)
		new DebugBall(camera.getMousePos(), random(1, 16), random(0, 1), random(1.0) < 0.5 ? random(0, 1) : random(0.95, 1.0), true).spawn();
	else
		for (int i = 0; i < 100; i++)
			new DebugBall(camera.getMousePos(), random(1, 16), random(0, 1), random(1.0) < 0.5 ? random(0, 1) : random(0.95, 1.0), false).spawn();
}

void mouseMoved() {
	entities.OnMouseMoved();
}
