PImage img;
float scaleX = 1.16;
float scaleY = 1.1;
float rotationAngle = -TWO_PI * 0.005;
float offsetFraction = 0.5;
float hueRotation = 2.0;
char prevKey = 'x';
float noiseOffset = 0.0;
float noiseStep = 0.01;
boolean isLooping = true;

TScaling scaling;
TRotation rotation;
TBaloon baloon;
PixelProjector projector;
PixelPainter painter;
PixelCreator creator;

void setup() {
	// fullScreen();
	size(1400, 960);
	// surface.setResizable(true);
	// frameRate(2);
	// noLoop();

	colorMode(HSB);

	img = loadImage("mountain.jpg");
	image(img, 0, 0, width, height);

	// background(6, 40, 80);
	// noStroke();
	// for (int i = 0; i < 185; ++i) {
	// 	fill(random(30, 255), random(30, 255), random(30, 255));
	// 	circle(random(width), random(height), random(65, 125));
	// }

	projector = new PixelProjector();
	scaling = new TScaling(scaleX, scaleY);
	rotation = new TRotation(rotationAngle);
	baloon = new TBaloon(2);
	projector.addTransform(rotation);
	projector.addTransform(scaling);
	painter = new PixelPainter();
	creator = new PixelCreator();
	creator.setPixelGetter(projector);
	painter.setPixelCreator(creator);
}

void draw() {
	loadPixels();

	float originXFrac = (mouseX / (width + 0.0) - 0.5) * offsetFraction + 0.5;
	float originYFrac = (mouseY / (height + 0.0) - 0.5) * offsetFraction + 0.5;

	if (keyPressed && key == ' ' && prevKey != ' ') {
		projector.clear();
		projector.addTransform(scaling);
		projector.addTransform(rotation);
		projector.addTransform(baloon);
		prevKey = key;
	}
	if (!keyPressed && prevKey == ' ') {
		projector.clear();
		projector.addTransform(scaling);
		projector.addTransform(rotation);
		prevKey = 'x';
	}

	rotation.setAngle(rotationAngle - noise(noiseOffset + noiseStep * frameCount));
	// creator.setHueRotation(hueRotation);
	projector.setDimensions(width, height);
	projector.setOrigin(originXFrac, originYFrac);
	painter.setDimensions(width, height);

	painter.paint(pixels);

	if (mousePressed) {
		painter.setMode(PixelPainter.KALEIDOSCOPE);
	} else {
		painter.setMode(PixelPainter.HORIZONTAL_FLIPPED_MIRROR);
	}

	updatePixels();
}

void keyPressed() {
  if (key == 'p') {
		if (isLooping) {
			noLoop();
		} else {
			loop();
		}
		isLooping = !isLooping;
	}

  if (key == 's') {
		save("feedback-" + frameCount + ".png");
	}
}
