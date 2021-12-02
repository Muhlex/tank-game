class Projectile extends PhysicsCircle {
	color tint;

	Projectile(PVector origin, PVector velocity, color tint) {
		super(origin, velocity, 8, 10, 0.33, 0.0);

		this.tint = tint;
	}

	void OnCollision(PVector collisionPos, PVector normal, float force) {
		new Explosion(collisionPos, 96.0);
		this.delete();
	}

	void OnDraw() {
		noStroke();
		fill(tint);
		circle(this.origin.x, this.origin.y, this.radius * 1.5);
	}
}
