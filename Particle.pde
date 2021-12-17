class Particle extends Node {
	PVector size;
	float rotation;
	PShape shape;
	PImage image;

	PVector velocity;
	color colorTint;
	float opacity;

	Particle(PVector origin, PVector velocity, PVector size, float rotation, PShape shape) {
		this(origin, velocity, size, rotation, shape, null);
	}
	Particle(PVector origin, PVector velocity, PVector size, float rotation, PImage image) {
		this(origin, velocity, size, rotation, null, image);
	}
	Particle(PVector origin, PVector velocity, PVector size, float rotation, PShape shape, PImage image) {
		this.origin = origin;
		this.velocity = velocity;
		this.size = size;
		this.rotation = rotation;
		this.shape = shape;
		this.image = image;

		this.colorTint = color(#ffffff);
		this.opacity = 1.0;

		this.updateBoundingBox();
	}

	void spawn() {
		super.spawn();
		particles.add(this);
	}

	void delete() {
		super.delete();
		particles.remove(this);
	}

	void updateBoundingBox() {
		this.boundingBox = this.getBoundingBoxForRadius(max(this.size.x, this.size.y) / 2.0);
	}

	void OnTick() {
		this.origin.add(this.velocity);
	};

	void OnDraw() {
		noStroke();

		translate(this.origin.x, this.origin.y);
		rotate(this.rotation);

		if (this.shape != null) {
			fill(this.colorTint, this.opacity);
			shape(this.shape, 0, 0, this.size.x, this.size.y);
		}
		if (this.image != null) {
			tint(this.colorTint, this.opacity);
			image(this.image, 0, 0, this.size.x, this.size.y);
		}
	}
}
