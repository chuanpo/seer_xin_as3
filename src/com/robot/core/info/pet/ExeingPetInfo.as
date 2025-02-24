package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class ExeingPetInfo
   {
      public var _flag:uint;
      
      public var _remainDay:uint;
      
      public var _course:uint;
      
      public var _capTm:Number;
      
      public var _petId:uint;
      
      public function ExeingPetInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this._flag = data.readUnsignedInt();
            this._capTm = data.readUnsignedInt();
            this._petId = data.readUnsignedInt();
            this._remainDay = data.readUnsignedInt() / 3600;
            this._course = data.readUnsignedInt();
         }
      }
   }
}

