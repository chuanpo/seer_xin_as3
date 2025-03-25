package com.robot.core.info.skillEffectInfo
{
	public class Effect_51 extends AbstractEffectInfo
	{
		public function Effect_51()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内，自身的[攻击力]和对方相同";
		}

	}
}