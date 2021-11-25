class Tank extends PhysicsObject {
	color colorPlayer;

	Tank(float x, float y, color colorPlayer) {
		super(new PVector(x, y), 16, 10, 0.2);

		this.colorPlayer = colorPlayer;
	}

	void accelerate(float speed) {
		this.velocity.x += speed;
	}

	void tick() {
		if (inputs.getIsActive("moveleft")) {
			this.accelerate(-0.1);
		}
		if (inputs.getIsActive("moveright")) {
			this.accelerate(0.1);
		}

		super.tick();
	}

	void draw() {
		fill(colorPlayer);
		circle(this.origin.x, this.origin.y, this.radius * 2);
	}
}
