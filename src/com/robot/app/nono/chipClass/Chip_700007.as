package com.robot.app.nono.chipClass
{
   import com.robot.core.CommandID;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.net.SocketConnection;
   
   public class Chip_700007
   {
      public function Chip_700007(info:SingleItemInfo)
      {
         super();
         SocketConnection.send(CommandID.NONO_IMPLEMENT_TOOL,info.itemID);
      }
   }
}

