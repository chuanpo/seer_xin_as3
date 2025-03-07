package com.robot.core.info.pet
{
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   
   public class PetInfo
   {
      public var id:uint;
      
      public var name:String;
      
      public var isDefault:Boolean = false;
      
      public var dv:uint;
      
      public var nature:uint;
      
      public var level:uint;
      
      public var exp:uint;
      
      public var lvExp:uint;
      
      public var nextLvExp:uint;
      
      public var hp:uint;
      
      public var maxHp:uint;
      
      public var attack:uint;
      
      public var defence:uint;
      
      public var s_a:uint;
      
      public var s_d:uint;
      
      public var speed:uint;
      
      public var ev_hp:uint;
      
      public var ev_attack:uint;
      
      public var ev_defence:uint;
      
      public var ev_sa:uint;
      
      public var ev_sd:uint;
      
      public var ev_sp:uint;
      
      public var skillNum:uint;
      
      public var skillArray:Array;
      
      public var catchTime:uint;
      
      public var catchMap:uint;
      
      public var catchRect:uint;
      
      public var catchLevel:uint;
      
      private var dict:Dictionary;
      
      public var effectCount:uint;
      
      public var effectList:Array;

      public var skinID:uint;
      
      public var shiny:uint;
      
      public function PetInfo(data:IDataInput)
      {
         var skillInfo:PetSkillInfo = null;
         this.skillArray = [];
         this.dict = new Dictionary();
         this.effectList = [];
         super();
         this.id = data.readUnsignedInt();
         this.name = data.readUTFBytes(16);
         this.dv = data.readUnsignedInt();
         this.nature = data.readUnsignedInt();
         this.level = data.readUnsignedInt();
         this.exp = data.readUnsignedInt();
         this.lvExp = data.readUnsignedInt();
         this.nextLvExp = data.readUnsignedInt();
         this.hp = data.readUnsignedInt();
         this.maxHp = data.readUnsignedInt();
         this.attack = data.readUnsignedInt();
         this.defence = data.readUnsignedInt();
         this.s_a = data.readUnsignedInt();
         this.s_d = data.readUnsignedInt();
         this.speed = data.readUnsignedInt();
         this.ev_hp = data.readUnsignedInt();
         this.ev_attack = data.readUnsignedInt();
         this.ev_defence = data.readUnsignedInt();
         this.ev_sa = data.readUnsignedInt();
         this.ev_sd = data.readUnsignedInt();
         this.ev_sp = data.readUnsignedInt();
         this.skillNum = data.readUnsignedInt();
         for(var i:int = 0; i < 4; i++)
         {
            skillInfo = new PetSkillInfo(data);
            if(skillInfo.id != 0)
            {
               this.skillArray.push(skillInfo);
               this.dict[skillInfo.id] = skillInfo;
            }
         }
         this.skillArray = this.skillArray.slice(0,this.skillNum);
         this.catchTime = data.readUnsignedInt();
         this.catchMap = data.readUnsignedInt();
         this.catchRect = data.readUnsignedInt();
         this.catchLevel = data.readUnsignedInt();
         this.effectCount = data.readUnsignedShort();
         for(var j:uint = 0; j < this.effectCount; j++)
         {
            this.effectList.push(new PetEffectInfo(data));
         }
         
         this.skinID = data.readUnsignedInt();
         this.shiny = data.readUnsignedInt();
         for(var k:uint = 0; k < 8; k++){
            data.readUnsignedInt();
         }
      }
      
      public function getSkillInfo(skillID:uint) : PetSkillInfo
      {
         return this.dict[skillID];
      }
      
      public function get allPP() : uint
      {
         var i:PetSkillInfo = null;
         var num:uint = 0;
         for each(i in this.skillArray)
         {
            num += i.pp;
         }
         return num;
      }
   }
}

