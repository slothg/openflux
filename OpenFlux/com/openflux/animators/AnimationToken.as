package com.openflux.animators
{
	public dynamic class AnimationToken //implements IAnimationToken
	{
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var width:Number;
		public var height:Number;
		
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;
		
		
		public function AnimationToken(width:Number, height:Number, x:Number = 0, y:Number = 0, z:Number = 0, rotationX:Number = 0, rotationY:Number = 0, rotationZ:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
			this.width = width;
			this.height = height;
			this.rotationX = rotationX;
			this.rotationY = rotationY;
			this.rotationZ = rotationZ;
		}
		
	}
}