package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	[SWF(width=600, height=450, backgroundColor="0x000000", frameRate=60)]
	public class AdTest extends Sprite
	{
		private var preadloader:Loader;
		
		private var sw:int;
		private var sh:int;
		
		public function AdTest()
		{
			
			//DebugTipAs3.instance.init(this.stage);
			//DebugTipAs3.instance.showDebugOnTop("gggggggg");
			Security.allowDomain("*");
			if(this.stage){
				init();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,onadded);
			}
		}
		private function onadded(evt:Event):void{
			init();
		}
		private function init():void{
			sw=stage.stageWidth;
			sh=stage.stageHeight;
			this.graphics.beginFill(0x565656,1);
			this.graphics.drawRect(0,0,sw,sh);
			this.graphics.endFill();
			
			preadloader=new Loader();
			preadloader.contentLoaderInfo.addEventListener(Event.COMPLETE,oncc);
			preadloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onccerror);
			preadloader.load(new URLRequest("PreAdLoader.swf"));
		}
		
		private function oncc(evt:Event):void{
			
			trace("加载模块结束!!!")
			
			preadloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,oncc);
			preadloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onccerror);
			this.addChild(preadloader);
			var con:*=preadloader.content;
			var obj:Object=new Object();
			obj.width=sw;
			obj.height=sh-32;
			obj.count=1;
			obj.baiduid="425807";

			con.configureParameters(obj);
			con.addEventListener("preadcomplete",onadcc);
			trace("alert-initad");
		}
		private function onadcc(evt:Event):void{
			//Sprite(evt.currentTarget).visible=false;
		}
		private function onccerror(evt:Event):void{
			
		}
	}
}