class PhysicsObject extends Entity {
	PVector origin;
	PVector velocity;
	float radius;
	float mass;
	float bounciness;
	boolean onGround;

	PhysicsObject(PVector origin, float radius, float mass, float bounciness) {
		this.origin = origin;
		this.radius = radius;
		this.mass = mass;
		this.bounciness = bounciness;

		this.velocity = new PVector();
		this.onGround = false;
	}

	void tick() {
		this.velocity.y += this.mass * GRAVITY;

		for (Geometry geo : geos) {
			for (PVector[] line : geo.getLines()) {
				if (this.testLineCircleIntersect(line[0].x, line[0].y, line[1].x, line[1].y, this.origin.x, this.origin.y, this.radius)) {
					PVector normal = PVector.sub(line[1], line[0]).rotate(-HALF_PI).normalize();
					this.velocity = normal.setMag(this.velocity.mag() * this.bounciness);

					// TODO: Implement onGround
				}
			}
		}

		this.origin.add(this.velocity);
	}

	boolean testLineCircleIntersect(float x1, float y1, float x2, float y2, float cx, float cy, float cr) {
		float dx = x2 - x1;
		float dy = y2 - y1;
		float a = dx * dx + dy * dy;
		float b = 2 * (dx * (x1 - cx) + dy * (y1 - cy));
		float c = cx * cx + cy * cy;
		c += x1 * x1 + y1 * y1;
		c -= 2 * (cx * x1 + cy * y1);
		c -= cr * cr;
		float bb4ac = b * b - 4 * a * c;

		if (bb4ac < 0) { // Not intersecting
			return false;
		}

		float mu = (-b + sqrt(b*b - 4*a*c)) / (2*a);
		float ix1 = x1 + mu*(dx);
		float iy1 = y1 + mu*(dy);
		mu = (-b - sqrt(b*b - 4*a*c)) / (2*a);
		float ix2 = x1 + mu*(dx);
		float iy2 = y1 + mu*(dy);

		// The intersection points
		//ellipse(ix1, iy1, 10, 10);
		//ellipse(ix2, iy2, 10, 10);

		float testX;
		float testY;
		// Figure out which point is closer to the circle
		if (dist(x1, y1, cx, cy) < dist(x2, y2, cx, cy)) {
			testX = x2;
			testY = y2;
		} else {
			testX = x1;
			testY = y1;
		}

		return dist(testX, testY, ix1, iy1) < dist(x1, y1, x2, y2) || dist(testX, testY, ix2, iy2) < dist(x1, y1, x2, y2);
	}
}
