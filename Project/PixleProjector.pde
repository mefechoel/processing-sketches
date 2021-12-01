class PixelProjector implements PixelGetter {
	int originX;
	int originY;

	List<Transformation> transforms;

	void setOrigin(int originX, int originY) {
		this.originX = originX;
		this.originY = originY;
	}
}
