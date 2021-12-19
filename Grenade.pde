class Grenade extends PhysicsEntity {
	color colorTint;
	color colorTintGlow;
	PImage image;
	float imageSize;

	Grenade(PVector origin, PVector velocity, color colorTint) {
		super(origin, velocity, 6.0, 12.0, 0.33, 0.0);
		this.zIndex = 1100;

		this.colorTint = color(hue(colorTint), 1.0, 0.4);
		this.colorTintGlow = color(hue(colorTint), 0.5, 1.0);
		this.image = loadImage("textures/grenade.png");
		this.imageSize = 16;
	}

	void OnCollision(Collision collision) {
		new Explosion(collision.position, 96.0, 28.0).spawn();
		this.delete();
	}

	void OnDraw() {
		long ticksAlive = this.getTicksAlive();

		tint((ticksAlive / 8) % 3 == 0 ? colorTint : colorTintGlow);
		imageMode(CENTER);

		translate(this.origin.x, this.origin.y);
		rotate(radians(ticksAlive * 6));
		image(this.image, 0, 0, this.imageSize, this.imageSize);
	}
}
