interface Transformation {
	float[] transform(float x, float y, float width, float height);
}

class TRotation implements Transformation {
	float angle;

	TRotation(float angle) {
		this.setAngle(angle);
	}

	void setAngle(float angle) {
		this.angle = angle;
	}

	float[] transform(float x, float y, float width, float height) {
		float x2 = cos(this.angle) * x - sin(this.angle) * y;
		float y2 = sin(this.angle) * x + cos(this.angle) * y;
		float[] result = { x2, y2 };
		return result;
	}
}

class TScaling implements Transformation {
	float scaleX;
	float scaleY;

	TScaling(float scaleX, float scaleY) {
		this.setScale(scaleX, scaleY);
	}

	TScaling(float scale) {
		this.setScale(scale);
	}

	void setScale(float scaleX, float scaleY) {
		this.scaleX = scaleX;
		this.scaleY = scaleY;
	}

	void setScale(float scale) {
		this.setScale(scale, scale);
	}

	float[] transform(float x, float y, float width, float height) {
		float x2 = this.scaleX * x;
		float y2 = this.scaleY * y;
		float[] result = { x2, y2 };
		return result;
	}
}

class TBaloon implements Transformation {
	float scale;

	TBaloon() {
		this.setScale(1.0);
	}

	TBaloon(float scale) {
		this.setScale(scale);
	}

	void setScale(float scale) {
		this.scale = scale;
	}

	float[] transform(float x, float y, float width, float height) {
		float len = sqrt(x * x + y * y);
		float normFactor = 1.0 / len;
		float nx = normFactor * x;
		float ny = normFactor * y;
		float maxLen = min(width, height);
		float lenFactor2 = len / maxLen;
		float x2 = nx * len * lenFactor2 * this.scale;
		float y2 = ny * len * lenFactor2 * this.scale;
		float[] result = { x2, y2 };
		return result;
	}

}
class TJitter implements Transformation {
	float strength;

	TJitter() {
		this.setStrength(0.01);
	}

	TJitter(float strength) {
		this.setStrength(strength);
	}

	void setStrength(float strength) {
		this.strength = strength;
	}

	float[] transform(float x, float y, float width, float height) {
		boolean applyJitter = random(1) < this.strength;
		if (!applyJitter) {
			float[] unchanged = { x, y };
			return unchanged;
		};
		float x2 = randomGaussian() * (width - 1);
		float y2 = randomGaussian() * (height - 1);
		float[] result = { x2, y2 };
		return result;
	}
}
