class ParticleManager {
	List<Particle> particles;
	List<Particle> addParticles;
	List<Particle> remParticles;

	ParticleManager() {
		this.particles = new ArrayList<Particle>();
		this.addParticles = new ArrayList<Particle>();
		this.remParticles = new ArrayList<Particle>();
	}

	void add(Particle particle) {
		this.addParticles.add(particle);
	}

	void remove(Particle particle) {
		this.remParticles.add(particle);
	}

	void clear() {
		this.particles.clear();
	}

	int getCount() {
		return this.particles.size();
	}

	void OnTick() {
		this.particles.addAll(this.addParticles);
		this.addParticles.clear();

		this.particles.removeAll(this.remParticles);
		this.remParticles.clear();

		for (Particle particle : this.particles) {
			particle.OnTick();
		}
	}

	void OnDraw(Camera camera) {
		for (Particle particle : new ArrayList<Particle>(this.particles)) {
			if (particle == null) return; // why do I have to do this???
			push();
			particle.OnDraw();
			pop();
		}
	}
}
