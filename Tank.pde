class Tank extends PhysicsCircle {
	color tint;
	float rotation;
	boolean flipped;
	PVector aimDirection;

	PImage imageBody;
	PImage imageGun;
	float imageScale;

	Tank(PVector origin, color tint) {
		super(origin, new PVector(), 16, 20, 0.15, 0.0);

		this.tint = tint;
		this.rotation = 0.0;
		this.flipped = false;
		this.aimDirection = new PVector(2, 0);

		this.imageBody = loadImage("textures/tank.png");
		this.imageGun = loadImage("textures/tank-gun.png");
		this.imageScale = 0.375; // 48px
	}

	void accelerate(float amount) {
		this.velocity.add(PVector.fromAngle(this.rotation).mult(amount));
	}

	void updateAim() {
		this.aimDirection = new PVector(mouseX, mouseY).sub(this.origin);
	}

	void shootProjectile() {
		PVector projectileOrigin = this.origin.copy().add(this.aimDirection.copy().setMag(16));
		new Projectile(projectileOrigin, new PVector(mouseX, mouseY).sub(projectileOrigin).div(50), this.tint).spawn();
	}

	void OnTick() {
		this.updateAim();

		float accelScale = 0.0;
		if (inputs.getIsActive("moveleft")) accelScale -= 0.1;
		if (inputs.getIsActive("moveright")) accelScale += 0.1;

		if (!this.onGround) accelScale = 0.0;

		if (accelScale != 0) {
			this.accelerate(accelScale);
			this.flipped = accelScale > 0.0;
			this.roll = 0.95;
		} else {
			if (this.velocity.mag() > 0.25)
				this.roll = 0.8;
			else
				this.roll = 0.0;
		}

		super.OnTick();
	}

	void OnCollision(Collision collision) {
		if (this.onGround)
			this.rotation = collision.normal.heading() + HALF_PI;
	}

	void OnMousePressed() {
		this.shootProjectile();
	}

	void OnDraw() {
		tint(this.tint);
		imageMode(CENTER);
		translate(this.origin.x, this.origin.y);

		pushMatrix();
		rotate(this.rotation);
		if (this.flipped)
			scale(-this.imageScale, this.imageScale);
		else
			scale(this.imageScale);
		image(this.imageBody, 0, 0);
		popMatrix();

		translate(0, -8 * this.imageScale);
		scale(this.imageScale);
		rotate(this.aimDirection.heading() + PI);

		image(this.imageGun, 0, 0);
	}
}
