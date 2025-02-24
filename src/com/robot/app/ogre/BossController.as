package com.robot.app.ogre
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.config.xml.OgreXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.mode.BossModel;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   
   public class BossController
   {
      private static var _list:HashMap;
      
      private static var _currObj:BossModel;
      
      private static var D_MAX:int = 60;
      
      private static var _isSwitching:Boolean = false;
      
      private static var _idList:HashMap = new HashMap();
      
      public function BossController()
      {
         super();
      }
      
      public static function getRegion(petId:uint) : uint
      {
         return _idList.getValue(petId);
      }
      
      public static function add(id:uint, region:uint, hp:uint, index:int) : void
      {
         var cla:Class = null;
         var o:BossModel = null;
         var obj:BossModel = null;
         if(_isSwitching)
         {
            return;
         }
         if(_list == null)
         {
            _list = new HashMap();
            MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
            MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,onMapDown);
         }
         _idList = new HashMap();
         _idList.add(id,region);
         var _pList:Array = OgreXMLInfo.getBossList(MainManager.actorInfo.mapID,region);
         if(Boolean(_pList))
         {
            if(index >= _pList.length)
            {
               return;
            }
            if(_list.containsKey(region))
            {
               o = _list.getValue(region) as BossModel;
               if(Boolean(o))
               {
                  if(o.id == id)
                  {
                     o.show(_pList[index],hp);
                     return;
                  }
                  o.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
                  o.destroy();
                  o = null;
               }
            }
            cla = PetXMLInfo.getClass(id);
            if(cla == null)
            {
               cla = BossModel;
            }
            if(Boolean(cla))
            {
               obj = new cla(id,region);
               obj.addEventListener(RobotEvent.OGRE_CLICK,onClick);
               _list.add(region,obj);
               obj.show(_pList[index],hp);
            }
         }
      }
      
      public static function remove(region:uint) : void
      {
         if(_list == null)
         {
            return;
         }
         var obj:BossModel = _list.remove(region) as BossModel;
         if(Boolean(obj))
         {
            obj.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
            obj.destroy();
            obj = null;
         }
      }
      
      public static function destroy() : void
      {
         var obj:BossModel = null;
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,onMapDown);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
         var data:Array = _list.getValues();
         for each(obj in data)
         {
            obj.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
            obj.destroy();
            obj = null;
         }
         _list = null;
      }
      
      private static function startFight(obj:BossModel) : Boolean
      {
         var petList:Array = null;
         var p:PetInfo = null;
         if(Point.distance(obj.pos,MainManager.actorModel.pos) < D_MAX)
         {
            if(PetManager.length == 0)
            {
               Alarm.show("你没有可出战的精灵哦");
               return true;
            }
            petList = PetManager.infos;
            for each(p in petList)
            {
               if(p.hp > 0)
               {
                  MainManager.actorModel.stop();
                  LevelManager.closeMouseEvent();
                  FightInviteManager.fightWithBoss("蘑菇怪");
                  return true;
               }
            }
            Alarm.show("你没有可出战的精灵哦");
            return true;
         }
         return false;
      }
      
      private static function onClick(e:RobotEvent) : void
      {
         _currObj = e.currentTarget as BossModel;
         if(_currObj.hp <= 0)
         {
            if(startFight(_currObj))
            {
               _currObj = null;
               return;
            }
         }
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
         MainManager.actorModel.walkAction(_currObj.pos);
      }
      
      private static function onEnter(e:Event) : void
      {
         if(Boolean(_currObj))
         {
            if(_currObj.hp <= 0)
            {
               if(startFight(_currObj))
               {
                  _currObj = null;
                  onMapDown(null);
                  return;
               }
            }
         }
      }
      
      private static function onMapDown(e:MapEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
      }
      
      private static function onMapSwitchOpen(e:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitchOpen);
         MapManager.removeEventListener(MapEvent.MAP_DESTROY,onMapSwitchOpen);
         _isSwitching = true;
         destroy();
      }
      
      private static function onMapSwitchComplete(e:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
         _isSwitching = false;
      }
   }
}

