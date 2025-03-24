package com.robot.core.info.skillEffectInfo
{
	public class Effect_4 extends AbstractEffectInfo
	{
		public function Effect_4()
		{
			super();
			_argsNum = 3;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[1] + "%自身的" + propDict[array[0]] + "等级" + array[2];
		}

	}
}