abstract class Node {
	public boolean alive;
	public long birthTick;
	public PVector origin;
	public PVector[] boundingBox;

	Node() {
		this.alive = false;
		this.birthTick = -1L;
		this.origin = new PVector(0, 0);
		this.boundingBox = new PVector[]{ new PVector(0, 0), new PVector(0, 0) };
	}

	void spawn() {
		this.alive = true;
		this.birthTick = currentTick;
	}

	void delete() {
		this.alive = false;
	}

	long getTicksAlive() {
		return currentTick - this.birthTick;
	}

	PVector[] getBoundingBoxForRadius(float radius) {
		PVector mins = this.origin.copy().sub(radius, radius);
		PVector maxs = this.origin.copy().add(radius, radius);
		return new PVector[]{ mins, maxs };
	}

	PVector[] getBoundingBoxForRect(float width, float height) {
		PVector mins = this.origin.copy().sub(width / 2.0, height / 2.0);
		PVector maxs = this.origin.copy().add(width / 2.0, height / 2.0);
		return new PVector[]{ mins, maxs };
	}

	abstract void updateBoundingBox();

	void drawBoundingBox() {
		push();

		rectMode(CORNERS);
		noFill();
		stroke(60, 1.0, 0.9);
		strokeWeight(2);
		rect(this.boundingBox[0].x, this.boundingBox[0].y, this.boundingBox[1].x, this.boundingBox[1].y);

		pop();
	}

	void OnTick() {}

	void OnDraw() {}

	void OnDrawInternal() {
		push();
		this.OnDraw();
		pop();

		if (DRAW_BOUNDING_BOXES)
			this.drawBoundingBox();
	}
}
