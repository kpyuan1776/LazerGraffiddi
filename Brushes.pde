class Brushes
{
  public void EllipseBrush(float x, float y, float maxRadius, color brushColor)
  {
    noStroke();
    fill(brushColor, 40); 
    ellipse(x, y, maxRadius, maxRadius);
    fill(brushColor, 90); 
    ellipse(x, y, 0.8 * maxRadius, 0.8 * maxRadius);
    fill(brushColor, 160); 
    ellipse(x, y, 0.65 * maxRadius, 0.65 * maxRadius);
    fill(brushColor, 255); 
    ellipse(x, y, 0.5 * maxRadius, 0.5 * maxRadius);
  }
}
