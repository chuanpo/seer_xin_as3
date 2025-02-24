package com.robot.app.teacherAward
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import org.taomee.events.SocketEvent;
   
   public class TeacherAwardModel
   {
      public function TeacherAwardModel()
      {
         super();
      }
      
      public static function sendCmd() : void
      {
         SocketConnection.addCmdListener(CommandID.TEACHERREWARD_COMPLETE,onSendCompleteHandler);
         SocketConnection.send(CommandID.TEACHERREWARD_COMPLETE);
      }
      
      private static function onSendCompleteHandler(event:SocketEvent) : void
      {
         var name_str:String = null;
         var i1:int = 0;
         SocketConnection.removeCmdListener(CommandID.TEACHERREWARD_COMPLETE,onSendCompleteHandler);
         var award:TeacherAwardInfo = event.data as TeacherAwardInfo;
         if(award.getInfo.length > 0)
         {
            name_str = "";
            for(i1 = 0; i1 < award.getInfo.length; i1++)
            {
               name_str += ItemXMLInfo.getName(award.getInfo[i1]) + ",";
            }
            Alarm.show("你是一名优秀的教官，奖励你:" + name_str + "希望你更加努力，培养更多精英。");
         }
      }
   }
}

