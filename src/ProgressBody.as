package
{
	import flash.display.Sprite;
	
	public class ProgressBody extends Sprite
	{
		public function ProgressBody(nh:int)
		{
			this.graphics.beginFill(0xdbb828,1);
			this.graphics.drawRect(0,0,100,nh);
			this.graphics.endFill();
			
			this.graphics.lineStyle(0.5,0x535353,1);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(100,0);
			this.graphics.lineTo(100,nh);
			this.graphics.lineTo(0,nh);
			this.graphics.lineTo(0,0);
		}
	}
}