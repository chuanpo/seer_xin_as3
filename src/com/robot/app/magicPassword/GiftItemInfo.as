package com.robot.app.magicPassword
{
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.IDataInput;
   
   public class GiftItemInfo
   {
      private var giftList_a:Array;
      
      public function GiftItemInfo(data:IDataInput)
      {
         var count:uint = 0;
         var i:uint = 0;
         var giftID:uint = 0;
         super();
         this.giftList_a = new Array();
         var flag:uint = data.readUnsignedInt();
         if(flag == 1)
         {
            count = data.readUnsignedInt();
            for(i = 0; i < count; i++)
            {
               giftID = data.readUnsignedInt();
               this.giftList_a.push(giftID);
            }
         }
         else
         {
            Alarm.show("你已经有这些礼物了");
         }
      }
      
      public function get giftList() : Array
      {
         return this.giftList_a;
      }
   }
}

