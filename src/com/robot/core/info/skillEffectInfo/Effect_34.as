package com.robot.core.info.skillEffectInfo
{
	public class Effect_34 extends AbstractEffectInfo
	{
		public function Effect_34()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			if(array[0] % 1)
			{
				"将自身所受伤害的" + (array[0] * 100.0) + "%反弹给对方"
			}

			else
			{
				"将自身所受伤害的" + array[0] + "00%反弹给对方"
			}

		}
	}
}