package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   
   public class PetPropClass_default
   {
      public function PetPropClass_default(param1:PetPropInfo)
      {

            SocketConnection.send(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,param1.petInfo.catchTime,param1.itemId);
            Alarm.show("道具已经成功使用完毕");
         
      }
   }
}

