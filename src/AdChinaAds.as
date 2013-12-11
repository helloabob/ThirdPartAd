package {		import com.ToolUtils.URLLoaderUtil;	import com.debugTip.DebugTip;		import flash.display.Loader;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.MouseEvent;	import flash.events.SecurityErrorEvent;	import flash.events.TimerEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.system.Security;	import flash.text.TextField;	import flash.utils.Timer;
	public class AdChinaAds extends Sprite implements IPreAdBase{		private var ld:Loader;		private var con:*;		//private var btnclose:ClsButton=new ClsButton();		private var swfurl:String="http://static.acs86.com/player/RollPlayer.swf";//?aid={0}		private var adwidth:int=0;		private var adheight:int=0;		public function AdChinaAds() {		}		public function disposeAd():void{			//con.dispose();			this.onAdEnd(null);		}				public function configureParameters(value:Object):void{			//			URLLoaderUtil.instence.loadURL("http://acs86.com/crossdomain.xml",ldsuccess,[value],ldFail)		}				private function ldFail(vaule:Object=null):void
		{
			// TODO Auto Generated method stub			this.dispatchEvent(new Event("onadfailed"));
		}				private function ldsuccess(value:Object=null):void
		{
			// TODO Auto Generated method stub
			this.adwidth=value.width;			this.adheight=value.height;			this.swfurl=this.swfurl.replace("{0}",value.id);			this.loadAd("static.acs86.com",swfurl);
		}		private function loadAd(hostName:String,url:String):void{			Security.allowDomain(hostName);			ld=new Loader();			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,onldcomplete);			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onlderror);			ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onlderror);			ld.load(new URLRequest(url));		}		private function onlderror(evt:IOErrorEvent):void{			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,onldcomplete);			ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onlderror);			this.dispatchEvent(new Event("onlderror"));		}		private function onldcomplete(evt:Event):void{			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,onldcomplete);			ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onlderror);			con=ld.content;			con.addEventListener("show_start",onAdStart);			con.addEventListener("show_end",onAdEnd);			con.addEventListener("ad_none",onAdNone);			con.addEventListener("load_failed",onAdFailed);			con.addEventListener("ad_click",onAdClick);						con.setSize(this.adwidth,this.adheight);			this.addChild(ld);		}				public function get duration():Number
		{
			// TODO Auto Generated method stub
			return con.duration;
		}						public function get spend():Number
		{
			// TODO Auto Generated method stub
			return con.spend;
		}				public function get time():Number
		{
			// TODO Auto Generated method stub
			return con.time;
		}				private function onAdNone(evt:Event):void{			this.dispatchEvent(new Event("onadnone"));		}		private function onAdFailed(evt:Event):void{			this.dispatchEvent(new Event("onadfailed"));		}		private function onAdClick(evt:Event):void{			this.dispatchEvent(new Event("onadclick"));		}		private function onAdStart(evt:Event):void{			this.dispatchEvent(new Event("onadstart"));		}		private function onAdEnd(evt:Event):void{			con.dispose();			this.dispatchEvent(new Event("onadend"));			this.removeChild(ld);			ld.removeEventListener("show_end",onAdEnd);			ld.removeEventListener("ad_none",onAdNone);			ld.removeEventListener("load_failed",onAdFailed);			ld.removeEventListener("show_start",onAdStart);			ld.removeEventListener("ad_click",onAdStart);			ld.unloadAndStop();								}	}	}