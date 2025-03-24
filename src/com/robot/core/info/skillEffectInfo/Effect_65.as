package com.robot.core.info.skillEffectInfo
{
	import com.robot.core.config.xml.SkillXMLInfo;

	public class Effect_65 extends AbstractEffectInfo
	{
		public function Effect_65()
		{
			super();
			_argsNum = 3;
		}

		override public function getInfo(array:Array = null) : String
		{
			return array[0] + "回合内， 自身" + SkillXMLInfo.getTypeCNBytTypeID(uint(array[1])) + "系技能的[威力]变为" + array[2] + "倍";
		}

	}
}