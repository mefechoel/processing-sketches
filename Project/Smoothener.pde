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
