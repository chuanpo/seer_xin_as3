package com.robot.app.action
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.SuitXMLInfo;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.TransformSkeleton;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ActorActionManager
   {
      private static var subMenu:MovieClip;
      
      private static var actionBtn:SimpleButton;
      
      private static var tranBtn:SimpleButton;
      
      private static var unTranBtn:SimpleButton;
      
      public static var isTransforming:Boolean = false;
      
      setup();
      
      public function ActorActionManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         EventManager.addEventListener(RobotEvent.TRANSFORM_START,onTranStart);
         EventManager.addEventListener(RobotEvent.TRANSFORM_OVER,onTranOver);
      }
      
      private static function onTranStart(event:RobotEvent) : void
      {
         isTransforming = true;
      }
      
      private static function onTranOver(event:RobotEvent) : void
      {
         isTransforming = false;
         if(Boolean(tranBtn))
         {
            tranBtn.visible = !MainManager.actorModel.isTransform;
            unTranBtn.visible = MainManager.actorModel.isTransform;
         }
      }
      
      public static function showMenu(o:DisplayObject) : void
      {
         var p:Point = null;
         if(!subMenu)
         {
            subMenu = new lib_transform_menu();
            p = o.localToGlobal(new Point());
            subMenu.x = p.x;
            subMenu.y = p.y - subMenu.height - 5;
            actionBtn = subMenu["actionBtn"];
            tranBtn = subMenu["tranBtn"];
            unTranBtn = subMenu["unTranBtn"];
            ToolTipManager.add(actionBtn,"蹲下");
            ToolTipManager.add(tranBtn,"变形");
            ToolTipManager.add(unTranBtn,"恢复变形");
            actionBtn.addEventListener(MouseEvent.CLICK,actionHandler);
            tranBtn.addEventListener(MouseEvent.CLICK,tranHandler);
            unTranBtn.addEventListener(MouseEvent.CLICK,unTranHandler);
         }
         tranBtn.visible = !MainManager.actorModel.isTransform;
         unTranBtn.visible = MainManager.actorModel.isTransform;
         LevelManager.topLevel.addChild(subMenu);
         MainManager.getStage().addEventListener(MouseEvent.CLICK,onStageClick);
      }
      
      private static function onStageClick(event:MouseEvent) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,onStageClick);
         if(!subMenu.hitTestPoint(event.stageX,event.stageY))
         {
            DisplayUtil.removeForParent(subMenu);
         }
      }
      
      private static function actionHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         if(MainManager.actorInfo.actionType == 1)
         {
            Alarm.show("注意！不要采用危险操作，取消飞行模式才能进行赛尔变形。");
            return;
         }
         if(isTransforming)
         {
            return;
         }
         if(!MainManager.actorModel.isTransform)
         {
            MainManager.actorModel.peculiarAction(MainManager.actorModel.direction);
         }
      }
      
      private static function tranHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         if(MainManager.actorInfo.actionType == 1)
         {
            Alarm.show("注意！不要采用危险操作，取消飞行模式才能进行赛尔变形。");
            return;
         }
         if(isTransforming)
         {
            return;
         }
         var suitID:uint = uint(SuitXMLInfo.getSuitID(MainManager.actorInfo.clothIDs));
         SocketConnection.send(CommandID.PEOPLE_TRANSFROM,suitID);
      }
      
      private static function unTranHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         if(isTransforming)
         {
            return;
         }
         if(MainManager.actorModel.skeleton is TransformSkeleton)
         {
            (MainManager.actorModel.skeleton as TransformSkeleton).untransform();
         }
      }
   }
}

