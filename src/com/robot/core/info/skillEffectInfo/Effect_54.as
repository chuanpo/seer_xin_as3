package com.robot.core.info.skillEffectInfo
{
	public class Effect_54 extends AbstractEffectInfo
	{
		public function Effect_54()
		{
			super();
			_argsNum = 2;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内，令对方的攻击伤害变为1/" + array[1];
		}

	}
}