abstract class Entity extends Node {
	public int zIndex;
	public boolean solid;

	Entity() {
		this.zIndex = 0;
		this.solid = false;
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
}
