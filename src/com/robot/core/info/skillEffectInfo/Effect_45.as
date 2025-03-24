package com.robot.core.info.skillEffectInfo
{
	public class Effect_45 extends AbstractEffectInfo
	{
		public function Effect_45()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内， 自身的[防御力]和对方相同";
		}

	}
}