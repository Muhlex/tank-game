import java.util.concurrent.CopyOnWriteArrayList;
import java.util.HashSet;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.geom.Line2D;

PFont font;
final int TICK_RATE = 100;
int tickCount = 0;
final float GRAVITY = 0.005;

EntityManager entities;
InputManager inputs;
ArrayList<Geometry> geos;

void setup() {
	size(960, 540);
	pixelDensity(displayDensity());
	frameRate(300);
	surface.setTitle("Tank Game");

	font = createFont("res/barlow-medium.ttf", 16);
	textFont(font);

	entities = new EntityManager();
	inputs = new InputManager();

	new Geometry(
		new PVector[] {
			new PVector(10, 334),
			new PVector(43, 316),
			new PVector(108, 304),
			new PVector(196, 304),
			new PVector(260, 320),
			new PVector(306, 345),
			new PVector(379, 380),
			new PVector(449, 406),
			new PVector(524, 415),
			new PVector(580, 406),
			new PVector(639, 386),
			new PVector(696, 354),
			new PVector(734, 328),
			new PVector(770, 292),
			new PVector(814, 256),
			new PVector(865, 223),
			new PVector(921, 196),
			new PVector(950, 191),
			new PVector(950, 530),
			new PVector(10, 530)
		},
		color(#aabb55)
	);
	new Geometry(
		new PVector[] {
			new PVector(400, 200),
			new PVector(600, 200),
			new PVector(600, 240),
			new PVector(400, 240)
		},
		color(#444444)
	);

	new Tank(new PVector(100.0, 200.0), color(#ff8888));
	new Tank(new PVector(480.0, 80.0), color(#8888ff));

	thread("setupTick");
}

void setupTick() {
	int tickLength = 1000 / TICK_RATE;
	while (true) {
		tick();
		tickCount++;
		delay(tickLength);
	}
}

void tick() {
	entities.OnTick();
}

void draw() {
	background(#aad9dd);

	entities.OnDraw();

	text("fps: " + (int)frameRate, 4, 20);
	text("TICK_RATE: " + TICK_RATE, 4, 40);
	text("GRAVITY: " + GRAVITY, 4, 60);
}

void keyPressed() {
	entities.OnKeyPressed();
}

void keyReleased() {
	entities.OnKeyReleased();
}

void mousePressed() {
	entities.OnMousePressed();

	if (inputs.getIsActive("shift"))
		new DebugBall(new PVector(mouseX, mouseY), (int)random(1, 10), random(0, 1), random(1.0) < 0.5 ? random(0, 1) : random(0.95, 1.0));
}

void mouseMoved() {
	entities.OnMouseMoved();
}
