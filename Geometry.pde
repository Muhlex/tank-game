class Geometry extends Entity {
	PVector[] points;
	color colorBG;
	PShape shape;

	Geometry(PVector[] points, color colorBG) {
		this.points = points;
		this.colorBG = colorBG;
		this.shape = createShape();

		this.shape.setFill(this.colorBG);
		this.shape.setStroke(false);
		this.shape.beginShape();
		for (PVector point : points) {
			this.shape.vertex(point.x, point.y);
		}
		this.shape.endShape(CLOSE);
	}

	PVector[] getLine(int index) {
		int a = index;
		int b = index < this.points.length - 1 ? index + 1 : 0;
		return new PVector[] { points[a], points[b] };
	}

	PVector[][] getLines() {
		PVector[][] result = new PVector[this.points.length][2];
		for (int i = 0; i < this.points.length; i++) {
			result[i] = this.getLine(i);
		}
		return result;
	}

	void draw() {
		shape(this.shape);
	}
}
