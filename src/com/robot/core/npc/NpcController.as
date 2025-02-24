package com.robot.core.npc
{
   import com.robot.core.config.xml.NpcXMLInfo;
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.MapModel;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   
   public class NpcController
   {
      private static var _curNpc:INpc;
      
      private static var _info:XMLList;
      
      private static var _curNpcInfo:NpcInfo;
      
      public static const GET_CURNPC:String = "getCurNpc";
      
      private static var _curPath:String = "";
      
      public function NpcController()
      {
         super();
      }
      
      public static function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapOpenHandler);
         MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapDestroyHandler);
      }
      
      private static function onMapOpenHandler(e:MapEvent) : void
      {
         var curMapModel:MapModel = e.mapModel;
         _info = NpcXMLInfo.getNpcXmlByMap(curMapModel.id);
         if(_info != null)
         {
            _curNpcInfo = new NpcInfo(_info);
            _curPath = _curNpcInfo.npcPath;
            init();
         }
      }
      
      private static function init() : void
      {
         ResourceManager.getResource(_curNpcInfo.npcPath,onComHandler);
      }
      
      private static function onComHandler(mc:DisplayObject) : void
      {
         var obj:Object = null;
         try
         {
            obj = getDefinitionByName("com.robot.app.npc.npcClass.NpcClass_" + _curNpcInfo.npcId);
            if(Boolean(obj))
            {
               _curNpc = new obj(_curNpcInfo,mc) as INpc;
               EventManager.dispatchEvent(new Event(GET_CURNPC));
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private static function onMapDestroyHandler(e:MapEvent) : void
      {
         if(_curPath != "")
         {
            ResourceManager.cancelURL(_curPath);
            _curPath = "";
         }
         if(Boolean(_curNpc))
         {
            _curNpc.destroy();
            _curNpc = null;
         }
      }
      
      public static function get curNpc() : INpc
      {
         return _curNpc;
      }
      
      public static function refreshTaskInfo() : void
      {
         if(Boolean(_curNpc))
         {
            if(Boolean(_curNpc.npc))
            {
               _curNpc.npc.refreshTask();
            }
         }
      }
   }
}

