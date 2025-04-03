package com.robot.core.info.skillEffectInfo
{
	public class Effect_172 extends AbstractEffectInfo
	{
		public function Effect_172()
		{
			super();
		}

		override public function getInfo(array:Array = null) : String
		{
			return "<惩罚>对方的特攻·特防强化等级越高，此技能的[威力]越大，提升值为强化等级*20";
		}

	}
}