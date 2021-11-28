/*
 * Visualize the incoming sound level from the mic as lines of circles
 * that bounce and vary depending on the audio level.
 *
 * Move the mouse from left to right, to increase the background movement noise.
 * Move the mouse from top to bottom, to increase the motion blur of the bouncing circles.
 */

import processing.sound.*;

// The base size of the circles
final int CIRCLE_SIZE = 10;
// The amount the size of the circles can vary, depending on the noise
final int CIRCLE_VARIANCE = 200;
// The base alpha value of the drawn circles
final int ALPHA_BASE = 70;
// The amount the alpha value of the drawn circles can vary,
// depending on the noise
final int ALPHA_VARIANCE = 120;
// The distance between the circles
final int STEP_SIZE = 30;
// The step from one perlin noise value to the next. The higher the number,
// the more random the movement of the circles will be
final float NOISE_STEP = 0.4;
// The amount the perlin noise is offset after each draw. The higher the
// value, the faster the lines will move
final float NOISE_OFFSET = 0.003;
// The base level of noise in the system
final float AMBIENT_NOISE = 0.0;
// A multiplier for the mic level, to make up for very quiet or loud
// environments. To decrease the input sensitivity use a value < 1.
// To increase the input sensitivity use a value > 1.
final float MIC_SENSITIVITY = 20;
// The maximum alpha value for the sketches background
final float MAX_BG_ALPHA = 140;
// The amount the audio level is smoothed by. The higher the value,
// the more the spikes will be reduced. The smaller the value, the
// more wobbely and shakey the movement will look
final int SMOOTHNES = 6;

float noisePos = 0.0;

AudioIn input;
Amplitude analyzer;
Smoothener smoothener;

class Smoothener {
  float[] smoothingQueue;

  Smoothener(int smoothnes) {
    // Keep a list of previous values
    smoothingQueue = new float[smoothnes];
    for (int i = 0; i < smoothingQueue.length; i++) {
      smoothingQueue[i] = 0;
    }
  }

  float smoothen(float value) {
    // Average the current value with the previous values, to smoothen out
    // spikes in the values. Then add the new value to the previous values
    // and remove the oldest one
    float current = value;
    float ratio = 1 / (smoothingQueue.length + 1.0);
    float smoothedValue = current * ratio;
    for (int i = 0; i < smoothingQueue.length; i++) {
      float tmp = current;
      current = smoothingQueue[i];
      smoothingQueue[i] = tmp;
      smoothedValue += current * ratio;
    }
    return smoothedValue;
  }
}

void setup() {
  size(1200, 800);
  surface.setResizable(true);
  noStroke();
  background(24, 32, 40);

  smoothener = new Smoothener(SMOOTHNES);

  // Start listening to the microphone
  // Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // start the Audio Input
  input.start();

  // create a new Amplitude analyzer
  analyzer = new Amplitude(this);

  // Patch the input to an volume analyzer
  analyzer.input(input);
}

void drawCircles(
  float centerOffset,
  float heightVariance,
  float circleVariance,
  float noiseOffset,
  float noiseImpact
) {
  for (int i = 0; i < width; i += 1) {
    float x = i * STEP_SIZE;
    float rawNoise = noise(noiseOffset + noisePos + NOISE_STEP * i);
    float noiseValue = (rawNoise - 0.5) * noiseImpact;
    float y = (height * centerOffset) + noiseValue * heightVariance * height;
    float alpha = ALPHA_BASE + noiseValue * ALPHA_VARIANCE * circleVariance;
    fill(200, alpha);
    float circleSize =
      CIRCLE_SIZE + noiseValue * CIRCLE_VARIANCE * circleVariance;
    circle(x, y, circleSize);
  }
}

void draw() {
  // Move the mouse from left to right, to increase the background
  // movement noise
  float mouseXRatio = (mouseX * 1.0) / (width * 1.0);
  // Move the mouse from top to bottom, to increase the motion blur of
  // the bouncing circles
  float mouseYRatio = (mouseY * 1.0) / (height * 1.0);
  // Get the overall volume (between 0 and 1.0). Smoothen it so spikes
  // in the audio don't lead to the visuals being overly wobbely
  float vol = smoothener.smoothen(analyzer.analyze());
  // Calculate the current base noise value from the audio input level
  float noiseImpact = vol * MIC_SENSITIVITY + AMBIENT_NOISE + mouseXRatio;

  // Use the mouse y position to change the alpha value of the background
  // creating a pseudo motion blur effect
  fill(24, 32, 40, MAX_BG_ALPHA - (mouseYRatio * MAX_BG_ALPHA));
  rect(0, 0, width, height);

  // Draw five lines of circles, that react more strongly to the noise
  // the further they are away from the center line
  drawCircles(0.15, 0.5, -1, 0, noiseImpact);
  drawCircles(0.35, 0.25, -0.5, 1000, noiseImpact);
  drawCircles(0.5, 0.12, 0, 2000, noiseImpact);
  drawCircles(0.65, 0.25, 0.5, 3000, noiseImpact);
  drawCircles(0.85, 0.5, 1, 4000, noiseImpact);

  noisePos += NOISE_OFFSET;
}

void drawCircle(float x, float y, float size, float blur, float alpha) {
  int radius = (int) size / 2;
  int blurEdgeRadius = radius - (int) (radius * blur);
  int remainingRadius = radius - blurEdgeRadius;
  println("radius         " + radius);
  println("blurEdgeRadius " + blurEdgeRadius);
  for (int r = blurEdgeRadius; r > 0; --r) {
    float blurAmount = (r + 0.0) / (blurEdgeRadius + 0.0);
    float currentAlpha = alpha - (blurAmount * alpha);
    fill(200, currentAlpha);
    circle(x, y, (r + remainingRadius) * 2);
  }
  fill(200, alpha);
  circle(x, y, remainingRadius * 2);
}
