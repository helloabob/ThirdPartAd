package{
	import com.debugTip.DebugTip;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Timer;
	
	public class PageChoiceAdPlugin extends Sprite{
		
		private var loader:Loader;
		
		public function PageChoiceAdPlugin(){
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		protected function addToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			
			DebugTip.instance.init(stage,false);
			Security.allowDomain("*");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// 派择生产线
			//var requestUrl:String="http://a.pagechoice.net/data/pagechoice/images/Player.swf?zoneid=121&layerstyle=pcad";
			// 派择测试机
			var requestUrl:String="http://as.pagechoice.net/dap/www/images/Player.swf?zoneid=121&layerstyle=pcad";
			var request:URLRequest=new URLRequest(requestUrl);
			loader=new Loader();
			addLoaderEvent();
			loader.load(request);
		}
		
		private function removeLoaderEvent():void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,ioErrorHandler);
		}
		
		private function addLoaderEvent():void{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,ioErrorHandler);
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
		
		public function play():void{}
		public function stop():void{}
		
		public function setSize(w:Number, h:Number):void
		{
			//TODO: implement function
			DebugTip.instance.log("-----page_choice_set_size_w_h------"+w+","+h);
			if(!loader.content)return;
			(loader.content as Object).setSize(w, h);
		}
		
		private function ioErrorHandler(evt:Event):void{
			removeLoaderEvent();
			dispatchEvent(new Event("load_failed"));
		}
		
		private function loadCompleteHandler(evt:Event):void
		{
			removeLoaderEvent();
			DebugTip.instance.log("---------page_choice_load_complete-----------")
			addChild(loader);			
			dispatchEvent(new Event("load_complete"));
			loader.content.addEventListener("show_start",showStartHandler);
			loader.content.addEventListener("show_end",showEndHandler);
			loader.content.addEventListener("ad_none",adNoneHandler);
			loader.content.addEventListener("load_failed",loadFailedHandler);
			(loader.content as Object).setSize(400, 300);
		}
		
		private function showStartHandler(evt:Event):void{
			DebugTip.instance.log("---------page_choice_show_start-----------");
			dispatchEvent(new Event("show_start"));
		}
		
		private function showEndHandler(evt:Event):void{
			DebugTip.instance.log("---------page_choice_show_end-----------");
			dispatchEvent(new Event("show_end"));
			dispose();
		}
		
		private function dispose():void{
			loader.content.removeEventListener("show_start",showStartHandler);
			loader.content.removeEventListener("show_end",showEndHandler);
			loader.content.removeEventListener("ad_none",adNoneHandler);
			loader.content.removeEventListener("load_failed",loadFailedHandler);
			loader.visible=false;
			loader.unloadAndStop(true);
		}
		
		private function adNoneHandler(evt:Event):void{
			DebugTip.instance.log("------ page_choice_ad_none-------");
			dispatchEvent(new Event("ad_none"));
			dispose();
		}		
		
		private function loadFailedHandler(evt:Event):void{
			DebugTip.instance.log("---------page_choice_load_failed-------------");
			dispatchEvent(new Event("load_failed"));
			dispose();
		}
		
	}
}