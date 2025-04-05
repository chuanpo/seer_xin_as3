package com.robot.core.info.skillEffectInfo
{
	public class Effect_53 extends AbstractEffectInfo
	{
		public function Effect_53()
		{
			super();
			_argsNum = 2;
		}

		override public function getInfo(array:Array = null) : String
		{
			if(array[1] % 1)
			{
				return array[0] + "回合内，令自身的攻击伤害增加" + ((array[1] - 1) * 100.0) + "%";
			}

			else
			{
				return array[0] + "回合内，令自身的攻击伤害增加" + (array[1] - 1) + "00%";
			}

		}
	}
}