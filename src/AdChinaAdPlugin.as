package
{
	import com.debugTip.DebugTip;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	[SWF(width=400, height=300)]
	public class AdChinaAdPlugin extends Sprite implements IAdChinaPlugin
	{
		private var ld:Loader;
		private var swfurl:String="http://static.acs86.com/player/RollPlayer.swf?aid=71026";
		public function AdChinaAdPlugin(){
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			DebugTip.instance.init(stage,false);
			// TODO Auto-generated method stub
			this.loadAd("static.acs86.com",swfurl);
		}
		
		public function get duration():Number
		{
			// TODO Auto Generated method stub
			return (ld.content as Object).duration;
		}
		
		public function get time():Number
		{
			// TODO Auto Generated method stub
			return (ld.content as Object).time;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			//TODO: implement function
			DebugTip.instance.log("-----adchina_set_size_w_h------"+w+","+h);
			this.width=w;
			this.height=h;
		}
		
		public function play():void{}
		public function stop():void{}
		
		public function disposeAd():void{
			//con.dispose();
			this.onAdEnd(null);
		}
		
		private function addLoaderEvent():void{
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,onldcomplete);
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onlderror);
		}
		
		private function removeLoaderEvent():void{
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,onldcomplete);
			ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onlderror);
		}
		
		private function loadAd(hostName:String,url:String):void{
			Security.allowDomain(hostName);
			ld=new Loader();
			addLoaderEvent();
			ld.load(new URLRequest(url));
		}
		private function onlderror(evt:IOErrorEvent):void{
			removeLoaderEvent();
			this.dispatchEvent(new Event("onlderror"));
		}
		private function onldcomplete(evt:Event):void{
			DebugTip.instance.log("-----adchina_ad_load_complete------");
			removeLoaderEvent();
			dispatchEvent(new Event("load_complete"));
			ld.content.addEventListener("show_start",onAdStart);
			ld.content.addEventListener("show_end",onAdEnd);
			ld.content.addEventListener("ad_none",onAdNone);
			ld.content.addEventListener("load_failed",onAdFailed);
			ld.content.addEventListener("ad_click",onAdClick);
			(ld.content as Object).setSize(400, 300);
			this.addChild(ld);
		}
		private function dispose():void{
			ld.content.removeEventListener("show_start",onAdStart);
			ld.content.removeEventListener("show_end",onAdEnd);
			ld.content.removeEventListener("ad_none",onAdNone);
			ld.content.removeEventListener("load_failed",onAdFailed);
			ld.content.removeEventListener("ad_click",onAdClick);
			ld.visible=false;
			ld.unloadAndStop(true);
		}
		
		public function get spend():Number
		{
			// TODO Auto Generated method stub
			return (ld.content as Object).spend;
		}
		
		private function onAdNone(evt:Event):void{
			DebugTip.instance.log("--------adchina_ad_none--------");
			dispatchEvent(new Event("ad_none"));
			dispose();
		}
		private function onAdFailed(evt:Event):void{
			DebugTip.instance.log("--------adchina_ad_failed-------");
			dispatchEvent(new Event("load_failed"));
			dispose();
		}
		private function onAdClick(evt:Event):void{
			DebugTip.instance.log("--------adchina_ad_click--------");
			this.dispatchEvent(new Event("ad_click"));
		}
		private function onAdStart(evt:Event):void{
			DebugTip.instance.log("--------adchina_ad_start--------");
			dispatchEvent(new Event("show_start"));
		}
		private function onAdEnd(evt:Event):void{
			DebugTip.instance.log("-------adchina_ad_end-----------");
			dispatchEvent(new Event("show_end"));
			dispose();
		}
	}
}