abstract class PhysicsEntity extends Entity {
	PVector lastTickOrigin;
	PVector velocity;
	float radius;
	float mass;
	float bounce;
	float roll;

	Collision lastCollision;
	boolean onGround;

	PhysicsEntity(PVector origin, PVector velocity, float radius, float mass, float bounce, float roll) {
		this.origin = origin;
		this.lastTickOrigin = null;
		this.velocity = velocity;
		this.radius = radius;
		this.mass = mass;
		this.bounce = bounce;
		this.roll = roll;

		this.lastCollision = null;
		this.onGround = false;

		this.updateBoundingBox();
	}

	void applyForce(PVector velocity) {
		this.velocity.add(velocity.copy().div(this.mass));
	}

	void cleanupInVoid() {
		PVector lvlSize = levels.getCurrent().size;
		boolean offscreenX = this.origin.x < -200 * -1 || this.origin.x > lvlSize.x + 200;
		boolean offscreenY = this.origin.y < -800 || this.origin.y > lvlSize.y + 3200;
		if (offscreenX || offscreenY)
			this.delete();
	}

	void updateCollision() {
		if (this.lastTickOrigin == null) return;

		int collisionCount = 0;
		PVector velocityNormalized = this.velocity.copy().normalize();
		PVector geometryIntersection = new PVector(); // how far the circle entered geometry on this tick
		PVector normalAverage = new PVector();
		PVector reflectionTotal = new PVector();
		PVector collisionPos = null;
		List<Entity> collidedEntities = new ArrayList<Entity>();

		for (Geometry geo : entities.getByClass(Geometry.class)) {
			if (!geo.solid || !isRectInsideRect(this.boundingBox, geo.boundingBox)) continue;
			for (PVector[] line : geo.getLines()) {
				// this is basically a circle-shaped trace:
				float dist = getLineSegmentLineSegmentDist(line, new PVector[] {this.origin, this.lastTickOrigin});

				if (dist < this.radius) {
					PVector normal = PVector.sub(line[1], line[0]).rotate(-HALF_PI).normalize(); // normalized vector perpendicular to the line (on the left side -> outside)
					normalAverage.add(normal);
					float normalDot = PVector.dot(velocityNormalized, normal); // -1.0 == head on collision; 0.0 == parallel to the line
					if (normalDot > 0.0) continue; // ignore inside collisions (actually only allows collisions from the left side of a line, which is our "normal")

					geometryIntersection.add(normal.copy().setMag(this.radius - dist)); // save how far the circle intersects this line

					PVector reflectionNormalized = PVector.sub(velocityNormalized, PVector.mult(normal, 2).mult(normalDot)); // https://math.stackexchange.com/a/13263
					reflectionTotal.add(reflectionNormalized);

					if (collisionCount == 0) { // only do for the first line that was hit
						collisionPos = getClosestPointOnLineSegment(line, this.origin);
					}

					collidedEntities.add(geo);
					collisionCount++;
				}
			}
		}

		if (collisionCount < 1) return;

		normalAverage.normalize();
		float collisionForce = abs(PVector.dot(velocityNormalized, normalAverage) * velocity.mag());
		// we decide whether the collision is a roll/bounce (or in-between)
		// depending on the amount of force the line was hit by
		float reflectionMult = lerp(this.roll, this.bounce, constrain(collisionForce * 0.5, 0.0, 1.0));

		this.origin.add(geometryIntersection); // move circle out of geometry
		this.velocity = PVector.mult(reflectionTotal.setMag(this.velocity.mag()), reflectionMult); // update velocity
		this.onGround = this.origin.y < collisionPos.y;

		this.lastCollision = new Collision(
			levels.getCurrent().currentTick,
			collisionPos,
			normalAverage,
			collisionForce,
			collidedEntities.toArray(new Entity[0])
		);
		this.OnCollision(this.lastCollision);
	}

	void updateBoundingBox() {
		this.boundingBox = this.getBoundingBoxForRadius(this.radius * 2);
	}

	void OnTick() {
		this.cleanupInVoid();

		this.velocity.y += this.mass * GRAVITY;
		this.origin.add(this.velocity);

		this.updateCollision();

		if (this.lastCollision != null && this.lastCollision.tick < levels.getCurrent().currentTick - 5)
			this.onGround = false;

		this.updateBoundingBox();
		this.lastTickOrigin = this.origin.copy();
	}

	void OnCollision(Collision collision) {}
}
