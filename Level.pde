class Level extends Entity {
	Entity[] entities;
	String nextLevelName;

	Level(Entity[] entities) {
		this.entities = entities;
		this.nextLevelName = null;
	}

	void OnInputStart(String inputName) {
		if (inputName == "restart") {
			levels.loadLevel("test");
		}
	}
}
