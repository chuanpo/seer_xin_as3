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
			"将自身所受伤害的" + array[0] + "倍反弹给对方"
		}

	}
}