package com.robot.core.net
{
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.StringUtil;
   
   public class BefLoad extends BaseBeanController
   {
      private static const PET_PATH:String = "resource/fightResource/pet/swf/";
      
      private static const SKILL_PATH:String = "resource/fightResource/skill/swf/";
      
      public function BefLoad()
      {
         super();
      }
      
      override public function start() : void
      {
         var info:PetInfo = null;
         var skillarr:Array = null;
         var sinfo:PetSkillInfo = null;
         var arr:Array = PetManager.infos;
         for each(info in arr)
         {
            ResourceManager.addBef(PET_PATH + StringUtil.renewZero(info.id.toString(),3) + ".swf","pet",false);
            skillarr = info.skillArray;
            for each(sinfo in skillarr)
            {
               ResourceManager.addBef(SKILL_PATH + sinfo.id.toString() + ".swf","skill",false);
            }
         }
         finish();
      }
   }
}

