abstract class Entity extends Node {
	public int zIndex;

	Entity() {
		this.zIndex = 0;
	}

	void spawn() {
		super.spawn();
		entities.add(this);
	}

	void delete() {
		super.delete();
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
