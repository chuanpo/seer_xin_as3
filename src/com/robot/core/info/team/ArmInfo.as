package com.robot.core.info.team
{
   import com.robot.core.config.xml.FortressItemXMLInfo;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.manager.ArmManager;
   import com.robot.core.utils.SolidType;
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   
   public class ArmInfo extends FitmentInfo
   {
      public var styleID:uint;
      
      public var buyTime:uint;
      
      public var isUsed:Boolean;
      
      public var form:uint;
      
      public var hp:uint;
      
      public var workCount:uint;
      
      public var donateCount:uint;
      
      public var res:HashMap = new HashMap();
      
      public var resNum:uint;
      
      public function ArmInfo()
      {
         super();
      }
      
      public static function setFor2941(info:ArmInfo, data:IDataInput = null) : void
      {
         info.id = data.readUnsignedInt();
         info.pos.x = data.readUnsignedInt();
         info.pos.y = data.readUnsignedInt();
         info.dir = data.readUnsignedInt();
         info.status = data.readUnsignedInt();
      }
      
      public static function setFor2942(info:ArmInfo, data:IDataInput = null) : void
      {
         info.id = data.readUnsignedInt();
         info.usedCount = data.readUnsignedInt();
         info.allCount = data.readUnsignedInt();
      }
      
      public static function setFor2964(info:ArmInfo, data:IDataInput = null) : void
      {
         info.id = data.readUnsignedInt();
         info.buyTime = data.readUnsignedInt();
         info.form = data.readUnsignedInt();
         info.pos.x = data.readUnsignedInt();
         info.pos.y = data.readUnsignedInt();
         info.dir = data.readUnsignedInt();
         info.status = data.readUnsignedInt();
      }
      
      public static function setFor2966(info:ArmInfo, data:IDataInput = null) : void
      {
         info.buyTime = data.readUnsignedInt();
         info.id = data.readUnsignedInt();
         info.form = data.readUnsignedInt();
         info.isUsed = Boolean(data.readUnsignedInt());
      }
      
      public static function setFor2967_2965(info:ArmInfo, data:IDataInput = null) : void
      {
         var n:uint = 0;
         info.id = data.readUnsignedInt();
         info.buyTime = data.readUnsignedInt();
         info.form = data.readUnsignedInt();
         info.hp = data.readUnsignedInt();
         info.workCount = data.readUnsignedInt();
         info.donateCount = data.readUnsignedInt();
         info.res.clear();
         info.resNum = 0;
         var arr:Array = FortressItemXMLInfo.getResIDs(info.id,info.form);
         for(var i:int = 0; i < 4; i++)
         {
            n = uint(data.readUnsignedInt());
            info.resNum += n;
            info.res.add(arr[i],n);
         }
         info.pos.x = data.readUnsignedInt();
         info.pos.y = data.readUnsignedInt();
         info.dir = data.readUnsignedInt();
         info.status = data.readUnsignedInt();
      }
      
      override public function set id(v:uint) : void
      {
         _id = v;
         if(_id == 1)
         {
            this.styleID = ArmManager.headquartersID;
            isFixed = true;
         }
         else
         {
            this.styleID = _id;
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
      
      public function clone() : ArmInfo
      {
         var info:ArmInfo = new ArmInfo();
         info.id = id;
         info.styleID = this.styleID;
         info.pos = pos.clone();
         info.dir = dir;
         info.status = status;
         info.buyTime = this.buyTime;
         info.form = this.form;
         info.hp = this.hp;
         info.res = this.res.clone();
         info.type = type;
         info.workCount = this.workCount;
         info.donateCount = this.donateCount;
         info.isUsed = this.isUsed;
         info.resNum = this.resNum;
         info.isFixed = isFixed;
         return info;
      }
   }
}

