package com.robot.core.info.pet.update
{
   import flash.utils.IDataInput;
   
   public class UpdateSkillInfo
   {
      private var _petCatchTime:uint;
      
      private var _activeSkills:Array = [];
      
      private var _unactiveSkills:Array = [];
      
      public function UpdateSkillInfo(data:IDataInput)
      {
         super();
         this._petCatchTime = data.readUnsignedInt();
         var num:uint = uint(data.readUnsignedInt());
         var num2:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < num; i++)
         {
            this._activeSkills.push(data.readUnsignedInt());
         }
         for(var j:uint = 0; j < num2; j++)
         {
            this._unactiveSkills.push(data.readUnsignedInt());
         }
      }
      
      public function get petCatchTime() : uint
      {
         return this._petCatchTime;
      }
      
      public function get activeSkills() : Array
      {
         return this._activeSkills;
      }
      
      public function get unactiveSkills() : Array
      {
         return this._unactiveSkills;
      }
   }
}

