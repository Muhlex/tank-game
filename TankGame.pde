import java.util.*;

PFont font;
final int TICK_RATE = 60;
final float GRAVITY = 0.01;

ArrayList<Entity> entities;
InputManager inputs;
ArrayList<Geometry> geos;

void setup() {
	size(960, 540);
	pixelDensity(displayDensity());
	frameRate(300);
	surface.setTitle("Tank Game");

	font = createFont("res/barlow-medium.ttf", 16);
	textFont(font);

	entities = new ArrayList<Entity>();
	geos = new ArrayList<Geometry>();

	inputs = new InputManager();
	entities.add(inputs);

	geos.add(
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
		)
	);

	for (Geometry geo : geos) {
		entities.add(geo);
	}

	entities.add(new Tank(100.0, 200.0, color(#ff0000)));
	entities.add(new Tank(300.0, 200.0, color(#0000ff)));

	thread("setupTick");
}

void setupTick() {
	int tickLength = 1000 / TICK_RATE;
	while (true) {
		tick();
		delay(tickLength);
	}
}

void tick() {
	for (Entity entity : entities) {
		entity.tick();
	}
}

void draw() {
	background(#aad9dd);

	for (Entity entity : entities) {
		push();
		entity.draw();
		pop();
	}

	text("fps: " + (int)frameRate, 4, 20);
	text("tickrate: " + TICK_RATE, 4, 40);
}

void keyPressed() {
	for (Entity entity : entities) {
		entity.keyPressed();
	}
}

void keyReleased() {
	for (Entity entity : entities) {
		entity.keyReleased();
	}
}
