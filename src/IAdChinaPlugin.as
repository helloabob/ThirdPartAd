package
{
	public interface IAdChinaPlugin
	{
		function get duration():Number;
		function get time():Number;
		
		function setSize(w:Number, h:Number):void;
		function play():void;
		function stop():void;
		
	}
}