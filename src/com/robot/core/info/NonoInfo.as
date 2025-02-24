package com.robot.core.info
{
   import flash.utils.IDataInput;
   import org.taomee.utils.BitUtil;
   
   public class NonoInfo
   {
      public var userID:uint;
      
      public var flag:Array;
      
      public var state:Array;
      
      public var nick:String;
      
      public var superNono:Boolean;
      
      public var color:uint;
      
      public var power:Number;
      
      public var mate:Number;
      
      public var iq:uint;
      
      public var ai:uint;
      
      public var birth:Number;
      
      public var chargeTime:uint;
      
      public var func:Array;
      
      public var superEnergy:Number;
      
      public var superLevel:uint;
      
      public var superStage:uint;
      
      public function NonoInfo(data:IDataInput = null)
      {
         var num:uint = 0;
         var f:int = 0;
         var s:int = 0;
         var i:int = 0;
         var k:int = 0;
         this.flag = [];
         this.state = [];
         this.func = [];
         super();
         if(Boolean(data))
         {
            this.userID = data.readUnsignedInt();
            num = data.readUnsignedInt();
            if(num == 0)
            {
               return;
            }
            for(f = 0; f < 32; f++)
            {
               this.flag.push(Boolean(BitUtil.getBit(num,f)));
            }
            num = data.readUnsignedInt();
            for(s = 0; s < 32; s++)
            {
               this.state.push(Boolean(BitUtil.getBit(num,s)));
            }
            this.nick = data.readUTFBytes(16);
            this.superNono = Boolean(data.readUnsignedInt());
            this.color = data.readUnsignedInt();
            this.power = data.readUnsignedInt() / 1000;
            this.mate = data.readUnsignedInt() / 1000;
            this.iq = data.readUnsignedInt();
            this.ai = data.readUnsignedShort();
            this.birth = data.readUnsignedInt() * 1000;
            this.chargeTime = data.readUnsignedInt();
            for(i = 0; i < 20; i++)
            {
               num = data.readUnsignedByte();
               for(k = 0; k < 8; k++)
               {
                  this.func.push(Boolean(BitUtil.getBit(num,k)));
               }
            }
            this.superEnergy = data.readUnsignedInt();
            this.superLevel = data.readUnsignedInt();
            this.superStage = data.readUnsignedInt();
            if(this.superStage > 4)
            {
               this.superStage = 4;
            }
            if(this.superStage == 0)
            {
               this.superStage = 1;
            }
         }
      }
      
      public function getMateLevel() : uint
      {
         if(this.mate <= 30)
         {
            return 1;
         }
         if(this.mate >= 31 && this.mate <= 69)
         {
            return 2;
         }
         return 3;
      }
      
      public function getPowerLevel() : uint
      {
         if(this.power <= 30)
         {
            return 1;
         }
         if(this.power >= 31 && this.power <= 69)
         {
            return 2;
         }
         return 3;
      }
   }
}

