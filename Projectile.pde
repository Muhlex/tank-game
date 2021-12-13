class Projectile extends PhysicsCircle {
	color tint;

	Projectile(PVector origin, PVector velocity, color tint) {
		super(origin, velocity, 6, 12, 0.33, 0.0);
		this.zIndex = 1100;

		this.tint = tint;
	}

	void OnCollision(Collision collision) {
		new Explosion(collision.position, 96.0).spawn();
		this.delete();
	}

	void OnDraw() {
		noStroke();
		fill(tint);
		circle(this.origin.x, this.origin.y, this.radius * 2);
	}
}
