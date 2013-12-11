package  
{
	import com.debugTip.DebugTip;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	
	/**
	 * ...
	 * @author yaoyi
	 */
	public class SmartMediaAdPlugin extends MovieClip
	{
		private var loader:Loader;
		public function SmartMediaAdPlugin() 
		{
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Security.allowDomain("*");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//广告播放器地址参数
			
			var url:String = "http://smmedia.allyes.com.cn/uuseesc/SM/bofangqi/adPlayer.swf?au=http%3A%2F%2Fsmartmedia.allyes.com%2Fmain%2Fs%3Fdb%3Dsmartmedia%26border%3D0%26local%3Dxml&aid=smgbb|inpage|patch_test&hc=1&hs=0&aw=600&ah=450&alt=&ast=15&azt=b&at=b&acl=0&hf=1&dbg=1&v=0.1.04 Alpha (1112)";
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			loader.load(new URLRequest(url));
			
			//DebugTip.instance.init(this.stage,true);
			//DebugTip.instance.log("----ad init------")
		}
		
		public function get duration():Number
		{
			// TODO Auto Generated method stub
			return Object(loader.content).duration;
		}
		
		public function get time():Number
		{
			// TODO Auto Generated method stub
			var time:int=Object(loader.content).time;
			
			return time;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			//TODO: implement function
			if(!loader.content)return;
			
			loader.content.width=w;
			loader.content.height=h;
		}
		
		override public function play():void
		{
		}
		
		override public function stop():void
		{
		}
		
		private function loadCompleteHandler(e:Event):void 
		{
			
			//初始化事件 在此事件开始加载广告计时
			loader.content.addEventListener("ad_init", adInitHandler);
			
			//广告开始播放事件 在此事件开始播放广告计时和设置大小
			loader.content.addEventListener("ad_show_start", showStartHandler);
			
			//广告播放结束事件
			loader.content.addEventListener("ad_show_end", showEndHandler);
			
			//无广告 直接结束不会播放广告
			loader.content.addEventListener("ad_none", adNoneHandler);
			
			//广告加载错误事件 直接结束不会播放广告
			loader.content.addEventListener("ad_load_failed", loadFailedHandler);
			
			//广告点击事件
			loader.content.addEventListener("ad_click", adClickHandler);
			addChild(loader);
			
			
			
		}
		
		private function adClickHandler(e:Event):void 
		{
			trace("clickHandler");
		}
		
		
		
		private function securityErrorHandler(e:SecurityErrorEvent):void 
		{
			dispatchEvent(new Event("ad_failed"));
			trace(e);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			dispatchEvent(new Event("ad_failed"));
			trace(e);
		}
		
		private function adInitHandler(e:Event):void 
		{
			trace("初始化成功,开始加载广告计时------------");
			//Object(loader.content).setSize(580, 435);
		}
		
		private function showStartHandler(evt:Event):void
		{
			dispatchEvent(new Event("load_complete"));
			//DebugTip.instance.log("--------load complete--------")
			//evt.target.setSize(580,435);
			trace("播放开始,开始播放计时");
			trace("广告加载时间:", Object(loader.content).spend);
			dispatchEvent(new Event("show_start"));
			//DebugTip.instance.log("-------------show start-------------")
			
			setSize(stage.stageWidth,stage.stageHeight);
		}
		
		private function showEndHandler(evt:Event):void{
			trace("广告播放时间:  ",evt.target.time);
			trace("播放结束");
			dispatchEvent(new Event("show_end"));
			loader.unloadAndStop(true);
		}
		
		private function adNoneHandler(evt:Event):void{
			trace("无广告r ");
			dispatchEvent(new Event("ad_none"));
		}		
		
		private function loadFailedHandler(evt:Event):void{
			trace("加载错误");
			dispatchEvent(new Event("ad_failed"));
		}		
	}
	
}