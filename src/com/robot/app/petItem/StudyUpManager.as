package com.robot.app.petItem
{
   import com.robot.core.CommandID;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.LeftToolBarManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class StudyUpManager
   {
      private static var leftTime:uint;
      
      private static var icon:MovieClip;
      
      private static var txt:TextField;
      
      public function StudyUpManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         EventManager.addEventListener(RobotEvent.STUDY_TIMES_CHANGE,onTimesChange);
         leftTime = MainManager.actorInfo.learnTimes;
         checkTime();
      }
      
      private static function onTimesChange(event:Event) : void
      {
         leftTime = MainManager.actorInfo.learnTimes;
         checkTime();
      }
      
      public static function useItem(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.USE_STUDY_ITEM,onUseItem);
         SocketConnection.send(CommandID.USE_STUDY_ITEM,id);
      }
      
      private static function onUseItem(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.USE_STUDY_ITEM,onUseItem);
         var by:ByteArray = event.data as ByteArray;
         var time:uint = by.readUnsignedInt();
         leftTime = time;
         MainManager.actorInfo.learnTimes = time;
         checkTime();
      }
      
      private static function checkTime() : void
      {
         if(!icon)
         {
            icon = TaskIconManager.getIcon("study_icon") as MovieClip;
            txt = icon["txt"];
         }
         if(leftTime > 0)
         {
            txt.text = leftTime.toString();
            LeftToolBarManager.addIcon(icon);
         }
         else
         {
            LeftToolBarManager.delIcon(icon);
         }
      }
   }
}

