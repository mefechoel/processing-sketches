interface PixelGetter {
	color getPixel(color[] pixels, int x, int y, color fallbackColor);
}
