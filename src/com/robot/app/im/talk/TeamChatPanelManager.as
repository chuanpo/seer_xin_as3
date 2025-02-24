package com.robot.app.im.talk
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.AppModel;
   import org.taomee.ds.HashMap;
   
   public class TeamChatPanelManager
   {
      private static var _list:HashMap;
      
      public function TeamChatPanelManager()
      {
         super();
      }
      
      public static function showTeamChatPanel(teamID:uint) : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         var tcp:AppModel = getTeamChatPanel(teamID);
         if(tcp == null)
         {
            tcp = new AppModel(ClientConfig.getAppModule("TeamChatPanel"),"正在打开战队聊天");
            _list.add(teamID,tcp);
            tcp.init(teamID);
            tcp.setup();
            tcp.show();
         }
      }
      
      public static function closeTalkPanel(teamID:uint) : void
      {
         var tcp:AppModel = _list.remove(teamID) as AppModel;
         if(Boolean(tcp))
         {
            tcp.destroy();
            tcp = null;
         }
         if(_list.length == 0)
         {
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         }
      }
      
      public static function closeAll() : void
      {
         _list.eachValue(function(tcp:AppModel):void
         {
            tcp.destroy();
            tcp = null;
         });
         _list.clear();
      }
      
      public static function getTeamChatPanel(teamID:uint) : AppModel
      {
         return _list.getValue(teamID) as AppModel;
      }
      
      public static function isOpen(teamID:uint) : Boolean
      {
         return _list.containsKey(teamID);
      }
      
      private static function onMapOpen(e:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         closeAll();
      }
   }
}

