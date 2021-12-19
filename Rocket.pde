class Rocket extends PhysicsEntity {
	color colorTint;
	color colorTintDark;
	color colorTintLight;
	PImage image;
	float imageSize;

	PShape circle;

	Rocket(PVector origin, PVector velocity, color colorTint) {
		super(origin, velocity, 6.0, 0.5, 0.0, 0.0);
		this.zIndex = 1100;

		this.colorTint = colorTint;
		this.colorTintDark = color(hue(colorTint), 0.1, 0.3);
		this.colorTintLight = color(hue(colorTint), 0.1, 1.0);
		this.image = loadImage("textures/rocket.png");
		this.imageSize = 20;

		this.circle = createShape(ELLIPSE, 0, 0, this.imageSize, this.imageSize);
		this.circle.disableStyle();
	}

	void OnCollision(Collision collision) {
		new Explosion(collision.position, 48.0, 64.0).spawn();
		this.delete();
	}

	void OnTick() {
		final float PARTICLE_SIZE = 6.0;

		new Particle(
			this.origin.copy().add(this.velocity.copy().setMag(this.imageSize * -0.4)),
			this.velocity.copy().setMag(random(-0.2, -1.0)).rotate(random(-PI, PI)),
			new PVector(PARTICLE_SIZE, PARTICLE_SIZE),
			0.0,
			circle
		) {
			void OnTick() {
				super.OnTick();
				this.updateBoundingBox();

				if (this.size.x < 0.2)
					this.delete();

				float lifeFrac = this.size.x / PARTICLE_SIZE;
				this.opacity = lerp(0.8, 0.4, lifeFrac);
				this.colorTint = lerpColors(lifeFrac, Rocket.this.colorTintDark, Rocket.this.colorTint, Rocket.this.colorTintLight);
				this.size.mult(0.92);
			}
		}.spawn();

		super.OnTick();
	}

	void OnDraw() {
		imageMode(CENTER);

		translate(this.origin.x, this.origin.y);
		rotate(this.velocity.heading());

		image(this.image, 0, 0, this.imageSize, this.imageSize / 4);
	}
}
