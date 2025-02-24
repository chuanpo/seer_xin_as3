package com.robot.app.magicPassword
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class MagicPasswordModel
   {
      private static var gift_a:Array;
      
      private static const MAX:int = 32;
      
      public function MagicPasswordModel()
      {
         super();
      }
      
      public static function send(pass:String) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_GIFT_COMPLETE,onSendCompleteHandler);
         var byte:ByteArray = new ByteArray();
         var sLen:int = pass.length;
         for(var i:int = 0; i < sLen; i++)
         {
            if(byte.length > MAX)
            {
               break;
            }
            byte.writeUTFBytes(pass.charAt(i));
         }
         SocketConnection.send(CommandID.GET_GIFT_COMPLETE,byte);
      }
      
      private static function onSendCompleteHandler(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_GIFT_COMPLETE,onSendCompleteHandler);
         var list:GiftItemInfo = event.data as GiftItemInfo;
         gift_a = list.giftList;
         trace("gift_a==" + gift_a);
         if(gift_a.length > 0)
         {
            search(gift_a);
         }
      }
      
      public static function get list() : Array
      {
         return gift_a;
      }
      
      private static function search(a:Array) : void
      {
         var itemName:String = null;
         var str:String = "";
         for(var j1:int = 0; j1 < a.length; j1++)
         {
            itemName = ItemXMLInfo.getName(a[j1]);
            str += itemName + ",";
         }
         trace("str==/==" + str);
         Alarm.show("兑换成功," + str + "已经放入你的储存箱,快去看看吧!");
      }
   }
}

