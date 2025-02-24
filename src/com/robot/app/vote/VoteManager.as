package com.robot.app.vote
{
   import com.robot.app.energy.ore.DayOreCount;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import flash.events.Event;
   import org.taomee.events.SocketEvent;
   
   public class VoteManager
   {
      private static var _sendId:uint;
      
      public function VoteManager()
      {
         super();
      }
      
      public static function vote(id:uint, answer:Array, sendId:uint) : void
      {
         _sendId = sendId;
         var day:DayOreCount = new DayOreCount();
         day.addEventListener(DayOreCount.countOK,function(event:Event):void
         {
            var count:uint = 0;
            var i:uint = 0;
            if(DayOreCount.oreCount < 1)
            {
               for each(i in answer)
               {
                  count += Math.pow(2,i);
               }
               SocketConnection.addCmdListener(CommandID.USER_INDAGATE,onIndagate);
               SocketConnection.send(CommandID.USER_INDAGATE,1,id,count);
            }
            else
            {
               Alarm.show("你已经投过票了");
            }
         });
         day.sendToServer(sendId);
      }
      
      private static function onIndagate(event:SocketEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_CATE,onSuccess);
         SocketConnection.send(CommandID.TALK_CATE,_sendId);
      }
      
      private static function onSuccess(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,onSuccess);
         ItemInBagAlert.show(400501,"5个扭蛋牌已经放入你的储存箱");
      }
   }
}

