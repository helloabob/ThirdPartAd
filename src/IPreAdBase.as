package
{
	public interface IPreAdBase
	{
		function configureParameters(value:Object):void;
		function disposeAd():void;
		function get duration():Number;
		function get time():Number;
		function get spend():Number;
	}
}