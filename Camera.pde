class Camera {
	PVector origin; // screen center point
	float fov; // total horizontal units
	float minFov;
	float maxFov;
	float padding;
	List<? extends Entity> followedEntities;

	PVector canvasCenter;
	float globalScale;
	float fovScale;

	PVector targetOrigin;
	float targetFov;

	Camera(PVector origin, float fov) {
		this.origin = origin;
		this.fov = fov;
		this.minFov = fov;
		this.maxFov = fov;
		this.padding = 0.0;
		this.followedEntities = null;

		this.updateDrawParams();

		this.targetOrigin = null;
		this.targetFov = -1.0;
	}

	void follow(List<? extends Entity> entities, float minFov, float maxFov, float padding) {
		this.followedEntities = entities;
		this.minFov = minFov;
		this.maxFov = maxFov;
		this.padding = padding;
	}

	void OnTick() {
		this.updateFollow();
		this.updateTarget();
		this.updateDrawParams();
	}

	void updateFollow() {
		if (this.followedEntities == null) return;

		for (Iterator<? extends Entity> iter = this.followedEntities.iterator(); iter.hasNext(); ) {
			Entity entity = iter.next();
			if (!entity.alive) iter.remove();
		}

		int entityCount = this.followedEntities.size();

		if (entityCount == 0) {
			this.followedEntities = null;
			return;
		}

		float[] xs = new float[entityCount];
		float[] ys = new float[entityCount];
		for (int i = 0; i < entityCount; i++) {
			xs[i] = this.followedEntities.get(i).origin.x;
			ys[i] = this.followedEntities.get(i).origin.y;
		}
		PVector mins = new PVector(min(xs), min(ys));
		PVector maxs = new PVector(max(xs), max(ys));
		PVector diff = PVector.sub(maxs, mins);

		this.targetFov = constrain(maxs.x - mins.x + (this.padding * 2), this.minFov, this.maxFov);
		this.targetOrigin = mins.add(diff.div(2)); // !! mutates everything cause why not
	}

	void updateTarget() {
		if (this.targetOrigin != null) {
			this.origin.add(PVector.sub(this.targetOrigin, this.origin).mult(0.04));
		}

		if (this.targetFov > -1.0) {
			this.fov = lerp(this.fov, this.targetFov, 0.04);
		}
	}

	void updateDrawParams() {
		this.canvasCenter = new PVector(width / 2.0, height / 2.0);
		this.globalScale = width / (float)DEFAULT_WIDTH;
		this.fovScale = DEFAULT_WIDTH / this.fov;
	}

	PVector getMousePos() {
		return new PVector(mouseX, mouseY)
			.sub(this.canvasCenter)
			.div(this.globalScale)
			.div(this.fovScale)
			.add(this.origin);
	}

	void OnDraw() {
		pushMatrix();

		// shift 0, 0 to the screen center
		translate(this.canvasCenter.x, this.canvasCenter.y);
		// global scale for window size changes
		scale(this.globalScale);

		// set fov scale
		scale(this.fovScale);
		// set camera position
		translate(-this.origin.x, -this.origin.y);

		entities.OnDraw(this);
		particles.OnDraw(this);

		popMatrix();
	}
}
