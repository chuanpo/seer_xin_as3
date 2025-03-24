package com.robot.core.info.skillEffectInfo
{
	public class Effect_44 extends AbstractEffectInfo
	{
		public function Effect_44()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内，自身受到[特殊攻击]伤害减少50%";
		}

	}
}