class PixelCreator implements PixelCreateable {
	int xoff = 0;
	int yoff = 0;
	PixelGetter pixelGetter;

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

	void setPixelGetter(PixelGetter pixelGetter) {
		this.pixelGetter = pixelGetter;
	}

	color createPixel(color[] oldPixels, int x, int y) {
		int i = x + y * width;
		color pixel = pixelGetter.getPixel(
			oldPixels,
			x + xoff,
			y + yoff,
			oldPixels[i]
		);
		return this.rotateHue(pixel, 2.0);
	}
}
