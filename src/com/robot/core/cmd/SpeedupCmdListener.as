package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.LeftToolBarManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class SpeedupCmdListener extends BaseBeanController
   {
      private static var icon:MovieClip;
      
      public function SpeedupCmdListener()
      {
         super();
      }
      
      public static function showIcon() : void
      {
         icon["txt"].text = MainManager.actorInfo.twoTimes.toString();
         LeftToolBarManager.addIcon(icon);
      }
      
      public static function delIcon() : void
      {
         LeftToolBarManager.delIcon(icon);
      }
      
      override public function start() : void
      {
         EventManager.addEventListener(RobotEvent.SPEEDUP_CHANGE,this.onChange);
         icon = TaskIconManager.getIcon("speedup_icon") as MovieClip;
         SocketConnection.addCmdListener(CommandID.USE_SPEEDUP_ITEM,this.onUseSpeedup);
         if(MainManager.actorInfo.twoTimes > 0)
         {
            showIcon();
         }
         finish();
      }
      
      private function onUseSpeedup(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         MainManager.actorInfo.twoTimes = data.readUnsignedInt();
         MainManager.actorInfo.threeTimes = data.readUnsignedInt();
         if(MainManager.actorInfo.twoTimes > 0)
         {
            showIcon();
         }
         else
         {
            delIcon();
         }
      }
      
      private function onChange(event:RobotEvent) : void
      {
         if(MainManager.actorInfo.twoTimes > 0)
         {
            showIcon();
         }
         else
         {
            delIcon();
         }
      }
   }
}

