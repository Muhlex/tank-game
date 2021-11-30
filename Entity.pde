abstract class Entity {
	Entity() {
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
