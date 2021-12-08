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
			PVector[][] polygons = this.subtractPolygons(geo.getVertices(), circle);
			for (PVector[] polygon : polygons) {
				new Geometry(polygon, geo.colorFill).spawn(); // TODO: Fix render z-order
			}
			geo.delete();
		}
	}

	PVector[][] subtractPolygons(PVector[] vertsSubject, PVector[] vertsClip) {
		final int PRECISION = 1000;

		Path subject = new Path(vertsSubject.length);
		for (PVector vertex : vertsSubject) {
			subject.add(new Point.LongPoint((long)vertex.x * PRECISION, (long)vertex.y * PRECISION));
		}

		Path clip = new Path(vertsClip.length);
		for (PVector vertex : vertsClip) {
			clip.add(new Point.LongPoint((long)vertex.x * PRECISION, (long)vertex.y * PRECISION));
		}

		Paths solution = new Paths();

		DefaultClipper clipper = new DefaultClipper(Clipper.STRICTLY_SIMPLE);
		clipper.addPath(subject, Clipper.PolyType.SUBJECT, true);
		clipper.addPath(clip, Clipper.PolyType.CLIP, true);
		clipper.execute(Clipper.ClipType.DIFFERENCE, solution);

		PVector[][] result = new PVector[solution.size()][];

		for (int i = 0; i < solution.size(); i++) {
			Path path = solution.get(i);
			result[i] = new PVector[path.size()];
			for (int j = 0; j < path.size(); j++) {
				Point.LongPoint point = path.get(j);
				result[i][j] = new PVector(point.getX() / PRECISION, point.getY() / PRECISION);
			}
		}

		return result;
	}

	PVector[] getCircleVertices(PVector origin, float radius, int sides) {
		float step = TWO_PI / sides;
		PVector[] vertices = new PVector[sides];

		for (int i = 0; i < sides; i++) {
			float angle = i * step;

			vertices[i] = new PVector(
				origin.x + radius * cos(angle),
				origin.y + radius * sin(angle)
			);
		}

		return vertices;
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
