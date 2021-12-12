abstract class Entity {
	boolean alive;
	long birthTick;
	int zIndex;
	PVector origin;

	Entity() {
		this.alive = false;
		this.birthTick = -1L;
		this.zIndex = 0;
		this.origin = new PVector(0, 0);
	}

	void spawn() {
		this.alive = true;
		this.birthTick = currentTick;
		entities.add(this);
	}

	void delete() {
		this.alive = false;
		entities.remove(this);
	}

	void OnKeyPressed() {};
	void OnKeyReleased() {};
	void OnInputStart(String inputName) {};
	void OnInputEnd(String inputName) {};
	void OnMousePressed() {};
	void OnMouseMoved() {};
	void OnTick() {};
	void OnDraw() {};
}
