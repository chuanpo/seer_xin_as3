package com.robot.core.info.skillEffectInfo
{
	public class Effect_37 extends AbstractEffectInfo
	{
		public function Effect_37()
		{
			super();
			_argsNum = 2;
		}

		override public function getInfo(array:Array = null) : String
		{
			if(array[1] % 1)
			{
				return "自身的HP小于1/" + array[0] + "的场合，该技能[威力]增加" + ((array[1] - 1) * 100.0) + "%";
			}

			else
			{
				return "自身的HP小于1/" + array[0] + "的场合，该技能[威力]增加" + (array[1] - 1) + "00%";
			}

		}
	}
}