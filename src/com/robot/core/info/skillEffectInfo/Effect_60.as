package com.robot.core.info.skillEffectInfo
{
	public class Effect_60 extends AbstractEffectInfo
	{
		public function Effect_60()
		{
			super();
			_argsNum = 2;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内，令对手每回合受到" + array[1] + "点[固定伤害]";
		}

	}
}