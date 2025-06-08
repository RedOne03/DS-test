
int previousImageIndex(int currentIndex, int totalImages) {
  return (currentIndex - 1 + totalImages) % totalImages;
}

int nextImageIndex(int currentIndex, int totalImages) {
  return (currentIndex + 1) % totalImages;
}
