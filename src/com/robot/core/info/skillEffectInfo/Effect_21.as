package com.robot.core.info.skillEffectInfo
{
	public class Effect_21 extends AbstractEffectInfo
	{
		public function Effect_21()
		{
			super();
			_argsNum = 3;
		}

		override public function getInfo(array:Array = null) : String
		{
			var str:String = null;

			if(array[0] != array[1])
			{
				str = array[0] + "~" + array[1] + "回合内，将自身所受伤害的1/" + array[2] + "反弹给对方";
			}

			else
			{
				str = array[0] + "回合内，将自身所受伤害的1/" + array[2] + "反弹给对方";
			}

			return str;
		}
	}
}