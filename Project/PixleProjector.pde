import java.util.List;

class PixelProjector implements PixelGetter {
	int width;
	int height;
	float widthf;
	float heightf;
	float halfWidthf;
	float halfHeightf;

	float originXFrac = 0.5;
	float originYFrac = 0.5;

	List<Transformation> transforms = new ArrayList<>();

	void clear() {
		this.transforms = new ArrayList<>();
	}

	void addTransform(Transformation t) {
		this.transforms.add(t);
	}

	void removeTransform(Transformation t) {
		this.transforms.remove(this.transforms.indexOf(t));
	}

	void setDimensions(int width, int height) {
		this.width = width;
		this.height = height;
		this.widthf = width + 0.0;
		this.heightf = height + 0.0;
		this.halfWidthf = this.widthf / 2.0;
		this.halfHeightf = this.heightf / 2.0;
	}

	void setOrigin(float originXFrac, float originYFrac) {
		this.originXFrac = originXFrac;
		this.originYFrac = originYFrac;
	}

	color getPixel(color[] pixels, int x, int y, color fallbackColor) {
		float offX = this.widthf * this.originXFrac;
		float offY = this.heightf * this.originYFrac;

		float currentX = (x + 0.0) - offX;
		float currentY = (y + 0.0) - offY;

		for (Transformation t : this.transforms) {
			float[] result = t.transform(
				currentX,
				currentY,
				this.widthf,
				this.heightf
			);
			currentX = result[0];
			currentY = result[1];
		}

		int nextX = (int) (currentX + offX);
		int nextY = (int) (currentY + offY);

		if (
			nextX >= this.width ||
			nextY >= this.height ||
			nextX < 0 ||
			nextY < 0
		) {
			return fallbackColor;
		}

		int i = nextY * this.width + nextX;
		return pixels[i];
	}
}
