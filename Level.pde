class Level {
	Entity[] entities;
	PVector size;
	String nextLevelName;
	long currentTick;

	Level(Entity[] entities, PVector size) {
		this.entities = entities;
		this.size = size;
		this.nextLevelName = null;
		this.currentTick = 0L;
	}

	void OnTick() {
		this.currentTick++;
	}
}
