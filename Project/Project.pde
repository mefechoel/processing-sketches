PImage img;
float scaleX = 1.16;
float scaleY = 1.16;
float offsetFraction = 0.15;
float hueRotation = 2;
int xoff = 0;
int yoff = 0;

Scaler scaler;
Rotator rotator;
PixelPainter painter;
PixelCreator creator;

void setup() {
	// fullScreen();
	size(1400, 960);
	// surface.setResizable(true);
	// frameRate(2);
	// noLoop();

	colorMode(HSB);

	img = loadImage("sunset.jpg");
	image(img, 0, 0, width, height);

	// background(6, 40, 80);
	// noStroke();
	// for (int i = 0; i < 185; ++i) {
	// 	fill(random(30, 255), random(30, 255), random(30, 255));
	// 	circle(random(width), random(height), random(65, 125));
	// }

	scaler = new Scaler();
	rotator = new Rotator();
	painter = new PixelPainter();
	creator = new PixelCreator();
	creator.setPixelGetter(rotator);
	painter.setPixelCreator(creator);
}

void draw() {
	loadPixels();

	int maxOffset = (int) (min(width, height) * offsetFraction);
	xoff = (int) (((mouseX / (width + 0.0)) * 2.0 - 1) * maxOffset);
	yoff = (int) (((mouseY / (height + 0.0)) * 2.0 - 1) * maxOffset);

	scaler.setScale(width, height, scaleX, scaleY);
	rotator.setRotation(width, height, TWO_PI / 6.0);
	painter.setDimensions(width, height);
	creator.setOffset(xoff, yoff);

	painter.paint(pixels);

	if (mousePressed) {
		painter.setMode(PixelPainter.KALEIDOSCOPE);
	} else {
		painter.setMode(PixelPainter.NORMAL);
	}

	updatePixels();
}
