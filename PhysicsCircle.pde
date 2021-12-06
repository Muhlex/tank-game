class PhysicsCircle extends Entity {
	PVector origin;
	PVector lastTickOrigin;
	PVector velocity;
	float radius;
	float mass;
	float bounce;
	float roll;

	Collision lastCollision;
	boolean onGround;

	PhysicsCircle(PVector origin, PVector velocity, float radius, float mass, float bounce, float roll) {
		this.origin = origin;
		this.lastTickOrigin = null;
		this.velocity = velocity;
		this.radius = radius;
		this.mass = mass;
		this.bounce = bounce;
		this.roll = roll;

		this.lastCollision = null;
		this.onGround = false;
	}

	void OnTick() {
		this.cleanupOffscreen();

		this.velocity.y += this.mass * GRAVITY;
		this.origin.add(this.velocity);

		this.updateCollision();

		if (this.lastCollision != null && this.lastCollision.tick < currentTick - 5)
			this.onGround = false;

		this.lastTickOrigin = this.origin.copy();
	}

	void cleanupOffscreen() {
		boolean offscreenX = this.origin.x < width * -1 || this.origin.x > width + width * 1;
		boolean offscreenY = this.origin.y < height * -8 || this.origin.y > height + height * 4;
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
		collidedEntities.add(this);

		for (Geometry geo : entities.getEntitiesByClass(Geometry.class)) {
			for (PVector[] line : geo.getLines()) {
				// this is basically a circle-shaped trace:
				float dist = this.getLineSegmentLineSegmentDist(line, new PVector[] {this.origin, this.lastTickOrigin});

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
		this.onGround = abs(normalAverage.heading() + HALF_PI) <= QUARTER_PI; // angled max 45deg

		this.lastCollision = new Collision(
			currentTick,
			collisionPos,
			normalAverage,
			collisionForce,
			collidedEntities.toArray(new Entity[0])
		);
		this.OnCollision(this.lastCollision);
	}

	float getLineSegmentPointDist(PVector[] line, PVector point) {
		return (float)Line2D.ptSegDist(line[0].x, line[0].y, line[1].x, line[1].y, point.x, point.y);
	}

	float getLineSegmentLineSegmentDist(PVector[] lineA, PVector[] lineB) {
		boolean intersecting = Line2D.linesIntersect(
			lineA[0].x, lineA[0].y, lineA[1].x, lineA[1].y,
			lineB[0].x, lineB[0].y, lineB[1].x, lineB[1].y
		);
		if (intersecting) return 0.0;

		return min(new float[] {
			this.getLineSegmentPointDist(lineA, lineB[0]),
			this.getLineSegmentPointDist(lineA, lineB[1]),
			this.getLineSegmentPointDist(lineB, lineA[0]),
			this.getLineSegmentPointDist(lineB, lineA[1])
		});
	}

	PVector getClosestPointOnLineSegment(PVector[] line, PVector point)
	{
		PVector diff = PVector.sub(line[1], line[0]);
		double frac = ((point.x - line[0].x) * diff.x + (point.y - line[0].y) * diff.y) / (diff.x * diff.x + diff.y * diff.y);

		if (frac < 0.0)
			return line[0].copy();
		else if (frac > 1.0)
			return line[1].copy();
		else
			return new PVector((float)(line[0].x + frac * diff.x), (float)(line[0].y + frac * diff.y));
	}

	void OnCollision(Collision collision) {}
}
