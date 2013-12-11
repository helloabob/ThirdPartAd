package com.debugTip
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class PDebugTip
	{
		private static var _instance:PDebugTip;
		
		private var txt:TextField    =new TextField();
		private var tf:TextFormat    =new TextFormat();
		private var moveBtn:Sprite   =new Sprite();
		private var resetBtn:Sprite  =new Sprite();
		private var closeBtn:Sprite  =new Sprite();
		private var container:Sprite =new Sprite();
		private var myStage:Stage;
		private var keyPassword:Array=[75,65,78,75,65,78,69,87,83];
		private var keySequence:Array=[];

		private static const VERSION:String   ="125_2013641536";

		public function PDebugTip(pClass:pvt)
		{
		}

		public static function get instance():PDebugTip
		{
			if (!_instance)
			{
				_instance=new PDebugTip(new pvt());
			}

			return _instance
		}

		public function log(str:String):void
		{
			trace(str);
			txt.appendText(str + "\n");
		}


		public function init(st:Stage):void
		{
			//container.visible=false;
			myStage=st;

			tf.size=12;

			txt.border=true;
			txt.selectable=true;
			txt.borderColor=0xff0000;
			txt.textColor=0xff0000;
			txt.width=300;
			txt.y=8;
			txt.height=300;
			txt.setTextFormat(tf);

			st.addChild(container);
			st.setChildIndex(container,st.numChildren - 1);

			container.addChild(txt);
			container.addChild(moveBtn);
			container.addChild(resetBtn);
			container.addChild(closeBtn);

			moveBtn.graphics.beginFill(0xff0000);
			moveBtn.graphics.drawRect(0,0,20,20);
			moveBtn.graphics.endFill();

			resetBtn.graphics.beginFill(0xff0000);
			resetBtn.graphics.drawRect(0,0,20,20);
			resetBtn.graphics.endFill();

			closeBtn.graphics.beginFill(0xff0000);
			closeBtn.graphics.drawRect(0,0,20,20);
			closeBtn.graphics.endFill();

			moveBtn.x=300;
			moveBtn.y=0;
			resetBtn.x=300;
			resetBtn.y=21;
			closeBtn.x=300;
			closeBtn.y=42;

			moveBtn.addEventListener(MouseEvent.MOUSE_DOWN,startDragTip);
			moveBtn.addEventListener(MouseEvent.MOUSE_UP,stopDragTip);
			resetBtn.addEventListener(MouseEvent.CLICK,resetClick);
			closeBtn.addEventListener(MouseEvent.CLICK,closeBtnClick);
			//st.addEventListener(KeyboardEvent.KEY_UP,checkKeyPassword);
			
			log("debugVer1:" + PDebugTip.VERSION)
		}

		protected function closeBtnClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			container.visible=false;
		}

		protected function checkKeyPassword(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub

			keySequence.push(event.keyCode);
			if (keySequence.length > 9)
				keySequence.shift();
			if (keySequence.toString() == keyPassword.toString())
				container.visible=true;
		}

		protected function stopDragTip(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			container.stopDrag();
		}

		protected function startDragTip(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			container.startDrag();
		}

		protected function resetClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			txt.text="";
		}

	}

}

class pvt
{
}
