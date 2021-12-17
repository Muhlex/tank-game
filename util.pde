color lerpColors(float amt, color... colors) {
	if (colors.length == 1) return colors[0];

	float cUnit = 1.0 / (colors.length - 1);
	return lerpColor(colors[floor(amt / cUnit)], colors[ceil(amt / cUnit)], amt % cUnit / cUnit);
}

boolean isRectInsideRect(PVector[] inside, PVector[] outside) {
	return isRectInsideRect(inside[0], inside[1], outside[0], outside[1]);
}

boolean isRectInsideRect(PVector insideTL, PVector insideBR, PVector outsideTL, PVector outsideBR) {
	return outsideTL.x < insideBR.x
		&& outsideTL.y < insideBR.y
		&& outsideBR.x > insideTL.x
		&& outsideBR.y > insideTL.y;
}

float getLineSegmentPointDist(PVector[] line, PVector point) {
	return (float)Line2D.ptSegDist(line[0].x, line[0].y, line[1].x, line[1].y, point.x, point.y);
}

float getLineSegmentLineSegmentDist(PVector[] lineA, PVector[] lineB) {
	boolean intersecting = Line2D.linesIntersect(
		lineA[0].x, lineA[0].y, lineA[1].x, lineA[1].y,
		lineB[0].x, lineB[0].y, lineB[1].x, lineB[1].y
	);
	if (intersecting) return 0.0;

	return min(new float[] {
		getLineSegmentPointDist(lineA, lineB[0]),
		getLineSegmentPointDist(lineA, lineB[1]),
		getLineSegmentPointDist(lineB, lineA[0]),
		getLineSegmentPointDist(lineB, lineA[1])
	});
}

PVector getClosestPointOnLineSegment(PVector[] line, PVector point)
{
	PVector diff = PVector.sub(line[1], line[0]);
	double frac = ((point.x - line[0].x) * diff.x + (point.y - line[0].y) * diff.y) / (diff.x * diff.x + diff.y * diff.y);

	if (frac < 0.0)
		return line[0].copy();
	else if (frac > 1.0)
		return line[1].copy();
	else
		return new PVector((float)(line[0].x + frac * diff.x), (float)(line[0].y + frac * diff.y));
}

PVector[] getCircleVertices(PVector origin, float radius, int sides) {
	float step = TWO_PI / sides;
	PVector[] vertices = new PVector[sides];

	for (int i = 0; i < sides; i++) {
		float angle = i * step;

		vertices[i] = new PVector(
			origin.x + radius * cos(angle),
			origin.y + radius * sin(angle)
		);
	}

	return vertices;
}

PVector[][] subtractPolygons(PVector[] vertsSubject, PVector[] vertsClip) {
	// Clipper expects (long) integers to not have rounding errors.
	// This is corresponds to the decimal places that we will account for.
	final long PRECISION = 1000;

	Path subject = new Path(vertsSubject.length);
	for (PVector vertex : vertsSubject) {
		subject.add(new Point.LongPoint((long)(vertex.x * PRECISION), (long)(vertex.y * PRECISION)));
	}

	Path clip = new Path(vertsClip.length);
	for (PVector vertex : vertsClip) {
		clip.add(new Point.LongPoint((long)(vertex.x * PRECISION), (long)(vertex.y * PRECISION)));
	}

	Paths solution = new Paths();

	DefaultClipper clipper = new DefaultClipper(Clipper.STRICTLY_SIMPLE);
	clipper.addPath(subject, Clipper.PolyType.SUBJECT, true);
	clipper.addPath(clip, Clipper.PolyType.CLIP, true);
	clipper.execute(Clipper.ClipType.DIFFERENCE, solution);

	PVector[][] result = new PVector[solution.size()][];

	for (int i = 0; i < solution.size(); i++) {
		Path path = solution.get(i);
		result[i] = new PVector[path.size()];
		for (int j = 0; j < path.size(); j++) {
			Point.LongPoint point = path.get(j);
			result[i][j] = new PVector(point.getX() / PRECISION, point.getY() / PRECISION);
		}
	}

	return result;
}
