package com.robot.core.info.skillEffectInfo
{
	public class Effect_9 extends AbstractEffectInfo
	{
		public function Effect_9()
		{
			super();
			_argsNum = 2;
		}

		override public function getInfo(array:Array = null) : String
		{
			return "连续使用时，每次的[威力]增加" + array[0] + "，最高[威力]为" + array[1];
		}

	}
}