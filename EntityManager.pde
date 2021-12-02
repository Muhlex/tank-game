class EntityManager {
	List<Entity> entities;
	Map<Class,List<Entity>> entitiesByClass;

	EntityManager() {
		this.entities = new CopyOnWriteArrayList<Entity>();
		this.entitiesByClass = new ConcurrentHashMap<Class,List<Entity>>();
	}

	void add(Entity entity) {
		this.entities.add(entity);

		Class entityClass = entity.getClass();
		List classList = this.entitiesByClass.getOrDefault(entityClass, new CopyOnWriteArrayList<Entity>());
		classList.add(entity);
		this.entitiesByClass.put(entityClass, classList);
	}

	void remove(Entity entity) {
		this.entities.remove(entity);

		List classEntities = this.getEntitiesByClass(entity.getClass());
		classEntities.remove(entity);
	}

	<E extends Entity> List<E> getEntitiesByClass(Class<E> entityClass) {
		this.entitiesByClass.putIfAbsent(entityClass, new CopyOnWriteArrayList<Entity>());
		return (List<E>)this.entitiesByClass.get(entityClass);
	}

	int getEntityCount() {
		return this.entities.size();
	}

	void OnTick() {
		for (Entity entity : this.entities) {
			entity.OnTick();
		}
	}

	void OnDraw() {
		for (Entity entity : this.entities) {
			push();
			entity.OnDraw();
			pop();
		}
	}

	void OnKeyPressed() {
		for (Entity entity : this.entities) {
			entity.OnKeyPressed();
		}
	}

	void OnKeyReleased() {
		for (Entity entity : this.entities) {
			entity.OnKeyReleased();
		}
	}

	void OnInputStart(String inputName) {
		for (Entity entity : this.entities) {
			entity.OnInputStart(inputName);
		}
	}

	void OnInputEnd(String inputName) {
		for (Entity entity : this.entities) {
			entity.OnInputEnd(inputName);
		}
	}

	void OnMousePressed() {
		for (Entity entity : this.entities) {
			entity.OnMousePressed();
		}
	}

	void OnMouseMoved() {
		for (Entity entity : this.entities) {
			entity.OnMouseMoved();
		}
	}
}
