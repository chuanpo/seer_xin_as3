package com.robot.app.im.talk
{
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.MapManager;
   import org.taomee.ds.HashMap;
   
   public class TalkPanelManager
   {
      private static var _list:HashMap = new HashMap();
      
      public function TalkPanelManager()
      {
         super();
      }
      
      public static function showTalkPanel(userID:uint) : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         var tp:TalkPanel = getTalkPanel(userID);
         if(tp == null)
         {
            tp = new TalkPanel();
            _list.add(userID,tp);
            tp.show(userID);
         }
      }
      
      public static function closeTalkPanel(userID:uint) : void
      {
         var tp:TalkPanel = _list.remove(userID) as TalkPanel;
         if(Boolean(tp))
         {
            tp.destroy();
            tp = null;
         }
         if(_list.length == 0)
         {
            MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         }
      }
      
      public static function closeAll() : void
      {
         _list.eachValue(function(tp:TalkPanel):void
         {
            tp.destroy();
            tp = null;
         });
         _list.clear();
      }
      
      public static function getTalkPanel(userID:uint) : TalkPanel
      {
         return _list.getValue(userID) as TalkPanel;
      }
      
      public static function isOpen(userID:uint) : Boolean
      {
         return _list.containsKey(userID);
      }
      
      private static function onMapOpen(e:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapOpen);
         closeAll();
      }
   }
}

