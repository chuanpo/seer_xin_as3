package com.robot.core.info.skillEffectInfo
{
	public class Effect_55 extends AbstractEffectInfo
	{
		public function Effect_55()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内，自身与对方的属性交换";
		}

	}
}