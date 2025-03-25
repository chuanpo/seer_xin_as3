package com.robot.core.info.skillEffectInfo
{
	public class Effect_46 extends AbstractEffectInfo
	{
		public function Effect_46()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return "令下" + array[0] + "次攻击对自身造成的伤害变为0";
		}

	}
}