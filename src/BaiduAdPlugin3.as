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
	public class BaiduAdPlugin3 extends Sprite
	{
		private var loaderBaiduAd : Loader; 
		private var playTime:int=15000;//时间设置15秒
		private var playTimer:Timer=new Timer(1000,15);//计时
		private var timeoutIdentifier:int=0;
		
		private var ad:Object;
		
		private var adBack:Sprite=new Sprite();
		
		public function BaiduAdPlugin3(){
			
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
			
			loaderBaiduAd = new Loader(); 
			addEvent();
			loaderBaiduAd.load(new URLRequest("http://cpro.baidu.com/cpro/ui/baiduPatch.swf")); 
			
		}
		
		private function addEvent():void{
//			loader.contentLoaderInfo.addEventListener(Event.INIT, onBaiduAdInit); 
			loaderBaiduAd.contentLoaderInfo.addEventListener(Event.COMPLETE,onBaiduAdInit);
			loaderBaiduAd.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loaderBaiduAd.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeEvent():void{
//			loader.contentLoaderInfo.removeEventListener(Event.INIT, onBaiduAdInit); 
			loaderBaiduAd.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBaiduAdInit);
			loaderBaiduAd.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loaderBaiduAd.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
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
//			var init_width:int=600;
//			var init_height:int=482;
//			if(stage!=null){
//				init_width=stage.stageWidth;
//				init_height=stage.stageHeight;
//			}
//			drawBack(init_width, init_height);
//			this.addChild(adBack);
//			this.addChild(loader);
//			this.dispatchEvent(new Event("load_complete"));
//			removeEvent();
//			var param:Object = {
//				"cpro_client":"78050048_1_cpr",
//				"cpro_url":"www.kankanews.com",
//				"cpro_w":init_width,
//				"cpro_h":init_height,
//				"cpro_skin":"tabcloud_skin_1"
//			};
//			(loader.content as Object)["requestAdData"](baiduAdComplete, param);
			// 注：请求检索广告之前必须将广告位直接放置在 stage 上，否则无法检索广告
			this.stage.addChild(loaderBaiduAd.content);
			// 注：这里设置广告位位置不起作用，需在调用 "show" 接口时设置
			//loaderBaiduAd.content.x = loaderBaiduAd.content.y = 50;
			ad = loaderBaiduAd.content as Object;
			// 请求检索广告，传入广告位 ID 以及对应 url domain
			ad["requestAd"]("u1877001", "www.kankanews.com", this.onSuccess,
				this.onError);
			
		}
		
		/**
		 * 成功检索广告时调用
		 * 广告展示、隐藏逻辑
		 */
		private function onSuccess():void {
			// option 为可选配置项
			var option = new Object();
			// 视频声音控制 0~10
			option.soundVolume = 5;
			// 视频广告完成播放时长时调用
			option.onPlayingOver = function(){
				// 隐藏广告接口-返回 true 时隐藏广告成功
				DebugTip.instance.log(ad["hide"]());
			};
			// 展示广告接口-返回 true 时展示广告成功
			DebugTip.instance.log(ad["show"](20,5,option));
			DebugTip.instance.log("success");
		}
		/**
		 * 广告检索失败时调用
		 * 自定义备用广告内容
		 */
		private function onError():void {
			DebugTip.instance.log("error");
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
			if(!loaderBaiduAd.content){
				return;
			}
			drawBack(w, h);
			loaderBaiduAd.width=w;
			loaderBaiduAd.height=h;
		}
		
		public function play():void{}
		public function stop():void{}
		
		public function closeAd():void{
			DebugTip.instance.log("-----baidu_ad_show_end------");
			dispatchEvent(new Event("show_end"));
			loaderBaiduAd.visible=false;
			loaderBaiduAd.unloadAndStop(true);
		}
	}
}