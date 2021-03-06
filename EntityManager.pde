class EntityManager {
	List<Entity> entities;
	Map<Class,List<Entity>> entitiesByClass;

	EntityManager() {
		this.entities = new CopyOnWriteArrayList<Entity>();
		this.entitiesByClass = new HashMap<Class,List<Entity>>();
	}

	void add(Entity entity) {
		int insertIndex = this.entities.size();
		for (int i = insertIndex - 1; i >= 0; i--) {
			if (entity.zIndex >= this.entities.get(i).zIndex) {
				insertIndex = i + 1;
				break;
			}
		}
		this.entities.add(insertIndex, entity);

		List<Class<? extends Entity>> entityClasses = new ArrayList();
		Class baseClass = entity.getClass();
		Class superClass = baseClass.getSuperclass();

		entityClasses.add(baseClass);
		while (Entity.class.isAssignableFrom(superClass)) {
			entityClasses.add(superClass);
			superClass = superClass.getSuperclass();
		}

		for (Class entityClass : entityClasses) {
			List classList = this.entitiesByClass.getOrDefault(entityClass, new ArrayList<Entity>());
			classList.add(entity);
			this.entitiesByClass.put(entityClass, classList);
		}
	}

	void remove(Entity entity) {
		this.entities.remove(entity);

		this.getByClassNoCopy(entity.getClass()).remove(entity);
	}

	void clear() {
		for (Entity entity : this.entities) {
			entity.delete();
		}
	}

	<E extends Entity> List<E> getByClassNoCopy(Class<E> entityClass) {
		this.entitiesByClass.putIfAbsent(entityClass, new ArrayList<Entity>());
		return (List<E>)this.entitiesByClass.get(entityClass);
	}
	<E extends Entity> List<E> getByClass(Class<E> entityClass) {
		return new ArrayList<E>(this.getByClassNoCopy(entityClass));
	}

	int getCount() {
		return this.entities.size();
	}

	void OnTick() {
		for (Entity entity : this.entities) {
			entity.OnTick();
		}
	}

	void OnDraw(Camera camera) {
		for (Entity entity : this.entities) {
			if (!camera.getIsNodeVisible(entity)) continue;
			entity.OnDrawInternal();
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
