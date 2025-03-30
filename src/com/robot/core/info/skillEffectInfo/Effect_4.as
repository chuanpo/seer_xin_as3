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
			if(array[1] != 100)
			{
				if(array[2] > 0)
				{
					return array[1] + "%几率令自身的" + propDict[array[0]] + "等级+" + array[2];
				}

				else
				{
					return array[1] + "%几率令自身的" + propDict[array[0]] + "等级" + array[2];
				}

			}

			else
			{
				if(array[2] > 0)
				{
					return "令自身的" + propDict[array[0]] + "等级+" + array[2];
				}

				else
				{
					return "令自身的" + propDict[array[0]] + "等级" + array[2];
				}

			}
		}
	}
}