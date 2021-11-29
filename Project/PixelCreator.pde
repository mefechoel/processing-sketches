class PixelCreator implements PixelCreateable {
	int xoff = 0;
	int yoff = 0;
	Scaler scaler;

	color rotateHue(color col, float amount) {
		return color(
			(hue(col) + amount) % 255,
			saturation(col),
			brightness(col)
		);
	}

	void setOffset(int xoff, int yoff) {
		this.xoff = xoff;
		this.yoff = yoff;
	}

	void setScaler(Scaler scaler) {
		this.scaler = scaler;
	}

	color createPixel(color[] oldPixels, int x, int y) {
		int i = index(x, y, width);
		color pixel = scaler.getPixel(
			oldPixels,
			x + xoff,
			y + yoff,
			oldPixels[i]
		);
		return this.rotateHue(pixel, 2.0);
	}
}
