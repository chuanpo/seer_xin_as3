package com.robot.core.info.skillEffectInfo
{
	public class Effect_52 extends AbstractEffectInfo
	{
		public function Effect_52()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "先手使用的场合， 令对方的下1个技能失效";
		}

	}
}