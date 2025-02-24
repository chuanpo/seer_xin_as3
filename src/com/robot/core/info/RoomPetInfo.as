package com.robot.core.info
{
   import com.robot.core.info.pet.PetEffectInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import flash.utils.IDataInput;
   
   public class RoomPetInfo
   {
      public var ownerId:uint;
      
      public var catchTime:uint;
      
      public var id:uint;
      
      public var nature:uint;
      
      public var lv:uint;
      
      public var hp:uint;
      
      public var atk:uint;
      
      public var def:uint;
      
      public var spatk:uint;
      
      public var spdef:uint;
      
      public var speed:uint;
      
      public var skillNum:uint;
      
      public var skillInfoArr:Array;
      
      public var len:int;
      
      public var evValueA:Array;
      
      public var effNum:uint;
      
      public var effA:Array;
      
      public function RoomPetInfo(data:IDataInput = null)
      {
         var k:int = 0;
         var i2:int = 0;
         var i1:int = 0;
         var skillInfo:PetSkillInfo = null;
         this.skillInfoArr = [];
         super();
         if(Boolean(data))
         {
            this.ownerId = data.readUnsignedInt();
            this.catchTime = data.readUnsignedInt();
            this.id = data.readUnsignedInt();
            this.nature = data.readUnsignedInt();
            this.lv = data.readUnsignedInt();
            this.hp = data.readUnsignedInt();
            this.atk = data.readUnsignedInt();
            this.def = data.readUnsignedInt();
            this.spatk = data.readUnsignedInt();
            this.spdef = data.readUnsignedInt();
            this.speed = data.readUnsignedInt();
            this.skillNum = data.readUnsignedInt();
            this.skillInfoArr = new Array();
            this.len = Math.min(this.skillNum,4);
            for(k = 0; k < this.len; k++)
            {
               skillInfo = new PetSkillInfo(data);
               if(skillInfo.id != 0)
               {
                  this.skillInfoArr.push(skillInfo);
               }
            }
            this.evValueA = new Array();
            for(i2 = 0; i2 < 6; i2++)
            {
               this.evValueA.push(data.readUnsignedInt());
            }
            this.effNum = data.readUnsignedShort();
            this.effA = new Array();
            for(i1 = 0; i1 < this.effNum; i1++)
            {
               this.effA.push(new PetEffectInfo(data));
            }
         }
      }
   }
}

