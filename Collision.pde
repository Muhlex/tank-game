class Collision {
	long tick;
	PVector position;
	PVector normal;
	float force;
	Entity[] entities;

	Collision(long tick, PVector position, PVector normal, float force, Entity[] entities) {
		this.tick = tick;
		this.position = position;
		this.normal = normal;
		this.force = force;
		this.entities = entities;
	}
}
