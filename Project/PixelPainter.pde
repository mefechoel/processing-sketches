class PixelPainter {
	static final String NORMAL = "LoopMode.Normal";
	static final String KALEIDOSCOPE = "LoopMode.Kaleidoscope";
	static final String MULTI_KALEIDOSCOPE = "LoopMode.MultiKaleidoscope";
	static final String VERTICAL_BLINDS = "LoopMode.VerticalBlinds";
	static final String HORIZONTAL_BLINDS = "LoopMode.HorizontalBlinds";
	static final String VERTICAL_MIRROR = "LoopMode.VerticalMirror";
	static final String HORIZONTAL_MIRROR = "LoopMode.HorizontalMirror";
	static final String VERTICAL_FLIPPED_MIRROR = "LoopMode.VerticalFlippedMirror";
	static final String HORIZONTAL_FLIPPED_MIRROR = "LoopMode.HorizontalFlippedMirror";

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
		} else if (this.mode == MULTI_KALEIDOSCOPE) {
			for (int y = 0; y < this.height / 4; y++) {
				for (int x = 0; x < this.width / 4; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					for (int yi = 0; yi < 4; yi++) {
						for (int xi = 0; xi < 4; xi++) {
							// int asdf = ((xi + yi) % 2);
							// int abc = asdf * 2 - 1;
							int xoff = (int) ((width - 1) * xi * 0.25);
							int yoff = (int) ((height - 1) * yi * 0.25);
							int xx = x + xoff;
							int yy = y + yoff;
							// int xx = x + (int) ((width - 1) * 0.25 * asdf) + xoff * -abc;
							// int yy = y + (int) ((width - 1) * 0.25 * asdf) + yoff * -abc;
							pixels[index(xx, yy, this.width)] = pixel;
						}
					}
				}
			}
		} else if (this.mode == VERTICAL_MIRROR) {
			for (int y = 0; y < this.height; y++) {
				for (int x = 0; x < this.width / 2; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
					pixels[index(this.width - 1 - x, y, this.width)] = pixel;
				}
			}
		} else if (this.mode == HORIZONTAL_MIRROR) {
			for (int y = 0; y < this.height / 2; y++) {
				for (int x = 0; x < this.width; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
					pixels[index(x, this.height - 1 - y, this.width)] = pixel;
				}
			}
		} else if (this.mode == VERTICAL_FLIPPED_MIRROR) {
			for (int y = 0; y < this.height; y++) {
				for (int x = 0; x < this.width / 2; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
					pixels[index(this.width - 1 - x, this.height - 1 - y, this.width)] = pixel;
				}
			}
		} else if (this.mode == HORIZONTAL_FLIPPED_MIRROR) {
			for (int y = 0; y < this.height / 2; y++) {
				for (int x = 0; x < this.width; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
					pixels[index(this.width - 1 - x, this.height - 1 - y, this.width)] = pixel;
				}
			}
		} else if (this.mode == VERTICAL_BLINDS) {
			for (int y = 0; y < this.height; y++) {
				for (int x = 0; x < this.width / 4; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
					pixels[index((int) (x + (width - 1) * 0.25), y, this.width)] = pixel;
					pixels[index((int) (x + (width - 1) * 0.5), y, this.width)] = pixel;
					pixels[index((int) (x + (width - 1) * 0.75), y, this.width)] = pixel;
				}
			}
		} else if (this.mode == HORIZONTAL_BLINDS) {
			for (int y = 0; y < this.height / 4; y++) {
				for (int x = 0; x < this.width; x++) {
					int i = index(x, y, this.width);
					color pixel = this.pixelCreator.createPixel(oldPixels, x, y);
					pixels[i] = pixel;
					pixels[index(x, (int) (y + (height - 1) * 0.25), this.width)] = pixel;
					pixels[index(x, (int) (y + (height - 1) * 0.5), this.width)] = pixel;
					pixels[index(x, (int) (y + (height - 1) * 0.75), this.width)] = pixel;
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
