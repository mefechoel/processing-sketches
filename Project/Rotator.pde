class Rotator implements PixelGetter {
	int width;
	int height;
	float widthf;
	float heightf;
	float halfWidthf;
	float halfHeightf;
	float angle;
	int count = 0;

	void setRotation(int width, int height, float angle) {
		this.width = width;
		this.height = height;
		this.widthf = width + 0.0;
		this.heightf = height + 0.0;
		this.halfWidthf = this.widthf / 2.0;
		this.halfHeightf = this.heightf / 2.0;
		this.angle = angle;
	}

	color getPixel(color[] pixels, int x, int y, color fallbackColor) {
		float vx = (x + 0.0) - this.halfWidthf;
		float vy = (y + 0.0) - this.halfHeightf;
		float vx2 = cos(this.angle) * vx - sin(this.angle) * vy;
		float vy2 = sin(this.angle) * vx + cos(this.angle) * vy;
		int x2 = (int) (vx2 + halfWidthf);
		int y2 = (int) (vy2 + halfHeightf);
		// if (this.count % 239 == 0 || this.count % 240 == 0 || this.count % 241 == 0 || this.count % 242 == 0) {
		// 	println("x, y: " + x + ", " + y);
		// 	println("x2, y2: " + x2 + ", " + y2);
		// }
		// this.count++;

		if (x2 >= this.width || y2 >= this.height || x2 < 0 || y2 < 0) {
			return fallbackColor;
		}
		int rotatedIndex = y2 * this.width + x2;
		return pixels[rotatedIndex];
	}
}
