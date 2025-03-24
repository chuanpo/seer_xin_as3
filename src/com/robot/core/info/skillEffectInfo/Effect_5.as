package com.robot.core.info.skillEffectInfo
{
	public class Effect_5 extends AbstractEffectInfo
	{
		public function Effect_5()
		{
			super();
			_argsNum = 3;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[1] + "%对方的" + propDict[array[0]] + "等级" + array[2];
		}

	}
}