package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   
   public class PetPropClass_300029
   {
      public function PetPropClass_300029(info:PetPropInfo)
      {
         super();
         SocketConnection.send(CommandID.USE_ENERGY_XISHOU,info.itemId);
      }
   }
}

