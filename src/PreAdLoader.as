package
{
	
	import customer.SelfAds;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[SWF(width=600, height=450, backgroundColor="0x000000", frameRate=60)]
	public class PreAdLoader extends Sprite
	{
		trace("=== 前帖广告 ===");
		private var _curadid:String="";
		private var _curadtype:String="";
		private var _timer:Timer=new Timer(1000);
		private var _timer_txt:TextField=new TextField();
		private var _tf:TextFormat=new TextFormat();
		private var _adswf:*;
		
		private var _pback:Sprite;
		private var _pbody:Sprite;
		private var _close:Sprite;
		
		public function PreAdLoader()
		{
			Security.allowDomain("*");
		}
		
		public function configureParameters(value:Object):void
		{
			
			//init parameters
			PreAdConfig._width=value.width;
			PreAdConfig._height=value.height;
			PreAdConfig._playcount=value.count;
			PreAdConfig._selfadparam=value.selfadparam;
			PreAdConfig._baseAdparam=value.baseadparam;
			
			if (PreAdConfig._selfadparam && PreAdConfig._selfadparam.t && PreAdConfig._selfadparam.t == "flv_ad")
			{
				PreAdConfig._adslist=new Array("Self");
			}
			if (value.adchinaid)
				PreAdConfig._adchinaid=value.adchinaid;
			if (value.baiduid)
				PreAdConfig._baiduid=value.baiduid;
			
			//background
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, PreAdConfig._width, PreAdConfig._height);
			this.graphics.endFill();
			
			
			//left time
			_tf.size=10;
			this._timer_txt.defaultTextFormat=_tf;
			this._timer_txt.setTextFormat(_tf);
			this._timer_txt.textColor=0xffffff;
			this._timer_txt.x=10;
			this._timer_txt.y=PreAdConfig._height - 25;
			this._timer_txt.height=25;
			this._timer_txt.width=PreAdConfig._height / 2;
			this._timer_txt.selectable=false;
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);
			this.addChild(_timer_txt);
			
			//progress
			this._pback=new ProgressBack(5);
			this._pback.width=PreAdConfig._width;
			this._pback.y=PreAdConfig._height - 5;
			this.addChild(this._pback);
			this._pbody=new ProgressBody(5);
			this._pbody.width=0;
			this._pbody.y=PreAdConfig._height - 5;
			this.addChild(this._pbody);
			
			//close button
			this._close=new CloseSprite(150, 30);
			this._close.x=PreAdConfig._width - this._close.width;
			this._close.y=PreAdConfig._height - 70;
			//跳过广告事件
			this._close.addEventListener(MouseEvent.CLICK, onDisposeAd);
			this.addChild(this._close);
			
			turnPrepearOnOff(false);
			this.initAd();
			
		}
		
		private function initAd():void
		{
			
			this.showInfo("prepare for initing!!!");
			if (this._adswf)
			{
				this._adswf.removeEventListener("onlderror", onlderror);
				this._adswf.removeEventListener("onadstart", onadstart);
				this._adswf.removeEventListener("onadfailed", onadfailed);
				this._adswf.removeEventListener("onadnone", onadnone);
				this._adswf.removeEventListener("onadend", onadend);
				if (this.contains(this._adswf))
					this.removeChild(this._adswf);
				this._adswf=null;
			}
			_timer.reset();
			this._pbody.width=0;
			this._timer_txt.text="正在努力为您加载 ......";
			this._close.visible=false;
			
			
			if (PreAdConfig._playcount > 0 && PreAdConfig._adslist.length > 0)
			{
				
				
				this._curadtype=PreAdConfig._adslist[0];
				switch (this._curadtype)
				{
					case "AdChina":
						this._adswf=new AdChinaAds();
						this._curadid=PreAdConfig._adchinaid;
						break;
					case "Baidu":
						this._adswf=new BaiduAds();
						this._curadid=PreAdConfig._baiduid;
						break;
					case "SmartMedia":
						this._adswf=new SmartMediaAds();
						this._curadid=PreAdConfig._smartmediaid;
						break;
					case "flv_ad":
						this._adswf=new SelfAds();
						break;
					default:
						//PreAdConfig._playcount--;
						//this.initAd();
						break;
				}
				
				
				if (this._adswf)
				{
					this.addChild(this._adswf);
					this.setChildIndex(this._adswf, 0);
					var obj:Object=new Object();
					obj.width=PreAdConfig._width;
					obj.height=PreAdConfig._height - 25;
					obj.id=this._curadid;
					
					trace("正在播放",this._curadtype)
					//this.showInfo("confiure_ad_w:"+obj.width+"and h:"+obj.height);
					this._adswf.configureParameters(obj);
					this._adswf.addEventListener("onlderror", onlderror);
					this._adswf.addEventListener("onadstart", onadstart);
					this._adswf.addEventListener("onadfailed", onadfailed);
					this._adswf.addEventListener("onadnone", onadnone);
					this._adswf.addEventListener("onadend", onadend);
				}
				
			}
			else
			{
				this._close.removeEventListener(MouseEvent.CLICK, onDisposeAd);
				this._timer.removeEventListener(TimerEvent.TIMER, onTimer);
				this.dispatchEvent(new Event("preadcomplete"));
			}
		}
		
		private function onDisposeAd(evt:MouseEvent):void
		{
			trace("this is skip ad")
			this.dispatchEvent(new Event("hideLoading")); 
			if (_timer.running)
				_timer.reset();
			this._adswf.disposeAd();
			
			//PreAdConfig._playcount--;
			//this.initAd();
		}
		
		private function showInfo(src:String):void
		{
			trace(src);
			//ExternalInterface.call("alert",src);
		}
		
		private function onlderror(evt:Event):void
		{
			turnPrepearOnOff(false);
			PreAdConfig._adslist.shift();
			this.showInfo("onlderror!!!");
			this.initAd();
		}
		
		private function showBaseAd():void
		{
			// TODO Auto Generated method stub
			PreAdConfig._selfadparam=PreAdConfig._baseAdparam;
			this.initAd();
		}
		
		private function onadstart(evt:Event):void
		{
			turnPrepearOnOff(true);
			//隐藏loading动画,由player 侦听
			this.dispatchEvent(new Event("hideLoading")); 
			this.showInfo("onadstart!!!");
			if (PreAdConfig._selfadparam && PreAdConfig._selfadparam.sc)
			{
				var lll:URLLoader=new URLLoader();
				lll.load(new URLRequest(PreAdConfig._selfadparam.sc.toString()));
			}
			
			this._timer.start();
		}
		
		private function onadfailed(evt:Event):void
		{
			turnPrepearOnOff(false);
			PreAdConfig._adslist.shift();
			this.showInfo("onadfailed!!!");
			this.initAd();
		}
		
		private function onadnone(evt:Event):void
		{
			turnPrepearOnOff(false);
			PreAdConfig._adslist.shift();
			this.showInfo("onadnone!!!");
			this.initAd();
			
		}
		
		private function onadend(evt:Event):void
		{
			turnPrepearOnOff(true);
			PreAdConfig._playcount--;
			this.showInfo("onadend!!!");
			this.initAd();
		}
		
		private function turnPrepearOnOff(bl:Boolean):void{
			
			_timer_txt.visible=_pback.visible=_pbody.visible=bl;
			
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			_timer_txt.text="广告({0})".replace("{0}", Utility.formatDate(this._adswf.duration - this._adswf.time).toString());
			this._pbody.width=this._adswf.time / this._adswf.duration * PreAdConfig._width;
			if (_timer.currentCount == 5)
			{
				//if (this._curadtype == "AdChina" || this._curadtype == "Self")
				this._close.visible=true;
			}
			if (this._curadtype == "Self" && _timer.currentCount == this._adswf.duration + 1)
			{
				this._adswf.disposeAd();
			}
		}
	}
}