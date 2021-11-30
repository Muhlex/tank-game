class EntityManager {
	CopyOnWriteArrayList<Entity> entityList; // https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/CopyOnWriteArrayList.html
	ArrayList<Geometry> geometryList;

	EntityManager() {
		this.entityList = new CopyOnWriteArrayList<Entity>();
		this.geometryList = new ArrayList<Geometry>();
	}

	void add(Entity entity) {
		this.entityList.add(entity);

		if (entity instanceof Geometry)
			this.geometryList.add((Geometry)entity);
	}

	void remove(Entity entity) {
		this.entityList.remove(entity);

		if (entity instanceof Geometry)
			this.geometryList.remove((Geometry)entity);
	}

	ArrayList<Geometry> getGeometry() {
		return this.geometryList;
	}

	void OnTick() {
		for (Entity entity : this.entityList) {
			entity.OnTick();
		}
	}

	void OnDraw() {
		for (Entity entity : this.entityList) {
			push();
			entity.OnDraw();
			pop();
		}
	}

	void OnKeyPressed() {
		for (Entity entity : this.entityList) {
			entity.OnKeyPressed();
		}
	}

	void OnKeyReleased() {
		for (Entity entity : this.entityList) {
			entity.OnKeyReleased();
		}
	}

	void OnInputStart(String inputName) {
		for (Entity entity : this.entityList) {
			entity.OnInputStart(inputName);
		}
	}

	void OnInputEnd(String inputName) {
		for (Entity entity : this.entityList) {
			entity.OnInputEnd(inputName);
		}
	}

	void OnMousePressed() {
		for (Entity entity : this.entityList) {
			entity.OnMousePressed();
		}
	}

	void OnMouseMoved() {
		for (Entity entity : this.entityList) {
			entity.OnMouseMoved();
		}
	}
}
