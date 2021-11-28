class Tank extends PhysicsCircle {
	color colorPlayer;
	float maxSpeed;
	boolean flipped;
	PImage image;
	float imageScale;

	Tank(float x, float y, color colorPlayer) {
		super(new PVector(x, y), new PVector(), 16, 10, 0.15, 0.0);

		this.maxSpeed = 5;
		this.colorPlayer = colorPlayer;
		this.image = loadImage("res/tank.png");
		this.flipped = false;
		this.imageScale = 0.375; // 48px
	}

	void accelerate(float amount) {
		this.velocity.add(this.lastCollisionNormal.copy().rotate(HALF_PI).mult(amount));
	}

	void tick() {
		float accelScale = 0.0;
		if (inputs.getIsActive("moveleft")) accelScale -= 0.05;
		if (inputs.getIsActive("moveright")) accelScale += 0.05;

		if (!this.onGround) accelScale = 0.0;

		if (accelScale != 0) {
			this.accelerate(accelScale);
			this.flipped = accelScale > 0.0;
			this.roll = 0.96;
		} else {
			if (this.velocity.mag() > 0.25)
				this.roll = 0.85;
			else
				this.roll = 0.0;
		}

		super.tick();
	}

	void draw() {
		fill(colorPlayer);
		translate(this.origin.x, this.origin.y);
		rotate(this.lastCollisionNormal.heading() + HALF_PI);
		if (this.flipped)
			scale(-this.imageScale, this.imageScale);
		else
			scale(this.imageScale);
		imageMode(CENTER);
		tint(colorPlayer);
		image(image, 0, 0);
	}
}
