class DebugController extends Entity {
	void updateBoundingBox() {}

	void OnInputStart(String inputName) {
		if (inputName == "restart") {
			levels.loadLevel("test");
		}
	}

	void OnMousePressed() {
		if (mouseButton != CENTER) return;

		if (!inputs.getIsActive("debug"))
			new DebugBall(camera.getMousePos(), random(1, 16), random(0, 1), random(1.0) < 0.5 ? random(0, 1) : random(0.95, 1.0), true).spawn();
		else
			for (int i = 0; i < 100; i++)
				new DebugBall(camera.getMousePos(), random(1, 16), random(0, 1), random(1.0) < 0.5 ? random(0, 1) : random(0.95, 1.0), false).spawn();
	}
}
