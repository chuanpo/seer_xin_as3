package com.robot.app.ogre
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.config.xml.OgreXMLInfo;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.mode.OgreModel;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   
   public class SpecialController
   {
      private static var _list:HashMap;
      
      private static var _pList:Array;
      
      private static var _currObj:OgreModel;
      
      private static var D_MAX:int = 40;
      
      private static var _isSwitching:Boolean = false;
      
      private static var b:Boolean = false;
      
      public function SpecialController()
      {
         super();
      }
      
      public static function add(index:int, id:uint) : void
      {
         var obj:OgreModel = null;
         if(_isSwitching)
         {
            return;
         }
         if(_list == null)
         {
            _pList = OgreXMLInfo.getSpecialList(MainManager.actorInfo.mapID);
            _list = new HashMap();
            MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
            MapManager.addEventListener(MapEvent.MAP_DESTROY,onMapSwitchOpen);
            MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,onMapDown);
         }
         if(_list.length > 3)
         {
            return;
         }
         if(_list.containsKey(index))
         {
            return;
         }
         if(Boolean(_pList))
         {
            obj = _list.getValue(index) as OgreModel;
            if(Boolean(obj))
            {
               obj.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
               obj.destroy();
               obj = null;
            }
            obj = new OgreModel(index);
            obj.addEventListener(RobotEvent.OGRE_CLICK,onClick);
            _list.add(index,obj);
            obj.show(id,_pList[index]);
         }
      }
      
      public static function remove(index:int) : void
      {
         if(_list == null)
         {
            return;
         }
         var obj:OgreModel = _list.remove(index) as OgreModel;
         if(Boolean(obj))
         {
            obj.removeEventListener(RobotEvent.OGRE_CLICK,onClick);
            obj.destroy();
            obj = null;
         }
      }
      
      public static function destroy() : void
      {
         var obj:OgreModel = null;
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
         _pList = null;
      }
      
      private static function startFight(obj:OgreModel) : Boolean
      {
         var petList:Array = null;
         var p:PetInfo = null;
         var num:uint = 0;
         var s:PetSkillInfo = null;
         if(Point.distance(obj.pos,MainManager.actorModel.pos) < D_MAX)
         {
            if(PetManager.length == 0)
            {
               Alarm.show("你的背包里还没有一只赛尔精灵哦！");
               return true;
            }
            petList = PetManager.infos;
            for each(p in petList)
            {
               num = 0;
               for each(s in p.skillArray)
               {
                  num += s.pp;
               }
               if(p.hp > 0 && num > 0)
               {
                  MainManager.actorModel.stop();
                  LevelManager.closeMouseEvent();
                  FightInviteManager.fightWithSpecial();
                  return true;
               }
            }
            if(!b)
            {
               b = true;
               Alarm.show("你的赛尔精灵没有体力或不能使用技能了，不能出战哦！");
            }
         }
         return false;
      }
      
      private static function onClick(e:RobotEvent) : void
      {
         b = false;
         _currObj = e.currentTarget as OgreModel;
         if(startFight(_currObj))
         {
            _currObj = null;
            return;
         }
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,onEnter);
         MainManager.actorModel.walkAction(_currObj.pos);
      }
      
      private static function onEnter(e:Event) : void
      {
         if(Boolean(_currObj))
         {
            if(startFight(_currObj))
            {
               _currObj = null;
               onMapDown(null);
               return;
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

