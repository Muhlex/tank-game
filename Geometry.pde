class Geometry {
	int x1;
	int y1;
	int x2;
	int y2;
	color colorBG;

	Geometry(int x1, int y1, int x2, int y2, color colorBG) {
		this.x1 = x1;
		this.y1 = y1;
		this.x2 = x2;
		this.y2 = y2;
		this.colorBG = colorBG;
	}

	void draw() {
		push();

		fill(colorBG);
		rectMode(CORNERS);
		rect(x1, y1, x2, y2);

		pop();
	}
}
