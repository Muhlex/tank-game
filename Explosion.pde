class Explosion extends Entity {
	float radius;
	float damage;
	float force;
	int duration;
	int destructions;

	Explosion(PVector origin, float radius, float force) {
		this.zIndex = 1200;

		this.origin = origin;
		this.radius = radius;
		this.damage = 0.0;
		this.force = force;
		this.duration = 350;
		this.destructions = 0;

		this.updateBoundingBox();
		this.applyForce();

		PVector vecToCamera = PVector.sub(camera.origin, this.origin);
		float distToCamera = vecToCamera.mag();
		float shakeMult = map(constrain(distToCamera, 40.0, 320.0), 40.0, 320.0, 1.0, 0.5);
		camera.shake(new CameraShake(
			force * 0.2 * shakeMult,
			(int)(radius * 16 * shakeMult),
			vecToCamera.heading()
		));
	}

	long getRestDuration() {
		return this.duration - (this.getTicksAlive() * TICK_MS);
	}

	float getRestDurationFrac() {
		return this.getRestDuration() / (float)this.duration;
	}

	void applyForce() {
		List<PhysicsEntity> affectedEntities = new ArrayList<PhysicsEntity>();
		affectedEntities.addAll(entities.getByClass(Tank.class));
		affectedEntities.addAll(entities.getByClass(DebugBall.class));

		for (PhysicsEntity entity : affectedEntities) {
			float forceFrac = 1.0 - min(PVector.dist(entity.origin, this.origin) / this.radius, 1.0);
			entity.applyForce(PVector.sub(entity.origin, this.origin).setMag(this.force * forceFrac));
		}
	}

	void destroyGeometry() {
		PVector[] circle = getCircleVertices(this.origin, this.radius / 1.5, 16);

		for (Geometry geo : entities.getByClass(Geometry.class)) {
			PVector[][] polygons = subtractPolygons(geo.getVertices(), circle);
			for (PVector[] polygon : polygons) {
				new Geometry(polygon, geo.colorFill, geo.solid).spawn();
			}
			geo.delete();
		}
		this.destructions++;
	}

	void updateBoundingBox() {
		this.boundingBox = this.getBoundingBoxForRadius(this.radius);
	}

	void OnTick() {
		float restDurationFrac = this.getRestDurationFrac();
		if (this.destructions == 0 && restDurationFrac < 0.5)
			this.destroyGeometry();

		if (restDurationFrac <= 0)
			this.delete();
	}

	void OnDraw() {
		final float OPACITY_FRAC = 0.3; // fraction of the lifetime at the start AND end to fade in AND out respectively
		float durationFrac = 1.0 - this.getRestDurationFrac();

		float opacity = lerp(0, 0.9, 1.0 - (max((abs(durationFrac - 0.5) - (0.5 - OPACITY_FRAC)), 0.0) / OPACITY_FRAC));
		float radius = lerp(this.radius / 5, this.radius, durationFrac);
		color colorFill = lerpColor(color(#fff996), color(#ff4a3d), durationFrac);
		noStroke();
		fill(colorFill, opacity);
		circle(this.origin.x, this.origin.y, radius * 2);
	}
}
