class PixelPainter {
	static final String NORMAL = "LoopMode.Normal";
	static final String KALEIDOSCOPE = "LoopMode.Kaleidoscope";

	int width;
	int height;
	PixelCreateable pixelCreator;
	String mode = NORMAL;

	int index(int x, int y, int width) {
		return x + y * width;
	}

	void setMode(String mode) {
		this.mode = mode;
	}

	void setPixelCreator(PixelCreateable pixelCreator) {
		this.pixelCreator = pixelCreator;
	}

	void setDimensions(int width, int height) {
		this.width = width;
		this.height = height;
	}

	void runLoop(color[] oldPixels, color[] pixels) {
		if (this.mode == KALEIDOSCOPE) {
			for (int y = 0; y < this.height / 2; y++) {
				for (int x = 0; x < this.width / 2; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
					pixels[index(x, this.height - 1 - y, this.width)] = pixel;
					pixels[index(this.width - 1 - x, y, this.width)] = pixel;
					pixels[index(this.width - 1 - x, this.height - 1 - y, this.width)] = pixel;
				}
			}
		} else {
			for (int y = 0; y < this.height; y++) {
				for (int x = 0; x < this.width; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
				}
			}
		}
	}

	void paint(color[] pixels) {
		color[] oldPixels = new color[pixels.length];
		for (int i = 0; i < pixels.length; i++) {
			oldPixels[i] = pixels[i];
		}
		this.runLoop(oldPixels, pixels);
	}
}
