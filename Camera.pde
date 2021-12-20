class Camera extends Node {
	float fov; // total horizontal units
	float minFov;
	float maxFov;
	float padding;
	float easingFrac;
	List<? extends Entity> followedEntities;

	List<CameraShake> cameraShakes;

	PVector canvasCenter;
	float globalScale;
	float fovScale;

	PVector targetOrigin;
	float targetFov;

	Camera(PVector origin, float fov) {
		this.fov = fov;
		this.minFov = fov;
		this.maxFov = fov;
		this.padding = 0.0;
		this.easingFrac = 1.0;
		this.followedEntities = null;

		this.cameraShakes = new ArrayList();

		this.updateDrawParams();
		this.updateBoundingBox();

		this.targetOrigin = null;
		this.targetFov = -1.0;
	}

	PVector getMousePos() {
		return new PVector(mouseX, mouseY)
			.sub(this.canvasCenter)
			.div(this.globalScale)
			.div(this.fovScale)
			.add(this.origin);
	}

	void follow(List<? extends Entity> entities) {
		this.follow(entities, this.minFov, this.maxFov, this.padding, this.easingFrac, false);
	}
	void follow(List<? extends Entity> entities, float minFov, float maxFov, float padding) {
		this.follow(entities, minFov, maxFov, padding, this.easingFrac, false);
	}
	void follow(List<? extends Entity> entities, float minFov, float maxFov, float padding, float easingFrac, boolean instant) {
		this.followedEntities = entities;
		this.minFov = minFov;
		this.maxFov = maxFov;
		this.padding = padding;
		this.easingFrac = easingFrac;

		this.updateFollow();
		this.updateTarget(instant);
	}

	void shake(CameraShake shake) {
		synchronized (this.cameraShakes) {
			this.cameraShakes.add(shake);
		}
	}

	void stopShaking() {
		synchronized (this.cameraShakes) {
			this.cameraShakes.clear();
		}
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

	void updateTarget(boolean instant) {
		float easingFrac = instant ? 1.0 : this.easingFrac;

		if (this.targetOrigin != null) {
			this.origin.add(PVector.sub(this.targetOrigin, this.origin).mult(easingFrac));
		}

		if (this.targetFov > -1.0) {
			this.fov = lerp(this.fov, this.targetFov, easingFrac);
		}
	}

	void updateDrawParams() {
		this.canvasCenter = new PVector(width / 2.0, height / 2.0);
		this.globalScale = width / (float)DEFAULT_WIDTH;
		this.fovScale = DEFAULT_WIDTH / this.fov;
	}

	void updateBoundingBox() {
		this.boundingBox = this.getBoundingBoxForRect(this.fov, this.fov * (height / (float)width));
	}

	boolean getIsNodeVisible(Node node) {
		return isRectInsideRect(node.boundingBox, this.boundingBox);
	}

	void OnTick() {
		this.updateFollow();
		this.updateTarget(false);

		this.updateDrawParams();
		this.updateBoundingBox();
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

		synchronized (this.cameraShakes) {
			for (Iterator<CameraShake> iter = this.cameraShakes.iterator(); iter.hasNext(); ) {
				CameraShake shake = iter.next();
				PVector shakeOffset = shake.getOffset();

				if (shakeOffset == null) iter.remove();
				else translate(shakeOffset.x, shakeOffset.y);
			}
		}

		entities.OnDraw(this);
		particles.OnDraw(this);

		popMatrix();
	}
}

class CameraShake {
	float force;
	int duration;
	float startAngle;
	float rotations;
	int peakCount;
	long startTick;

	CameraShake(float force, int duration) {
		this(force, duration, random(TWO_PI));
	}
	CameraShake(float force, int duration, float startAngle) {
		this(force, duration, startAngle, duration / 4000.0, duration / 200);
	}
	CameraShake(float force, int duration, float startAngle, float rotations, int peakCount) {
		this.force = force;
		this.duration = duration;
		this.startAngle = startAngle;
		this.rotations = rotations;
		this.peakCount = peakCount;
		this.startTick = levels.getCurrent().currentTick;
	}

	int getRestDuration() {
		return this.duration - (int)((levels.getCurrent().currentTick - this.startTick) * TICK_MS);
	}
	float getRestDurationFrac() {
		return this.getRestDuration() / (float)this.duration;
	}

	PVector getOffset() {
		float restFrac = this.getRestDurationFrac();
		float frac = 1.0 - restFrac;
		if (restFrac <= 0.0) return null;

		PVector offset = new PVector(sin(lerp(0.0, PI * this.peakCount, restFrac)) * this.force * restFrac, 0.0);
		return offset.rotate(frac * TWO_PI * this.rotations + this.startAngle);
	}
}
