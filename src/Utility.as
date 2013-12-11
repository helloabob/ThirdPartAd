package
{
	public class Utility
	{
		public function Utility()
		{
		}
		public static function formatDate(sec:int):String{
			var mm:int=sec/60;
			var ss:int=sec-mm*60;
			return mm.toString()+":"+(ss<10?"0":"")+ss.toString();
		}
	}
}