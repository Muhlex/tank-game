class Explosion extends Entity {
	PVector origin;
	float radius;
	float damage;
	float force;
	int duration;
	int destructions;

	Explosion(PVector origin, float radius) {
		this.origin = origin;
		this.radius = radius;
		this.damage = 0.0;
		this.force = 2.5;
		this.duration = 350;
		this.destructions = 0;

		this.applyForce();
	}

	int getRestDuration() {
		return this.duration - (int)((currentTick - this.birthTick) * TICK_MS);
	}

	float getRestDurationFrac() {
		return this.getRestDuration() / (float)this.duration;
	}

	void applyForce() {
		for (Tank tank : entities.getEntitiesByClass(Tank.class)) {
			float forceFrac = 1.0 - min(PVector.dist(tank.origin, this.origin) / this.radius, 1.0);
			tank.velocity.add(PVector.sub(tank.origin, this.origin).setMag(this.force * forceFrac));
		}
	}

	void destroyGeometry() {
		PVector[] circle = getCircleVertices(this.origin, this.radius / 1.5, 16);

		for (Geometry geo : entities.getEntitiesByClass(Geometry.class)) {
			PVector[][] polygons = subtractPolygons(geo.getVertices(), circle);
			for (PVector[] polygon : polygons) {
				new Geometry(polygon, geo.colorFill).spawn(); // TODO: Fix render z-order
			}
			geo.delete();
		}
	}

	void OnTick() {
		float restDurationFrac = this.getRestDurationFrac();
		if (this.destructions == 0 && restDurationFrac < 0.25)
			this.destroyGeometry();

		if (restDurationFrac <= 0)
			this.delete();
	}

	void OnDraw() {
		final float OPACITY_FRAC = 0.3; // fraction of the lifetime at the start AND end to fade in AND out respectively
		float durationFrac = 1.0 - this.getRestDurationFrac();

		int opacity = (int)lerp(0, 200, 1.0 - (max((abs(durationFrac - 0.5) - (0.5 - OPACITY_FRAC)), 0.0) / OPACITY_FRAC));
		float radius = lerp(this.radius / 5, this.radius, durationFrac);
		color colorFill = lerpColor(color(#fff996), color(#ff4a3d), durationFrac);
		noStroke();
		fill(colorFill, opacity);
		circle(this.origin.x, this.origin.y, radius * 2);
	}
}
