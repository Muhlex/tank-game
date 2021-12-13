class LevelManager {

	LevelManager() {
		this.loadLevel("test");
	}

	void loadLevel(String path) {
		Level level = parseLevel(path);

		entities.clear();
		level.spawn();
		for (Entity entity : level.entities) {
			entity.spawn();
		}
		camera.follow(entities.getByClass(Tank.class), 800.0, 1920.0, 128.0);
	}

	Level parseLevel(String path) {
		path = "levels/" + path;
		if (!path.endsWith(".svg"))
			path += ".svg";

		PShape svgShape = loadShape(path);
		XML svgXml = loadXML(path);
		for (XML node : svgXml.getChildren())
			if (node.getName() == "#text")
				svgXml.removeChild(node);

		List<Entity> entities = new ArrayList<Entity>();

		for (int i = 0; i < svgXml.getChildCount(); i++) {
			PShape shape = svgShape.getChild(i);
			XML node = svgXml.getChild(i);

			switch (node.getName()) {
				case "path":
					entities.add(this.parseGeometry(node, shape));
					break;
				case "circle":
					entities.add(this.parseTank(node));
					break;
			}
		}
		return new Level(entities.toArray(new Entity[0]));
	}

	Geometry parseGeometry(XML node, PShape shape) {
		List<PVector> vertices = new ArrayList<PVector>();
		for (int j = 0; j < shape.getVertexCount(); j++) {
			vertices.add(shape.getVertex(j));
		}

		return new Geometry(vertices.toArray(new PVector[0]), this.getFill(node));
	}

	Tank parseTank(XML node) {
		PVector origin = new PVector(node.getFloat("cx"), node.getFloat("cy"));

		return new Tank(origin, this.getFill(node));
	}

	color getFill(XML node) {
		String fillString = node.getString("fill", "#FF0000");

		if (fillString.contains("#")) {
			fillString = fillString.replace("#", "");
		} else {
			println("Can only load hexadecimal color values! Object will be rendered red: \n" + node);
			fillString = "FF0000";
		}

		if (fillString.length() == 6) // when there is no alpha value, make it fully opaque
			fillString = "FF" + fillString;

		return unhex(fillString);
	}
}
