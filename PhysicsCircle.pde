class PhysicsCircle extends Entity {
	PVector origin;
	PVector velocity;
	float radius;
	float mass;
	float bounce;
	float roll;
	int lastCollisionTick;
	boolean onGround;

	PVector lastCollisionNormal;

	PhysicsCircle(PVector origin, PVector velocity, float radius, float mass, float bounce, float roll) {
		this.origin = origin;
		this.velocity = velocity;
		this.radius = radius;
		this.mass = mass;
		this.bounce = bounce;
		this.roll = roll;

		this.lastCollisionTick = -1;
		this.lastCollisionNormal = new PVector(0, -1);
		this.onGround = false;
	}

	void tick() {
		this.velocity.y += this.mass * GRAVITY;
		this.origin.add(this.velocity);

		this.onGround = this.lastCollisionTick > tickCount - 5;

		int collisionCount = 0;
		PVector velocityNormalized = this.velocity.copy().normalize();
		PVector geometryIntersection = new PVector(); // how far the circle entered geometry on this tick
		PVector normalAverage = new PVector();
		PVector reflectionTotal = new PVector();

		for (Geometry geo : geos) {
			for (PVector[] line : geo.getLines()) {
				float dist = this.getLinePointDist(line[0], line[1], this.origin);

				if (dist < this.radius) {
					PVector normal = PVector.sub(line[1], line[0]).rotate(-HALF_PI).normalize(); // normalized vector perpendicular to the line (on the left side -> outside)
					normalAverage.add(normal);
					float normalDot = PVector.dot(velocityNormalized, normal); // -1.0 == head on collision; 0.0 == parallel to the line
					if (normalDot > 0.0) continue; // ignore inside collisions (actually only allows collisions from the left side of a line, which is our "normal")

					geometryIntersection.add(normal.copy().setMag(this.radius - dist)); // save how far the circle intersects this line

					PVector reflectionNormalized = PVector.sub(velocityNormalized, PVector.mult(normal, 2).mult(normalDot)); // https://math.stackexchange.com/a/13263
					reflectionTotal.add(reflectionNormalized);

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

		this.lastCollisionNormal = normalAverage;
		this.lastCollisionTick = tickCount;
	}

	float getLinePointDist(PVector start, PVector end, PVector circlePos) {
		Line2D.Float line = new Line2D.Float(start.x, start.y, end.x, end.y);
		return (float)line.ptSegDist(circlePos.x, circlePos.y);
	}
}
