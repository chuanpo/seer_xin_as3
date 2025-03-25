package com.robot.core.info.skillEffectInfo
{
	public class Effect_42 extends AbstractEffectInfo
	{
		public function Effect_42()
		{
			super();
			_argsNum = 2;
		}

		override public function getInfo(array:Array = null) : String
		{
			var str:String = null;

			if(array[0] != array[1])
			{
				str = array[0] + "~" + array[1] + "回合内，自身的电招式伤害提升100%";
			}

			else
			{
				str = array[0] + "回合内，自身的电招式伤害提升100%";
			}

			return str;
		}
	}
}