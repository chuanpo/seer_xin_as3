package com.robot.core.info.skillEffectInfo
{
	public class Effect_171 extends AbstractEffectInfo
	{
		public function Effect_171()
		{
			super();
			_argsNum = 1;
		}

		override public function getInfo(array:Array = null) : String
		{
			return "<潜能>自身的潜力越高，此技能的[威力]越大，范围0~155\n" + "命中时，有" + array[0] + "%几率令对方陷入中毒状态";
		}

	}
}