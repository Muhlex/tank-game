class Geometry extends Entity {
	PVector[] vertices;
	color colorFill;
	PShape shape;

	Geometry(PVector[] vertices, color colorFill) {
		this.vertices = vertices;
		this.colorFill = colorFill;
		this.shape = createShape();

		this.shape.setFill(this.colorFill);
		this.shape.setStroke(false);
		this.shape.beginShape();
		for (PVector point : vertices) {
			this.shape.vertex(point.x, point.y);
		}
		this.shape.endShape(CLOSE);
	}

	PVector getVertex(int index) {
		return this.vertices[index];
	}
	PVector[] getVertices() {
		return this.vertices;
	}

	PVector[] getLine(int index) {
		PVector start = this.vertices[index];
		PVector end = this.vertices[index < this.vertices.length - 1 ? index + 1 : 0];
		return new PVector[] { start, end };
	}

	PVector[][] getLines() {
		PVector[][] result = new PVector[this.vertices.length][2];
		for (int i = 0; i < this.vertices.length; i++) {
			result[i] = this.getLine(i);
		}
		return result;
	}

	void OnDraw() {
		shape(this.shape);
	}
}
