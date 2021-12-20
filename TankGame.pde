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

final boolean DRAW_BOUNDING_BOXES = false;

final int DEFAULT_WIDTH = 960;
final int DEFAULT_HEIGHT = 540;
final int TICK_RATE = 100;
final int TICK_MS = 1000 / TICK_RATE;
final float GRAVITY = 0.005;

float globalScale = 1.0;
long lastTickMillis = 0;
float tickRate = 0;
int lastTickDuration = 0;

InputManager inputs;
LevelManager levels;
EntityManager entities;
ParticleManager particles;
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
	surface.setTitle("Untitled Tank Game");
	cursor(loadImage("textures/xhair.png"), 16, 16);
	// surface.setResizable(true);

	colorMode(HSB, 360.0, 1.0, 1.0, 1.0);

	fontRegular = createFont("fonts/barlow-medium.ttf", 64);
	fontBold = createFont("fonts/barlow-extrabold.ttf", 64);
	textFont(fontRegular);

	inputs = new InputManager();
	levels = new LevelManager();
	entities = new EntityManager();
	particles = new ParticleManager();
	camera = new Camera(new PVector(0, 0), DEFAULT_WIDTH * 2);

	TimerTask tickTask = new TimerTask() {
		void run() {
			long millis = System.currentTimeMillis();

			tick();

			lastTickDuration = (int)(System.currentTimeMillis() - millis);
			tickRate = (float)(1000 / (millis - lastTickMillis == 0 ? 1 : millis - lastTickMillis));
			lastTickMillis = millis;
		}
	};
	new Timer().scheduleAtFixedRate(tickTask, 0L, (long)TICK_MS);

	levels.loadLevel("test");
}

void tick() {
	inputs.OnTick();
	levels.OnTick();
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
	entities.OnMousePressed();
}

void mouseMoved() {
	entities.OnMouseMoved();
}
