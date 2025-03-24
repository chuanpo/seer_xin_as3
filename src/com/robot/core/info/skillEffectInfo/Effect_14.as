package com.robot.core.info.skillEffectInfo
{
	public class Effect_14 extends AbstractEffectInfo
	{
		public function Effect_14()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return "命中时， 有" + array[0] + "%几率令对方陷入冻伤状态";
		}

	}
}