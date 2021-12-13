class Projectile extends PhysicsCircle {
	color colorTint;
	color colorTintGlow;
	PImage image;
	float imageSize;

	Projectile(PVector origin, PVector velocity, color colorTint) {
		super(origin, velocity, 6, 12, 0.33, 0.0);
		this.zIndex = 1100;

		this.colorTint = colorTint;
		this.colorTintGlow = color(hue(colorTint), 0.5, 1.0);
		this.image = loadImage("textures/grenade.png");
		this.imageSize = 16;
	}

	void OnCollision(Collision collision) {
		new Explosion(collision.position, 96.0).spawn();
		this.delete();
	}

	void OnDraw() {
		int ticksAlive = (int)(currentTick - this.birthTick);
		tint((ticksAlive / 8) % 3 == 0 ? colorTint : colorTintGlow);
		imageMode(CENTER);

		translate(this.origin.x, this.origin.y);
		rotate(radians(ticksAlive * 8));
		image(this.image, 0, 0, this.imageSize, this.imageSize);
		// circle(0, 0, this.radius * 2);
	}
}
