package com.robot.core.info.skillEffectInfo
{
	import flash.utils.Dictionary;

	public class AbstractEffectInfo
	{
		protected var _argsNum:uint = 0;
		protected var propDict:Dictionary = new Dictionary();

		public function AbstractEffectInfo()
		{
			super();
			this.propDict["0"] = "攻击";
			this.propDict["1"] = "防御";
			this.propDict["2"] = "特攻";
			this.propDict["3"] = "特防";
			this.propDict["4"] = "速度";
			this.propDict["5"] = "命中";
		}

		public function get argsNum() : uint
		{
			return this._argsNum;
		}

		public function getInfo(array:Array = null) : String
		{
			return "";
		}

	}
}