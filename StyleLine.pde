class StyleLine
{
	private ArrayList<StyleVector> _vectors;

	public StyleLine()
	{
		_vectors = new ArrayList<StyleVector>();
	}

	public void draw()
	{
		for(int i = 0; i < _vectors.size(); i++)
		{
			StyleVector vector = (StyleVector)_vectors.get(i);
			
			float speed = (float) (vector.Speed);
			float weight = (float)(CanvasOnScreen.MaxWidth - speed * CanvasOnScreen.SpeedInfluence);
			weight = (float) (weight < CanvasOnScreen.MinWidth ? CanvasOnScreen.MinWidth : weight);
			
			strokeWeight(weight);
			stroke(CanvasOnScreen.Fontcolor);
			_vectors.get(i).draw();
		}
	}

	public void add(StyleVector vector)
	{
		float changeVelocity = CanvasOnScreen.SpeedChange;
		
		if (_vectors.size() > 0)
		{
			StyleVector lastVector = _vectors.get(_vectors.size() - 1);
			
			if (Math.abs(lastVector.Speed - vector.Speed) > changeVelocity)
				vector.Speed = (float) (lastVector.Speed - changeVelocity * Math.signum(lastVector.Speed - vector.Speed));
		}

		_vectors.add(vector);
	}

        public void smooth(int times)
        {
          for (int j = 0; j < times; j++)
          {
            if (_vectors.size() > 1)
            {
              ArrayList<StyleVector> newLine = new ArrayList<StyleVector>();
              for(int i = 0; i < _vectors.size() - 1; i++)
              {
                StyleVector vectorOne = _vectors.get(i);
                StyleVector vectorTwo = _vectors.get(i+1);
                
                newLine.add(vectorOne);
                if (Math.abs(vectorOne.Speed - vectorTwo.Speed) > CanvasOnScreen.SpeedChange * 0.7)
                  newLine.add(new StyleVector(vectorOne.GetPointAt(0.75), vectorTwo.GetPointAt(0.25), (float)(0.5 * (vectorOne.Speed + vectorTwo.Speed))));
              }
              newLine.add(_vectors.get(_vectors.size() - 1));
              
              _vectors = newLine;
            }
          }
        }
}
