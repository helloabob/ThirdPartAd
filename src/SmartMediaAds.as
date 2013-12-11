package {
	
	import com.ToolUtils.URLLoaderUtil;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class SmartMediaAds extends Sprite implements IPreAdBase{
		private var ld:Loader;
		private var con:*;
		
		private var swfurl:String="http://smmedia.allyes.com.cn/uuseesc/SM/bofangqi/adPlayer.swf?au=http%3A%2F%2Fsmartmedia.allyes.com%2Fmain%2Fs%3Fdb%3Dsmartmedia%26border%3D0%26local%3Dxml&aid=smgbb|inpage|patch&hc=0&hs=0&alt=10&aw=600&ah=450&ast=15&azt=b&at=b&v=0.1.04 Alpha (1119)";
		private var adwidth:int=0;
		private var adheight:int=0;
		private var checktimer:Timer=new Timer(10000,1);
		public function SmartMediaAds() {
		}
		public function disposeAd():void{
			
			onAdEnd(null);
		}
		public function configureParameters(value:Object):void{
			URLLoaderUtil.instence.loadURL("http://smartmedia.allyes.com/crossdomain.xml",ldsuccess,[value],ldFail)
		}
		
		private function ldFail(vaule:Object=null):void
		{
			// TODO Auto Generated method stub
			this.dispatchEvent(new Event("onadfailed"));
		}
		
		private function ldsuccess(value:Object=null):void
		{
			// TODO Auto Generated method stub
			//http://smartmedia.allyes.com/crossdomain.xml
			this.adwidth=value.width;
			this.adheight=value.height;
			this.swfurl=this.swfurl.replace("{0}",value.id);
			//this.loadAd("static.acs86.com",swfurl);
			loadAd("www.smartcreative.cn",swfurl);
		}
			
		
		private function loadAd(hostName:String,url:String):void{
			Security.allowDomain(hostName);
			ld=new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,onldcomplete);
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onlderror);
			ld.load(new URLRequest(url));
		}
		private function onlderror(evt:IOErrorEvent):void{
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,onldcomplete);
			ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onlderror);
			this.dispatchEvent(new Event("onlderror"));
		}
		private function onldcomplete(evt:Event):void{
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,onldcomplete);
			ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onlderror);
			checktimer.addEventListener(TimerEvent.TIMER_COMPLETE,onchecktimercomplete);
			checktimer.start();
			con=ld.content;
			
			
			//con.addEventListener("ad_init",onAdInit);
			con.addEventListener("ad_show_end",onAdEnd);
			con.addEventListener("ad_none",onAdNone);
			con.addEventListener("ad_load_failed",onAdFailed);
			con.addEventListener("ad_show_start",onAdStart);
			
			//con.setSize(this.adwidth,this.adheight);
			this.addChild(ld);
		}
		private function onchecktimercomplete(evt:TimerEvent):void{
			onAdEnd(null);
		}
		
		public function get duration():Number
		{
			// TODO Auto Generated method stub
			return con.duration;
		}
		
		public function get spend():Number
		{
			// TODO Auto Generated method stub
			return con.spend;
		}
		
		public function get time():Number
		{
			// TODO Auto Generated method stub
			return con.time;
		}
		
		private function onAdNone(evt:Event):void{
			this.dispatchEvent(new Event("onadnone"));
		}
		private function onAdFailed(evt:Event):void{
			this.dispatchEvent(new Event("onadfailed"));
		}
		private function onAdClick(evt:Event):void{
			this.dispatchEvent(new Event("onadclick"));
		}
		private function onAdStart(evt:Event):void{
			checktimer.reset();
			con.setSize(this.adwidth,this.adheight);
			//con.setVolume(1);
			this.dispatchEvent(new Event("onadstart"));
		}
		private function onAdEnd(evt:Event):void{
			con.dispose();
			this.dispatchEvent(new Event("onadend"));
			
			this.removeChild(ld);
			checktimer.reset();
			con.removeEventListener("ad_show_end",onAdEnd);
			con.removeEventListener("ad_none",onAdNone);
			con.removeEventListener("ad_load_failed",onAdFailed);
			con.removeEventListener("ad_show_start",onAdStart);
			ld.unloadAndStop();
		}
	}
	
}
