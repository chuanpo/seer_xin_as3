package com.robot.app.help
{
   import com.robot.app.newspaper.ContributeAlert;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.HelpXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Alert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class HelpManager
   {
      private static var panel:AppModel;
      
      public function HelpManager()
      {
         super();
      }
      
      public static function show(id:uint) : void
      {
         var arr:Array = HelpXMLInfo.getIdList();
         if(arr.indexOf(id) < 0)
         {
            Alarm.show("帮助XML配置ID错误。");
            return;
         }
         var type:uint = uint(HelpXMLInfo.getType(id));
         switch(type)
         {
            case 0:
               showPanel(id);
               break;
            case 1:
               showTalk(id);
               break;
            case 2:
               showMes(id);
               break;
            default:
               Alarm.show("帮助XML配置类型错误。");
         }
      }
      
      private static function showMes(id:uint) : void
      {
         var u:uint = uint(HelpXMLInfo.getComment(id));
         switch(u)
         {
            case 1:
               ContributeAlert.show(ContributeAlert.NEWS_TYPE);
               break;
            case 2:
               ContributeAlert.show(ContributeAlert.SHIPER_TYPE);
               break;
            case 3:
               ContributeAlert.show(ContributeAlert.DOCTOR_TYPE);
               break;
            case 4:
               ContributeAlert.show(ContributeAlert.NONO);
               break;
            case 5:
               ContributeAlert.show(ContributeAlert.LYMAN);
               break;
            default:
               Alarm.show("帮助XML配置写信错误");
         }
      }
      
      public static function nullPanel() : void
      {
         panel = null;
      }
      
      private static function showPanel(id:uint) : void
      {
         var str:String = HelpXMLInfo.getComment(id);
         var arr:Array = HelpXMLInfo.getItemAry(id);
         var isBack:Boolean = Boolean(HelpXMLInfo.getIsBack(id));
         var obj:Object = new Object();
         obj.str = str;
         obj.arr = arr;
         obj.isBack = isBack;
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getHelpModule("HelpListPanel"),"正在打开帮助信息");
            panel.setup();
            panel.init(obj);
            panel.show();
         }
         else
         {
            panel.hide();
            panel.init(obj);
            panel.show();
         }
      }
      
      private static function enterFrameHandler(e:Event) : void
      {
         var temp:MovieClip = e.currentTarget as MovieClip;
         if(temp.currentFrame == 70)
         {
            temp.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            LevelManager.appLevel.removeChild(temp);
         }
      }
      
      private static function arrowRot(arow:MovieClip, point:Point) : void
      {
         var ang:int = 0;
         var _x:Number = point.x;
         var _y:Number = point.y;
         if(!(_x > 288 && _x < 711 && _y > 167 && _y < 405))
         {
            ang = int(Math.atan2(_y - 280,_x - 480) * 180 / Math.PI);
            arow.rotation = ang + 90;
         }
         arow.x = _x;
         arow.y = _y;
      }
      
      private static function showTalk(id:uint) : void
      {
         var mapid:uint = 0;
         var point:Point = null;
         var myArrow:MovieClip = null;
         var str:String = null;
         mapid = uint(HelpXMLInfo.getMapId(id));
         if(!mapid || mapid == MainManager.actorInfo.mapID)
         {
            point = HelpXMLInfo.getArrowPoint(id);
            myArrow = new HelpUI_Arrow();
            LevelManager.appLevel.addChild(myArrow);
            arrowRot(myArrow,point);
            myArrow.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
         }
         else
         {
            str = HelpXMLInfo.getComment(id);
            Alert.show(str,function():void
            {
               MapManager.changeMap(mapid);
            },null);
         }
      }
      
      public static function getType(id:uint) : uint
      {
         return HelpXMLInfo.getType(id);
      }
      
      public static function getObj(id:uint) : Object
      {
         var str:String = HelpXMLInfo.getComment(id);
         var arr:Array = HelpXMLInfo.getItemAry(id);
         var isBack:Boolean = Boolean(HelpXMLInfo.getIsBack(id));
         var obj:Object = new Object();
         obj.str = str;
         obj.arr = arr;
         obj.isBack = isBack;
         return obj;
      }
      
      public static function getBack(id:uint) : Boolean
      {
         return HelpXMLInfo.getIsBack(id);
      }
   }
}

