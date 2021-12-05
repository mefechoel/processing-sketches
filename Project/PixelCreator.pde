class PixelCreator implements PixelCreateable {
	PixelGetter pixelGetter;

	float hueRotation = 0.0;

	void setHueRotation(float offset) {
		this.hueRotation = offset;
	}

	color rotateHue(color col, float amount) {
		return color(
			(hue(col) + amount) % 255,
			saturation(col),
			brightness(col)
		);
	}

	void setPixelGetter(PixelGetter pixelGetter) {
		this.pixelGetter = pixelGetter;
	}

	color createPixel(color[] oldPixels, int x, int y) {
		int i = x + y * width;
		color pixel = pixelGetter.getPixel(oldPixels, x, y, oldPixels[i]);
		return this.rotateHue(pixel, hueRotation);
	}
}
