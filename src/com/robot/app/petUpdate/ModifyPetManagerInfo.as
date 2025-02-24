package com.robot.app.petUpdate
{
   import com.robot.core.config.xml.SkillXMLInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.PetManager;
   import flash.utils.ByteArray;
   
   public class ModifyPetManagerInfo
   {
      public function ModifyPetManagerInfo()
      {
         super();
      }
      
      public static function addSkill(catchTime:uint, id:uint) : void
      {
         var petInfo:PetInfo = PetManager.getPetInfo(catchTime);
         if(petInfo.skillArray.length == 4)
         {
            throw new Error("宠物技能已经为四个，不能再手动添加技能");
         }
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(id);
         byte.writeUnsignedInt(SkillXMLInfo.getPP(id));
         byte.position = 0;
         petInfo.skillArray.push(new PetSkillInfo(byte));
      }
      
      public static function replaceSkill(catchTime:uint, dropArr:Array, studyArr:Array) : void
      {
         var i:uint = 0;
         var oldSkillInfo:PetSkillInfo = null;
         var index:uint = 0;
         var id:uint = 0;
         var byte:ByteArray = null;
         var petInfo:PetInfo = PetManager.getPetInfo(catchTime);
         var count:uint = 0;
         for each(i in dropArr)
         {
            oldSkillInfo = petInfo.getSkillInfo(i);
            index = uint(petInfo.skillArray.indexOf(oldSkillInfo));
            trace("index",index);
            id = uint(studyArr[count]);
            byte = new ByteArray();
            byte.writeUnsignedInt(id);
            byte.writeUnsignedInt(SkillXMLInfo.getPP(id));
            byte.position = 0;
            petInfo.skillArray[index] = new PetSkillInfo(byte);
            count++;
         }
      }
   }
}

