class DebugBall extends PhysicsCircle {
	color colorCircle;

	DebugBall(PVector origin, float mass, float bounce, float roll) {
		super(origin, new PVector(), mass + 8, mass, bounce, roll);

		this.colorCircle = color(random(80, 255),random(80, 255),random(80, 255));
	}

	void move(PVector velocity) {
		this.velocity.add(velocity);
	}

	void OnTick() {
		if (inputs.getIsActive("moveup")) {
			this.move(new PVector(0, -0.1));
		}
		if (inputs.getIsActive("movedown")) {
			this.move(new PVector(0, 0.1));
		}
		if (inputs.getIsActive("moveleft")) {
			this.move(new PVector(-0.1, 0));
		}
		if (inputs.getIsActive("moveright")) {
			this.move(new PVector(0.1, 0));
		}

		super.OnTick();
	}

	void OnDraw() {
		fill(colorCircle);
		circle(this.origin.x, this.origin.y, this.radius * 2);

		textSize(12);
		textLeading(14);
		String text = "MASS: " + nf(this.mass, 0, 0) + "\nBOUNCE: " + nf(this.bounce, 0, 2) + "\nROLL: " + nf(this.roll, 0, 2);
		float textX = this.origin.x + this.radius;
		float textY = this.origin.y + this.radius * 2;
		fill(0);
		text(text, textX + 1, textY + 1);
		fill(colorCircle);
		text(text, textX, textY);
	}
}
