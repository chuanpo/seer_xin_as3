package com.robot.app.experienceShared
{
   import flash.utils.IDataInput;
   
   public class GetExperienceInfo
   {
      private var exp:uint;
      
      public function GetExperienceInfo(data:IDataInput)
      {
         super();
         this.exp = data.readUnsignedInt();
      }
      
      public function get getExp() : uint
      {
         return this.exp;
      }
   }
}

