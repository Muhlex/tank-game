class DebugBall extends PhysicsEntity {
	color colorFill;
	boolean showLabel;
	String debugLabel;

	PShape shape;

	DebugBall(PVector origin, float mass, float bounce, float roll, boolean showLabel) {
		super(origin, new PVector(), mass + 8, mass, bounce, roll);

		this.zIndex = 100000;

		this.colorFill = color(random(360.0), 0.5, 1.0);
		this.debugLabel = "MASS: " + nf(this.mass, 0, 2) + "\nBOUNCE: " + nf(this.bounce, 0, 2) + "\nROLL: " + nf(this.roll, 0, 2);
		this.showLabel = showLabel;

		this.shape = createShape(ELLIPSE, 0, 0, this.radius * 2, this.radius * 2);
		this.shape.setFill(colorFill);
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
		shape(this.shape, this.origin.x, this.origin.y);

		if (!this.showLabel) return;

		textSize(12);
		textLeading(14);
		float textX = this.origin.x + this.radius;
		float textY = this.origin.y + this.radius * 2;
		fill(0);
		text(this.debugLabel, textX + 1, textY + 1);
		fill(colorFill);
		text(this.debugLabel, textX, textY);
	}
}
