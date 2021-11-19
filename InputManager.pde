class InputManager extends Entity {
	StringDict inputMappings;
	HashSet inputsActive;

	InputManager() {
		this.inputsActive = new HashSet();
		this.inputMappings = new StringDict();

		this.inputMappings.set("a", "moveleft");
		this.inputMappings.set("d", "moveright");
	}

	boolean getIsActive(String inputName) {
		return this.inputsActive.contains(inputName);
	}

	String getInputForKey(char key) {
		return this.inputMappings.get(Character.toString(key));
	}

	void keyPressed() {
		String inputName = this.getInputForKey(key);
		if (inputName == null) return;
		this.inputsActive.add(inputName);
	}

	void keyReleased() {
		String inputName = this.getInputForKey(key);
		if (inputName == null) return;
		this.inputsActive.remove(inputName);
	}
}
