class StyleVector
{
	private float _fromVectorX;
	private float _fromVectorY;
	private float _toVectorX;
	private float _toVectorY;
	public float Speed;

	public StyleVector(float xStart, float yStart, float xTo, float yTo)
	{
		_fromVectorX = xStart;
		_fromVectorY = yStart;
		_toVectorX = xTo;
		_toVectorY = yTo;
		Speed = (float) Math.sqrt((_toVectorX - _fromVectorX) * (_toVectorX - _fromVectorX) + (_toVectorY - _fromVectorY) * (_toVectorY - _fromVectorY)); //mouse speed
	}

        public StyleVector(PVector start, PVector to, float speed)
        {
          	_fromVectorX = start.x;
		_fromVectorY = start.y;
		_toVectorX = to.x;
		_toVectorY = to.y;
                Speed = speed;
        }
        
	public void draw()
	{
		line(_fromVectorX, _fromVectorY, _toVectorX, _toVectorY);
	}

        public PVector GetStartPoint()
        {
          return new PVector(_fromVectorX, _fromVectorY);
        }
        
        public PVector GetEndPoint()
        {
          return new PVector(_toVectorX, _toVectorY);
        }

        public PVector GetPointAt(float scalar)
        {
            return new PVector(_fromVectorX + scalar*(_toVectorX - _fromVectorX), _fromVectorY + scalar*(_toVectorY - _fromVectorY));
        }
}
