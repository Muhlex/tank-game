class Projectile extends PhysicsCircle {
	color tint;

	Projectile(PVector origin, PVector velocity, color tint) {
		super(origin, velocity, 8, 10, 0.33, 0.0);

		this.tint = tint;
	}

	void OnCollision(PVector normal, float force) {
		this.delete();
	}

	void OnDraw() {
		noStroke();
		fill(tint);
		circle(this.origin.x, this.origin.y, this.radius); // half the hitbox size
	}
}
