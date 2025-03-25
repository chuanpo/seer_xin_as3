package com.robot.core.info.skillEffectInfo
{
	public class Effect_31 extends AbstractEffectInfo
	{
		public function Effect_31()
		{
			super();
			_argsNum = 2;
		}

		override public function getInfo(array:Array = null) : String
		{
			var str:String = null;
			if(array[0] != array[1])
			{
				str = "连续进行" + array[0] + "~" + array[1] + "次攻击";
			}
			else
			{
				str = "连续进行" + array[0] + "次攻击";
			}
			return str;
		}

	}
}