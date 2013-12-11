package
{
	import com.debugTip.DebugTip;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[SWF(width=300,height=250,frameRate=60)]
	public class BaiduAdPlugin2 extends Sprite
	{
		private var loader : Loader; 
		private var playTime:int=15000;//时间设置15秒
		private var playTimer:Timer=new Timer(1000,15);//计时
		private var timeoutIdentifier:int=0;
		
		private var adBack:Sprite=new Sprite();
		
		public function BaiduAdPlugin2(){
			
			Security.allowDomain("cpro.baidu.com");
			if (stage){
				loadBdAd(null);
			}
			else{
				this.addEventListener(Event.ADDED_TO_STAGE, loadBdAd);
			}
		}
	
		
		private function loadBdAd(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, loadBdAd);
			DebugTip.instance.init(this.stage,false);
			DebugTip.instance.log("916a-----loadBdAd()-----");
			DebugTip.instance.log("-----remove-----");
			
			loader = new Loader(); 
			addEvent();
			loader.load(new URLRequest("http://cpro.baidu.com/cpro/ui/baiduSTag.swf")); 
			
		}
		
		private function addEvent():void{
			loader.contentLoaderInfo.addEventListener(Event.INIT, onBaiduAdInit); 
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeEvent():void{
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onBaiduAdInit); 
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		protected function securityErrorHandler(event:Event):void
		{
			DebugTip.instance.log("-----4------")
			this.dispatchEvent(new Event("ad_failed"));
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			DebugTip.instance.log("-----5------")
			this.dispatchEvent(new Event("ad_failed"));
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			DebugTip.instance.log("-----1------")
		}
		
		private function drawBack(w:int, h:int):void{
			adBack.graphics.beginFill(0xffffff);
			adBack.graphics.drawRect(0, 0, w, h);
			adBack.graphics.endFill();
		}
		
		private function onBaiduAdInit(e : Event):void { 
			//标签云Loader加载完成后执行 
			DebugTip.instance.log("-----baidu_ad_load_complete------");
			var init_width:int=600;
			var init_height:int=482;
			if(stage!=null){
				init_width=stage.stageWidth;
				init_height=stage.stageHeight;
			}
			drawBack(init_width, init_height);
			this.addChild(adBack);
			this.addChild(loader);
			this.dispatchEvent(new Event("load_complete"));
			removeEvent();
			var param:Object = {
				"cpro_client":"78050048_cpr",
				"cpro_url":"www.kankanews.com",
				"cpro_w":init_width,
				"cpro_h":init_height,
				"cpro_skin":"tabcloud_skin_1"
			};
			(loader.content as Object)["requestAdData"](baiduAdComplete, param);
		}
		
		private function baiduAdComplete():void{
			DebugTip.instance.log("------baidu_show_start-------");
			this.dispatchEvent(new Event("show_start"));
			playTimer.addEventListener(TimerEvent.TIMER,checkTime);
			playTimer.start();
			timeoutIdentifier=setTimeout(closeAd,playTime);
		}
		
		protected function checkTime(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			DebugTip.instance.log("time:"+ time);
		}
		
		public function dispose():void{
			playTimer.reset();
			playTimer.removeEventListener(TimerEvent.TIMER,checkTime);
			if(timeoutIdentifier!=0)flash.utils.clearTimeout(timeoutIdentifier);
		}
		
		public function get duration():Number
		{
			// TODO Auto Generated method stub
			return playTime;
		}
		
		public function get time():Number
		{
			// TODO Auto Generated method stub
			return playTimer.currentCount;//Object(loader.content).time;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			//TODO: implement function
			DebugTip.instance.log("-----baidu_set_size_w_h------"+w+","+h);
			if(!loader.content){
				return;
			}
			drawBack(w, h);
			loader.width=w;
			loader.height=h;
		}
		
		public function play():void{}
		public function stop():void{}
		
		public function closeAd():void{
			DebugTip.instance.log("-----baidu_ad_show_end------");
			dispatchEvent(new Event("show_end"));
			loader.visible=false;
			loader.unloadAndStop(true);
		}
	}
}