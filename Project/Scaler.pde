class Scaler implements PixelGetter {
	int width;
	int height;
	float widthf;
	float heightf;
	float zoomX;
	float zoomY;
	float zoomedWidth;
	float zoomedHeight;
	float xOffset;
	float yOffset;

	void setScale(int width, int height, float zoomX, float zoomY) {
		this.width = width;
		this.height = height;
		this.widthf = width + 0.0;
		this.heightf = height + 0.0;
		this.zoomX = zoomX;
		this.zoomY = zoomY;
		this.zoomedWidth = this.widthf * this.zoomX;
		this.zoomedHeight = this.heightf * this.zoomY;
		this.xOffset = (this.widthf - this.zoomedWidth) / 2.0;
		this.yOffset = (this.heightf - this.zoomedHeight) / 2.0;
	}

	color getPixel(color[] pixels, int x, int y, color fallbackColor) {
		int zoomedX = (int) (x * this.zoomX + this.xOffset);
		int zoomedY = (int) (y * this.zoomY + this.yOffset);
		if (
			zoomedX >= this.width ||
			zoomedY >= this.height ||
			zoomedX < 0 ||
			zoomedY < 0
		) {
			return fallbackColor;
		}
		int zoomedIndex = zoomedY * this.width + zoomedX;
		return pixels[zoomedIndex];
	}
}
