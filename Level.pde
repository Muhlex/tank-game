class Level {
	Entity[] entities;
	String nextLevelName;
	long currentTick;

	Level(Entity[] entities) {
		this.entities = entities;
		this.nextLevelName = null;
		this.currentTick = 0L;
	}

	void OnTick() {
		this.currentTick++;
	}
}
