import java.util.*;

PFont font;
int tickRate = 60;

ArrayList<Entity> entities;
InputManager inputs;

Tank[] tanks = new Tank[2];

void setup() {
	size(960, 540);
	pixelDensity(displayDensity());
	frameRate(300);
	surface.setTitle("Tank Game");

	font = createFont("res/barlow-medium.ttf", 16);
	textFont(font);

	entities = new ArrayList<Entity>();
	inputs = new InputManager();
	entities.add(inputs);

	tanks[0] = new Tank(100.0, 400.0, color(#ff0000));
	entities.add(tanks[0]);
	tanks[1] = new Tank(300.0, 400.0, color(#0000ff));
	entities.add(tanks[1]);

	thread("setupTick");
}

void setupTick() {
	int tickLength = 1000 / tickRate;
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
	background(#aabb55);

	for (Entity entity : entities) {
		entity.draw();
	}

	text("fps: " + (int)frameRate, 4, 20);
	text("tick: " + tickRate, 4, 40);
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
