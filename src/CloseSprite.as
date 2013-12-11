package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CloseSprite extends Sprite
	{
		private var txt:TextField=new TextField();
		private var tf:TextFormat=new TextFormat();

		
		public function CloseSprite(nw:int,nh:int)
		{
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRect(0,0,nw,nh);
			this.graphics.endFill();
			
			/*
			this.graphics.lineStyle(0.5,0xffffff,0.8);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(nw,0);
			this.graphics.lineTo(nw,nh);
			this.graphics.lineTo(0,nh);
			this.graphics.lineTo(0,0);
			*/
			tf.align=TextFormatAlign.CENTER;
			tf.size=12;
			txt.border=false;
			txt.textColor=0xffffff;
			txt.text="跳过广告";
			txt.selectable=false;
			txt.width=nw;
			txt.y=8;
			txt.height=nh;
			txt.setTextFormat(tf);
			this.addChild(txt);
			
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0xffffff,0);
			sp.graphics.drawRect(0,0,nw,nh);
			sp.graphics.endFill();
			this.addChild(sp);
			
			this.buttonMode=true;
		}
	}
}