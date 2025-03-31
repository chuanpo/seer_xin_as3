package com.robot.core.info.skillEffectInfo
{
	public class Effect_28 extends AbstractEffectInfo
	{
		public function Effect_28()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return "扣除对方1/" + array[0] + "的HP";
		}

	}
}