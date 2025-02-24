package com.robot.core.info.pet
{
   import com.robot.core.config.xml.SkillXMLInfo;
   import flash.utils.IDataInput;
   
   public class PetSkillInfo
   {
      private var _id:uint;
      
      public var pp:uint;
      
      public function PetSkillInfo(data:IDataInput = null)
      {
         super();
         if(data != null)
         {
            this._id = data.readUnsignedInt();
            this.pp = data.readUnsignedInt();
         }
      }
      
      public function set id(ID:uint) : void
      {
         this._id = ID;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return SkillXMLInfo.getName(this.id);
      }
      
      public function get maxPP() : uint
      {
         return SkillXMLInfo.getPP(this.id);
      }
      
      public function get damage() : uint
      {
         return SkillXMLInfo.getDamage(this.id);
      }
   }
}

