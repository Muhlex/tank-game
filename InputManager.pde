class InputManager {
	HashMap<Integer,String> inputMappings;
	HashSet inputsActive;

	InputManager() {
		this.inputMappings = new HashMap<Integer,String>();
		this.inputsActive = new HashSet();

		this.inputMappings.put(KeyEvent.VK_W, "moveup");
		this.inputMappings.put(KeyEvent.VK_S, "movedown");
		this.inputMappings.put(KeyEvent.VK_A, "moveleft");
		this.inputMappings.put(KeyEvent.VK_D, "moveright");
		this.inputMappings.put(KeyEvent.VK_R, "restart");
		this.inputMappings.put(KeyEvent.VK_SHIFT, "shift");
	}

	boolean getIsActive(String inputName) {
		return this.inputsActive.contains(inputName);
	}

	String getInputForKey(int keyCode) {
		return this.inputMappings.get(keyCode);
	}

	void OnKeyPressed() {
		String inputName = this.getInputForKey(keyCode);
		if (inputName == null || this.getIsActive(inputName)) return;
		this.inputsActive.add(inputName);

		entities.OnInputStart(inputName);
	}

	void OnKeyReleased() {
		String inputName = this.getInputForKey(keyCode);
		if (inputName == null || !this.getIsActive(inputName)) return;
		this.inputsActive.remove(inputName);

		entities.OnInputEnd(inputName);
	}

	void OnTick() {
		if (!focused) {
			this.inputsActive.clear();
		}
	}
}
