PImage img;
float scaleX = 1.16;
float scaleY = 1.16;
float offsetFraction = 0.1;

void setup() {
	size(1200, 800);

	img = loadImage("mountain.jpg");
	image(img, 0, 0, width, height);
}

void draw() {
	loadPixels();

	int maxOffset = (int) (min(width, height) * offsetFraction);

	color[] oldPixels = new color[pixels.length];
	for (int i = 0; i < pixels.length; i++) {
		oldPixels[i] = pixels[i];
	}

	int xoff = (int) (((mouseX / (width + 0.0)) * 2.0 - 1) * maxOffset);
	int yoff = (int) (((mouseY / (height + 0.0)) * 2.0 - 1) * maxOffset);

	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			int i = y * width + x;
			color pixel = pixelAt(
				oldPixels,
				width,
				x + xoff,
				y + yoff,
				scaleX,
				scaleY,
				oldPixels[i]
			);
			pixels[i] = lerpColor(pixel, oldPixels[i], 0.3);
		}
	}

	updatePixels();
}

color pixelAt(
	color[] pixels,
	int width,
	int x,
	int y,
	float zoomX,
	float zoomY,
	color neutral
) {
	int height = pixels.length / width;
	int zoomedWidth = (int) (width * zoomX);
	int zoomedHeight = (int) (height * zoomY);
	int zoomedX = (int) (x * zoomX + (width - zoomedWidth) / 2.0);
	int zoomedY = (int) (y * zoomY + (height - zoomedHeight) / 2.0);
	if (zoomedX >= width || zoomedY >= height || zoomedX < 0 || zoomedY < 0) {
		return neutral;
	}
	int zoomedIndex = zoomedY * width + zoomedX;
	return pixels[zoomedIndex];
}
