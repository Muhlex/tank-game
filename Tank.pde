class Tank extends Entity {
	float x;
	float y;
	float w;
	float h;
	color colorPlayer;

	Tank(float x, float y, color colorPlayer) {
		this(x, y, 48, 16, colorPlayer);
	}

	Tank(float x, float y, float w, float h, color colorPlayer) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.colorPlayer = colorPlayer;
	}

	void move(float speed) {
		this.x += speed;
	}

	void tick() {
		if (inputs.getIsActive("moveleft")) {
			this.move(-0.5);
		}
		if (inputs.getIsActive("moveright")) {
			this.move(0.5);
		}
	}

	void draw() {
		push();

		fill(colorPlayer);
		rect(x, y, w, h);

		pop();
	}
}
