package com.robot.core.info.skillEffectInfo
{
	public class Effect_50 extends AbstractEffectInfo
	{
		public function Effect_50()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内， 自身受到[物理攻击]伤害减少50%";
		}

	}
}