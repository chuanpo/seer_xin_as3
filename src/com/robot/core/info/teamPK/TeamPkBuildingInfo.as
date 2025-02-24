package com.robot.core.info.teamPK
{
   import com.robot.core.info.team.ArmInfo;
   import com.robot.core.utils.SolidType;
   import flash.utils.IDataInput;
   
   public class TeamPkBuildingInfo extends ArmInfo
   {
      private var _headID:uint;
      
      public function TeamPkBuildingInfo(data:IDataInput, headID:uint)
      {
         super();
         this._headID = headID;
         this.id = data.readUnsignedInt();
         form = data.readUnsignedInt();
         buyTime = data.readUnsignedInt();
         hp = data.readUnsignedInt();
         pos.x = data.readUnsignedInt();
         pos.y = data.readUnsignedInt();
         dir = data.readUnsignedInt();
         status = data.readUnsignedInt();
      }
      
      override public function set id(v:uint) : void
      {
         _id = v;
         if(_id == 1)
         {
            styleID = this._headID;
            isFixed = true;
         }
         else
         {
            styleID = _id;
            isFixed = false;
         }
         if(_id == 1)
         {
            type = SolidType.HEAD;
         }
         else if(_id >= 2 && _id <= 60)
         {
            type = SolidType.INDUSTRY;
         }
         else if(_id >= 61 && _id <= 140)
         {
            type = SolidType.MILITARY;
         }
         else if(_id >= 141 && _id <= 200)
         {
            type = SolidType.DEFENSE;
         }
         else if(_id >= 800001 && _id <= 800200)
         {
            type = SolidType.FRAME;
         }
         else if(_id >= 800501 && _id <= 801000)
         {
            type = SolidType.PUT;
         }
      }
   }
}

