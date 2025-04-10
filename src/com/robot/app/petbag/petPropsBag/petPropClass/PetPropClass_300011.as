package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   
   public class PetPropClass_300011
   {
      public function PetPropClass_300011(info:PetPropInfo)
      {
         super();
         if(info.petInfo.hp == info.petInfo.maxHp)
         {
            Alarm.show("你的<font color=\'#ff0000\'>" + info.petInfo.name + "</font>不需要再使用此物品啦!");
         }
         else
         {
            SocketConnection.send(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,info.petInfo.catchTime,info.itemId);
         }
      }
   }
}

