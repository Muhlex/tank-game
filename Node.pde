abstract class Node {
	public boolean alive;
	public long birthTick;
	public PVector origin;

	Node() {
		this.alive = false;
		this.birthTick = -1L;
		this.origin = new PVector(0, 0);
	}

	void spawn() {
		this.alive = true;
		this.birthTick = currentTick;
	}

	void delete() {
		this.alive = false;
	}

	long getTicksAlive() {
		return currentTick - this.birthTick;
	}

	abstract void OnTick();
	abstract void OnDraw();
}
