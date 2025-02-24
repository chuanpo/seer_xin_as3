package com.robot.core.info.pet
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PetEffectInfo
   {
      public var itemId:uint;
      
      public var status:uint;
      
      public var leftCount:uint;
      
      public var effectID:uint;
      
      public var param:ByteArray;
      
      public var args:String;
      
      public function PetEffectInfo(data:IDataInput)
      {
         super();
         this.itemId = data.readUnsignedInt();
         this.status = data.readUnsignedByte();
         this.leftCount = data.readUnsignedByte();
         this.effectID = data.readUnsignedShort();
         var a1:uint = uint(data.readUnsignedByte());
         data.readUnsignedByte();
         var a2:uint = uint(data.readUnsignedByte());
         if(a2 != 0)
         {
            this.args = a1 + " " + a2;
         }
         else
         {
            this.args = a1.toString();
         }
         data.readUTFBytes(13);
      }
   }
}

