
class StyleInterface
{
      private StyleLine currentLine;
      private PImage imageBuffer;
      
      public StyleInterface()
      {
      	currentLine = new StyleLine();
      }
      
      public void draw()
      {
        if (currentLine != null)
          currentLine.draw();
      }
      
      	public void OnPressed()
      	{
      		//add new line
      		currentLine = new StyleLine();
      	}
      
      	public void OnReleased()
      	{ 
            if (currentLine != null)
                currentLine.smooth(3);
      		//draw last changes
      		//save current image to memory
      		//imageBuffer = get(0, 0, 800, 800);
      		//remove last line
      		currentLine = null;
      	}
      
      	public void OnDragged(float X, float Y, float pX, float pY)
      	{
      		if (X == pX && Y == pY)
      			return;
      
            //if (currentLine != null)
      		currentLine.add(new  StyleVector(X, Y, pX, pY));
      	}
}
