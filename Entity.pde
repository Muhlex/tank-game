abstract class Entity {
	int birthTick;

	void spawn() {
		this.birthTick = currentTick;
		entities.add(this);
	}

	void delete() {
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
