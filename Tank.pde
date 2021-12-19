class Tank extends PhysicsEntity {
	color colorTint;
	float rotation;
	boolean flipped;
	PVector aimDirection;

	PImage imageBody;
	PImage imageGun;
	float imageSize;

	Tank(PVector origin, color colorTint) {
		super(origin, new PVector(), 16.0, 10.0, 0.15, 0.0);
		this.zIndex = 1000;
		this.solid = true;

		this.colorTint = colorTint;
		this.rotation = 0.0;
		this.flipped = false;
		this.aimDirection = new PVector(2, 0);

		this.imageBody = loadImage("textures/tank.png");
		this.imageGun = loadImage("textures/tank-gun.png");
		this.imageSize = 48;
	}

	void accelerate(float amount) {
		this.velocity.add(PVector.fromAngle(this.rotation).mult(amount));
	}

	void updateAim() {
		this.aimDirection = camera.getMousePos().sub(this.origin);
	}

	void shootGrenade() {
		PVector projectileOrigin = this.origin.copy().add(this.aimDirection.copy().setMag(12));
		new Grenade(projectileOrigin, this.aimDirection.copy().mult(0.02).limit(6.0).add(this.velocity), this.colorTint).spawn();
	}

	void shootRocket() {
		PVector projectileOrigin = this.origin.copy().add(this.aimDirection.copy().setMag(12));
		new Rocket(projectileOrigin, this.aimDirection.copy().setMag(6.0), color(#ffab26)).spawn();
	}

	void OnTick() {
		this.updateAim();

		float accelScale = 0.0;
		if (inputs.getIsActive("moveleft")) accelScale -= 0.05;
		if (inputs.getIsActive("moveright")) accelScale += 0.05;

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
		if (mouseButton == LEFT) {
			this.shootRocket();
		} else if (mouseButton == RIGHT) {
			this.shootGrenade();
		}
	}

	void OnDraw() {
		tint(this.colorTint);
		imageMode(CENTER);
		translate(this.origin.x, this.origin.y);

		pushMatrix();
		rotate(this.rotation);
		if (this.flipped)
			scale(-1.0, 1.0);
		image(this.imageBody, 0, 0, this.imageSize, this.imageSize);
		popMatrix();

		translate(0, this.imageSize / -16);
		rotate(this.aimDirection.heading() + PI);

		image(this.imageGun, 0, 0, this.imageSize, this.imageSize / 8);
	}
}
