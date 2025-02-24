package com.robot.core.aticon
{
   import com.robot.core.CommandID;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.IActionSprite;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   
   public class ChatAction
   {
      private static const MAX:int = 131;
      
      public function ChatAction()
      {
         super();
      }
      
      public function execute(people:IActionSprite, msg:String, toID:uint = 0, isNet:Boolean = true) : void
      {
         var byte:ByteArray = null;
         var sLen:int = 0;
         var i:int = 0;
         if(msg == "")
         {
            return;
         }
         if(isNet)
         {
            byte = new ByteArray();
            sLen = msg.length;
            for(i = 0; i < sLen; i++)
            {
               if(byte.length > MAX)
               {
                  break;
               }
               byte.writeUTFBytes(msg.charAt(i));
            }
            byte.writeUTFBytes("0");
            SocketConnection.send(CommandID.CHAT,toID,byte.length,byte);
         }
         else
         {
            BasePeoleModel(people).showBox(msg,5);
         }
      }
   }
}

