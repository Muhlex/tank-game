class DebugBall extends PhysicsCircle {
	color colorCircle;
	boolean showLabel;
	String debugLabel;

	DebugBall(PVector origin, float mass, float bounce, float roll, boolean showLabel) {
		super(origin, new PVector(), mass + 8, mass, bounce, roll);

		this.colorCircle = color(random(80, 255),random(80, 255),random(80, 255));
		this.debugLabel = "MASS: " + nf(this.mass, 0, 0) + "\nBOUNCE: " + nf(this.bounce, 0, 2) + "\nROLL: " + nf(this.roll, 0, 2);
		this.showLabel = showLabel;
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

		if (!this.showLabel) return;

		textSize(12);
		textLeading(14);
		float textX = this.origin.x + this.radius;
		float textY = this.origin.y + this.radius * 2;
		fill(0);
		text(this.debugLabel, textX + 1, textY + 1);
		fill(colorCircle);
		text(this.debugLabel, textX, textY);
	}
}
